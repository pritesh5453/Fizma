import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/api_endpoints/dio_client.dart';
import 'package:fizmaa/models_n_services/assign_volunteers/assign_volunteers_model.dart';

class AssignVolunteerService {
  final Dio _dio = DioClient.instance;

  Future<AssignVolunteerResponse> assignVolunteers(
    AssignVolunteerRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.assignVolunteers,
        data: request.toJson(),
      );

      print("=========== ASSIGN VOLUNTEERS SUCCESS ===========");
      print("Status : ${response.statusCode}");
      print("Data   : ${response.data}");
      print("=================================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssignVolunteerResponse.fromJson(response.data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=========== ASSIGN VOLUNTEERS ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("================================================");

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Failed to assign volunteers',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}