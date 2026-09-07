import 'package:fizmaa/Customer_app/event_ticket/event_details_screen/event_details_screen.dart';
import 'package:flutter/material.dart';

class EventTicketsScreen extends StatefulWidget {
  const EventTicketsScreen({super.key});

  @override
  State<EventTicketsScreen> createState() => _EventTicketsScreenState();
}

class _EventTicketsScreenState extends State<EventTicketsScreen> {
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All Events', 'icon': Icons.grid_view_rounded},
    {'label': 'Concerts', 'icon': Icons.mic_none_rounded},
    {'label': 'Dance', 'icon': Icons.accessibility_new_rounded},
    {'label': 'Music', 'icon': Icons.music_note_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Event Tickets',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: const [
                          Icon(Icons.location_on_outlined, color: Color(0xFFFF2B4A), size: 14),
                          SizedBox(width: 4),
                          Text('Nashik', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Coin Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB800),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'F',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('200', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Notification Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: Color(0xFFFF2B4A), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Event Category Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFF2B4A) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF2B4A) : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _categories[index]['icon'],
                              size: 16,
                              color: isSelected ? Colors.white : const Color(0xFFFF2B4A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _categories[index]['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search venues, caterers, photographers...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFFF2B4A),
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white, size: 14),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFFFF2B4A)),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 4. Featured Banner
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/600/300?concert'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 10, right: 10,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black38,
                        child: Icon(Icons.favorite_border, color: Colors.white, size: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('LIVE IN NASHIK', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 4),
                          const Text('Ram Navami Special', style: TextStyle(color: Colors.amber, fontSize: 11)),
                          const Text('BHAJAN CONCERT', style: TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('An Evening of Devotion & Music', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _infoChip(Icons.calendar_today, '17 Apr, 6:00 PM'),
                              const SizedBox(width: 6),
                              _infoChip(Icons.location_on, 'Siddhivinayak Hall, Nashik'),
                              const Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF2B4A),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                ),
                                onPressed: () {},
                                child: const Text('Book Now →', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 5. Recent Concert Shows
              const Text('Recent Concert Shows', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('Latest concerts you shouldn\'t miss', style: TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 12),

              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildRecentConcertCard('EDM Vibes Festival', 'Music Festival', 'May 24 • 5:00 PM', 'City Convention Center', '890'),
                    const SizedBox(width: 12),
                    _buildRecentConcertCard('Rock Night Live', 'Rock', 'May 28 • 7:00 PM', 'Stadium Nashik', '1200'),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 6. Happening This Week (Ticket Cards)
              const Text(
                'Happening This Week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2022)),
              ),
              const SizedBox(height: 2),
              Text(
                "Don't miss out on these amazing events",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 14),

              // Ticket 1
              _buildExactTicketCard(
                imageUrl: 'https://picsum.photos/200/200?bhajan',
                title: 'Bhajan Concert',
                category: 'Entertainment',
                date: 'Apr 11 • 6:00 PM',
                location: 'Nashik',
                points: '20',
                price: '400',
              ),
              const SizedBox(height: 14),

              // Ticket 2
              _buildExactTicketCard(
                imageUrl: 'https://picsum.photos/200/200?jazz',
                title: 'Jazz Concert',
                category: 'Entertainment',
                date: 'Apr 11 • 6:00 PM',
                location: 'Nashik',
                points: '20',
                price: '450',
              ),
              const SizedBox(height: 14),

              // Ticket 3
              _buildExactTicketCard(
                imageUrl: 'https://picsum.photos/200/200?music',
                title: 'Jazz Concert',
                category: 'Entertainment',
                date: 'Apr 11 • 6:00 PM',
                location: 'Nashik',
                points: '20',
                price: '450',
              ),
              const SizedBox(height: 20),

              // 7. Nearby Happenings Banner
              _buildNearbyHappeningsBanner(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Info Chip (static – no context needed)
  static Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 10),
          const SizedBox(width: 3),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 9)),
        ],
      ),
    );
  }

  // Helper: Recent Concert Card (static – no navigation)
  static Widget _buildRecentConcertCard(String title, String tag, String date, String location, String price) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.network('https://picsum.photos/120/150?party', width: 110, height: double.infinity, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(tag, style: const TextStyle(color: Colors.pink, fontSize: 9)),
                  ),
                  const SizedBox(height: 6),
                  Text('📅 $date', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  Text('📍 $location', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹$price', style: const TextStyle(color: Color(0xFFFF2B4A), fontWeight: FontWeight.bold, fontSize: 14)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF2B4A),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: const Text('Book', style: TextStyle(color: Colors.white, fontSize: 10)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ✅ FIXED: Removed 'static' so it can access 'context' (instance method)
  Widget _buildExactTicketCard({
    required String imageUrl,
    required String title,
    required String category,
    required String date,
    required String location,
    required String points,
    required String price,
  }) {
    return PhysicalShape(
      clipper: TicketClipper(notchRadius: 10, splitPositionRatio: 0.64),
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.08),
      child: Container(
        height: 125,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            // Left Section (64%)
            Expanded(
              flex: 64,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2022)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDE8EC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF8C7381), fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 11, color: Color(0xFFFF3B5C)),
                            const SizedBox(width: 4),
                            Text(date, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 11, color: Color(0xFFFF3B5C)),
                            const SizedBox(width: 4),
                            Text(location, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(color: Color(0xFFFFB800), shape: BoxShape.circle),
                              child: const Center(
                                child: Text('F', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(points, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dashed Divider
            CustomPaint(
              size: const Size(1, double.infinity),
              painter: DashedLinePainter(),
            ),

            // Right Section (36%)
            Expanded(
              flex: 36,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.favorite_border, size: 16, color: Color(0xFFFF3B5C)),
                    ),
                    const Spacer(),
                    Text('Starts from', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                    Text('₹$price', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF3B5C))),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF5268), Color(0xFFFF1A3C)],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // ✅ NOW 'context' is available because this method is NOT static
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                          );
                        },
                        child: const Text('Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Nearby Happenings Banner (static – no context)
  static Widget _buildNearbyHappeningsBanner() {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6575), Color(0xFFFF2B4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              'https://picsum.photos/300/300?map',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Nearby\nHappenings✨',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.1),
                ),
                const SizedBox(height: 8),
                Text(
                  '12 Live events happening within 5km of your location.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for Ticket Shape
class TicketClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double splitPositionRatio;

  TicketClipper({this.notchRadius = 10, this.splitPositionRatio = 0.64});

  @override
  Path getClip(Size size) {
    final path = Path();
    final notchCenter = size.width * splitPositionRatio;

    path.lineTo(notchCenter - notchRadius, 0);
    path.arcToPoint(
      Offset(notchCenter + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(notchCenter + notchRadius, size.height);
    path.arcToPoint(
      Offset(notchCenter - notchRadius, size.height),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Painter for Vertical Dashed Line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 3, startY = 12;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    while (startY < size.height - 12) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
