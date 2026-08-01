import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'add_venue_screen.dart';

// Model for a Sponsor
class Sponsor {
  String name;
  String? website;
  String? sponsorType; // NEW: Platinum, Gold, Silver, Bronze
  List<String> logos; // store file paths or URLs

  Sponsor({
    this.name = '',
    this.website,
    this.sponsorType,
    this.logos = const [],
  });
}

// Model for a Collaborator
class Collaborator {
  String name;
  bool hasAccess;

  Collaborator({required this.name, this.hasAccess = true});
}

class MediaUploadScreen extends StatefulWidget {
  const MediaUploadScreen({super.key});

  @override
  State<MediaUploadScreen> createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  List<Sponsor> sponsors = [Sponsor()]; // start with one empty sponsor

  // Collaborators state
  List<Collaborator> collaborators = [];
  final TextEditingController _collaboratorController = TextEditingController();
  String _collaboratorSearchQuery = '';
  bool _showSuggestions = false;

  // Dummy suggestions (phone numbers with names)
  final List<String> _allSuggestions = [
    '9876543210 - John Doe',
    '9876543211 - Jane Smith',
    '9876543212 - Robert Johnson',
    '9876543213 - Maria Garcia',
    '9876543214 - David Lee',
    '9876543215 - Sarah Williams',
  ];

  List<String> get _filteredSuggestions {
    if (_collaboratorSearchQuery.isEmpty) return [];
    final existingNames = collaborators.map((c) => c.name).toSet();
    return _allSuggestions.where((s) =>
        s.toLowerCase().contains(_collaboratorSearchQuery.toLowerCase()) &&
        !existingNames.contains(s)
    ).toList();
  }

  // Helper to add a new sponsor
  void _addSponsor() {
    setState(() {
      sponsors.add(Sponsor());
    });
  }

  // Helper to remove a sponsor (keep at least one)
  void _removeSponsor(int index) {
    setState(() {
      if (sponsors.length > 1) {
        sponsors.removeAt(index);
      }
    });
  }

  // Helper to add a logo to a specific sponsor
  void _addLogoToSponsor(int sponsorIndex, String logoPath) {
    setState(() {
      sponsors[sponsorIndex].logos.add(logoPath);
    });
  }

  // Helper to remove a logo from a specific sponsor
  void _removeLogoFromSponsor(int sponsorIndex, int logoIndex) {
    setState(() {
      sponsors[sponsorIndex].logos.removeAt(logoIndex);
    });
  }

  // Collaborator methods
  void _addCollaborator(String name) {
    setState(() {
      if (!collaborators.any((c) => c.name == name)) {
        collaborators.add(Collaborator(name: name, hasAccess: true));
      }
      _collaboratorController.clear();
      _collaboratorSearchQuery = '';
      _showSuggestions = false;
    });
  }

  void _removeCollaborator(int index) {
    setState(() {
      collaborators.removeAt(index);
    });
  }

  void _toggleCollaboratorAccess(int index) {
    setState(() {
      collaborators[index].hasAccess = !collaborators[index].hasAccess;
    });
  }

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
                      _label('Event Banner'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _dashedUploadBox(
                              icon: Icons.desktop_windows_outlined,
                              title: 'Horizontal (Desktop)',
                              subtitle: '16:9 - up to 5MB',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dashedUploadBox(
                              icon: Icons.stay_primary_portrait_outlined,
                              title: 'Vertical (Mobile)',
                              subtitle: '9:16 - up to 5MB',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Promotional Video (Optional)'),
                            const SizedBox(height: 10),
                            _textField(hint: 'Paste YouTube or Vimeo link'),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                'or',
                                style: TextStyle(color: AppColors.kHint, fontSize: 12.5),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _dashedUploadBox(
                              icon: Icons.file_upload_outlined,
                              title: 'Upload video file',
                              subtitle: 'MP4, MOV - up to 500MB',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Gallery (Optional)'),
                            const SizedBox(height: 10),
                            _dashedUploadBox(
                              icon: Icons.add_circle_outline,
                              title: 'Add photo',
                              subtitle: null,
                              iconOnTop: false,
                              big: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ---------- MULTIPLE SPONSORS SECTION ----------
                      _label('Sponsors'),
                      const SizedBox(height: 10),
                      ...List.generate(sponsors.length, (index) {
                        return _buildSponsorCard(index);
                      }),
                      const SizedBox(height: 12),
                      _addSponsorButton(),
                      const SizedBox(height: 20),

                      // ---------- COLLABORATORS SECTION ----------
                      _buildCollaboratorsSection(),
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

  // ---------- Build Collaborators Section ----------
  Widget _buildCollaboratorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Collaborators (Organizers)'),
        const SizedBox(height: 8),
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field with suggestions
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
                        controller: _collaboratorController,
                        onChanged: (value) {
                          setState(() {
                            _collaboratorSearchQuery = value;
                            _showSuggestions = value.isNotEmpty;
                          });
                        },
                        onTap: () {
                          setState(() {
                            _showSuggestions = _collaboratorSearchQuery.isNotEmpty;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Search by name or phone number',
                          hintStyle: TextStyle(color: AppColors.kHint, fontSize: 14),
                        ),
                        style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
                      ),
                    ),
                    if (_collaboratorController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _collaboratorController.clear();
                            _collaboratorSearchQuery = '';
                            _showSuggestions = false;
                          });
                        },
                        child: const Icon(Icons.clear, color: AppColors.kHint, size: 18),
                      ),
                  ],
                ),
              ),
              // Suggestions list
              if (_showSuggestions && _filteredSuggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
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
                        title: Text(
                          suggestion,
                          style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
                        ),
                        onTap: () => _addCollaborator(suggestion),
                      );
                    },
                  ),
                ),
              // Display added collaborators with toggle and delete
              if (collaborators.isNotEmpty) ...[
                const SizedBox(height: 12),
                Column(
                  children: collaborators.asMap().entries.map((entry) {
                    int index = entry.key;
                    Collaborator collaborator = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.kChipBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                collaborator.name,
                                style: const TextStyle(fontSize: 13, color: AppColors.kTextDark),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Access',
                                style: TextStyle(fontSize: 12, color: AppColors.kHint),
                              ),
                              const SizedBox(width: 4),
                              Switch(
                                value: collaborator.hasAccess,
                                onChanged: (_) => _toggleCollaboratorAccess(index),
                                activeColor: AppColors.kRed,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _removeCollaborator(index),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Build a single sponsor card ----------
  Widget _buildSponsorCard(int index) {
    final sponsor = sponsors[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sponsor ${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextDark,
                  ),
                ),
                if (sponsors.length > 1)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () => _removeSponsor(index),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _label('Sponsor Name'),
            _textField(
              hint: 'Enter name',
              initialValue: sponsor.name,
              onChanged: (val) => sponsor.name = val,
            ),
            const SizedBox(height: 12),

            // ---------- NEW: Sponsor Type Dropdown ----------
            _label('Sponsor Type'),
            const SizedBox(height: 6),
            _sponsorTypeDropdown(
              currentValue: sponsor.sponsorType,
              onChanged: (String? newValue) {
                setState(() {
                  sponsor.sponsorType = newValue;
                });
              },
            ),
            const SizedBox(height: 12),

            _label('Sponsor Website (Optional)'),
            _textField(
              hint: 'Enter website URL',
              initialValue: sponsor.website ?? '',
              onChanged: (val) => sponsor.website = val.isNotEmpty ? val : null,
            ),
            const SizedBox(height: 12),
            _label('Logo'),
            const SizedBox(height: 8),
            _dashedUploadBox(
              icon: Icons.add_photo_alternate_outlined,
              title: 'Upload Logo',
              subtitle: '1:1 ratio, up to 5MB each',
              iconOnTop: true,
              big: true,
              onTap: () {
                // Simulate upload - for demo, add a dummy logo name
                _addLogoToSponsor(index, 'Logo_${DateTime.now().millisecondsSinceEpoch}');
              },
            ),
            if (sponsor.logos.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sponsor.logos.asMap().entries.map((entry) {
                  int logoIndex = entry.key;
                  String logo = entry.value;
                  return Chip(
                    label: Text(logo),
                    onDeleted: () => _removeLogoFromSponsor(index, logoIndex),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------- Sponsor Type Dropdown (styled) ----------
  Widget _sponsorTypeDropdown({
    required String? currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    const options = ['Platinum', 'Gold', 'Silver', 'Bronze'];
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
          hint: const Text(
            'Select type',
            style: TextStyle(color: AppColors.kHint, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kHint),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ---------- Add Sponsor Button ----------
  Widget _addSponsorButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: _addSponsor,
        icon: const Icon(Icons.add, color: AppColors.kRed),
        label: const Text(
          'Add Sponsor',
          style: TextStyle(color: AppColors.kRed),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.kRed),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ---------- Top App Bar ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextDark),
          ),
          const Text(
            'Media Upload',
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

  // ---------- Progress Bar (4 segments, step 2 partially active) ----------
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: List.generate(4, (index) {
          double fill;
          if (index == 0) {
            fill = 1.0;
          } else if (index == 1) {
            fill = 0.5;
          } else {
            fill = 0.0;
          }
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fill,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.kRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- Section Label ----------
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.kTextDark,
      ),
    );
  }

  // ---------- Card wrapper ----------
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

  // ---------- Text Field with optional controller / onChanged ----------
  Widget _textField({
    required String hint,
    String? initialValue,
    Function(String)? onChanged,
  }) {
    final controller = TextEditingController(text: initialValue ?? '');
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

  // ---------- Dashed Upload Box (with optional onTap) ----------
  Widget _dashedUploadBox({
    required IconData icon,
    required String title,
    String? subtitle,
    bool iconOnTop = true,
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
                decoration: const BoxDecoration(
                  color: AppColors.kChipBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.kRed, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10.5, color: AppColors.kHint),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Bottom Buttons ----------
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kRed,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddVenueScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save & Proceed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Custom dashed border painter ----------
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
