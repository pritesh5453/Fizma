// lib/models_n_services/coupon/coupon_model.dart

class CouponRequest {
  final String couponCode;
  final String couponName;
  final String description;
  final String discountType; // "percentage" or "flat"
  final int discountValue;
  final int usageLimit;
  final int perUserLimit;
  final String applicableEventType; // "all" or "specific"
  final int? applicableEventId; // only if applicableEventType == "specific"
  final String startDate; // format: "YYYY-MM-DD"
  final String expiryDate; // format: "YYYY-MM-DD"

  CouponRequest({
    required this.couponCode,
    required this.couponName,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.usageLimit,
    required this.perUserLimit,
    required this.applicableEventType,
    this.applicableEventId,
    required this.startDate,
    required this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'coupon_code': couponCode,
      'coupon_name': couponName,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'usage_limit': usageLimit,
      'per_user_limit': perUserLimit,
      'applicable_event_type': applicableEventType,
      'start_date': startDate,
      'expiry_date': expiryDate,
    };

    // Only add applicable_event_id if type is "specific"
    if (applicableEventType == 'specific' && applicableEventId != null) {
      map['applicable_event_id'] = applicableEventId;
    }

    return map;
  }
}

// lib/models_n_services/coupon/coupon_model.dart (add at bottom)

class CouponResponse {
  final bool success;
  final String message;
  final CouponData? data;

  CouponResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CouponData.fromJson(json['data']) : null,
    );
  }
}

class CouponData {
  final int id;
  final int organiserId;
  final String couponCode;
  final String couponName;
  final String description;
  final String discountType;
  final String discountValue;
  final int usageLimit;
  final int usedCount;
  final int perUserLimit;
  final int? applicableEventId;
  final String applicableEventType;
  final String startDate;
  final String expiryDate;
  final String status; // "active", "expired", "upcoming"
  final String createdAt;
  final String updatedAt;

  CouponData({
    required this.id,
    required this.organiserId,
    required this.couponCode,
    required this.couponName,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.usageLimit,
    required this.usedCount,
    required this.perUserLimit,
    this.applicableEventId,
    required this.applicableEventType,
    required this.startDate,
    required this.expiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      id: json['id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      couponCode: json['coupon_code'] ?? '',
      couponName: json['coupon_name'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value']?.toString() ?? '0',
      usageLimit: json['usage_limit'] ?? 0,
      usedCount: json['used_count'] ?? 0,
      perUserLimit: json['per_user_limit'] ?? 0,
      applicableEventId: json['applicable_event_id'],
      applicableEventType: json['applicable_event_type'] ?? '',
      startDate: json['start_date'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}