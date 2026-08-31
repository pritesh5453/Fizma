import 'dart:io';
import 'package:fizmaa/Screens/navbar/navbar.dart';
import 'package:fizmaa/models_n_services/add_event/add_event_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fizmaa/Screens/add_event/media_upload.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:fizmaa/models_n_services/add_event/add_event_model.dart';

class _ArtistData {
  final String name;
  final String? imagePath;

  _ArtistData(this.name, [this.imagePath]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ArtistData &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // ---------- API service ----------
  final EventService _eventService = EventService();
  bool _isSubmitting = false;

  // ---------- Category ----------
  final List<String> _categories = const [
    'Music',
    'Comedy',
    'Sports',
    'Theatre',
    'Workshop',
    'Conference',
    'Other',
  ];
  String? _selectedCategory;

  // ---------- Languages / Tags ----------
  List<String> _languagesList = ['English', 'Spanish'];
  List<String> _tagsList = ['#livemusic', '#weekendvibes', '#outdoor'];

  // ---------- Date/Time ----------
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  // ---------- Artists ----------
  final List<_ArtistData> _availableArtists = [
    _ArtistData('Samay Raina'),
    _ArtistData('Arijit Singh'),
    _ArtistData('Sunidhi Chauhan'),
    _ArtistData('Divine'),
    _ArtistData('Nucleya'),
    _ArtistData('Ritviz'),
    _ArtistData('Prateek Kuhad'),
  ];
  final List<_ArtistData> _selectedArtists = [];

  // ---------- Age Restriction ----------
  String? _selectedAgeRestriction;

  // ---------- Text Controllers ----------
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  final TextEditingController _facilitiesController = TextEditingController();
  final TextEditingController _organiserNameController = TextEditingController(); // ✅ Added

  int _descriptionWordCount = 0;
  static const int maxWords = 300;

  @override
  void initState() {
    super.initState();
    _termsController.text =
        '• All attendees must follow the venue’s rules and regulations.\n'
        '• The organizer reserves the right to refuse entry or eject any attendee for violation of terms.\n'
        '• Tickets are non‑refundable unless the event is cancelled.\n'
        '• By attending, you consent to photography and video recording for promotional purposes.\n'
        '• Please carry a valid ID for age‑restricted events.';

    _descriptionController.addListener(_updateWordCount);

    // ✅ Load organiser name from preferences (optional)
    _loadOrganiserName();
  }

  Future<void> _loadOrganiserName() async {
    final details = await AppPreferences.getOrganiserDetails();
    final name = details['organisationName'] ?? 'Organiser';
    _organiserNameController.text = name;
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _termsController.dispose();
    _facilitiesController.dispose();
    _organiserNameController.dispose();
    super.dispose();
  }

  void _updateWordCount() {
    final text = _descriptionController.text;
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    setState(() {
      _descriptionWordCount = words;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDateForApi(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _formatTimeForApi(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  // ---------- API call: STEP 1 ----------
  Future<void> _handleSaveAndProceed() async {
    if (_eventNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter event name');
      return;
    }
    if (_selectedCategory == null) {
      _showSnackBar('Please select event category');
      return;
    }
    if (_startDateTime == null || _endDateTime == null) {
      _showSnackBar('Please select event start & end date/time');
      return;
    }

    setState(() => _isSubmitting = true);

    final organiserId = await AppPreferences.getOrganiserId() ?? 0;
    if (organiserId == 0) {
      if (mounted) setState(() => _isSubmitting = false);
      _showSnackBar('Organiser not found. Please log in again.');
      return;
    }

    final request = EventCreateRequest(
      eventName: _eventNameController.text.trim(),
      eventCategory: _selectedCategory!,
      artists: _selectedArtists.map((a) => a.name).toList(),
      ageRestriction: _selectedAgeRestriction ?? '',
      languages: _languagesList,
      description: _descriptionController.text.trim(),
      tags: _tagsList,
      termsConditions: _termsController.text.trim(),
      facilities: _facilitiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      status: 'draft',
      promotionalVideoUrl: '',
      organiserId: organiserId,
      eventDate: _formatDateForApi(_startDateTime!),
      startTime: _formatTimeForApi(_startDateTime!),
      endTime: _formatTimeForApi(_endDateTime!),
      step: 1,
    );

    try {
      final response = await _eventService.createEvent(request);
      if (!mounted) return;

      // ✅ Navigate to MediaUploadScreen with all required parameters
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaUploadScreen(
            eventId: response.eventId,
            organiserId: organiserId,
            eventName: _eventNameController.text.trim(),
            eventCategory: _selectedCategory!,
            organiserName: _organiserNameController.text.trim(),
            languages: _languagesList.join(', '),
            status: 'draft',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to save event: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ---------- Build UI ----------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goToEventsNavBar();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AppColors.screenGradient,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                _buildProgressBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // // ---- Organiser Name (optional but needed for next screen) ----
                        // _label('Organiser Name'),
                        // _textField(hint: 'Enter Organiser Name', controller: _organiserNameController),
                        // const SizedBox(height: 12),

                        _label('Event Name'),
                        _textField(hint: 'Enter Name', controller: _eventNameController),
                        const SizedBox(height: 18),

                        _label('Event Category'),
                        _buildCategoryDropdown(),
                        const SizedBox(height: 18),

                        _buildDateTimeSection(),
                        const SizedBox(height: 18),

                        _buildArtistsSection(),
                        const SizedBox(height: 18),

                        _buildAgeRestrictionDropdown(),
                        const SizedBox(height: 18),

                        _label('Languages Supported'),
                        const SizedBox(height: 8),
                        _chipsWithAdd(
                          items: _languagesList,
                          addLabel: '+ Add Language',
                          onAdd: _showAddLanguageDialog,
                          onRemove: (i) => setState(() => _languagesList.removeAt(i)),
                        ),
                        const SizedBox(height: 18),

                        _label('Description'),
                        const SizedBox(height: 8),
                        _buildDescriptionRichTextBox(),
                        const SizedBox(height: 18),

                        _label('Tags for Discoverability'),
                        const SizedBox(height: 8),
                        _tagChipsWithAdd(
                          items: _tagsList,
                          onAdd: _showAddTagDialog,
                          onRemove: (i) => setState(() => _tagsList.removeAt(i)),
                        ),
                        const SizedBox(height: 18),

                        _label('Terms & Conditions'),
                        const SizedBox(height: 8),
                        _buildTermsRichTextBox(),
                        const SizedBox(height: 18),

                        _label('Facilities'),
                        const SizedBox(height: 8),
                        _richTextBox(
                          hintText: 'List facilities available (comma separated)...',
                          controller: _facilitiesController,
                          initialText: null,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Navigation to EventsNavBar ----------
  void _goToEventsNavBar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EventsNavBar(initialIndex: 0),
      ),
    );
  }

  // ---------- Progress Bar ----------
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: List.generate(6, (index) {
          final bool active = index == 0;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
              height: 4,
              decoration: BoxDecoration(
                color: active ? AppColors.kRed : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- Category dropdown ----------
  Widget _buildCategoryDropdown() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: const Text('Select category',
              style: TextStyle(color: AppColors.kHint, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kHint),
          items: _categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() => _selectedCategory = newValue);
          },
        ),
      ),
    );
  }

  // ---------- Artist selection section ----------
  Widget _buildArtistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Select Artists'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ..._selectedArtists.map((artist) => _removableChip(artist, onRemove: () {
                  setState(() {
                    _selectedArtists.remove(artist);
                  });
                })),
            _addArtistButton(),
          ],
        ),
      ],
    );
  }

  Widget _removableChip(_ArtistData artist, {required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.kChipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (artist.imagePath != null)
            ClipOval(
              child: Image.file(
                File(artist.imagePath!),
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 24),
              ),
            ),
          if (artist.imagePath != null) const SizedBox(width: 6),
          Text(
            artist.name,
            style: const TextStyle(fontSize: 13, color: AppColors.kTextDark),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 15, color: AppColors.kTextDark),
          ),
        ],
      ),
    );
  }

  Widget _addArtistButton() {
    return GestureDetector(
      onTap: _showAddArtistDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kRed, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, color: AppColors.kRed, size: 18),
            SizedBox(width: 4),
            Text(
              'Add Artist',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.kRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddArtistDialog() {
    String searchQuery = '';
    List<_ArtistData> filteredArtists = List.from(_availableArtists);

    String newArtistName = '';
    String? newArtistImagePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.people, color: AppColors.kRed),
                  const SizedBox(width: 8),
                  const Text('Select Artists'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search artists...',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setStateDialog(() {
                                    searchQuery = '';
                                    filteredArtists = List.from(_availableArtists);
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setStateDialog(() {
                          searchQuery = value.trim();
                          if (searchQuery.isEmpty) {
                            filteredArtists = List.from(_availableArtists);
                          } else {
                            filteredArtists = _availableArtists
                                .where((a) => a.name
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredArtists.length +
                            (searchQuery.isNotEmpty &&
                                    !_availableArtists.any((a) =>
                                        a.name.toLowerCase() ==
                                        searchQuery.toLowerCase()) &&
                                    !_selectedArtists.any((a) =>
                                        a.name.toLowerCase() ==
                                        searchQuery.toLowerCase())
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          bool isAddNew = index == filteredArtists.length;
                          if (isAddNew) {
                            return Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.kBorder),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Add New Artist',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final picker = ImagePicker();
                                          final pickedFile =
                                              await picker.pickImage(
                                            source: ImageSource.gallery,
                                            maxWidth: 200,
                                            maxHeight: 200,
                                          );
                                          if (pickedFile != null) {
                                            setStateDialog(() {
                                              newArtistImagePath =
                                                  pickedFile.path;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: AppColors.kChipBg,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: AppColors.kBorder),
                                          ),
                                          child: newArtistImagePath != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(newArtistImagePath!),
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            const Icon(Icons
                                                                .broken_image),
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.add_a_photo,
                                                  color: AppColors.kHint,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Artist name',
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8),
                                          ),
                                          onChanged: (value) {
                                            newArtistName = value.trim();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: (newArtistName.isEmpty)
                                          ? null
                                          : () {
                                              final newArtist = _ArtistData(
                                                  newArtistName,
                                                  newArtistImagePath);
                                              setState(() {
                                                _selectedArtists.add(newArtist);
                                                _availableArtists.add(newArtist);
                                              });
                                              Navigator.pop(context);
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.kRed,
                                        foregroundColor: AppColors.kWhite,
                                      ),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Artist'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          final artist = filteredArtists[index];
                          final isSelected = _selectedArtists.contains(artist);
                          return ListTile(
                            leading: isSelected
                                ? const Icon(Icons.check_circle,
                                    color: AppColors.kRed)
                                : const Icon(Icons.circle_outlined,
                                    color: AppColors.kHint),
                            title: Text(artist.name),
                            trailing: (artist.imagePath != null)
                                ? ClipOval(
                                    child: Image.file(
                                      File(artist.imagePath!),
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.person),
                                    ),
                                  )
                                : null,
                            onTap: isSelected
                                ? null
                                : () {
                                    setState(() {
                                      _selectedArtists.add(artist);
                                    });
                                    Navigator.pop(context);
                                  },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------- Age restriction dropdown ----------
  Widget _buildAgeRestrictionDropdown() {
    const options = ['All Ages', '5+', '18+', '21+'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Age Restriction'),
        const SizedBox(height: 8),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.kBorder, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAgeRestriction,
              hint: const Text('Select age restriction',
                  style: TextStyle(color: AppColors.kHint, fontSize: 14)),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.kHint),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedAgeRestriction = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Description with word counter ----------
  Widget _buildDescriptionRichTextBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.kBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                _toolbarIcon(Icons.format_bold),
                _toolbarIcon(Icons.format_italic),
                _toolbarIcon(Icons.format_underline),
                _toolbarIcon(Icons.format_list_bulleted),
                _toolbarIcon(Icons.format_list_numbered),
                _toolbarIcon(Icons.link),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Describe what makes your event special...',
                    hintStyle:
                        TextStyle(color: AppColors.kHint, fontSize: 13.5),
                  ),
                  style: const TextStyle(
                      fontSize: 13.5, color: AppColors.kTextDark),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Words: $_descriptionWordCount / $maxWords',
                    style: TextStyle(
                      fontSize: 12,
                      color: _descriptionWordCount > maxWords
                          ? AppColors.kRed
                          : AppColors.kHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Terms & Conditions ----------
  Widget _buildTermsRichTextBox() {
    return _richTextBox(
      hintText: 'Edit terms & conditions...',
      controller: _termsController,
      initialText: null,
      maxLines: 6,
    );
  }

  // ---------- Generic Rich Text Box ----------
  Widget _richTextBox({
    required String hintText,
    TextEditingController? controller,
    String? initialText,
    int maxLines = 3,
  }) {
    final actualController = controller ?? TextEditingController(text: initialText);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.kBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                _toolbarIcon(Icons.format_bold),
                _toolbarIcon(Icons.format_italic),
                _toolbarIcon(Icons.format_underline),
                _toolbarIcon(Icons.format_list_bulleted),
                _toolbarIcon(Icons.format_list_numbered),
                _toolbarIcon(Icons.link),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: actualController,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 13.5),
              ),
              style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Date & Time section ----------
  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Event Date & Time'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _dateTimeField(
                label: 'Start',
                selectedDateTime: _startDateTime,
                onTap: () => _selectDateTime(isStart: true),
                hint: 'Select Start',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _dateTimeField(
                label: 'End',
                selectedDateTime: _endDateTime,
                onTap: () => _selectDateTime(isStart: false),
                hint: 'Select End',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateTimeField({
    required String label,
    required DateTime? selectedDateTime,
    required VoidCallback onTap,
    required String hint,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.kBorder, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedDateTime != null
                    ? _formatDateTime(selectedDateTime)
                    : hint,
                style: TextStyle(
                  fontSize: 13,
                  color: selectedDateTime != null
                      ? AppColors.kTextDark
                      : AppColors.kHint,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: AppColors.kHint,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart ? (_startDateTime ?? now) : (_endDateTime ?? now);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.kRed,
              onPrimary: AppColors.kWhite,
              onSurface: AppColors.kTextDark,
            ),
            dialogBackgroundColor: AppColors.kWhite,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.kRed,
              onPrimary: AppColors.kWhite,
              onSurface: AppColors.kTextDark,
            ),
            dialogBackgroundColor: AppColors.kWhite,
          ),
          child: child!,
        );
      },
    );
    if (pickedTime == null) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        _startDateTime = newDateTime;
        if (_endDateTime != null && _endDateTime!.isBefore(_startDateTime!)) {
          _endDateTime = null;
        }
      } else {
        if (_startDateTime != null && newDateTime.isBefore(_startDateTime!)) {
          _endDateTime = _startDateTime!.add(const Duration(hours: 1));
        } else {
          _endDateTime = newDateTime;
        }
      }
    });
  }

  // ---------- Save Button ----------
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSaveAndProceed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kRed,
            foregroundColor: AppColors.kWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.kWhite,
                  ),
                )
              : const Text(
                  'Save & Proceed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kWhite,
                  ),
                ),
        ),
      ),
    );
  }

  // ---------- Top Bar ----------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _goToEventsNavBar,
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextDark),
          ),
          const Text(
            'Add Event',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Label ----------
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.kTextDark,
        ),
      ),
    );
  }

  // ---------- Simple Text Field ----------
  Widget _textField({required String hint, TextEditingController? controller}) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 14),
        ),
        style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
      ),
    );
  }

  // ---------- Add Language / Tag dialogs ----------
  void _showAddLanguageDialog() {
    String value = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Language'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Hindi'),
          onChanged: (v) => value = v.trim(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.kRed),
            onPressed: () {
              if (value.isNotEmpty && !_languagesList.contains(value)) {
                setState(() => _languagesList.add(value));
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: AppColors.kWhite)),
          ),
        ],
      ),
    );
  }

  void _showAddTagDialog() {
    String value = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. #festival'),
          onChanged: (v) => value = v.trim(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.kRed),
            onPressed: () {
              if (value.isNotEmpty) {
                final tag = value.startsWith('#') ? value : '#$value';
                if (!_tagsList.contains(tag)) {
                  setState(() => _tagsList.add(tag));
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: AppColors.kWhite)),
          ),
        ],
      ),
    );
  }

  // ---------- Language Chips ----------
  Widget _chipsWithAdd({
    required List<String> items,
    required String addLabel,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (int i = 0; i < items.length; i++)
          _chip(items[i], onRemove: () => onRemove(i)),
        _addChipButton(addLabel, onTap: onAdd),
      ],
    );
  }

  // ---------- Tag Chips ----------
  Widget _tagChipsWithAdd({
    required List<String> items,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < items.length; i++)
          _chip(items[i], onRemove: () => onRemove(i)),
        _circleAddButton(onTap: onAdd),
      ],
    );
  }

  Widget _chip(String text, {VoidCallback? onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.kChipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppColors.kTextDark),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 15, color: AppColors.kTextDark),
          ),
        ],
      ),
    );
  }

  Widget _addChipButton(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kRed, width: 1.2),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.kRed,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _circleAddButton({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.kRed, width: 1.2),
        ),
        child: const Icon(Icons.add, color: AppColors.kRed, size: 18),
      ),
    );
  }

  // ---------- Toolbar Icon ----------
  Widget _toolbarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Icon(icon, size: 18, color: AppColors.kTextDark.withOpacity(0.75)),
    );
  }
}