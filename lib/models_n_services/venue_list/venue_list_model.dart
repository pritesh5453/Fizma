// lib/models_n_services/venue_list/venue_list_model.dart

class VenueOption {
  final int id;
  final String name;
  final String? city;      // optional – abhi use nahi hai
  final int capacity;
  final int safetyCap;     // ✅ added
  final String? type;      // optional – abhi use nahi hai

  const VenueOption({
    required this.id,
    required this.name,
    this.city,
    required this.capacity,
    required this.safetyCap,
    this.type,
  });
}

class VenueResponse {
  final bool success;
  final String message;
  final int total;
  final List<Venue> data;

  VenueResponse({
    required this.success,
    required this.message,
    required this.total,
    required this.data,
  });

  factory VenueResponse.fromJson(Map<String, dynamic> json) {
    return VenueResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      total: json['total'] ?? 0,
      data: json['data'] != null
          ? List<Venue>.from(json['data'].map((x) => Venue.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'total': total,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class Venue {
  final int id;
  final int organiserId;
  final String venueName;
  final String? exactAddress;
  final String? googleMapsLink;
  final String? latitude;
  final String? longitude;
  final String venueType;
  final int status;
  final String createdAt;
  final String updatedAt;

  Venue({
    required this.id,
    required this.organiserId,
    required this.venueName,
    this.exactAddress,
    this.googleMapsLink,
    this.latitude,
    this.longitude,
    required this.venueType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      venueName: json['venue_name'] ?? '',
      exactAddress: json['exact_address'],
      googleMapsLink: json['google_maps_link'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      venueType: json['venue_type'] ?? 'Indoor',
      status: json['status'] ?? 1,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organiser_id': organiserId,
      'venue_name': venueName,
      'exact_address': exactAddress,
      'google_maps_link': googleMapsLink,
      'latitude': latitude,
      'longitude': longitude,
      'venue_type': venueType,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  VenueOption toVenueOption() {
    String city = 'Unknown Location';
    if (exactAddress != null && exactAddress!.isNotEmpty) {
      final parts = exactAddress!.split(',');
      if (parts.isNotEmpty) city = parts.last.trim();
    }
    return VenueOption(
      id: id,
      name: venueName,
      city: city,
      capacity: 0,
      safetyCap: 0,
      type: venueType,
    );
  }
}