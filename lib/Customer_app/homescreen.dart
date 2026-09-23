import 'package:fizmaa/Customer_app/event_ticket/event_details_screen/event_details_screen.dart';
import 'package:fizmaa/Screens/events/EventDetails_screen.dart';
import 'package:flutter/material.dart';

class EventHomeScreen extends StatelessWidget {
  const EventHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeaderSection(),
            const SizedBox(height: 30),
            _buildSectionHeader("Explore categories", showSeeAll: true),
            _buildCategoriesRow(),
            const SizedBox(height: 20),
            _buildSectionHeader(
              "Trending Events",
              subtitle: "Latest concerts you shouldn't miss",
              showSeeAll: true,
            ),
            _buildEventCarousel(),
            const SizedBox(height: 20),
            _buildMusicConcertsBanner(context),
            const SizedBox(height: 20),
            _buildSectionHeader("Featured Events", showSeeAll: true),
            _buildFilterChips(),
            _buildEventsGrid(context, startIndex: 0, itemCount: 2),
            const SizedBox(height: 8),
            _buildRedeemBanner(),
            const SizedBox(height: 20),
            _buildSectionHeader("Nearby Happenings ✨", showSeeAll: false),
            _buildEventsGrid(context, startIndex: 2, itemCount: 2),
            const SizedBox(height: 20),
            _buildExploreEventsByCity(),
            const SizedBox(height: 20),
            _buildFizmaaRewardsBanner(),
            const SizedBox(height: 20),
            _buildSectionHeader("All Events", showSeeAll: false),
            _buildEventsGrid(context),
            const SizedBox(height: 20),
            _buildSectionHeader("Artists in your event", showSeeAll: false),
            _buildArtistsRow(),
            const SizedBox(height: 20),
            _buildSectionHeader("Music & Concerts", showSeeAll: false),
            _buildEventsGrid(context, startIndex: 0, itemCount: 2),
            const SizedBox(height: 20),
            _buildSectionHeader("Theatre", showSeeAll: false),
            _buildFilterChips(),
            _buildEventsGrid(context),
            const SizedBox(height: 20),
            _buildSectionHeader("Event Partners", showSeeAll: false),
            _buildPartnersRow(),
            const SizedBox(height: 20),
            _buildFooterAndListings(),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  // --- TOP HEADER & STACKED IMAGES BANNER SECTION ---
  Widget _buildTopHeaderSection() {
    const String parentFestiveBackgroundAsset = 'assets/images/fizma_back.png';
    const String childHeroBannerCardImage =
        'https://picsum.photos/id/1025/600/400';
    const String flowerAsset = 'assets/icons/Group.png';

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 520),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(parentFestiveBackgroundAsset, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.35),
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),
          ),

          // ===== BOTTOM LEFT FLOWER =====
          Positioned(
            bottom: -25,
            left: -5,
            child: Image.asset(flowerAsset, width: 40, height: 40),
          ),

          // ===== BOTTOM RIGHT FLOWER =====
          Positioned(
            bottom: -25,
            right: -5,
            child: Image.asset(flowerAsset, width: 40, height: 40),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          'https://picsum.photos/id/64/200/200',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Nashik",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B000D),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.amber.shade600,
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.amber,
                              child: Text(
                                'F',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "200",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B000D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Search venues, caterers, photographers...",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 210),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.amber.shade600.withOpacity(0.6),
                        width: 1,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(childHeroBannerCardImage),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.85),
                                Colors.transparent,
                                Colors.black.withOpacity(0.9),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF320042),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 3,
                                          backgroundColor: Colors.purpleAccent,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "LIVE IN NASHIK",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Text(
                                "Ram Navami Special",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              const Text(
                                "BHAJAN",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const Text(
                                "CONCERT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.amber,
                                          size: 9,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "17 Apr, 6:00 PM",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.amber,
                                          size: 9,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Siddhivinayak, Nashik",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION HEADER ---
  Widget _buildSectionHeader(
    String title, {
    String? subtitle,
    bool showSeeAll = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showSeeAll)
                const Text(
                  "See All >",
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  // --- CATEGORIES ---
  Widget _buildCategoriesRow() {
    final categories = [
      {"icon": Icons.queue_music, "label": "Events", "isSelected": true},
      {"icon": Icons.headphones, "label": "Concerts", "isSelected": false},
      {"icon": Icons.local_dining, "label": "Theatre", "isSelected": false},
      {"icon": Icons.theater_comedy, "label": "Comedy", "isSelected": false},
      {"icon": Icons.music_note, "label": "Music", "isSelected": false},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          final isSelected = item["isSelected"] as bool;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFF4EE)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: const Color(0xFFE8A87C), width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      item["icon"] as IconData,
                      color: isSelected
                          ? const Color(0xFFD35400)
                          : Colors.black87,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item["label"] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- EVENT CARD BUILDER ---
  Widget _buildEventCard(BuildContext context, {bool isGrid = false}) {
    return Container(
      width: isGrid ? double.infinity : 170,
      margin: isGrid
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.network(
                  'https://picsum.photos/id/1015/300/400',
                  height: 230,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EDM Vibes Festival",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Music Festival",
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey.shade500,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "May 24 • 5:00 PM",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey.shade500,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "City Convention Center",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "₹890",
                      style: TextStyle(
                        color: Color(0xFF1F1F1F),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EventDetailsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Book",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- EVENT CAROUSEL ---
  Widget _buildEventCarousel() {
    return SizedBox(
      height: 370,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildEventCard(context, isGrid: false);
        },
      ),
    );
  }

  // --- MUSIC & CONCERTS BANNER ---
  Widget _buildMusicConcertsBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF000000), Color(0xFFCB9C50), Color(0xFF3D0C05)],
          stops: [0.3583, 0.6792, 1.0],
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://picsum.photos/id/1018/400/600',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 14.0,
                  top: 4.0,
                  bottom: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Music & Concerts",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Raasiya Navratri",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "11 Oct 2026 at 5:00 pm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "3 Big Venues, All within your\nreach , Nashik, Maharashtra, 422007",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 32,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EventDetailsScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFD3331C),
                                width: 1.2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Book Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Similar Shows",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://picsum.photos/id/1015/200/300',
                                width: 58,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://picsum.photos/id/1019/200/300',
                                width: 58,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FILTER CHIPS ---
  Widget _buildFilterChips() {
    final filters = ["Filters ∨", "Today", "Tomorrow", "Music"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                filters[index],
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- EVENTS GRID ---
  Widget _buildEventsGrid(
    BuildContext context, {
    int startIndex = 0,
    int itemCount = 4,
  }) {
    List<Widget> rows = [];
    for (int i = 0; i < itemCount; i += 2) {
      final bool hasSecondCard = (i + 1) < itemCount;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < itemCount ? 12 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildEventCard(context, isGrid: true)),
              const SizedBox(width: 12),
              Expanded(
                child: hasSecondCard
                    ? _buildEventCard(context, isGrid: true)
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }

  // --- EXPLORE EVENTS BY CITY ---
  Widget _buildExploreEventsByCity() {
    final List<Map<String, String>> cities = [
      {
        'name': 'NASHIK',
        'image':
            'https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'PUNE',
        'image':
            'https://images.unsplash.com/photo-1571171637578-41bc2dd41cd2?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'INDORE',
        'image':
            'https://images.unsplash.com/photo-1609946527934-1be1c90bc98d?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'MUMBAI',
        'image':
            'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?q=80&w=600&auto=format&fit=crop',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Explore Events by City",
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 185,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(55),
                    bottom: Radius.circular(6),
                  ),
                  child: Container(
                    width: 125,
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(city['image']!, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black.withOpacity(0.35),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 22,
                          left: 0,
                          right: 0,
                          child: Text(
                            city['name']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 4.0,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- FIZMAA REWARDS BANNER ---
  Widget _buildFizmaaRewardsBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fizma_rewards.png', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Fizmaa",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                       RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: "More events. More ",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: "rewards.",
                              style: TextStyle(
                                color: Color(0xFFF57C00),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.7),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.percent, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- REDEEM YOUR PRINTED PASS BANNER ---
  Widget _buildRedeemBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 110,
      child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFFF7A7A), Color(0xFFFFB3B3), Color(0xFFFFF0F0)],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 85,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "2368 237845 511",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          14,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 1.5),
                            height: index % 3 == 0 ? 3 : 1.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomPaint(
                size: const Size(1, double.infinity),
                painter: DashedLinePainter(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Redeem your printed pass",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Get your secure QR ticket",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Redeem now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ARTISTS ROW ---
  Widget _buildArtistsRow() {
    final artists = [
      {"name": "Arjit Sing", "img": "https://picsum.photos/id/64/200/200"},
      {"name": "Shreya Ghoshal", "img": "https://picsum.photos/id/65/200/200"},
      {"name": "Arjit Sing", "img": "https://picsum.photos/id/66/200/200"},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE53935),
                        Color(0xFF43A047),
                        Color(0xFF1E88E5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(artist["img"]!),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  artist["name"]!,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- EVENT PARTNERS ROW ---
  Widget _buildPartnersRow() {
    final partners = <Map<String, Object>>[
      {
        'label': 'PNG',
        'subLabel': '25+ YEARS OF\nJEWELLERY',
        'bgColor': const Color(0xFF4A3560),
        'borderColor': const Color(0xFF4A3560),
      },
      {
        'label': 'raasiya',
        'subLabel': 'BY FIZMAA',
        'bgColor': const Color(0xFF6B0F14),
        'borderColor': const Color(0xFF6B0F14),
      },
      {
        'label': 'Fizmaa',
        'subLabel': '',
        'bgColor': Colors.white,
        'borderColor': const Color(0xFFE53935),
      },
      {
        'label': 'DMD',
        'subLabel': 'DHIRAJ BUILDING\n& DEVELOPERS',
        'bgColor': Colors.white,
        'borderColor': const Color(0xFFF9A825),
      },
      {
        'label': 'V',
        'subLabel': 'VIRENDRA LUMINE',
        'bgColor': Colors.white,
        'borderColor': const Color(0xFF1A1A1A),
      },
      {
        'label': 'PNG',
        'subLabel': '25+ YEARS OF\nJEWELLERY',
        'bgColor': const Color(0xFF4A3560),
        'borderColor': const Color(0xFF4A3560),
      },
    ];

    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: partners.length,
        itemBuilder: (context, index) {
          final partner = partners[index];
          final String label = partner['label'] as String;
          final String subLabel = partner['subLabel'] as String;
          final Color bg = partner['bgColor'] as Color;
          final Color borderColor = partner['borderColor'] as Color;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bg,
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: bg == Colors.white
                              ? borderColor
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          height: 1.0,
                        ),
                      ),
                      if (subLabel.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: bg == Colors.white
                                ? borderColor.withOpacity(0.75)
                                : Colors.white.withOpacity(0.85),
                            fontSize: 5.5,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- COMBINED FOOTER + MY EVENT LISTINGS ---
  Widget _buildFooterAndListings() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF2A0A0A),
            Color(0xFF7F0000),
            Color(0xFFB71C1C),
            Color(0xFFD32F2F),
          ],
          stops: [0.0, 0.35, 0.6, 0.8, 1.0],
        ),
      ),
      padding: const EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "List Your Event, Your Way.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "Launch Your Event in Minutes",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Create Event",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Event Listings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  "See All >",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/id/1018/600/400',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.75),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SEASON PASS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "NASHIK",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= TICKET CLIPPER =================
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);

    double notchRadius = 4;
    double clipCount = 7;
    double spacing = size.height / clipCount;

    for (int i = 0; i < clipCount; i++) {
      double centerY = (i * spacing) + (spacing / 2);
      path.lineTo(0, centerY - notchRadius);
      path.arcToPoint(
        Offset(0, centerY + notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: true,
      );
    }

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    for (int i = clipCount.toInt() - 1; i >= 0; i--) {
      double centerY = (i * spacing) + (spacing / 2);
      path.lineTo(size.width, centerY + notchRadius);
      path.arcToPoint(
        Offset(size.width, centerY - notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: true,
      );
    }

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ================= DASHED LINE PAINTER =================
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 3, startY = 6;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.8;

    while (startY < size.height - 6) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}