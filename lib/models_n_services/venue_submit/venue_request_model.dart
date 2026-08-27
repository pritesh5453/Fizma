// lib/models_n_services/venue_submit/venue_request_model.dart

// ---------- REQUEST MODELS ----------
class VenueSubmitRequest {
  final int eventId;
  final int organiserId;
  final int step;
  final List<VenueItemRequest> venues;

  VenueSubmitRequest({
    required this.eventId,
    required this.organiserId,
    required this.step,
    required this.venues,
  });

  Map<String, dynamic> toJson() => {
    'event_id': eventId,
    'organiser_id': organiserId,
    'step': step,
    'venues': venues.map((v) => v.toJson()).toList(),
  };
}

class VenueItemRequest {
  final int venueId;        // ✅ internally use karte hain
  final String venueName;
  final int capacity;
  final int safetyCap;

  VenueItemRequest({
    required this.venueId,
    required this.venueName,
    required this.capacity,
    required this.safetyCap,
  });

  Map<String, dynamic> toJson() => {
    'venue_id': venueId,      // ✅ API me 'venue_id' bhejega
    'venue_name': venueName,
    'capacity': capacity,
    'safety_cap': safetyCap,
  };
}

// ---------- RESPONSE MODELS ----------
class VenueSubmitResponse {
  final bool success;
  final String message;
  final int totalVenues;
  final List<VenueResponseItem> venues;

  VenueSubmitResponse({
    required this.success,
    required this.message,
    required this.totalVenues,
    required this.venues,
  });

  factory VenueSubmitResponse.fromJson(Map<String, dynamic> json) =>
      VenueSubmitResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        totalVenues: json['total_venues'] ?? 0,
        venues: (json['venues'] as List?)
                ?.map((e) => VenueResponseItem.fromJson(e))
                .toList() ??
            [],
      );
}

class VenueResponseItem {
  final int id;
  final int venueId;
  final String venueName;
  final int capacity;
  final int safetyCap;

  VenueResponseItem({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.capacity,
    required this.safetyCap,
  });

  factory VenueResponseItem.fromJson(Map<String, dynamic> json) =>
      VenueResponseItem(
        id: json['id'] ?? 0,
        venueId: json['venue_id'] ?? 0,
        venueName: json['venue_name'] ?? '',
        capacity: json['capacity'] ?? 0,
        safetyCap: json['safety_cap'] ?? 0,
      );
}