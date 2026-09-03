import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/api_endpoints/dio_client.dart';
import 'package:fizmaa/models_n_services/events/all_events_model.dart';

class EventsService {
  final Dio _dio = DioClient.instance;

  Future<EventsResponse> getEvents({
    required int organiserId,
    int limit = 10,
    int offset = 0,
    String status = 'all', // optional filter
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.events,
        queryParameters: {
          'organiser_id': organiserId,
          'limit': limit,
          'offset': offset,
          if (status.isNotEmpty) 'status': status,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return EventsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch events. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}