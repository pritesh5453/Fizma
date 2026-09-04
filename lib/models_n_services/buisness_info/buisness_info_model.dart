import 'dart:io';
import 'package:dio/dio.dart';

class BusinessDetailsRequest {
  final String? businessName;
  final String? businessEmail;
  final String? businessMobile;
  final String? businessLandline;
  final String? gstNumber;
  final bool? gstVerified;
  final String? instagramUrl;
  final String? facebookUrl;
  final String? youtubeUrl;
  final String? completeAddress;
  final String? locality;
  final String? city;
  final String? state;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final File? logo;
  final File? cover;
  final File? gstDocument;

  BusinessDetailsRequest({
    this.businessName,
    this.businessEmail,
    this.businessMobile,
    this.businessLandline,
    this.gstNumber,
    this.gstVerified,
    this.instagramUrl,
    this.facebookUrl,
    this.youtubeUrl,
    this.completeAddress,
    this.locality,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.logo,
    this.cover,
    this.gstDocument,
  });

  /// Convert to FormData for Dio
  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    _addIfNotNull(map, 'business_name', businessName);
    _addIfNotNull(map, 'business_email', businessEmail);
    _addIfNotNull(map, 'business_mobile', businessMobile);
    _addIfNotNull(map, 'business_landline', businessLandline);
    _addIfNotNull(map, 'gst_number', gstNumber);
    _addIfNotNull(map, 'gst_verified', gstVerified?.toString());
    _addIfNotNull(map, 'instagram_url', instagramUrl);
    _addIfNotNull(map, 'facebook_url', facebookUrl);
    _addIfNotNull(map, 'youtube_url', youtubeUrl);
    _addIfNotNull(map, 'complete_address', completeAddress);
    _addIfNotNull(map, 'locality', locality);
    _addIfNotNull(map, 'city', city);
    _addIfNotNull(map, 'state', state);
    _addIfNotNull(map, 'pincode', pincode);
    _addIfNotNull(map, 'latitude', latitude?.toString());
    _addIfNotNull(map, 'longitude', longitude?.toString());

    // Attach files
    if (logo != null) {
      map['logo'] = await MultipartFile.fromFile(logo!.path);
    }
    if (cover != null) {
      map['cover'] = await MultipartFile.fromFile(cover!.path);
    }
    if (gstDocument != null) {
      map['gst_document'] = await MultipartFile.fromFile(gstDocument!.path);
    }

    return FormData.fromMap(map);
  }

  void _addIfNotNull(Map<String, dynamic> map, String key, dynamic value) {
    if (value != null) map[key] = value;
  }
}


class BusinessDetailsResponse {
  final bool success;
  final String message;
  final BusinessDetailsData? data;

  BusinessDetailsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BusinessDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? BusinessDetailsData.fromJson(json['data'])
          : null,
    );
  }
}

class BusinessDetailsData {
  final String organiserId;
  final String logo;
  final String cover;
  final String gstDocument;

  BusinessDetailsData({
    required this.organiserId,
    required this.logo,
    required this.cover,
    required this.gstDocument,
  });

  factory BusinessDetailsData.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsData(
      organiserId: json['organiser_id'] ?? '',
      logo: json['logo'] ?? '',
      cover: json['cover'] ?? '',
      gstDocument: json['gst_document'] ?? '',
    );
  }
}