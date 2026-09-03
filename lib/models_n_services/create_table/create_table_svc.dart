import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/api_endpoints/dio_client.dart';
import 'package:fizmaa/models_n_services/create_table/create_table_model.dart';

class TableTicketService {
  final Dio _dio = DioClient.instance;

  Future<TableTicketResponse> createTableTicket(TableTicketRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.tableTickets,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == true) {
          return TableTicketResponse.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to create table ticket. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}