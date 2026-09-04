// lib/models_n_services/bank/bank_model.dart

class BankDetailsRequest {
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String accountHolderName;
  final String upiId;

  BankDetailsRequest({
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.accountHolderName,
    required this.upiId,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'bank_name': bankName,
      'account_holder_name': accountHolderName,
      'upi_id': upiId,
    };
  }
}


// lib/models_n_services/bank/bank_model.dart (add at bottom)

class BankDetailsResponse {
  final bool success;
  final String message;
  final BankDetailsData? data;

  BankDetailsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BankDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? BankDetailsData.fromJson(json['data']) : null,
    );
  }
}

class BankDetailsData {
  final int id;
  final int organiserId;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String accountHolderName;
  final String upiId;
  final int bankVerified; // 0/1
  final String? verificationNotes;
  final String? verifiedAt;
  final String createdAt;
  final String updatedAt;

  BankDetailsData({
    required this.id,
    required this.organiserId,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.accountHolderName,
    required this.upiId,
    required this.bankVerified,
    this.verificationNotes,
    this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankDetailsData.fromJson(Map<String, dynamic> json) {
    return BankDetailsData(
      id: json['id'] ?? 0,
      organiserId: json['organiser_id'] ?? 0,
      accountNumber: json['account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      upiId: json['upi_id'] ?? '',
      bankVerified: json['bank_verified'] ?? 0,
      verificationNotes: json['verification_notes'],
      verifiedAt: json['verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}