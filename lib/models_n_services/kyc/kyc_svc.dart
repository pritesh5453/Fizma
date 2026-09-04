// lib/models_n_services/kyc/kyc_svc.dart

import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/kyc/kyc_model.dart';

class KycService {
  final Dio _dio;

  KycService(this._dio);

  // ------------------- GET: Fetch KYC details -------------------
  Future<KycResponse> getKyc(int organiserId) async {
    try {
      final endpoint = ApiEndpoints.kycDetails(organiserId);

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [GET KYC]');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🆔 Organiser ID: $organiserId');
      print('🔗 Endpoint: $endpoint');

      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response: ${response.data}');

      if (response.statusCode == 200) {
        return KycResponse.fromJson(response.data);
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
      throw Exception('Failed to fetch KYC: ${e.message}');
    }
  }

  // ------------------- POST: Update KYC details -------------------
  Future<KycResponse> updateKyc({
    required int organiserId,
    required KycRequest request,
  }) async {
    try {
      final endpoint = ApiEndpoints.kycDetails(organiserId);

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [POST KYC]');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🆔 Organiser ID: $organiserId');
      print('🔗 Endpoint: $endpoint');

      final formData = await request.toFormData();

      print('⏳ Sending request...');

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ KYC updated successfully');
        return KycResponse.fromJson(response.data);
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
      throw Exception('KYC Update Error: ${e.message}');
    }
  }
}