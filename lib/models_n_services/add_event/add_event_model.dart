import 'dart:convert';

class SponsorDto {
  final String name;
  final String type;
  final String website;
  SponsorDto({required this.name, required this.type, required this.website});
}

class CollaboratorDto {
  final String name;
  final String phone;
  final String role;
  final Map<String, bool> permissions;
  CollaboratorDto({
    required this.name,
    required this.phone,
    required this.role,
    required this.permissions,
  });
}

class EventCreateRequest {
  final String eventName;
  final String eventCategory;
  final List<String> artists;
  final String ageRestriction;
  final List<String> languages;
  final String description;
  final List<String> tags;
  final String termsConditions;
  final List<String> facilities;
  final String status;
  final String promotionalVideoUrl;
  final int organiserId;
  final String eventDate;
  final String startTime;
  final String endTime;
  final List<SponsorDto> sponsors;
  final List<CollaboratorDto> collaborators;

  // ---------- Extra fields (अब ये mandatory नहीं, optional हैं) ----------
  final int? step;
  final int? eventId;

  EventCreateRequest({
    required this.eventName,
    required this.eventCategory,
    required this.artists,
    required this.ageRestriction,
    required this.languages,
    required this.description,
    required this.tags,
    required this.termsConditions,
    required this.facilities,
    required this.status,
    required this.promotionalVideoUrl,
    required this.organiserId,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    this.sponsors = const [],
    this.collaborators = const [],
    this.step,
    this.eventId,
  });

  Map<String, dynamic> toApiPayload() {
  final payload = {
    'event_name': eventName,
    'event_category': eventCategory,
    'artists': jsonEncode(artists),           // 👈 fix
    'age_restriction': ageRestriction,
    'languages': jsonEncode(languages),       // 👈 fix
    'description': description,
    'tags': jsonEncode(tags),                 // 👈 fix
    'terms_conditions': termsConditions,
    'facilities': jsonEncode(facilities),     // 👈 fix
    'status': status,
    'promotional_video_url': promotionalVideoUrl,
    'organiser_id': organiserId,
    'event_date': eventDate,
    'start_time': startTime,
    'end_time': endTime,
  };

  // Sponsors
  for (int i = 0; i < sponsors.length; i++) {
    final s = sponsors[i];
    payload['sponsor_name[$i]'] = s.name;
    payload['sponsor_type[$i]'] = s.type;
    payload['sponsor_website[$i]'] = s.website;
  }

  // Collaborators
  for (int i = 0; i < collaborators.length; i++) {
    final c = collaborators[i];
    payload['collaborator_name[$i]'] = c.name;
    payload['collaborator_phone[$i]'] = c.phone;
    payload['collaborator_role[$i]'] = c.role;
    payload['collaborator_permissions[$i]'] = jsonEncode(c.permissions);
  }

  if (step != null) payload['step'] = step!;
  if (eventId != null) payload['event_id'] = eventId!;

  return payload;
}
}

class EventResponse {
  final String message;
  final int eventId;
  final bool success;

  EventResponse({
    required this.message,
    required this.eventId,
    this.success = true,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    final rawEventId = data?['event_id'] ?? json['event_id'] ?? json['eventId'];

    return EventResponse(
      message: json['message']?.toString() ?? '',
      success: json['success'] == true,
      eventId: rawEventId is int
          ? rawEventId
          : int.tryParse(rawEventId?.toString() ?? '') ?? 0,
    );
  }
}