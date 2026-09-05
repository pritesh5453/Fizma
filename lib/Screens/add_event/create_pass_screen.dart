import 'dart:io';
import 'package:fizmaa/Screens/add_event/create_ticket_n_tables_screen.dart';
import 'package:fizmaa/models_n_services/Pass/create_pass_model.dart';
import 'package:fizmaa/models_n_services/Pass/create_pass_svc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:fizmaa/utils/appcolors.dart';

// ---------- Function to show bottom sheet ----------
Future<PassTier?> showCreatePassBottomSheet(
  BuildContext context, {
  required int eventId,
  required int venueId,
}) {
  return showModalBottomSheet<PassTier>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CreatePassBottomSheet(
      eventId: eventId,
      venueId: venueId,
    ),
  );
}

// ---------- Bottom Sheet Widget ----------
class CreatePassBottomSheet extends StatefulWidget {
  final int eventId;
  final int venueId;

  const CreatePassBottomSheet({
    super.key,
    required this.eventId,
    required this.venueId,
  });

  @override
  State<CreatePassBottomSheet> createState() => _CreatePassBottomSheetState();
}

class _CreatePassBottomSheetState extends State<CreatePassBottomSheet> {
  // Controllers
  final TextEditingController _passNameController = TextEditingController();
  final TextEditingController _passCountController =
      TextEditingController(text: '100');
  final TextEditingController _passPriceController =
      TextEditingController(text: '50.00');
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expiryDaysController =
      TextEditingController(text: '365');

  bool _isActive = true;
  File? _imageFile;

  // Description character limit
  static const int _descriptionMaxLength = 300;
  int _descriptionLength = 0;

  // Loading state
  bool _isLoading = false;

  // 🔥 Service – APNE GLOBAL DIO CLIENT SE REPLACE KAREIN
  final PassService _passService = PassService(Dio()); // <-- Badlein

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateDescriptionLength);
    _updateDescriptionLength();
  }

  void _updateDescriptionLength() {
    setState(() {
      _descriptionLength = _descriptionController.text.length;
    });
  }

  @override
  void dispose() {
    _passNameController.dispose();
    _passCountController.dispose();
    _passPriceController.dispose();
    _descriptionController.dispose();
    _expiryDaysController.dispose();
    super.dispose();
  }

  // ---------- Image Picker ----------
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // ---------- Validation & Submit ----------
  Future<void> _submitPass() async {
    // Validation
    if (_passNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter pass name')),
      );
      return;
    }
    final count = int.tryParse(_passCountController.text.trim());
    if (count == null || count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pass count must be a positive number')),
      );
      return;
    }
    final price = double.tryParse(_passPriceController.text.trim());
    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Price must be a valid non-negative number')),
      );
      return;
    }
    final expiry = int.tryParse(_expiryDaysController.text.trim());
    if (expiry == null || expiry <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expiry days must be a positive number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _passService.createPass(
        eventId: widget.eventId,
        venueId: widget.venueId,
        passName: _passNameController.text.trim(),
        passCount: count,
        passPrice: price,
        description: _descriptionController.text.trim(),
        status: _isActive ? 'active' : 'inactive',
        isActive: _isActive ? 1 : 0,
        expiryDays: expiry,
        passBackgroundCover: _imageFile,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        // ✅ PassTier ab pass_model.dart se import ho raha hai
        final passTier = PassTier(
          id: response.data!.id.toString(), // agar id chahiye toh
          name: response.data!.passName,
          totalPasses: response.data!.passCount,
          price: double.tryParse(response.data!.passPrice) ?? 0.0,
          maxPerPerson: 1, // API se nahi aata, default
          isActive: response.data!.isActive == 1,
          validityDays: response.data!.expiryDays,
        );
        Navigator.pop(context, passTier);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.message}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.80, // 80% height
          decoration: AppColors.screenGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(Icons.card_giftcard, 'Pass Details'),
                      const SizedBox(height: 14),

                      _label('Pass Name'),
                      const SizedBox(height: 8),
                      _textField(controller: _passNameController),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Total Passes'),
                                const SizedBox(height: 8),
                                _textField(controller: _passCountController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Price (₹)'),
                                const SizedBox(height: 8),
                                _textField(
                                  controller: _passPriceController,
                                  prefixText: '₹ ',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _label('Expiry Days'),
                      const SizedBox(height: 8),
                      _textField(
                        controller: _expiryDaysController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      _label('Description'),
                      const SizedBox(height: 8),
                      _descriptionBox(),
                      const SizedBox(height: 20),

                      _toggleRow(
                        label: 'Active',
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        subtitle: 'Pass will be visible to users',
                      ),
                      const SizedBox(height: 20),

                      _imagePickerSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Top Bar ----------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              'Create Pass',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.kTextDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 3),
                Text(
                  'For event #${widget.eventId}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.kTextDark.withOpacity(0.45),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Reusable Widgets ----------
  Widget _sectionHeader(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.kRed),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.kTextDark,
          ),
        ),
      ],
    );
  }

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

  Widget _textField({
    required TextEditingController controller,
    String? prefixText,
    String? suffixText,
    bool enabled = true,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: enabled ? AppColors.kWhite : AppColors.kChipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (prefixText != null)
            Text(prefixText,
                style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
            ),
          ),
          if (suffixText != null)
            Text(suffixText,
                style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
        ],
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextDark,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.kRed,
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.5)),
          ),
        ],
      ],
    );
  }

  Widget _descriptionBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            maxLength: _descriptionMaxLength,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: 'Describe the pass benefits...',
              hintStyle: TextStyle(color: AppColors.kHint, fontSize: 13.5),
              counterText: '',
            ),
            style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '$_descriptionLength / $_descriptionMaxLength',
              style: TextStyle(
                fontSize: 12,
                color: _descriptionLength > _descriptionMaxLength
                    ? AppColors.kRed
                    : AppColors.kHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Background Cover (optional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.kTextDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.kBorder, width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFile!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'No image selected',
                          style: TextStyle(color: AppColors.kHint),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library, size: 18),
                label: Text(_imageFile != null ? 'Change' : 'Pick Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (_imageFile != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => setState(() => _imageFile = null),
                  icon: const Icon(Icons.close, color: AppColors.kRed),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Bottom Buttons ----------
  Widget _buildBottomButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.kWhite,
                  side: const BorderSide(color: AppColors.kRed, width: 1.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kRed),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitPass,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.kWhite,
                        ),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kWhite),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}