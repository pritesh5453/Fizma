// business_info_model.dart
class BusinessDetailsGetResponse {
  final bool success;
  final BusinessDetailsData data;

  BusinessDetailsGetResponse({required this.success, required this.data});

  factory BusinessDetailsGetResponse.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsGetResponse(
      success: json['success'] ?? false,
      data: BusinessDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class BusinessDetailsData {
  final int id;
  final int organiserId;
  final String businessName;
  final String businessEmail;
  final String businessMobile;
  final String? businessLandline;
  final String? gstNumber;
  final int gstVerified;
  final String? gstScannedDocument;
  final String? instagramUrl;
  final String? facebookUrl;
  final String? youtubeUrl;
  final String completeAddress;
  final String locality;
  final String city;
  final String state;
  final String pincode;
  final String latitude;
  final String longitude;
  final dynamic mapPinLocation;
  final String? logoImage;
  final String? coverImage;
  final String createdAt;
  final String updatedAt;

  BusinessDetailsData({
    required this.id,
    required this.organiserId,
    required this.businessName,
    required this.businessEmail,
    required this.businessMobile,
    this.businessLandline,
    this.gstNumber,
    required this.gstVerified,
    this.gstScannedDocument,
    this.instagramUrl,
    this.facebookUrl,
    this.youtubeUrl,
    required this.completeAddress,
    required this.locality,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.mapPinLocation,
    this.logoImage,
    this.coverImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessDetailsData.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsData(
      id: json['id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      businessName: json['business_name'] ?? '',
      businessEmail: json['business_email'] ?? '',
      businessMobile: json['business_mobile'] ?? '',
      businessLandline: json['business_landline'],
      gstNumber: json['gst_number'],
      gstVerified: json['gst_verified'] ?? 0,
      gstScannedDocument: json['gst_scanned_document'],
      instagramUrl: json['instagram_url'],
      facebookUrl: json['facebook_url'],
      youtubeUrl: json['youtube_url'],
      completeAddress: json['complete_address'] ?? '',
      locality: json['locality'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: json['latitude'] ?? '0.0',
      longitude: json['longitude'] ?? '0.0',
      mapPinLocation: json['map_pin_location'],
      logoImage: json['logo_image'],
      coverImage: json['cover_image'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}