import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/coupons/coupons_model.dart';
import 'package:fizmaa/utils/app_preference.dart';

class CouponService {
  final Dio _dio;

  CouponService(this._dio);

  /// Create a new coupon
  Future<CouponResponse> createCoupon({
    required CouponRequest request,
  }) async {
    try {
      // Get organiser ID from SharedPreferences
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        throw Exception('Organiser ID not found. Please login again.');
      }

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [API REQUEST] Create Coupon');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🆔 Organiser ID: $organiserId');

      // Build request body
      final body = request.toJson();
      print('\n📝 Request Body:');
      body.forEach((key, value) {
        print('   $key: $value');
      });

      // API Endpoint
      final endpoint = ApiEndpoints.createCoupon(organiserId);
      print('\n🔗 Endpoint: $endpoint');

      // Make POST request
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Add auth token if needed
            // 'Authorization': 'Bearer ${await AppPreferences.getToken()}',
          },
        ),
      );

      print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📥 [API RESPONSE]');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Coupon created successfully!');
        return CouponResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response != null) {
        print('   Status: ${e.response?.statusCode}');
        print('   Data: ${e.response?.data}');
      }
      throw Exception('Failed to create coupon: ${e.message}');
    } catch (e) {
      print('❌ Unexpected Error: $e');
      throw Exception('Error: $e');
    }
  }
}