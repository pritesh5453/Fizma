import 'package:fizma/Screens/add_event/media_upload.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final List<String> languages = ['English', 'Spanish'];
  final List<String> tags = ['#livemusic', '#weekendvibes', '#outdoor'];

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
              _buildTopBar(),
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Event Name'),
                      _textField(hint: 'Enter Name'),
                      const SizedBox(height: 18),

                      _label('Event Category'),
                      _dropdown(hint: 'Select category'),
                      const SizedBox(height: 18),

                      _label('Select Artists'),
                      _dropdown(hint: 'Samay Raina'),
                      const SizedBox(height: 18),

                      _label('Age Restriction'),
                      _dropdown(hint: 'All Ages'),
                      const SizedBox(height: 18),

                      _label('Languages Supported'),
                      const SizedBox(height: 8),
                      _chipsWithAdd(
                        items: languages,
                        addLabel: '+ Add Language',
                      ),
                      const SizedBox(height: 18),

                      _label('Description'),
                      const SizedBox(height: 8),
                      _richTextBox(),
                      const SizedBox(height: 18),

                      _label('Tags for Discoverability'),
                      const SizedBox(height: 8),
                      _tagChipsWithAdd(items: tags),
                      const SizedBox(height: 18),

                      _label('Terms & Conditions'),
                      const SizedBox(height: 8),
                      _richTextBox(),
                      const SizedBox(height: 18),

                      _label('Facilities'),
                      const SizedBox(height: 8),
                      _richTextBox(),
                    ],
                  ),
                ),
              ),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Save & Proceed Button ----------
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MediaUploadScreen()),
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
    );
  }

  // ---------- Top App Bar ----------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
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

  // ---------- Progress Bar (4 segments, first active) ----------
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: List.generate(4, (index) {
          final bool active = index == 0;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
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

  // ---------- Section Label ----------
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
  Widget _textField({required String hint}) {
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

  // ---------- Dropdown-style Field ----------
  Widget _dropdown({required String hint}) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kHint),
        ],
      ),
    );
  }

  // ---------- Language Chips + Add Button ----------
  Widget _chipsWithAdd({required List<String> items, required String addLabel}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...items.map((e) => _chip(e)),
        _addChipButton(addLabel),
      ],
    );
  }

  // ---------- Tag Chips + circular Add Button ----------
  Widget _tagChipsWithAdd({required List<String> items}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...items.map((e) => _chip(e)),
        _circleAddButton(),
      ],
    );
  }

  Widget _chip(String text) {
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
          const Icon(Icons.close, size: 15, color: AppColors.kTextDark),
        ],
      ),
    );
  }

  Widget _addChipButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.kRed, width: 1.2, style: BorderStyle.solid),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.kRed,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _circleAddButton() {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.kRed, width: 1.2),
      ),
      child: const Icon(Icons.add, color: AppColors.kRed, size: 18),
    );
  }

  // ---------- Rich Text Box with formatting toolbar ----------
  Widget _richTextBox() {
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
              maxLines: 3,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Describe what makes your event special...',
                hintStyle: TextStyle(color: AppColors.kHint, fontSize: 13.5),
              ),
              style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Icon(icon, size: 18, color: AppColors.kTextDark.withOpacity(0.75)),
    );
  }
}