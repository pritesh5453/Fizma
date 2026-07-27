import 'package:flutter/foundation.dart';

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
  final List<EventData> data;

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
      data: (json['data'] as List? ?? [])
          .map((e) => EventData.fromJson(e))
          .toList(),
    );
  }
}

class EventData {
  final int id;
  final String title;
  final String? location;
  final String? eventDate;
  final int ticketsSold;
  final num totalRevenue;
  final int progressPercentage;
  final String category;
  final String status;
  final String bannerImage;

  EventData({
    required this.id,
    required this.title,
    this.location,
    this.eventDate,
    required this.ticketsSold,
    required this.totalRevenue,
    required this.progressPercentage,
    required this.category,
    required this.status,
    required this.bannerImage,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'],
      eventDate: json['event_date'],
      ticketsSold: json['tickets_sold'] ?? 0,
      totalRevenue: json['total_revenue'] ?? 0,
      progressPercentage: json['progress_percentage'] ?? 0,
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      bannerImage: json['banner_image'] ?? '',
    );
  }
}