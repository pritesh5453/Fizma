import 'package:dio/dio.dart';
import 'package:fizma/api_endpoints/api_endpoint.dart';
import 'package:fizma/api_endpoints/dio_client.dart';
import 'package:fizma/models_n_services/login/login_model.dart';

class OrganiserAuthService {
  final Dio _dio = DioClient.instance;

  Future<OrganiserLoginResponse> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.organiserLogin,
        data: {
          "email_or_phone": emailOrPhone,
          "password": password,
        },
      );

      print("=========== LOGIN SUCCESS ===========");
      print(response.data);
      print("=====================================");

      return OrganiserLoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("=========== LOGIN ERROR ===========");
      print("Status Code : ${e.response?.statusCode}");
      print("Response    : ${e.response?.data}");
      print("Message     : ${e.message}");
      print("===================================");

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Something went wrong',
      );
    }
  }
}