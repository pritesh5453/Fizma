// lib/models_n_services/volunteer/volunteer_service.dart

import 'package:dio/dio.dart';
import 'package:fizma/api_endpoints/api_endpoint.dart';
import 'package:fizma/api_endpoints/dio_client.dart';
import 'package:fizma/models_n_services/event_volunteers/volunteers_list.dart';

class VolunteerService {
  final Dio _dio = DioClient.instance;

  Future<VolunteerListResponse> getVolunteers(int organiserId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getVolunteers(organiserId),
      );

      print("=========== FETCH VOLUNTEERS SUCCESS ===========");
      print("Status : ${response.statusCode}");
      print("Data   : ${response.data}");
      print("=================================================");

      if (response.statusCode == 200) {
        return VolunteerListResponse.fromJson(response.data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=========== FETCH VOLUNTEERS ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("==============================================");

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Failed to fetch volunteers',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}