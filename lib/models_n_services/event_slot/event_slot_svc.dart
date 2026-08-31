// lib/models_n_services/event_slot/event_slot_service.dart

import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/api_endpoints/dio_client.dart';
import 'package:fizmaa/models_n_services/event_slot/event_slot_model.dart';

class EventSlotService {
  final Dio _dio = DioClient.instance;

  Future<AddEventSlotResponse> addEventSlots(
    AddEventSlotRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addEventSlots,
        data: request.toJson(),
      );

      print("=========== EVENT SLOT ADD SUCCESS ===========");
      print("Status : ${response.statusCode}");
      print("Data   : ${response.data}");
      print("===============================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddEventSlotResponse.fromJson(response.data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=========== EVENT SLOT ADD ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("=============================================");

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Failed to add event slots',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}