// lib/api_endpoints/dio_client.dart

import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/utils/app_preference.dart';   // ✅ import for token

class DioClient {
  DioClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: {
        "Accept": "application/json",
      },
    ),
  )..interceptors.addAll([
      // ✅ Token Interceptor – attaches Bearer token automatically
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AppPreferences.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print("🚀 Request: ${options.method} ${options.uri}");
          print("📦 Headers: ${options.headers}");
          print("📦 Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response: ${response.statusCode} ${response.requestOptions.uri}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ Error: ${e.type} - ${e.message}");
          print("📄 Response: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    ]);
}