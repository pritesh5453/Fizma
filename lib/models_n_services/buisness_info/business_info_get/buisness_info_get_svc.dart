import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/buisness_info/buisness_info_model.dart';
import 'package:fizmaa/models_n_services/buisness_info/business_info_get/buisness_info_get_model.dart';

class BusinessDetailsApiService {
  final Dio _dio;

  BusinessDetailsApiService(this._dio);

  // =============================
  // GET: Fetch business details
  // =============================
  Future<BusinessDetailsGetResponse> getBusinessDetails(int organiserId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getBusinessDetails(organiserId),
        options: Options(
          headers: {
            // Add auth token if required
            // 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return BusinessDetailsGetResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch: ${e.message}');
    }
  }

  // =============================
  // POST: Update business details
  // =============================
  Future<BusinessDetailsResponse> updateBusinessDetails({
    required int organiserId,
    required BusinessDetailsRequest request,
  }) async {
    try {
      final formData = await request.toFormData();

      final response = await _dio.post(
        ApiEndpoints.updateBusinessDetails(organiserId),
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BusinessDetailsResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }
}