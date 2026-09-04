// lib/models_n_services/kyc/kyc_model.dart

import 'dart:io';
import 'package:dio/dio.dart';

class KycRequest {
  final String? aadhaarNumber;
  final String? panNumber;
  final String? businessLicenseNumber;
  final String? certificateName;
  final File? aadhaarDocument;
  final File? panDocument;
  final File? businessLicenseDocument;
  final File? certificateDocument;

  KycRequest({
    this.aadhaarNumber,
    this.panNumber,
    this.businessLicenseNumber,
    this.certificateName,
    this.aadhaarDocument,
    this.panDocument,
    this.businessLicenseDocument,
    this.certificateDocument,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    // Text fields – send empty string if null
    map['aadhaar_number'] = aadhaarNumber ?? '';
    map['pan_number'] = panNumber ?? '';
    map['business_license_number'] = businessLicenseNumber ?? '';
    map['certificate_name'] = certificateName ?? '';

    // ✅ File fields – SERVER EXPECTS THESE NAMES (different from GET response)
    if (aadhaarDocument != null) {
      map['aadhaar_document'] = await MultipartFile.fromFile(aadhaarDocument!.path);
    }
    if (panDocument != null) {
      map['pan_document'] = await MultipartFile.fromFile(panDocument!.path);
    }
    // ✅ FIXED: "business_license" (not "business_license_document")
    if (businessLicenseDocument != null) {
      map['business_license'] = await MultipartFile.fromFile(businessLicenseDocument!.path);
    }
    // ✅ FIXED: "certificate" (not "certificate_document")
    if (certificateDocument != null) {
      map['certificate'] = await MultipartFile.fromFile(certificateDocument!.path);
    }

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📝 [KYC FormData]');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📦 Fields: ${map.keys.join(', ')}');

    return FormData.fromMap(map);
  }
}

// ==============================
// KYC RESPONSE (unchanged)
// ==============================
class KycResponse {
  final bool success;
  final KycData data;

  KycResponse({required this.success, required this.data});

  factory KycResponse.fromJson(Map<String, dynamic> json) {
    return KycResponse(
      success: json['success'] ?? false,
      data: KycData.fromJson(json['data'] ?? {}),
    );
  }
}

class KycData {
  final int id;
  final int organiserId;
  final String aadhaarNumber;
  final int aadhaarVerified;
  final String? aadhaarDocument;
  final String panNumber;
  final int panVerified;
  final String? panDocument;
  final String businessLicenseNumber;
  final int businessLicenseVerified;
  final String businessLicenseStatus;
  final String? businessLicenseDocument;
  final String? businessLicenseReviewNotes;
  final String certificateName;
  final String? certificateDocument;
  final String createdAt;
  final String updatedAt;

  KycData({
    required this.id,
    required this.organiserId,
    required this.aadhaarNumber,
    required this.aadhaarVerified,
    this.aadhaarDocument,
    required this.panNumber,
    required this.panVerified,
    this.panDocument,
    required this.businessLicenseNumber,
    required this.businessLicenseVerified,
    required this.businessLicenseStatus,
    this.businessLicenseDocument,
    this.businessLicenseReviewNotes,
    required this.certificateName,
    this.certificateDocument,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KycData.fromJson(Map<String, dynamic> json) {
    return KycData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      organiserId: int.tryParse(json['organiser_id']?.toString() ?? '0') ?? 0,
      aadhaarNumber: json['aadhaar_number'] ?? '',
      aadhaarVerified: int.tryParse(json['aadhaar_verified']?.toString() ?? '0') ?? 0,
      aadhaarDocument: json['aadhaar_document'],
      panNumber: json['pan_number'] ?? '',
      panVerified: int.tryParse(json['pan_verified']?.toString() ?? '0') ?? 0,
      panDocument: json['pan_document'],
      businessLicenseNumber: json['business_license_number'] ?? '',
      businessLicenseVerified: int.tryParse(json['business_license_verified']?.toString() ?? '0') ?? 0,
      businessLicenseStatus: json['business_license_status'] ?? '',
      businessLicenseDocument: json['business_license_document'],
      businessLicenseReviewNotes: json['business_license_review_notes'],
      certificateName: json['certificate_name'] ?? '',
      certificateDocument: json['certificate_document'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}