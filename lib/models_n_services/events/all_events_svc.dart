// lib/models_n_services/events/event_service.dart

import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/api_endpoints/dio_client.dart';
import 'package:fizmaa/models_n_services/events/all_events_model.dart';

class EventService {
  final Dio _dio = DioClient.instance;

  Future<EventsResponse> getEvents({
    required int organiserId,
    required String status,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      // 🔥 Print the full URL for debugging
      final fullUrl = '${_dio.options.baseUrl}${ApiEndpoints.organiserEvents}';
      print("🌐 Request URL: $fullUrl");
      print("📦 Query Params: organiser_id=$organiserId, status=$status, limit=$limit, offset=$offset");

      final response = await _dio.get(
        ApiEndpoints.organiserEvents,
        queryParameters: {
          "organiser_id": organiserId,
          "status": status,
          "limit": limit,
          "offset": offset,
        },
      );

      print("=========== EVENTS SUCCESS ===========");
      print(response.data);
      print("=====================================");

      return EventsResponse.fromJson(response.data);
    } on DioException catch (e) {
      // ✅ FULL error details
      print("=========== EVENTS ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("Type        : ${e.type}");   // <-- important: connectionError, sendTimeout, etc.
      print("Error       : ${e.error}");   // <-- underlying error (e.g., SocketException)
      print("Request URL : ${e.requestOptions.uri}"); // the exact URL tried
      print("====================================");

      String errorMsg = 'Something went wrong';
      if (e.response?.data != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      } else if (e.message != null) {
        errorMsg = e.message!;
      } else if (e.error != null) {
        errorMsg = e.error.toString();
      }
      throw Exception(errorMsg);
    }
  }
}