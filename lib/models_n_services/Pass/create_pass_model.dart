// pass_model.dart
import 'dart:convert';

// ---------- Request Model ----------
class PassCreateRequest {
  final int eventId;
  final int venueId;
  final int organiserId;
  final String passName;
  final int passCount;
  final double passPrice;
  final String? description;
  final String? status;
  final int? isActive;
  final int expiryDays;

  PassCreateRequest({
    required this.eventId,
    required this.venueId,
    required this.organiserId,
    required this.passName,
    required this.passCount,
    required this.passPrice,
    this.description,
    this.status,
    this.isActive = 1,
    required this.expiryDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'venue_id': venueId,
      'organiser_id': organiserId,
      'pass_name': passName,
      'pass_count': passCount,
      'pass_price': passPrice.toStringAsFixed(2),
      'description': description,
      'status': status,
      'is_active': isActive,
      'expiry_days': expiryDays,
    }..removeWhere((key, value) => value == null);
  }
}

// ---------- Response Model ----------
class PassResponse {
  final bool success;
  final String message;
  final PassData? data;

  PassResponse({required this.success, required this.message, this.data});

  factory PassResponse.fromJson(Map<String, dynamic> json) {
    return PassResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PassData.fromJson(json['data']) : null,
    );
  }
}

class PassData {
  final int id;
  final int eventId;
  final int venueId;
  final int organiserId;
  final String passName;
  final int passCount;
  final String passPrice;
  final String? description;
  final String? passBackgroundCover;
  final int purchaseCount;
  final int expiryDays;
  final int isActive;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? imageUrl;

  PassData({
    required this.id,
    required this.eventId,
    required this.venueId,
    required this.organiserId,
    required this.passName,
    required this.passCount,
    required this.passPrice,
    this.description,
    this.passBackgroundCover,
    required this.purchaseCount,
    required this.expiryDays,
    required this.isActive,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory PassData.fromJson(Map<String, dynamic> json) {
    return PassData(
      id: json['id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      venueId: json['venue_id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      passName: json['pass_name'] ?? '',
      passCount: json['pass_count'] ?? 0,
      passPrice: json['pass_price']?.toString() ?? '0.00',
      description: json['description'],
      passBackgroundCover: json['pass_background_cover'],
      purchaseCount: json['purchase_count'] ?? 0,
      expiryDays: json['expiry_days'] ?? 0,
      isActive: json['is_active'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}

// ✅ PassTier class (UI ke liye)
class PassTier {
  final String id;
  final String name;
  final int totalPasses;
  final double price;
  final int maxPerPerson;
  bool isActive;
  final int validityDays;

  PassTier({
    required this.id,
    required this.name,
    required this.totalPasses,
    required this.price,
    required this.maxPerPerson,
    this.isActive = true,
    required this.validityDays,
  });
}