import 'package:fizmaa/Screens/Auth/login_new.dart';
import 'package:fizmaa/Screens/Profile/coupons_screen.dart';
import 'package:fizmaa/Screens/Profile/kyc/buisness_form.dart';
import 'package:fizmaa/Screens/Profile/kyc/kyc_details.dart';
import 'package:fizmaa/Screens/Profile/profile_details_screen.dart';
import 'package:fizmaa/Screens/Profile/venue_list.dart';
import 'package:fizmaa/Screens/voluteer/VolunteersScreen.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/profile/profile_model.dart';
import 'package:fizmaa/models_n_services/profile/profile_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  bool _isLoading = true;
  ProfileData? _profileData;
  String? _error;

  late final ProfileService _profileService;

  // Helper: get initials
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  // Helper: get display name
  String _getDisplayName() {
    final profile = _profileData?.profile;
    if (profile == null) return 'User';
    return profile.fullName ?? profile.organisationName ?? 'User';
  }

  // Helper: get email
  String _getEmail() {
    return _profileData?.profile.email ?? 'No email';
  }

  // Helper: get phone
  String _getPhone() {
    return _profileData?.profile.phoneNo ?? 'No phone';
  }

  // Helper: get organisation
  String _getOrganisation() {
    return _profileData?.profile.organisationName ?? 'Organisation';
  }

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

  // ---------- Logout Function ----------
  Future<void> _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    // Clear SharedPreferences
    await AppPreferences.clear();

    // Navigate to LoginScreen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
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
    final verification = _profileData!.verificationStatus;
    final name = _getDisplayName();
    final email = _getEmail();
    final phone = _getPhone();
    final organisation = _getOrganisation();
    final initials = _getInitials(name);

    // Determine overall status badge
    final bool isVerified = verification.overallStatus == 'verified';
    final String statusLabel = isVerified ? 'Verified Organizer' : 'Pending Verification';
    final Color statusColor = isVerified ? const Color(0xFF16A34A) : const Color(0xFFD97706);
    final Color statusBgColor = isVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- TOP PROFILE HEADER ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F2547), // Dark navy blue background
                ),
                child: Row(
                  children: [
                    // Avatar Box
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // User Info & Badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // Status Badge (Dynamic)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Phone Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E7FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  phone,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const OrganizerProfileScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------- MANAGEMENT SECTION ----------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'MANAGEMENT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        iconBg: const Color(0xFFFEE2E2),
                        iconColor: const Color(0xFFEF4444),
                        title: 'Venues',
                        subtitle: 'Manage event locations',
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const VenueListScreen()));
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.people_alt_outlined,
                        iconBg: const Color(0xFFEEF2FF),
                        iconColor: const Color(0xFF6366F1),
                        title: 'Volunteers',
                        subtitle: 'Scanning staff & roles',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VolunteersScreen(organiserId: null),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.discount_outlined,
                        iconBg: const Color(0xFFFEF3C7),
                        iconColor: const Color(0xFFD97706),
                        title: 'Coupons & Discounts',
                        subtitle: 'Create & manage promo codes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CouponsMainScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.refresh_rounded,
                        iconBg: const Color(0xFFE0F2FE),
                        iconColor: const Color(0xFF0284C7),
                        title: 'Manage Refunds',
                        subtitle: 'Approve or dispute requests',
                        onTap: () {
                          // Navigate to Refunds management screen
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.trending_up_rounded,
                        iconBg: const Color(0xFFF0FDF4),
                        iconColor: const Color(0xFF16A34A),
                        title: 'Transaction History',
                        subtitle: 'Earnings, commissions & payouts',
                        onTap: () {
                          // Navigate to Transaction History screen
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------- APP SECTION ----------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'APP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.notifications_none_rounded,
                        iconBg: const Color(0xFFEEF2FF),
                        iconColor: const Color(0xFF6366F1),
                        title: 'Notifications',
                        subtitle: 'Push & email alerts',
                        onTap: () {
                          // Navigate to Notifications screen
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        iconBg: const Color(0xFFF3F4F6),
                        iconColor: const Color(0xFF6B7280),
                        title: 'Settings',
                        subtitle: 'Account & preferences',
                        onTap: () {
                          // Navigate to Settings screen
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.business_outlined,
                        iconBg: const Color(0xFFDCFCE7),
                        iconColor: const Color(0xFF16A34A),
                        title: 'Business Information',
                        subtitle: 'Business info',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BusinessOnboardingFlow(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.shield_outlined,
                        iconBg: const Color(0xFFDCFCE7),
                        iconColor: const Color(0xFF16A34A),
                        title: 'KYC & Verification',
                        subtitle: 'Business info, KYC, bank details',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KycDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildMenuItem(
                        icon: Icons.help_outline_rounded,
                        iconBg: const Color(0xFFFEF3C7),
                        iconColor: const Color(0xFFD97706),
                        title: 'Help & Support',
                        subtitle: 'FAQs and contact us',
                        onTap: () {
                          // Navigate to Help & Support screen
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------- LOGOUT BUTTON ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE2E2),
                      foregroundColor: const Color(0xFFEF4444),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------- APP VERSION FOOTER ----------
              const Center(
                child: Text(
                  'Fizmaa v2.1.0',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFD1D5DB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Reusable Menu Item ----------
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFD1D5DB),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}