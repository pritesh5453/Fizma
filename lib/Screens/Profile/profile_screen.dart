import 'package:fizma/Screens/Auth/login_new.dart';
import 'package:fizma/Screens/Profile/edit_profile.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';
// Import your LoginScreen here
// import 'package:fizma/screens/login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppColors.screenGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),
               _buildProfileCard(context),
                const SizedBox(height: 16),
                _buildMenuCard(context),
                const SizedBox(height: 16),
                _buildLogoutCard(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Profile Header Card ---
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryRed,
                      child: const Text(
                        'PP',
                        style: TextStyle(
                          color: AppColors.kWhite,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.kWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryRed,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
  right: 0,
  top: 0,
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        showBasicDetailsDialog(context);
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.statPinkBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.edit_outlined,
          color: AppColors.primaryRed,
          size: 18,
        ),
      ),
    ),
  ),
),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Pritesh Pawar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'pritesh@gmail.com',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.actionRedBg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildStatItem('EVENTS', '48', AppColors.textPrimary),
                _buildVerticalDivider(),
                _buildStatItem('TICKETS', '12.4K', AppColors.primaryRed),
                _buildVerticalDivider(),
                _buildStatItem('REVENUE', '₹8.2L', AppColors.textPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: AppColors.kBorder.withOpacity(0.5),
    );
  }

  // --- Menu Card ---
  Widget _buildMenuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.storefront_outlined,
            iconBg: AppColors.chipViewBg,
            iconColor: AppColors.chipViewFg,
            title: 'Business Information',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.calendar_today_outlined,
            iconBg: AppColors.statPurpleBg,
            iconColor: AppColors.statPurpleFg,
            title: 'My Events',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.account_balance_wallet_outlined,
            iconBg: AppColors.statGreenBg,
            iconColor: AppColors.statGreenFg,
            title: 'Payment',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.notifications_none_outlined,
            iconBg: AppColors.statOrangeBg,
            iconColor: AppColors.statOrangeFg,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.help_outline_rounded,
            iconBg: AppColors.chipViewBg,
            iconColor: AppColors.chipViewFg,
            title: 'Help & Support',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.shield_outlined,
            iconBg: AppColors.chipViewBg,
            iconColor: AppColors.chipViewFg,
            title: 'Privacy Policy',
            isLast: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // --- Log Out Card ---
  Widget _buildLogoutCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showLogoutDialog(context), // Logout Dialog trigger
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.actionRedBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.kChipBg,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Custom Logout Confirmation BottomSheet Dialog
  // -------------------------------------------------------------
  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar at the top
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.kChipBg,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Logout Icon Circle Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: AppColors.actionRedBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.primaryRed,
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons Row
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.kBorder, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColors.kWhite,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Confirm Logout Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, 
                          MaterialPageRoute(builder: (context) => const LoginScreen()));
                          
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Yes, Log Out',
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}