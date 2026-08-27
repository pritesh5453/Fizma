// lib/models_n_services/event_venue/event_venue_service.dart

import 'package:dio/dio.dart';
import 'package:fizma/api_endpoints/api_endpoint.dart';
import 'package:fizma/api_endpoints/dio_client.dart';
import 'package:fizma/models_n_services/event_venue/event_venue_model.dart';

class EventVenueService {
  final Dio _dio = DioClient.instance;

  Future<EventVenueResponse> getVenuesForEvent(int eventId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getEventVenues(eventId),
      );

      print("=========== FETCH EVENT VENUES SUCCESS ===========");
      print("Status : ${response.statusCode}");
      print("Data   : ${response.data}");
      print("==================================================");

      if (response.statusCode == 200) {
        return EventVenueResponse.fromJson(response.data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=========== FETCH EVENT VENUES ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("=================================================");

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Failed to fetch event venues',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}