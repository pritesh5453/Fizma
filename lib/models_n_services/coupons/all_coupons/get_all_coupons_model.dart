// lib/models_n_services/coupons/coupons_model.dart

// ... existing CouponRequest, CouponResponse, CouponData (already defined) ...

// ==============================
// GET Coupons List Response
// ==============================

import 'package:fizmaa/models_n_services/coupons/coupons_model.dart';

class CouponListResponse {
  final bool success;
  final List<CouponData> data;
  final Pagination pagination;

  CouponListResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory CouponListResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return CouponListResponse(
      success: json['success'] ?? false,
      data: dataList.map((item) => CouponData.fromJson(item)).toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}