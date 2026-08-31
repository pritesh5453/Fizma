import 'package:fizmaa/Screens/Profile/kyc/bank_details_screen.dart';
import 'package:fizmaa/Screens/Profile/kyc/kyc_details.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

// =============================================================================
// 1. MAIN PARENT WRAPPER (Sari screens ka flow handle karega)
// =============================================================================
class BusinessOnboardingFlow extends StatefulWidget {
  const BusinessOnboardingFlow({Key? key}) : super(key: key);

  @override
  State<BusinessOnboardingFlow> createState() => _BusinessOnboardingFlowState();
}

class _BusinessOnboardingFlowState extends State<BusinessOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // User swipe karke skip na kare
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        // STEP 1: Business Information
        BusinessInformationScreen(
          onNextPressed: _nextPage,
        ),
        // STEP 2: KYC Details
        KycDetailsScreen(
          onBackPressed: _previousPage,
          onNextPressed: _nextPage,
        ),
        BankDetailsScreen(
          onBackPressed: _previousPage,
          onNextPressed: _nextPage,
        ),
        // STEP 3: Bank Details (Placeholder - Aap apni bank details screen yahan attach kar sakte hain)
        Scaffold(
          appBar: AppBar(title: const Text("Bank Details")),
          body: Center(
            child: ElevatedButton(
              onPressed: _previousPage,
              child: const Text("Back to KYC"),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 2. STEP 1: BUSINESS INFORMATION SCREEN
// =============================================================================
class BusinessInformationScreen extends StatelessWidget {
  final VoidCallback? onNextPressed;

  const BusinessInformationScreen({Key? key, this.onNextPressed}) : super(key: key);

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
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Business Information',
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
              _buildImageHeader(),
              const SizedBox(height: 20),

              Row(
                children: const [
                  Text("Basic Details ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("*", style: TextStyle(color: AppColors.kRed, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),

              _buildLabelWithAttachment("GST Number (Optional)"),
              _buildTextField(initialValue: "GST54545345", prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.verified_user_outlined,
                iconBg: AppColors.statGreenBg,
                iconFg: AppColors.statGreenFg,
                title: "GST",
                subtitle: "GST****345",
                statusText: "VERIFIED",
                statusBg: AppColors.statGreenBg,
                statusFg: AppColors.statGreenFg,
                fileName: "GST_scanned.jpg",
              ),
              const SizedBox(height: 16),

              _buildLabel("Business Name"),
              _buildTextField(initialValue: "Fizma Organization", prefixIcon: Icons.business_outlined),
              const SizedBox(height: 12),

              _buildLabel("Business Email"),
              _buildTextField(initialValue: "fizmat@gmail.com", prefixIcon: Icons.email_outlined),
              const SizedBox(height: 12),

              _buildLabel("Business Mobile No."),
              _buildTextField(initialValue: "+91 8878590676", prefixIcon: Icons.phone_outlined),
              const SizedBox(height: 12),

              _buildLabel("Business Landline No."),
              _buildTextField(initialValue: "907347", prefixIcon: Icons.phone_in_talk_outlined),
              const SizedBox(height: 20),

              _buildSectionCard(
                title: "Social Media",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Instagram"),
                    _buildTextField(hintText: "Enter Instagram URL", prefixIconWidget: const Icon(Icons.camera_alt, color: Colors.pink, size: 18)),
                    const SizedBox(height: 10),
                    _buildLabel("Facebook"),
                    _buildTextField(hintText: "Enter Facebook URL", prefixIconWidget: const Icon(Icons.facebook, color: Colors.blue, size: 18)),
                    const SizedBox(height: 10),
                    _buildLabel("YouTube"),
                    _buildTextField(hintText: "Enter YouTube URL", prefixIconWidget: const Icon(Icons.play_arrow_rounded, color: Colors.red, size: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: "Address",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Complete Address"),
                    _buildTextField(
                      initialValue: "Flat 402, Sai Residency, Plot No. 12, Sector 20",
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Locality"),
                              _buildTextField(initialValue: "Parijat Nagar", prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("City"),
                              _buildTextField(initialValue: "Nashik", prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("State"),
                              _buildTextField(initialValue: "Maharashtra", prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Pincode"),
                              _buildTextField(initialValue: "400008", prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: "Update location on map",
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage('https://tile.openstreetmap.org/13/4193/2747.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 40),
                      Positioned(
                        bottom: 12,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kWhite,
                            foregroundColor: AppColors.kRed,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 2,
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.map_outlined, size: 16),
                          label: const Text("Edit Pin Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onNextPressed,
                  child: const Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
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
          _stepItem(step: "1", title: "Business Info", isActive: true),
          _stepDivider(),
          _stepItem(step: "2", title: "KYC Details", isActive: false),
          _stepDivider(),
          _stepItem(step: "3", title: "Bank Details", isActive: false),
        ],
      ),
    );
  }

  Widget _stepItem({required String step, required String title, required bool isActive}) {
    Color bg = isActive ? AppColors.kRed : Colors.grey.shade300;
    Color textCol = isActive ? AppColors.kRed : AppColors.textSecondary;

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
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider() {
    return Container(width: 8, height: 1, color: Colors.grey.shade300);
  }

  Widget _buildImageHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=500'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.edit, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text("Change Cover", style: TextStyle(color: Colors.white, fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: -25,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shield, size: 30, color: Colors.black87),
                    Text("LOGO DESIGN", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Positioned(
                bottom: -4,
                right: -4,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.edit, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
      ),
    );
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