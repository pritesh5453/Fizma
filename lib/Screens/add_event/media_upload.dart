import 'dart:convert';
import 'dart:io';

import 'package:fizma/models_n_services/add_event/add_event_svc.dart';
import 'package:fizma/utils/app_preference.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'add_venue_screen.dart';

// ------------------------------------------------------------
// Local UI models
// ------------------------------------------------------------
class Sponsor {
  String name;
  String? type;
  String website;
  String logoUrl;
  File? logoFile;

  Sponsor({
    this.name = '',
    this.type,
    this.website = '',
    this.logoUrl = '',
    this.logoFile,
  });
}

class Collaborator {
  String name;
  String? role;
  bool hasAccess;

  Collaborator({
    this.name = '',
    this.role,
    this.hasAccess = true,
  });
}

// ------------------------------------------------------------
// Main Screen – now receives event details from previous page
// ------------------------------------------------------------
class MediaUploadScreen extends StatefulWidget {
  final int eventId;
  final int organiserId;
  final String eventName;
  final String eventCategory;
  final String organiserName;
  final String languages;
  final String status;

  const MediaUploadScreen({
    super.key,
    required this.eventId,
    required this.organiserId,
    required this.eventName,
    required this.eventCategory,
    required this.organiserName,
    required this.languages,
    required this.status,
  });

  @override
  State<MediaUploadScreen> createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  final EventService _eventService = EventService();
  bool _isSubmitting = false;
  int? _organiserId;

  // ---------- Images ----------
  File? _horizontalBanner;
  File? _verticalBanner;
  List<File> _galleryImages = [];

  // ---------- Video ----------
  File? _promoVideoFile;

  // ---------- Sponsors & Collaborators ----------
  List<Sponsor> sponsors = [Sponsor()];
  List<Collaborator> collaborators = [Collaborator()];

  // ---------- Text controllers ----------
  final TextEditingController _promoVideoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSuggestions = false;

  final List<String> _allSuggestions = [
    '9876543210 - John Doe',
    '9876543211 - Jane Smith',
    '9876543212 - Robert Johnson',
    '9876543213 - Maria Garcia',
  ];

  List<String> get _filteredSuggestions {
    if (_searchQuery.isEmpty) return [];
    final existingNames = collaborators.map((c) => c.name).toSet();
    return _allSuggestions
        .where((s) =>
            s.toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !existingNames.contains(s))
        .toList();
  }

  // ------------------------------------------------------------
  // Lifecycle
  // ------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadOrganiserId();
  }

  Future<void> _loadOrganiserId() async {
    // Use the passed organiserId, but also keep preferences for fallback
    final id = await AppPreferences.getOrganiserId();
    setState(() {
      _organiserId = id ?? widget.organiserId;
    });
  }

  @override
  void dispose() {
    _promoVideoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Permission & Picker Helpers
  // ------------------------------------------------------------
  Future<bool> _requestStoragePermission() async {
    if (await Permission.photos.isGranted) return true;
    if (await Permission.storage.isGranted) return true;
    if (await Permission.photos.request().isGranted) return true;
    if (await Permission.storage.request().isGranted) return true;
    return false;
  }

  Future<void> _pickImage(Function(File?) setter) async {
    if (!await _requestStoragePermission()) {
      _showSnackBar('Storage permission denied');
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => setter(File(picked.path)));
    }
  }

  void _removeImage(Function(File?) setter) {
    setState(() => setter(null));
  }

  Future<void> _pickGalleryImages() async {
    if (!await _requestStoragePermission()) {
      _showSnackBar('Storage permission denied');
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _galleryImages.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  void _removeGalleryImage(int index) {
    setState(() => _galleryImages.removeAt(index));
  }

  // ------------------------------------------------------------
  // Video Picker (with 50 MB limit)
  // ------------------------------------------------------------
  Future<void> _pickVideo() async {
    if (!await _requestStoragePermission()) {
      _showSnackBar('Storage permission denied');
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final sizeInBytes = await file.length();
      const maxSize = 50 * 1024 * 1024; // 50 MB

      if (sizeInBytes > maxSize) {
        _showSnackBar('Video size must be less than 50 MB.');
        return;
      }
      setState(() => _promoVideoFile = file);
    }
  }

  void _removeVideo() {
    setState(() => _promoVideoFile = null);
  }

  // ------------------------------------------------------------
  // Sponsors & Collaborators Operations
  // ------------------------------------------------------------
  void _addSponsor() => setState(() => sponsors.add(Sponsor()));
  void _removeSponsor(int index) {
    if (sponsors.length > 1) setState(() => sponsors.removeAt(index));
  }

  void _addCollaboratorCard() => setState(() => collaborators.add(Collaborator()));
  void _addCollaboratorFromSearch(String name) {
    setState(() {
      if (!collaborators.any((c) => c.name == name)) {
        collaborators.add(Collaborator(name: name, hasAccess: true));
      }
      _searchController.clear();
      _searchQuery = '';
      _showSuggestions = false;
    });
  }
  void _removeCollaborator(int index) {
    if (collaborators.length > 1) setState(() => collaborators.removeAt(index));
  }
  void _toggleAccess(int index) {
    setState(() => collaborators[index].hasAccess = !collaborators[index].hasAccess);
  }

  Map<String, String> _parseCollaboratorEntry(String raw) {
    final parts = raw.split(' - ');
    if (parts.length >= 2) {
      return {'phone': parts.first.trim(), 'name': parts.sublist(1).join(' - ').trim()};
    }
    return {'phone': '', 'name': raw.trim()};
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // ------------------------------------------------------------
  // API Call – Step 2 (multipart with text + files)
  // ------------------------------------------------------------
  Future<void> _handleSaveAndProceed() async {
    if (_organiserId == null) {
      _showSnackBar('Organiser ID not found. Please login again.');
      return;
    }

    setState(() => _isSubmitting = true);

    // Build sponsors list
    final sponsorList = sponsors
        .where((s) => s.name.trim().isNotEmpty)
        .map((s) => {
              'name': s.name.trim(),
              'type': s.type ?? '',
              'website': s.website.trim(),
            })
        .toList();

    // Build collaborators list
    final collaboratorList = collaborators
        .where((c) => c.name.trim().isNotEmpty)
        .map((c) {
          final parsed = _parseCollaboratorEntry(c.name);
          return {
            'name': parsed['name'] ?? c.name,
            'phone': parsed['phone'] ?? '',
            'role': c.role ?? '',
            'permissions': {'hasAccess': c.hasAccess},
          };
        })
        .toList();

    // Prepare sponsor logo lists (same order as sponsors)
    final sponsorLogoHorizontal = sponsorList.map((s) {
      final sponsorObj = sponsors.firstWhere((sp) => sp.name.trim() == s['name']);
      return sponsorObj.logoFile;
    }).toList();

    final sponsorLogoVertical = sponsorList.map((s) {
      final sponsorObj = sponsors.firstWhere((sp) => sp.name.trim() == s['name']);
      return sponsorObj.logoFile;
    }).toList();

    try {
      // ✅ Single multipart call – text + all files
      await _eventService.updateEventStep2WithMultipart(
        eventId: widget.eventId,
        organiserId: _organiserId!,
        promotionalVideoUrl: _promoVideoController.text.trim(),
        sponsors: sponsorList,
        collaborators: collaboratorList,
        bannerHorizontal: _horizontalBanner,
        bannerVertical: _verticalBanner,
        promoVideoFile: _promoVideoFile,
        galleryImages: _galleryImages.isNotEmpty ? _galleryImages : null,
        sponsorLogoHorizontal: sponsorLogoHorizontal,
        sponsorLogoVertical: sponsorLogoVertical,
      );

      if (!mounted) return;

      // ✅ Success – navigate to AddVenueScreen with event details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddVenueScreen(
            eventName: widget.eventName,
            eventCategory: widget.eventCategory,
            organiserName: widget.organiserName,
            languages: widget.languages,
            eventId: widget.eventId.toString(),
            status: widget.status,
            organiserId: widget.organiserId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to save: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ------------------------------------------------------------
  // Build UI (unchanged)
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppColors.screenGradient,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Banners ----
                      _label('Event Banner'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildImagePickerBox(
                              label: 'Horizontal (Desktop)',
                              subtitle: '16:9 - up to 5MB',
                              file: _horizontalBanner,
                              onPick: () => _pickImage((f) => _horizontalBanner = f),
                              onRemove: () => _removeImage((f) => _horizontalBanner = f),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildImagePickerBox(
                              label: 'Vertical (Mobile)',
                              subtitle: '9:16 - up to 5MB',
                              file: _verticalBanner,
                              onPick: () => _pickImage((f) => _verticalBanner = f),
                              onRemove: () => _removeImage((f) => _verticalBanner = f),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ---- Promotional Video ----
                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Promotional Video (Optional)'),
                            const SizedBox(height: 10),
                            _textField(
                              hint: 'Paste YouTube or Vimeo link',
                              controller: _promoVideoController,
                            ),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                'or',
                                style: TextStyle(color: AppColors.kHint, fontSize: 12.5),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _promoVideoFile == null
                                ? _dashedUploadBox(
                                    icon: Icons.file_upload_outlined,
                                    title: 'Upload video file',
                                    subtitle: 'MP4, MOV - up to 50MB',
                                    onTap: _pickVideo,
                                  )
                                : _buildFilePreview(
                                    fileName: _promoVideoFile!.path.split('/').last,
                                    onRemove: _removeVideo,
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ---- Gallery ----
                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Gallery (Optional)'),
                            const SizedBox(height: 10),
                            if (_galleryImages.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(_galleryImages.length, (index) {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _galleryImages[index],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: -6,
                                        right: -6,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.close, size: 16, color: Colors.red),
                                          onPressed: () => _removeGalleryImage(index),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            const SizedBox(height: 10),
                            _dashedUploadBox(
                              icon: Icons.add_circle_outline,
                              title: 'Add photo',
                              subtitle: null,
                              big: true,
                              onTap: _pickGalleryImages,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ---- Sponsors ----
                      _label('Event Sponsors (Optional)'),
                      const SizedBox(height: 10),
                      ...List.generate(sponsors.length, _buildSponsorCard),
                      const SizedBox(height: 8),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: _addSponsor,
                          icon: const Icon(Icons.add, color: AppColors.kRed),
                          label: const Text('Add Sponsor', style: TextStyle(color: AppColors.kRed)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.kRed),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ---- Collaborators ----
                      _label('Collaborators (Organizers)'),
                      const SizedBox(height: 10),
                      _buildCollaboratorSearchBar(),
                      const SizedBox(height: 14),
                      ...List.generate(collaborators.length, _buildCollaboratorCard),
                      const SizedBox(height: 8),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: _addCollaboratorCard,
                          icon: const Icon(Icons.add, color: AppColors.kRed),
                          label: const Text('Add Collaborator', style: TextStyle(color: AppColors.kRed)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.kRed),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Sponsor Card ----------
  Widget _buildSponsorCard(int index) {
    final sponsor = sponsors[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sponsor ${index + 1}',
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.kTextDark)),
                if (sponsors.length > 1)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                    onPressed: () => _removeSponsor(index),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _textField(hint: 'Sponsor Name', initialValue: sponsor.name, onChanged: (v) => sponsor.name = v),
            const SizedBox(height: 10),
            _sponsorTypeDropdown(
              currentValue: sponsor.type,
              onChanged: (v) => setState(() => sponsor.type = v),
            ),
            const SizedBox(height: 10),
            _textField(hint: 'Sponsor Website (Optional)', initialValue: sponsor.website, onChanged: (v) => sponsor.website = v),
            const SizedBox(height: 10),
            _buildImagePickerBox(
              label: 'Upload Sponsor Logo',
              subtitle: 'PNG, JPG - up to 2MB',
              file: sponsor.logoFile,
              onPick: () => _pickImage((f) => setState(() => sponsor.logoFile = f)),
              onRemove: () => setState(() => sponsor.logoFile = null),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Collaborator Card ----------
  Widget _buildCollaboratorCard(int index) {
    final collaborator = collaborators[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Collaborator ${index + 1}',
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.kTextDark)),
                if (collaborators.length > 1)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                    onPressed: () => _removeCollaborator(index),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _textField(hint: 'Enter name or phone number', initialValue: collaborator.name, onChanged: (v) => collaborator.name = v),
            const SizedBox(height: 10),
            _collaboratorRoleDropdown(
              currentValue: collaborator.role,
              onChanged: (v) => setState(() => collaborator.role = v),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.kChipBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Organizer Permissions',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.kTextDark)),
                  Switch(
                    value: collaborator.hasAccess,
                    onChanged: (_) => _toggleAccess(index),
                    activeColor: AppColors.kRed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Reusable Components
  // ------------------------------------------------------------
  Widget _buildImagePickerBox({
    required String label,
    required String? subtitle,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onRemove,
  }) {
    return GestureDetector(
      onTap: file == null ? onPick : null,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: AppColors.kRed, radius: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: file == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(color: AppColors.kChipBg, shape: BoxShape.circle),
                      child: Icon(Icons.image_outlined, color: AppColors.kRed, size: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.kTextDark)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.kHint)),
                    ],
                  ],
                )
              : Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(file, height: 80, width: double.infinity, fit: BoxFit.cover),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close, size: 20, color: Colors.red),
                      onPressed: onRemove,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFilePreview({required String fileName, required VoidCallback onRemove}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kChipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.video_file, color: AppColors.kRed),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(fontSize: 13, color: AppColors.kTextDark),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }

  Widget _sponsorTypeDropdown({
    required String? currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    const types = ['Platinum', 'Gold', 'Silver', 'Bronze'];
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
          value: currentValue,
          hint: const Text('Select Sponsor Type', style: TextStyle(color: AppColors.kHint, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kHint),
          items: types.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.kTextDark)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _collaboratorRoleDropdown({
    required String? currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    const roles = ['Co-Organizer', 'Event Manager', 'Promoter', 'Moderator'];
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
          value: currentValue,
          hint: const Text('Select role', style: TextStyle(color: AppColors.kHint, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kHint),
          items: roles.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCollaboratorSearchBar() {
    return Column(
      children: [
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.kBorder, width: 1.2),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.kHint, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _showSuggestions = value.isNotEmpty;
                    });
                  },
                  onTap: () => setState(() => _showSuggestions = _searchQuery.isNotEmpty),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Search user by name or phone number',
                    hintStyle: TextStyle(color: AppColors.kHint, fontSize: 14),
                  ),
                  style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
                ),
              ),
            ],
          ),
        ),
        if (_showSuggestions && _filteredSuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kBorder, width: 1),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSuggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  dense: true,
                  title: Text(suggestion,
                      style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark)),
                  trailing: const Icon(Icons.add, color: AppColors.kRed, size: 18),
                  onTap: () => _addCollaboratorFromSearch(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }

  // ---------- Base UI Helpers ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextDark),
          ),
          const Text('Media, Sponsors & Collaborators',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.kTextDark)),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: List.generate(6, (index) {
          double fill = index == 0 ? 1.0 : index == 1 ? 0.5 : 0.0;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
              height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fill,
                  child: Container(height: 4, decoration: BoxDecoration(color: AppColors.kRed, borderRadius: BorderRadius.circular(4))),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kTextDark));
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: child,
    );
  }

  Widget _textField({
    required String hint,
    String? initialValue,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    final actualController = controller ?? TextEditingController(text: initialValue ?? '');
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
        controller: actualController,
        onChanged: onChanged,
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

  Widget _dashedUploadBox({
    required IconData icon,
    required String title,
    String? subtitle,
    bool big = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: AppColors.kRed, radius: 10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: big ? 26 : 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: AppColors.kChipBg, shape: BoxShape.circle),
                child: Icon(icon, color: AppColors.kRed, size: 18),
              ),
              const SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.kTextDark)),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10.5, color: AppColors.kHint)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.kWhite,
                  side: const BorderSide(color: AppColors.kRed, width: 1.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.kRed)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSaveAndProceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.kWhite),
                      )
                    : const Text('Save & Proceed',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.kWhite)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Custom Painter (unchanged)
// ------------------------------------------------------------
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;

  _DashedBorderPainter({
    required this.color,
    this.radius = 10,
    this.dashWidth = 5,
    this.dashGap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    final dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + dashGap;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}