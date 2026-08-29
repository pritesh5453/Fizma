// lib/models_n_services/publish_event/publish_event_model.dart

// ---------- REQUEST ----------
import 'dart:convert';

class PublishEventRequest {
  final int eventId;

  PublishEventRequest({
    required this.eventId,
  });

  Map<String, dynamic> toJson() => {
    'event_id': eventId,
  };
}

// ---------- RESPONSE ----------
class PublishEventResponse {
  final bool success;
  final String message;
  final PublishedEventData event;

  PublishEventResponse({
    required this.success,
    required this.message,
    required this.event,
  });

  factory PublishEventResponse.fromJson(Map<String, dynamic> json) {
    return PublishEventResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      event: PublishedEventData.fromJson(json['event'] ?? {}),
    );
  }
}

class PublishedEventData {
  final int id;
  final int organiserId;
  final String eventName;
  final String eventCategory;
  final DateTime eventDate;
  final String startTime;
  final String endTime;
  final List<String> artists;
  final String ageRestriction;
  final List<String> languages;
  final String description;
  final List<String> tags;
  final String termsConditions;
  final List<String> facilities;
  final String? bannerHorizontal;
  final String? bannerVertical;
  final String promotionalVideoUrl;
  final String? promotionalVideoFile;
  final List<String> gallery;
  final String status;
  final int step;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SponsorPublish> sponsorsData;
  final List<CollaboratorPublish>? collaboratorsData;
  final List<int> assignedVolunteers;

  PublishedEventData({
    required this.id,
    required this.organiserId,
    required this.eventName,
    required this.eventCategory,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.artists,
    required this.ageRestriction,
    required this.languages,
    required this.description,
    required this.tags,
    required this.termsConditions,
    required this.facilities,
    this.bannerHorizontal,
    this.bannerVertical,
    required this.promotionalVideoUrl,
    this.promotionalVideoFile,
    required this.gallery,
    required this.status,
    required this.step,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.sponsorsData,
    this.collaboratorsData,
    required this.assignedVolunteers,
  });

  factory PublishedEventData.fromJson(Map<String, dynamic> json) {
    return PublishedEventData(
      id: json['id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      eventName: json['event_name'] ?? '',
      eventCategory: json['event_category'] ?? '',
      eventDate: DateTime.parse(json['event_date'] ?? DateTime.now().toIso8601String()),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      artists: json['artists'] != null
          ? List<String>.from(jsonDecode(json['artists']))
          : [],
      ageRestriction: json['age_restriction'] ?? '',
      languages: json['languages'] != null
          ? List<String>.from(jsonDecode(json['languages']))
          : [],
      description: json['description'] ?? '',
      tags: json['tags'] != null
          ? List<String>.from(jsonDecode(json['tags']))
          : [],
      termsConditions: json['terms_conditions'] ?? '',
      facilities: json['facilities'] != null
          ? List<String>.from(jsonDecode(json['facilities']))
          : [],
      bannerHorizontal: json['banner_horizontal'],
      bannerVertical: json['banner_vertical'],
      promotionalVideoUrl: json['promotional_video_url'] ?? '',
      promotionalVideoFile: json['promotional_video_file'],
      gallery: json['gallery'] != null
          ? List<String>.from(jsonDecode(json['gallery']))
          : [],
      status: json['status'] ?? '',
      step: json['step'] ?? 0,
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      sponsorsData: json['sponsors_data'] != null
          ? List<SponsorPublish>.from(
              json['sponsors_data'].map((x) => SponsorPublish.fromJson(x)),
            )
          : [],
      collaboratorsData: json['collaborators_data'] != null
          ? List<CollaboratorPublish>.from(
              json['collaborators_data'].map((x) => CollaboratorPublish.fromJson(x)),
            )
          : null,
      assignedVolunteers: json['assigned_volunteers'] != null
          ? List<int>.from(json['assigned_volunteers'])
          : [],
    );
  }
}

class SponsorPublish {
  final String name;
  final String type;
  final String website;
  final String? logoVertical;
  final String? logoHorizontal;

  SponsorPublish({
    required this.name,
    required this.type,
    required this.website,
    this.logoVertical,
    this.logoHorizontal,
  });

  factory SponsorPublish.fromJson(Map<String, dynamic> json) {
    return SponsorPublish(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      website: json['website'] ?? '',
      logoVertical: json['logo_vertical'],
      logoHorizontal: json['logo_horizontal'],
    );
  }
}

class CollaboratorPublish {
  final String name;
  final String? role;
  final String? phone;
  final String? email;

  CollaboratorPublish({
    required this.name,
    this.role,
    this.phone,
    this.email,
  });

  factory CollaboratorPublish.fromJson(Map<String, dynamic> json) {
    return CollaboratorPublish(
      name: json['name'] ?? '',
      role: json['role'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}