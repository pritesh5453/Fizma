// lib/models_n_services/assign_volunteer/assign_volunteer_model.dart

// ---------- REQUEST ----------
class AssignVolunteerRequest {
  final int eventId;
  final int step;
  final List<int> volunteerIds;

  AssignVolunteerRequest({
    required this.eventId,
    required this.step,
    required this.volunteerIds,
  });

  Map<String, dynamic> toJson() => {
    'event_id': eventId,
    'step': step,
    'volunteer_ids': volunteerIds,
  };
}

// ---------- RESPONSE ----------
class AssignVolunteerResponse {
  final bool success;
  final String message;

  AssignVolunteerResponse({
    required this.success,
    required this.message,
  });

  factory AssignVolunteerResponse.fromJson(Map<String, dynamic> json) {
    return AssignVolunteerResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}