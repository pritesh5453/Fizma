import 'package:flutter/material.dart';

class CustHomeScreen extends StatefulWidget {
  const CustHomeScreen({super.key});

  @override
  State<CustHomeScreen> createState() => _CustHomeScreenState();
}

class _CustHomeScreenState extends State<CustHomeScreen> {
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _subCategories = [
    {'label': 'All', 'icon': Icons.grid_view},
    {'label': 'Venue', 'icon': Icons.location_city},
    {'label': 'Photography', 'icon': Icons.camera_alt_outlined},
    {'label': 'Caterer', 'icon': Icons.restaurant},
    {'label': 'Anchor', 'icon': Icons.mic_none},
    {'label': 'Cakes', 'icon': Icons.cake_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 80), // 👈 ye FAB ko upar karega
  child: Container(
    width: 50,
    height: 50,
    decoration: const BoxDecoration(
      color: Color(0xFFFF2B4A),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.headset_mic_outlined, color: Colors.white),
  ),
),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://picsum.photos/100'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hello, User', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.green, size: 14),
                          SizedBox(width: 4),
                          Text('Nashik', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 14),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  _buildHeaderIcon(Icons.favorite_border),
                  _buildHeaderIcon(Icons.shopping_bag_outlined),
                  _buildHeaderIcon(Icons.notifications_none),
                ],
              ),
              const SizedBox(height: 15),

              // 2. Top Color Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('Fizmaa', Icons.bolt, const Color(0xFFFF2B4A), Colors.white),
                    _buildChip('50% Off Zone', Icons.sell_outlined, const Color(0xFFFFF0E6), const Color(0xFFFF8A3D)),
                    _buildChip('Rental Mall', Icons.storefront_outlined, const Color(0xFFEBF3FF), const Color(0xFF3B82F6)),
                    _buildChip('Everyday Deals', Icons.card_giftcard, const Color(0xFFEAF8EC), const Color(0xFF22A745)),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // 3. Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search venues, caterers, photographers...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFFF2B4A),
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white, size: 16),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFFFF2B4A)),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 4. Sub-Categories Icon Scroll Section
              SizedBox(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _subCategories.length,
                  itemBuilder: (context, index) {
                    final item = _subCategories[index];
                    final isSelected = _selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryIndex = index),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFFF0F2) : Colors.transparent,
                                shape: BoxShape.circle,
                                border: isSelected ? Border.all(color: const Color(0xFFFF2B4A)) : null,
                              ),
                              child: Icon(
                                item['icon'],
                                color: isSelected ? const Color(0xFFFF2B4A) : Colors.grey[700],
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? const Color(0xFFFF2B4A) : Colors.black87,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                height: 2,
                                width: 16,
                                color: const Color(0xFFFF2B4A),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),

              // 5. Hero Banner Carousel Card
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B0000), Color(0xFFFF3333)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/400/220?wedding'),
                    fit: BoxFit.cover,
                    opacity: 0.35,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text("Celebrate Life's Best Moments", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('Make Every\nCelebration Special', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Discover top venues, trusted vendors\nand unforgettable experiences.', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Explore Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF2B4A))),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14, color: Color(0xFFFF2B4A)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          height: 6,
                          width: 18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 6. Discover New Finds Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Discover New Finds ✨', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.star_border, color: Color(0xFFFF2B4A)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: NetworkImage('https://picsum.photos/300/400?flower'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Explore More\nVendor!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('VIEW COLLECTIONS', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          height: 119,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image: NetworkImage('https://picsum.photos/300/200?camera'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Photography', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              Text('BOOK ARTISTS', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 119,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image: NetworkImage('https://picsum.photos/300/200?food'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Catering', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              Text('ELITE CHEFS', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 7. Couple Countdown Banner
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/500/300?couple'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          _TimerText(val: '871', label: 'Days'),
                          SizedBox(width: 15),
                          _TimerText(val: '7', label: 'Hours'),
                          SizedBox(width: 15),
                          _TimerText(val: '16', label: 'Min'),
                          SizedBox(width: 15),
                          _TimerText(val: '36', label: 'Sec'),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF2B4A),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Riya & Arjun', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Wedding on 19 July 2026', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 8. Trending Services Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Trending Services', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2B4A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('View All', style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildServiceCard('Gateway Nashik', '75,000', '4.8 (256)'),
                    const SizedBox(width: 12),
                    _buildServiceCard('Grand Aura p...', '75,000', '4.8 (259)'),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 9. Discount Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6F7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFC9D2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sell, color: Color(0xFFFF2B4A), size: 34),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                  children: [
                                    TextSpan(text: 'Save up to '),
                                    TextSpan(text: '20%', style: TextStyle(color: Color(0xFFFF2B4A))),
                                  ],
                                ),
                              ),
                              const Text('on Wedding Packages', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.card_giftcard, color: Color(0xFFFF2B4A), size: 34),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFFC9D2)),
                          ),
                          child: const Text('Use Code: FIZMAA20', style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF2B4A),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Grab Offer', style: TextStyle(color: Colors.white, fontSize: 12)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 10. Unforgettable Events
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Unforgettable Events Start Here', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildEventCategoryCard(
                      'Wedding',
                      'Make your dream\nwedding a reality',
                      Colors.pink.shade50,
                      const Color(0xFFC2185B),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEventCategoryCard(
                      'Birthday',
                      'Celebrate special\nmoments',
                      Colors.purple.shade50,
                      const Color(0xFF7B1FA2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEventCategoryCard(
                      'Corporate',
                      'Professional events\nperfectly planned',
                      Colors.blue.shade50,
                      const Color(0xFF1565C0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 11. Nearby Events
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nearby Events', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2B4A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('View All', style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 190,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildNearbyEventCard(
                      image: 'https://picsum.photos/220/140?concert1',
                      badge: '10\nJune',
                      title: 'Bhajan Concert',
                      subtitle: '11 pm June 10, 2022\nGateway, Nashik',
                      price: '₹400 onward',
                    ),
                    const SizedBox(width: 12),
                    _buildNearbyEventCard(
                      image: 'https://picsum.photos/220/140?concert2',
                      badge: '2\nMay',
                      title: 'Bollywood Night Desi Party',
                      subtitle: '11 pm June 10, 2022\nBacalls Blue Midtown, NY',
                      price: '₹400 onward',
                    ),
                    const SizedBox(width: 12),
                    _buildNearbyEventCard(
                      image: 'https://picsum.photos/220/140?concert3',
                      badge: null,
                      title: 'Live Band Night',
                      subtitle: '11 pm June 10, 2022\nGateway, Nashik',
                      price: '₹400 onward',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  static Widget _buildHeaderIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF0F2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFFFF2B4A), size: 18),
    );
  }

  static Widget _buildChip(String label, IconData icon, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  static Widget _buildServiceCard(String title, String price, String rating) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network('https://picsum.photos/200/140?hall', height: 140, width: double.infinity, fit: BoxFit.cover),
              ),
              const Positioned(
                top: 8, right: 8,
                child: CircleAvatar(
                  radius: 12, backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: Colors.red, size: 14),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Venue', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    Text(' $rating', style: const TextStyle(color: Colors.black87, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Starting From', style: TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹$price', style: const TextStyle(color: Color(0xFFFF2B4A), fontWeight: FontWeight.bold, fontSize: 14)),
                        const Text('onwards', style: TextStyle(color: Colors.grey, fontSize: 9)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2B4A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Book Now', style: TextStyle(color: Colors.white, fontSize: 10)),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget _buildEventCategoryCard(String title, String description, Color bg, Color textColor) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(description, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 9)),
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_forward, size: 10, color: textColor),
            ),
          )
        ],
      ),
    );
  }

  static Widget _buildNearbyEventCard({
    required String image,
    String? badge,
    required String title,
    required String subtitle,
    required String price,
  }) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(image, height: 90, width: double.infinity, fit: BoxFit.cover),
              ),
              if (badge != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFFF2B4A), fontSize: 10, fontWeight: FontWeight.bold, height: 1.1),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: Color(0xFFFF2B4A), fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TimerText extends StatelessWidget {
  final String val;
  final String label;
  const _TimerText({required this.val, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ],
    );
  }
}