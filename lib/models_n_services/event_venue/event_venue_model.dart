// lib/models_n_services/event_venue/event_venue_model.dart

import 'package:fizmaa/models_n_services/venue_list/venue_list_model.dart';

class EventVenueResponse {
  final bool success;
  final List<EventVenue> venues;

  EventVenueResponse({
    required this.success,
    required this.venues,
  });

  factory EventVenueResponse.fromJson(Map<String, dynamic> json) {
    return EventVenueResponse(
      success: json['success'] ?? false,
      venues: json['venues'] != null
          ? List<EventVenue>.from(json['venues'].map((x) => EventVenue.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'venues': venues.map((e) => e.toJson()).toList(),
  };
}

class EventVenue {
  final int id;          // mapping entry ID
  final int eventId;
  final int organiserId;
  final int venueId;     // ✅ actual venue ID
  final String venueName;
  final int capacity;
  final int safetyCap;

  EventVenue({
    required this.id,
    required this.eventId,
    required this.organiserId,
    required this.venueId,
    required this.venueName,
    required this.capacity,
    required this.safetyCap,
  });

  factory EventVenue.fromJson(Map<String, dynamic> json) {
    return EventVenue(
      id: json['id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      venueId: json['venue_id'] ?? 0,
      venueName: json['venue_name'] ?? '',
      capacity: json['capacity'] ?? 0,
      safetyCap: json['safety_cap'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'organiser_id': organiserId,
    'venue_id': venueId,
    'venue_name': venueName,
    'capacity': capacity,
    'safety_cap': safetyCap,
  };

  VenueOption toVenueOption() {
    return VenueOption(
      id: venueId,          // ✅ actual venue ID
      name: venueName,
      city: null,           // ✅ not needed
      capacity: capacity,
      safetyCap: safetyCap,
      type: null,           // ✅ not needed
    );
  }
}