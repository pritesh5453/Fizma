import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/buisness_info/buisness_info_model.dart';
import 'package:fizmaa/utils/app_preference.dart';

class BusinessDetailsService {
  final Dio _dio;

  BusinessDetailsService(this._dio);

  Future<BusinessDetailsResponse> updateBusinessDetails({
    required int organiserId,
    required BusinessDetailsRequest request,
  }) async {
    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📤 [API REQUEST] Update Business Details');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🆔 Organiser ID: $organiserId');

      final formData = await request.toFormData();

      print('\n📝 Text Fields:');
      final textFields = {
        'business_name': request.businessName,
        'business_email': request.businessEmail,
        'business_mobile': request.businessMobile,
        'business_landline': request.businessLandline,
        'gst_number': request.gstNumber,
        'gst_verified': request.gstVerified?.toString(),
        'instagram_url': request.instagramUrl,
        'facebook_url': request.facebookUrl,
        'youtube_url': request.youtubeUrl,
        'complete_address': request.completeAddress,
        'locality': request.locality,
        'city': request.city,
        'state': request.state,
        'pincode': request.pincode,
        'latitude': request.latitude?.toString(),
        'longitude': request.longitude?.toString(),
      };
      textFields.forEach((key, value) => print('   $key: ${value ?? 'null'}'));

      print('\n📎 Attached Files:');
      if (request.logo != null) print('   logo: ${request.logo!.path} (${await request.logo!.length()} bytes)');
      else print('   logo: null');
      if (request.cover != null) print('   cover: ${request.cover!.path} (${await request.cover!.length()} bytes)');
      else print('   cover: null');
      if (request.gstDocument != null) print('   gst_document: ${request.gstDocument!.path} (${await request.gstDocument!.length()} bytes)');
      else print('   gst_document: null');

      final endpoint = ApiEndpoints.updateBusinessDetails(organiserId);
      print('\n🔗 Endpoint: $endpoint');

      final stopwatch = Stopwatch()..start();
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      stopwatch.stop();
      print('⏱️ Request completed in ${stopwatch.elapsedMilliseconds} ms');

      print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📥 [API RESPONSE]');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Success!');
        return BusinessDetailsResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response != null) print('   Data: ${e.response?.data}');
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected Error: $e');
      throw Exception('Error: $e');
    }
  }
}