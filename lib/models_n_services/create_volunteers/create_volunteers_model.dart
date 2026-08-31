// lib/models_n_services/volunteer/volunteer_create_model.dart

class CreateVolunteerRequest {
  final int organiserId;
  final String volunteerName;
  final String phone;
  final String email;
  final String access;
  final String password;
  final bool isActive;

  CreateVolunteerRequest({
    required this.organiserId,
    required this.volunteerName,
    required this.phone,
    required this.email,
    required this.access,
    required this.password,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'organiser_id': organiserId,
        'volunteer_name': volunteerName,
        'phone': phone,
        'email': email,
        'access': access,
        'password': password,
        'is_active': isActive,
      };
}

class CreateVolunteerResponse {
  final bool success;
  final String message;
  final int? volunteerId; // might be null if error

  CreateVolunteerResponse({
    required this.success,
    required this.message,
    this.volunteerId,
  });

  factory CreateVolunteerResponse.fromJson(Map<String, dynamic> json) {
    return CreateVolunteerResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      volunteerId: json['volunteer_id'],
    );
  }
}