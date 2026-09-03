import 'package:fizmaa/Screens/events/EventDetails_screen.dart';
import 'package:fizmaa/models_n_services/event_models/all_event_model.dart';
import 'package:fizmaa/models_n_services/event_models/all_event_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  String _selectedFilter = 'All';
  List<EventItem> _events = [];
  bool _isLoading = true;
  String? _error;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'status': 'all'},
    {'label': 'Published', 'status': 'published'},
    {'label': 'Drafts', 'status': 'draft'},
    {'label': 'Completed', 'status': 'completed'},
    {'label': 'Canceled', 'status': 'canceled'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        setState(() {
          _error = 'Organiser ID not found. Please login again.';
          _isLoading = false;
        });
        return;
      }

      String status = _selectedFilter.toLowerCase();
      if (status == 'all') status = 'all';

      // ✅ New service call – returns EventsResponse with List<EventItem>
      final response = await EventsService().getEvents(
        organiserId: organiserId,
        limit: 10,
        offset: 0,
        status: status,
      );

      setState(() {
        _events = response.data.cast<EventItem>();   
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildSearchBarRow(),
            const SizedBox(height: 12),
            _buildFilterChips(),
            const SizedBox(height: 14),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.kRed));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.kRed, size: 48),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 14)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchEvents,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.kRed),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
    if (_events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('No events found', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text('Try changing the filter or create a new event.', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildEventCard(_events[index]),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('My Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.kTextDark)),
              SizedBox(height: 2),
              Text('Manage your hosted events', style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93))),
            ],
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: const Color(0xFFFFEAEA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.notifications_outlined, color: AppColors.kRed, size: 22),
          ),
        ],
      ),
    );
  }

  // ---------- Search Bar + Add Event ----------
  Widget _buildSearchBarRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, size: 18, color: Color(0xFF9E9E9E)),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kRed,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Event', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ---------- Filter Chips ----------
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _filters.map((filter) {
          final label = filter['label'] as String;
          final isSelected = _selectedFilter == label;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedFilter = label);
                _fetchEvents();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.kRed : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppColors.kRed : const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF4B5563),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------- Event Card ----------
  Widget _buildEventCard(EventItem event) {
    double progress = event.totalTickets > 0 ? event.ticketsSold / event.totalTickets : 0;
    String imageUrl = event.bannerImage ?? '';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.025), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 180, color: const Color(0xFFE0E0E0), child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40))),
                        )
                      : Container(height: 180, color: const Color(0xFFE0E0E0), child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40))),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                        child: Text(event.status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF3B82F6))),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.confirmation_number, size: 10, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(event.categoryTag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(event.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.kTextDark))),
                      Text(event.sessions, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF9E9E9E)),
                      const SizedBox(width: 4),
                      Text(event.date, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                      const Spacer(),
                      const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF9E9E9E)),
                      const SizedBox(width: 4),
                      Text(event.venue, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 13, color: AppColors.kRed),
                      const SizedBox(width: 4),
                      Expanded(child: Text(event.performers, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF4B5563)))),
                      Row(
                        children: [
                          const Icon(Icons.people_outline, size: 12, color: Color(0xFF9E9E9E)),
                          const SizedBox(width: 4),
                          Text(event.volunteers, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFE5E7EB),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.kRed),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${event.ticketsSold}/${event.totalTickets}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
                      const SizedBox(width: 8),
                      Text(event.revenue, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Event Detail Screen (same as before) ----------
class EventDetailScreen extends StatelessWidget {
  final EventItem event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    String imageUrl = event.bannerImage ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(event.title), backgroundColor: Colors.white, elevation: 0, foregroundColor: AppColors.kTextDark),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey.shade200, child: const Icon(Icons.image, size: 50, color: Colors.grey)))
                  : Container(height: 200, color: Colors.grey.shade200, child: const Icon(Icons.image, size: 50, color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            Text(event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.calendar_today, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(event.date, style: const TextStyle(fontSize: 14, color: Colors.grey))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(event.venue, style: const TextStyle(fontSize: 14, color: Colors.grey))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.person, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(event.performers, style: const TextStyle(fontSize: 14, color: Colors.grey))]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [Text('${event.ticketsSold}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const Text('Sold', style: TextStyle(fontSize: 12, color: Colors.grey))]),
                  Column(children: [Text(event.revenue, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.green)), const Text('Revenue', style: TextStyle(fontSize: 12, color: Colors.grey))]),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to My Events'),
            ),
          ],
        ),
      ),
    );
  }
}