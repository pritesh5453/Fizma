class AddVenueRequest {
  final int organiserId;
  final String venueName;
  final String exactAddress;
  final String googleMapsLink;
  final double latitude;
  final double longitude;
  final String venueType;

  AddVenueRequest({
    required this.organiserId,
    required this.venueName,
    required this.exactAddress,
    required this.googleMapsLink,
    required this.latitude,
    required this.longitude,
    required this.venueType,
  });

  Map<String, dynamic> toJson() {
    return {
      'organiser_id': organiserId,
      'venue_name': venueName,
      'exact_address': exactAddress,
      'google_maps_link': googleMapsLink,
      'latitude': latitude,
      'longitude': longitude,
      'venue_type': venueType,
    };
  }
}

/// Response model for adding a new venue
class AddVenueResponse {
  final bool success;
  final String message;
  final int venueId;

  AddVenueResponse({
    required this.success,
    required this.message,
    required this.venueId,
  });

  factory AddVenueResponse.fromJson(Map<String, dynamic> json) {
    return AddVenueResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      venueId: json['venue_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'venue_id': venueId,
    };
  }
}