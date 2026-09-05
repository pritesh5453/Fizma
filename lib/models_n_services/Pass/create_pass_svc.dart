// pass_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/Pass/create_pass_model.dart';
import 'package:fizmaa/utils/app_preference.dart';

class PassService {
  final Dio _dio;

  PassService(this._dio);

  // Main method to create pass with optional image
  Future<PassResponse> createPass({
    required int eventId,
    required int venueId,
    required String passName,
    required int passCount,
    required double passPrice,
    String? description,
    String? status,
    int? isActive,
    required int expiryDays,
    File? passBackgroundCover,
  }) async {
    // 1. Get organiser ID from preferences
    final organiserId = await AppPreferences.getOrganiserId();
    if (organiserId == null) {
      throw Exception('Organiser not logged in. Please login again.');
    }

    // 2. Prepare request data (without file)
    final request = PassCreateRequest(
      eventId: eventId,
      venueId: venueId,
      organiserId: organiserId,
      passName: passName,
      passCount: passCount,
      passPrice: passPrice,
      description: description,
      status: status ?? 'active',
      isActive: isActive ?? 1,
      expiryDays: expiryDays,
    );

    // 3. Build FormData
    final formData = FormData.fromMap(request.toJson());

    // 4. Attach image if provided
    if (passBackgroundCover != null) {
      final multipartFile = await MultipartFile.fromFile(
        passBackgroundCover.path,
        filename: passBackgroundCover.path.split('/').last,
      );
      formData.files.add(
        MapEntry('pass_background_cover', multipartFile),
      );
    }

    // 5. Make API call
    final response = await _dio.post(
      ApiEndpoints.baseUrl + ApiEndpoints.createPass,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          // Token will be added via interceptor
          // If you don't have interceptor, uncomment:
          // 'Authorization': 'Bearer ${await AppPreferences.getToken()}',
        },
      ),
    );

    // 6. Parse response
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PassResponse.fromJson(response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to create pass: ${response.statusCode}',
      );
    }
  }
}
