import 'package:fizma/Screens/navbar/navbar.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

// Complete Screen Implementation
class CreateTicketsScreen extends StatefulWidget {
  const CreateTicketsScreen({Key? key}) : super(key: key);

  @override
  State<CreateTicketsScreen> createState() => _CreateTicketsScreenState();
}

class _CreateTicketsScreenState extends State<CreateTicketsScreen> {
  bool isTicketActive = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gradient background set matching AppColors.screenGradient
      decoration: AppColors.screenGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent, // Background transparent for gradient
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kTextDark, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'Create Tickets',
            style: TextStyle(
              color: AppColors.kTextDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Top Progress Indicator (4 segments: 3 active, 1 inactive)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    _buildProgressSegment(isActive: true),
                    const SizedBox(width: 6),
                    _buildProgressSegment(isActive: true),
                    const SizedBox(width: 6),
                    _buildProgressSegment(isActive: true),
                    const SizedBox(width: 6),
                    _buildProgressSegment(isActive: false),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section: "My Tickets" + "Add More Ticket" Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'My Tickets',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              // Add ticket logic
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.kRed, width: 1.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              backgroundColor: AppColors.kWhite,
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.kRed),
                            label: const Text(
                              'Add More Ticket',
                              style: TextStyle(
                                color: AppColors.kRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Subtitle
                      const Text(
                        'Manage your upcoming event access.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Venue Info Block
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.kRed, size: 20),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Siddhivinayak Community Hall',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Nashik',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Ticket Card
                      _buildTicketCard(),
                    ],
                  ),
                ),
              ),

              // Bottom Action Buttons (Back & Submit for Review)
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Back Button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.kRed, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: AppColors.kWhite,
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.kRed,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Submit for Review Button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => const EventsNavBar()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kRed,
                            elevation: 2,
                            shadowColor: AppColors.kRed.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit for Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Top Progress Bar Segments
  Widget _buildProgressSegment({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? AppColors.kRed : AppColors.kChipBg,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // Helper widget for Ticket Card
  Widget _buildTicketCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag, Serial & Toggle Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tagBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'VIP',
                      style: TextStyle(
                        color: AppColors.tagFg,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'FIZ-99283-X',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Custom Colored Switch
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isTicketActive,
                  activeColor: AppColors.kWhite,
                  activeTrackColor: AppColors.statGreenFg,
                  onChanged: (val) {
                    setState(() {
                      isTicketActive = val;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Ticket Title
          const Text(
            'VIP Pass',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Text(
                'Siddhivinayak Community Hall',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Date & Time
          Row(
            children: const [
              Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Text(
                'Oct 26 | 08:00 PM',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Dotted Divider Line
          Row(
            children: List.generate(
              30,
              (index) => Expanded(
                child: Container(
                  height: 1,
                  color: index % 2 == 0 ? AppColors.kPink : Colors.transparent,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Action Chips (View, Edit, Delete)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionChip(
                icon: Icons.remove_red_eye_outlined,
                iconColor: AppColors.chipViewFg,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _buildActionChip(
                icon: Icons.edit_outlined,
                iconColor: AppColors.chipEditFg,
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _buildActionChip(
                icon: Icons.delete_outline,
                iconColor: AppColors.chipDeleteFg,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for View / Edit / Delete Action Icons
  Widget _buildActionChip({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}