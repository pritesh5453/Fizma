import 'package:fizma/Screens/events/event_details_screen.dart';
import 'package:fizma/api_endpoints/api_endpoint.dart';
import 'package:fizma/models_n_services/events/all_events_model.dart';
import 'package:fizma/models_n_services/events/all_events_svc.dart';
import 'package:fizma/utils/app_preference.dart';
import 'package:fizma/utils/customappbar.dart';
import 'package:flutter/material.dart';

class LiveEventsScreen extends StatefulWidget {
  final int? organiserId;

  const LiveEventsScreen({super.key, this.organiserId});

  @override
  State<LiveEventsScreen> createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> {
  final EventService _eventService = EventService();

  String selectedTab = 'Current Live';
  final Map<String, String> tabStatusMap = {
    'Current Live': 'live',
    'Upcoming': 'upcoming',
    'History': 'done',
  };
  final Map<String, Map<String, String>> tabContentConfig = {
    'Current Live': {
      'title': 'All Live Events',
      'subtitle': 'Manage your hosted events',
    },
    'Upcoming': {
      'title': 'Upcoming Events',
      'subtitle': 'Events scheduled for the future',
    },
    'History': {
      'title': 'Past Events',
      'subtitle': 'View your past analytics',
    },
  };

  List<EventData> events = [];
  bool isLoading = false;
  String? errorMessage;
  int? _organiserId;
  bool _isLoadingId = true;

  @override
  void initState() {
    super.initState();
    _resolveOrganiserId();
  }

  Future<void> _resolveOrganiserId() async {
    int? id = widget.organiserId;
    if (id == null) {
      id = await AppPreferences.getOrganiserId();
    }
    setState(() {
      _organiserId = id;
      _isLoadingId = false;
    });
    if (id != null) {
      _fetchEvents();
    } else {
      setState(() {
        errorMessage = 'Organiser ID not found. Please login again.';
      });
    }
  }

  Future<void> _fetchEvents() async {
    if (_organiserId == null) return;
    final status = tabStatusMap[selectedTab]!;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _eventService.getEvents(
        organiserId: _organiserId!,
        status: status,
        limit: 20,
        offset: 0,
      );
      setState(() {
        events = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _changeTab(String tab) {
    if (selectedTab == tab) return;
    setState(() {
      selectedTab = tab;
    });
    _fetchEvents();
  }

  void _onMenuSelected(String action, int index) {
    final event = events[index];
    switch (action) {
      case 'preview':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventDetailScreen()),
        );
        break;
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit: ${event.title}')),
        );
        break;
      case 'delete':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete: ${event.title}')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentConfig = tabContentConfig[selectedTab]!;

    if (_isLoadingId) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF3F3),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_organiserId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF3F3),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                errorMessage ?? 'No organiser found',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resolveOrganiserId,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F3),
      appBar: CustomAppBar(
        title: currentConfig['title']!,
        subtitle: currentConfig['subtitle']!,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTabButton('Current Live', Icons.fiber_manual_record),
                const SizedBox(width: 10),
                _buildTabButton('Upcoming', Icons.calendar_month_outlined),
                const SizedBox(width: 10),
                _buildTabButton('History', Icons.history),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.redAccent),
                              const SizedBox(height: 12),
                              Text(
                                'Error loading events',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchEvents,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : events.isEmpty
                          ? const Center(
                              child: Text(
                                'No events found for this status',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.76,
                              ),
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                final event = events[index];
                                return _buildEventCard(event, index);
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, IconData icon) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => _changeTab(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black87),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(EventData event, int index) {
    final soldText = '${event.ticketsSold}';
    final revenueText = '₹${(event.totalRevenue / 1000).toStringAsFixed(1)}K';
    final progress = event.progressPercentage / 100;

    String statusBadge = '';
    Color badgeColor = Colors.redAccent;
    if (selectedTab == 'Current Live') {
      statusBadge = 'Live';
      badgeColor = Colors.redAccent;
    } else if (selectedTab == 'Upcoming') {
      statusBadge = 'Upcoming';
      badgeColor = Colors.orange;
    } else {
      statusBadge = 'Done';
      badgeColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  event.bannerImage.isNotEmpty
                      ?Image.network(
  "${ApiEndpoints.baseUrl}${event.bannerImage}",
  fit: BoxFit.cover,
)
                      : Container(color: Colors.grey.shade200),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusBadge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        event.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            child: const Icon(
                              Icons.more_vert,
                              size: 16,
                              color: Colors.black54,
                            ),
                            onSelected: (value) => _onMenuSelected(value, index),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'preview',
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility_outlined, size: 18, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Preview'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 18, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text(
                          event.location ?? 'No location',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sold', style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 1),
                            Text(
                              soldText,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Revenue', style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 1),
                            Text(
                              revenueText,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.redAccent,
                        minHeight: 3.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
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
    );
  }
}
