import 'package:fizma/Screens/add_event/add_event_screen.dart';
import 'package:fizma/Screens/navbar/navbar.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class EventPublishedSuccessScreen extends StatefulWidget {
  final String eventTitle;
  final String organizerName;
  final String languages;
  final String eventId;
  final String venueLocation;

  const EventPublishedSuccessScreen({
    super.key,
    this.eventTitle = 'Bhajan Concert 2026',
    this.organizerName = 'Anup Jain',
    this.languages = 'Hindi, Marathi',
    this.eventId = 'EVT-2026-01',
    this.venueLocation = 'Manohar Garden, Nashik',
  });

  @override
  State<EventPublishedSuccessScreen> createState() => _EventPublishedSuccessScreenState();
}

class _EventPublishedSuccessScreenState extends State<EventPublishedSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _horizontalAnimation;

  @override
  void initState() {
    super.initState();
    // Continuous horizontal moving animation for the tick mark
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _horizontalAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F8F0), // Mint Light Green Background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ---------- MOVING TICK MARK ICON ----------
              AnimatedBuilder(
                animation: _horizontalAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_horizontalAnimation.value, 0),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981), // Emerald Green
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 52,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // ---------- TITLE TEXT WITH PARTY POPPER ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Event Published!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.kTextDark,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '🎉',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ---------- WHITE DETAILS CARD ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Calendar Pink Icon Box
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.kRed,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Event Title
                    Text(
                      widget.eventTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kTextDark,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Organizer | Languages | Event ID
                    Text(
                      'By : ${widget.organizerName} | ${widget.languages} | ID : ${widget.eventId}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Venue Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: Color(0xFF8E8E93),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.venueLocation,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Green Live Notice Ribbon
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Your event is now live and accepting registrations.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Button: View My Events
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => const EventsNavBar(initialIndex: 1)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View My Events',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Secondary Button: Create Another Event
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => const AddEventScreen()));
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFEAEA),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create Another Event',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kRed,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}