class OrganiserLoginResponse {
  final bool success;
  final String message;
  final String token;
  final Organiser organiser;

  OrganiserLoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.organiser,
  });

  factory OrganiserLoginResponse.fromJson(Map<String, dynamic> json) {
    return OrganiserLoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      organiser: Organiser.fromJson(json['organiser'] ?? {}),
    );
  }
}

class Organiser {
  final int id;
  final String email;
  final String phoneNo;
  final String organisationName;

  Organiser({
    required this.id,
    required this.email,
    required this.phoneNo,
    required this.organisationName,
  });

  factory Organiser.fromJson(Map<String, dynamic> json) {
    return Organiser(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      organisationName: json['organisation_name'] ?? '',
    );
  }
}