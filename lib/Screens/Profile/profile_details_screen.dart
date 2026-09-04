import 'package:fizmaa/Screens/Profile/kyc/buisness_form.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/profile/profile_model.dart';
import 'package:fizmaa/models_n_services/profile/profile_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class OrganizerProfileScreen extends StatefulWidget {
  const OrganizerProfileScreen({super.key});

  @override
  State<OrganizerProfileScreen> createState() => _OrganizerProfileScreenState();
}

class _OrganizerProfileScreenState extends State<OrganizerProfileScreen> {
  bool _isLoading = true;
  ProfileData? _profileData;
  String? _error;

  late final ProfileService _profileService;

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    _profileService = ProfileService(dio);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _profileService.getProfile();
      setState(() {
        _profileData = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // Helper: Get initials from name
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  // Helper: Get verification status text
  String _getVerificationStatus(bool isVerified) {
    return isVerified ? 'VERIFIED' : 'PENDING';
  }

  // Helper: Get verification colors
  Color _getVerificationBgColor(bool isVerified) {
    return isVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
  }

  Color _getVerificationTextColor(bool isVerified) {
    return isVerified ? const Color(0xFF16A34A) : const Color(0xFFD97706);
  }

  Color _getVerificationIconColor(bool isVerified) {
    return isVerified ? const Color(0xFF22C55E) : const Color(0xFFD97706);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF8F6),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDF8F6),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              const Text('Failed to load profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final profile = _profileData!.profile;
    final business = _profileData!.business;
    final kyc = _profileData!.kyc;
    final bank = _profileData!.bank;
    final verification = _profileData!.verificationStatus;

    final name = profile.fullName ?? profile.organisationName;
    final organisation = profile.organisationName;
    final email = profile.email;
    final phone = profile.phoneNo;
    final location = '${business.city}, ${business.state}';

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------- TOP HEADER WITH AVATAR ----------
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Dark Blue Header Bar
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: const Color(0xFF0F2547),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 22),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                        ),
                        const Text(
                          'Organizer Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Edit Button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                            onPressed: () {
                              // Navigate to edit profile screen
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Avatar Overlapping Header
                  Positioned(
                    bottom: -32,
                    child: Stack(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFDF8F6), width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _getInitials(name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Green Online Badge Icon
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: verification.overallStatus == 'verified'
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 42),

              // ---------- USER INFO ----------
              Text(
                name ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                organisation ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 8),

              // Pro Organizer Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  verification.overallStatus == 'verified' ? 'Verified Organizer' : 'Pending Verification',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------- CONTACT INFO CARD ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      _buildContactRow(
                        icon: Icons.email_outlined,
                        value: email,
                      ),
                      const SizedBox(height: 12),
                      _buildContactRow(
                        icon: Icons.phone_outlined,
                        value: phone,
                      ),
                      const SizedBox(height: 12),
                      _buildContactRow(
                        icon: Icons.location_on_outlined,
                        value: location,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------- KYC VERIFICATION SECTION ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'KYC Verification',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BusinessOnboardingFlow(),
                          ),
                        );
                      },
                      child: const Text(
                        'Manage >',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      _buildKycRow(
                        title: 'Business Info',
                        isVerified: verification.businessVerified,
                      ),
                      const SizedBox(height: 12),
                      _buildKycRow(
                        title: 'KYC Details',
                        isVerified: verification.kycVerified,
                      ),
                      const SizedBox(height: 12),
                      _buildKycRow(
                        title: 'Bank Details',
                        isVerified: verification.bankVerified,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------- BOTTOM STATS CARDS (3 GRID) ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        value: '12',
                        label: 'Events',
                        bgColor: const Color(0xFFEEF2FF),
                        textColor: const Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        value: '₹2.8L',
                        label: 'Revenue',
                        bgColor: const Color(0xFFDCFCE7),
                        textColor: const Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        value: '4.9 ★',
                        label: 'Rating',
                        bgColor: const Color(0xFFFEF3C7),
                        textColor: const Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- UI Helpers ----------

  Widget _buildContactRow({required IconData icon, required String value}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFEF4444), size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }

  Widget _buildKycRow({required String title, required bool isVerified}) {
    final status = _getVerificationStatus(isVerified);
    final bgColor = _getVerificationBgColor(isVerified);
    final textColor = _getVerificationTextColor(isVerified);
    final iconColor = _getVerificationIconColor(isVerified);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isVerified ? Icons.check_rounded : Icons.schedule_rounded,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}