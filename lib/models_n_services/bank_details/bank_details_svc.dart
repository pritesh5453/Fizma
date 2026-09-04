import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/bank_details/bank_details_model.dart';
import 'package:fizmaa/utils/app_preference.dart';

class BankService {
  final Dio _dio;

  BankService(this._dio);

  // ------------------- GET: Fetch Bank Details -------------------
  Future<BankDetailsResponse> getBankDetails() async {
    try {
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        throw Exception('Organiser ID not found. Please login again.');
      }

      final endpoint = ApiEndpoints.bankDetails(organiserId);

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [API REQUEST] Get Bank Details');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🆔 Organiser ID: $organiserId');
      print('🔗 Endpoint: $endpoint');

      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // If token needed: 'Authorization': 'Bearer ${await AppPreferences.getToken()}',
          },
        ),
      );

      print('📊 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return BankDetailsResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      throw Exception('Failed to fetch bank details: ${e.message}');
    }
  }

  // ------------------- POST: Update Bank Details -------------------
  Future<BankDetailsResponse> updateBankDetails({
    required BankDetailsRequest request,
  }) async {
    try {
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        throw Exception('Organiser ID not found. Please login again.');
      }

      final endpoint = ApiEndpoints.bankDetails(organiserId);
      final body = request.toJson();

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [API REQUEST] Update Bank Details');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🆔 Organiser ID: $organiserId');
      print('🔗 Endpoint: $endpoint');
      print('📦 Request Body: $body');

      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📊 Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BankDetailsResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      throw Exception('Failed to update bank details: ${e.message}');
    }
  }
}