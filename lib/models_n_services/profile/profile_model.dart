// lib/models_n_services/profile/profile_model.dart

// ==============================
// PROFILE RESPONSE
// ==============================
class ProfileResponse {
  final bool success;
  final ProfileData data;

  ProfileResponse({required this.success, required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

// ==============================
// PROFILE DATA (Main Container)
// ==============================
class ProfileData {
  final Profile profile;
  final BusinessData business;
  final KycData kyc;
  final BankData bank;
  final VerificationStatus verificationStatus;

  ProfileData({
    required this.profile,
    required this.business,
    required this.kyc,
    required this.bank,
    required this.verificationStatus,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      profile: Profile.fromJson(json['profile'] ?? {}),
      business: BusinessData.fromJson(json['business'] ?? {}),
      kyc: KycData.fromJson(json['kyc'] ?? {}),
      bank: BankData.fromJson(json['bank'] ?? {}),
      verificationStatus: VerificationStatus.fromJson(json['verification_status'] ?? {}),
    );
  }
}

// ==============================
// PROFILE
// ==============================
class Profile {
  final int id;
  final String? businessName;
  final String? fullName;
  final String email;
  final String phoneNo;
  final String? category;
  final String? experience;
  final String organisationName;
  final String createdAt;

  Profile({
    required this.id,
    this.businessName,
    this.fullName,
    required this.email,
    required this.phoneNo,
    this.category,
    this.experience,
    required this.organisationName,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      businessName: json['business_name'],
      fullName: json['full_name'],
      email: json['email'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      category: json['category'],
      experience: json['experience'],
      organisationName: json['organisation_name'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

// ==============================
// BUSINESS DATA
// ==============================
class BusinessData {
  final int id;
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
  final String businessCreatedAt;
  final String? gstNumberMasked;

  BusinessData({
    required this.id,
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
    required this.businessCreatedAt,
    this.gstNumberMasked,
  });

  factory BusinessData.fromJson(Map<String, dynamic> json) {
    return BusinessData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      businessName: json['business_name'] ?? '',
      businessEmail: json['business_email'] ?? '',
      businessMobile: json['business_mobile'] ?? '',
      businessLandline: json['business_landline'],
      gstNumber: json['gst_number'],
      gstVerified: int.tryParse(json['gst_verified']?.toString() ?? '0') ?? 0,
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
      businessCreatedAt: json['business_created_at'] ?? '',
      gstNumberMasked: json['gst_number_masked'],
    );
  }
}

// ==============================
// KYC DATA
// ==============================
class KycData {
  final int id;
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
  final String kycCreatedAt;

  KycData({
    required this.id,
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
    required this.kycCreatedAt,
  });

  factory KycData.fromJson(Map<String, dynamic> json) {
    return KycData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
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
      kycCreatedAt: json['kyc_created_at'] ?? '',
    );
  }
}

// ==============================
// BANK DATA
// ==============================
class BankData {
  final int id;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String accountHolderName;
  final String upiId;
  final int bankVerified;
  final String? verificationNotes;
  final String? verifiedAt;
  final String bankCreatedAt;
  final String? accountNumberMasked;

  BankData({
    required this.id,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.accountHolderName,
    required this.upiId,
    required this.bankVerified,
    this.verificationNotes,
    this.verifiedAt,
    required this.bankCreatedAt,
    this.accountNumberMasked,
  });

  factory BankData.fromJson(Map<String, dynamic> json) {
    return BankData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      accountNumber: json['account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      upiId: json['upi_id'] ?? '',
      bankVerified: int.tryParse(json['bank_verified']?.toString() ?? '0') ?? 0,
      verificationNotes: json['verification_notes'],
      verifiedAt: json['verified_at'],
      bankCreatedAt: json['bank_created_at'] ?? '',
      accountNumberMasked: json['account_number_masked'],
    );
  }
}

// ==============================
// VERIFICATION STATUS
// ==============================
class VerificationStatus {
  final bool businessVerified;
  final bool kycVerified;
  final bool bankVerified;
  final String overallStatus;

  VerificationStatus({
    required this.businessVerified,
    required this.kycVerified,
    required this.bankVerified,
    required this.overallStatus,
  });

  factory VerificationStatus.fromJson(Map<String, dynamic> json) {
    return VerificationStatus(
      businessVerified: json['business_verified'] ?? false,
      kycVerified: json['kyc_verified'] ?? false,
      bankVerified: json['bank_verified'] ?? false,
      overallStatus: json['overall_status'] ?? '',
    );
  }
}