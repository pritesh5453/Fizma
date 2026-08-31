import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/venue_submit/venue_request_model.dart';
import 'package:fizmaa/utils/app_preference.dart';

class VenueSubmitService {
  late final Dio _dio;

  VenueSubmitService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor to attach token from preferences
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Fetch token from SharedPreferences
          final token = await AppPreferences.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<VenueSubmitResponse> submitVenues(VenueSubmitRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.submitVenues,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VenueSubmitResponse.fromJson(response.data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to submit venues: $e');
    }
  }
}