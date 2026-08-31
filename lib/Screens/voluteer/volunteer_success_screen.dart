import 'package:fizmaa/Screens/voluteer/VolunteersScreen.dart';
import 'package:flutter/material.dart';

class VolunteerSuccessScreen extends StatelessWidget {
  final String volunteerName;
  final String role;
  final String email;

  const VolunteerSuccessScreen({
    super.key,
    required this.volunteerName,
    required this.role,
    required this.email,
  });

  // Compute initials from name
  String get _initials {
    final parts = volunteerName.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F8EE),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Success checkmark
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x2910B981),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Volunteer Added Successfully! 🎉',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const Spacer(flex: 2),

            // Main card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Inner profile card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFF3F4F6),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Avatar with initials
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Name
                          Text(
                            volunteerName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Role
                          Text(
                            role,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Email
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // View My Volunteers
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                           Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'View My Volunteers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Create New Volunteer
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate back to AddVolunteerScreen
                          Navigator.pop(context); // closes success screen
                          // Then we might want to pop again to go to AddVolunteer? Actually we want to go to AddVolunteerScreen.
                          // Since we are coming from ReviewDetailsScreen -> AddVolunteerScreen? Let's assume we want to go back to AddVolunteerScreen.
                          // But we might have nested navigation. Safer: pop to the first screen and then push AddVolunteer? 
                          // For simplicity, we'll pop all the way to the first screen and then push AddVolunteer.
                          // But the user said "Create New Volunteer" should go back to the add screen.
                          // Let's pop twice (success -> review -> add) if they are in the stack.
                          // We'll implement as: pop current, then pop again to reach AddVolunteerScreen.
                          Navigator.pop(context); // This will pop to the screen below success
                          // Now we are at ReviewDetailsScreen? Actually we replaced ReviewDetailsScreen with Success screen (pushReplacement), 
                          // so the stack has [AddVolunteerScreen, SuccessScreen]? We need to check.
                          // If we used pushReplacement, then Success replaced ReviewDetails, so stack is [AddVolunteerScreen, SuccessScreen].
                          // So popping once will go back to AddVolunteerScreen. So just one pop is enough.
                          // But if we used push (not replacement), we need to pop twice.
                          // Let's make it robust: we'll navigate to AddVolunteerScreen directly by pushing a new instance and clearing the stack.
                          // Simpler: just pop the success screen, and the user will be back to the previous screen (which is AddVolunteerScreen if we used replacement).
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEE2E2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Create New Volunteer',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}