class EventItem {
  final int id;
  final String title;
  final String status;
  final String categoryTag;
  final String date;
  final String sessions;
  final String performers;
  final String venue;
  final String volunteers;
  final int ticketsSold;
  final int totalTickets;
  final String revenue;
  final String? bannerImage;
  final String createdAt;

  EventItem({
    required this.id,
    required this.title,
    required this.status,
    required this.categoryTag,
    required this.date,
    required this.sessions,
    required this.performers,
    required this.venue,
    required this.volunteers,
    required this.ticketsSold,
    required this.totalTickets,
    required this.revenue,
    this.bannerImage,
    required this.createdAt,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      categoryTag: json['category_tag'] ?? '',
      date: json['date'] ?? '',
      sessions: json['sessions'] ?? '',
      performers: json['performers'] ?? '',
      venue: json['venue'] ?? '',
      volunteers: json['volunteers'] ?? '',
      ticketsSold: json['tickets_sold'] ?? 0,
      totalTickets: json['total_tickets'] ?? 0,
      revenue: json['revenue'] ?? '',
      bannerImage: json['banner_image'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'category_tag': categoryTag,
      'date': date,
      'sessions': sessions,
      'performers': performers,
      'venue': venue,
      'volunteers': volunteers,
      'tickets_sold': ticketsSold,
      'total_tickets': totalTickets,
      'revenue': revenue,
      'banner_image': bannerImage,
      'created_at': createdAt,
    };
  }
}


class EventsResponse {
  final bool success;
  final String message;
  final int organiserId;
  final String status;
  final int total;
  final int limit;
  final int offset;
  final int count;
  final bool hasMore;
  final List<EventItem> data;

  EventsResponse({
    required this.success,
    required this.message,
    required this.organiserId,
    required this.status,
    required this.total,
    required this.limit,
    required this.offset,
    required this.count,
    required this.hasMore,
    required this.data,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return EventsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      organiserId: json['organiser_id'] ?? 0,
      status: json['status'] ?? '',
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 0,
      offset: json['offset'] ?? 0,
      count: json['count'] ?? 0,
      hasMore: json['hasMore'] ?? false,
      data: dataList.map((item) => EventItem.fromJson(item)).toList(),
    );
  }
}