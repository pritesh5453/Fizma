import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class KycDetailsScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onNextPressed;

  const KycDetailsScreen({
    Key? key,
    this.onBackPressed,
    this.onNextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppColors.screenGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kTextDark, size: 20),
            onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'KYC Details',
            style: TextStyle(
              color: AppColors.kTextDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepperHeader(),
              const SizedBox(height: 16),

              const Text(
                "KYC Verification Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.kTextDark),
              ),
              const SizedBox(height: 16),

              // Aadhaar Section
              _buildLabelWithAttachment("Aadhaar Number"),
              _buildTextField(initialValue: "674284389333", prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.badge_outlined,
                iconBg: AppColors.statGreenBg,
                iconFg: AppColors.statGreenFg,
                title: "Aadhaar Card",
                subtitle: "**** **** 1234",
                statusText: "VERIFIED",
                statusBg: AppColors.statGreenBg,
                statusFg: AppColors.statGreenFg,
                fileName: "aadhaar_front_copy.pdf",
                fileSize: "1.2 MB",
              ),
              const SizedBox(height: 16),

              // Pan Card Section
              _buildLabelWithAttachment("Pan Card"),
              _buildTextField(initialValue: "54545345", prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.account_balance_wallet_outlined,
                iconBg: AppColors.statGreenBg,
                iconFg: AppColors.statGreenFg,
                title: "PAN Card",
                subtitle: "BNMP*****K",
                statusText: "VERIFIED",
                statusBg: AppColors.statGreenBg,
                statusFg: AppColors.statGreenFg,
                fileName: "pan_card_scanned.jpg",
                fileSize: "850 KB",
              ),
              const SizedBox(height: 16),

              // Business License (Optional)
              _buildLabelWithAttachment("Business License(Optional)"),
              _buildTextField(initialValue: "54545345", prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.restaurant,
                iconBg: AppColors.statOrangeBg,
                iconFg: AppColors.statOrangeFg,
                title: "License",
                statusText: "PENDING",
                statusBg: AppColors.statOrangeBg,
                statusFg: AppColors.statOrangeFg,
                fileName: "License_2025.pdf",
                fileSize: "2.1 MB",
                warningText: "Document under review by admin",
              ),
              const SizedBox(height: 20),

              // Certificates Section
              _buildSectionCard(
                title: "Certificates",
                titleIcon: Icons.verified_outlined,
                child: Column(
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFBEB),
                        side: const BorderSide(color: Color(0xFFFCD34D)),
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD97706), size: 18),
                      label: const Text("Buy Certifications", style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(height: 10),
                    _buildPdfFileTile(fileName: "fizmaa Trust Center .pdf", fileSize: "2.1 MB"),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Navigation Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.kRed),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
                        child: const Text("Back", style: TextStyle(color: AppColors.kTextDark, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: onNextPressed,
                        child: const Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stepItem(step: "1", title: "Business Info", isActive: false, isCompleted: true),
          _stepDivider(),
          _stepItem(step: "2", title: "KYC Details", isActive: true, isCompleted: false),
          _stepDivider(),
          _stepItem(step: "3", title: "Bank Details", isActive: false, isCompleted: false),
        ],
      ),
    );
  }

  Widget _stepItem({required String step, required String title, required bool isActive, bool isCompleted = false}) {
    Color bg = isActive || isCompleted ? AppColors.kRed : Colors.grey.shade300;
    Color textCol = isActive || isCompleted ? AppColors.kRed : AppColors.textSecondary;

    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: bg,
          child: Text(
            step,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            color: textCol,
            fontSize: 11,
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider() {
    return Container(width: 8, height: 1, color: Colors.grey.shade300);
  }

  Widget _buildLabelWithAttachment(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const Icon(Icons.attach_file, size: 16, color: AppColors.kRed),
        ],
      ),
    );
  }

  Widget _buildTextField({
    String? initialValue,
    String? hintText,
    IconData? prefixIcon,
    Widget? prefixIconWidget,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.5)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        style: const TextStyle(fontSize: 13, color: AppColors.kTextDark, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 12),
          prefixIcon: prefixIconWidget ?? (prefixIcon != null ? Icon(prefixIcon, size: 16, color: AppColors.kRed) : null),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    String? subtitle,
    required String statusText,
    required Color statusBg,
    required Color statusFg,
    required String fileName,
    String fileSize = "1.2 MB",
    String? warningText,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconFg, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.kTextDark)),
                  if (subtitle != null)
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusFg, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (warningText != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(6)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Color(0xFFD97706)),
                  const SizedBox(width: 6),
                  Text(warningText, style: const TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          _buildPdfFileTile(fileName: fileName, fileSize: fileSize),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, IconData? titleIcon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (titleIcon != null) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.kPink, borderRadius: BorderRadius.circular(6)),
                  child: Icon(titleIcon, size: 16, color: AppColors.kRed),
                ),
                const SizedBox(width: 8),
              ],
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.kTextDark)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildPdfFileTile({required String fileName, required String fileSize}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.kTextDark)),
                const SizedBox(height: 2),
                Text("$fileSize •", style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}