// lib/models_n_services/volunteer/volunteer_model.dart

class VolunteerListResponse {
  final bool success;
  final int total;
  final List<Volunteer> data;

  VolunteerListResponse({
    required this.success,
    required this.total,
    required this.data,
  });

  factory VolunteerListResponse.fromJson(Map<String, dynamic> json) {
    return VolunteerListResponse(
      success: json['success'] ?? false,
      total: json['total'] ?? 0,
      data: json['data'] != null
          ? List<Volunteer>.from(json['data'].map((x) => Volunteer.fromJson(x)))
          : [],
    );
  }
}

class Volunteer {
  final int id;
  final int organiserId;
  final String volunteerName;
  final String phone;
  final String email;
  final String access;
  final int viewTickets;
  final int scanTickets;
  final int isActive;
  final String createdAt;

  Volunteer({
    required this.id,
    required this.organiserId,
    required this.volunteerName,
    required this.phone,
    required this.email,
    required this.access,
    required this.viewTickets,
    required this.scanTickets,
    required this.isActive,
    required this.createdAt,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      volunteerName: json['volunteer_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      access: json['access'] ?? '',
      viewTickets: json['view_tickets'] ?? 0,
      scanTickets: json['scan_tickets'] ?? 0,
      isActive: json['is_active'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}