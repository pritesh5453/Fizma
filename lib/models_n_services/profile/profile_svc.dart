import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/profile/profile_model.dart';
import 'package:fizmaa/utils/app_preference.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  /// Get Profile Details (includes profile, business, kyc, bank, verification status)
  Future<ProfileResponse> getProfile() async {
    try {
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        throw Exception('Organiser ID not found. Please login again.');
      }

      final endpoint = ApiEndpoints.profile(organiserId);

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [API REQUEST] Get Profile');
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
        print('✅ Profile fetched successfully');
        return ProfileResponse.fromJson(response.data);
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
      throw Exception('Failed to fetch profile: ${e.message}');
    }
  }
}