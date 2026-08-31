// lib/models_n_services/publish_event/publish_event_service.dart

import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/api_endpoints/dio_client.dart';
import 'package:fizmaa/models_n_services/publish_event/publish_event_model.dart';

class PublishEventService {
  final Dio _dio = DioClient.instance;

  Future<PublishEventResponse> publishEvent(PublishEventRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.publishEvent,
        data: request.toJson(),
      );

      print("=========== PUBLISH EVENT SUCCESS ===========");
      print("Status : ${response.statusCode}");
      print("Data   : ${response.data}");
      print("=============================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PublishEventResponse.fromJson(response.data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=========== PUBLISH EVENT ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("============================================");

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Failed to publish event',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}