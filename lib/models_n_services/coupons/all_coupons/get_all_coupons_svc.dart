import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/coupons/all_coupons/get_all_coupons_model.dart';
import 'package:fizmaa/models_n_services/coupons/coupons_model.dart';
import 'package:fizmaa/utils/app_preference.dart';

class CouponApiService {
  final Dio _dio;

  CouponApiService(this._dio);

  // ------------------- GET: Fetch Coupons (with optional status) -------------------
  Future<CouponListResponse> getCoupons({String? status}) async {
    try {
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        throw Exception('Organiser ID not found. Please login again.');
      }

      final endpoint = ApiEndpoints.getCoupons(organiserId, status: status);

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [API REQUEST] Get Coupons');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🆔 Organiser ID: $organiserId');
      print('🔗 Endpoint: $endpoint');

      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📊 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return CouponListResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      throw Exception('Failed to fetch coupons: ${e.message}');
    }
  }

  // ------------------- POST: Create Coupon -------------------
  Future<CouponResponse> createCoupon({
    required CouponRequest request,
  }) async {
    try {
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        throw Exception('Organiser ID not found. Please login again.');
      }

      final endpoint = ApiEndpoints.createCoupon(organiserId);
      final body = request.toJson();

      print('📤 Create Coupon: $endpoint');
      print('📦 Body: $body');

      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CouponResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to create coupon: ${e.message}');
    }
  }
}