// lib/api_endpoints/dio_client.dart

import 'package:dio/dio.dart';
import 'api_endpoint.dart';

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
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
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
          return handler.next(e);
        },
      ),
    );
}