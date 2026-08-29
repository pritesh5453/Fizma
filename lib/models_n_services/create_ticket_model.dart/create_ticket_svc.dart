import 'package:dio/dio.dart';
import 'package:fizma/api_endpoints/api_endpoint.dart';
import 'package:fizma/api_endpoints/dio_client.dart';
import 'package:fizma/models_n_services/create_ticket_model.dart/create_ticket_model.dart';

class CreateTicketService {
  final Dio _dio = DioClient.instance;

  Future<CreateTicketResponse> createTicket(
    CreateTicketRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createTicket,
        data: request.toJson(),
      );

      print("=========== CREATE TICKET SUCCESS ===========");
      print("Status : ${response.statusCode}");
      print("Data   : ${response.data}");
      print("=============================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateTicketResponse.fromJson(response.data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("=========== CREATE TICKET ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("============================================");

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Failed to create ticket',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}