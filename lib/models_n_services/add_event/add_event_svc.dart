import 'package:dio/dio.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/add_event/add_event_model.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'dart:convert';
import 'dart:io';

class EventService {
  final Dio _dio;
  EventService({Dio? dio}) : _dio = dio ?? Dio();

  // ---------- Step 1 – Create Event ----------
  Future<EventResponse> createEvent(EventCreateRequest request) async {
    print("🟢 [EventService] createEvent() called");
    final url = ApiEndpoints.createEvent;
    final payload = request.toApiPayload();

    print("📡 URL: $url");
    print("📦 Payload: $payload");

    final token = await AppPreferences.getToken();
    print("🔑 Token: ${token != null ? 'Present (${token.substring(0, 10)}...)' : 'NULL'}");

    final headers = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    if (token != null) headers['Authorization'] = 'Bearer $token';

    try {
      final response = await _dio.post(
        url,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers),
      );
      print("✅ API RESPONSE >>> ${response.data}");
      print("📊 Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = EventResponse.fromJson(response.data);
        print("🎯 Event created! eventId: ${result.eventId}");
        return result;
      } else {
        throw Exception('Event creation failed: ${response.data}');
      }
    } on DioException catch (e) {
      print("❌ DioError: ${e.response?.data ?? e.message}");
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      print("❌ Unexpected error: $e");
      throw Exception('Unexpected error: $e');
    }
  }

  // ---------- Step 2 – Multipart Request ----------
  Future<void> updateEventStep2WithMultipart({
    required int eventId,
    required int organiserId,
    required String promotionalVideoUrl,
    required List<Map<String, dynamic>> sponsors,
    required List<Map<String, dynamic>> collaborators,
    File? bannerHorizontal,
    File? bannerVertical,
    File? promoVideoFile,
    List<File>? galleryImages,
    List<File?>? sponsorLogoHorizontal,
    List<File?>? sponsorLogoVertical,
  }) async {
    print("🟢 [EventService] updateEventStep2WithMultipart() called");
    print("📌 eventId: $eventId");
    print("📌 organiserId: $organiserId");
    print("📌 promotionalVideoUrl: $promotionalVideoUrl");
    print("📌 sponsors: ${sponsors.length}");
    print("📌 collaborators: ${collaborators.length}");
    print("📌 bannerHorizontal: ${bannerHorizontal != null ? bannerHorizontal.path : 'null'}");
    print("📌 bannerVertical: ${bannerVertical != null ? bannerVertical.path : 'null'}");
    print("📌 promoVideoFile: ${promoVideoFile != null ? promoVideoFile.path : 'null'}");
    print("📌 galleryImages: ${galleryImages?.length ?? 0}");
    print("📌 sponsorLogoHorizontal: ${sponsorLogoHorizontal?.length ?? 0}");
    print("📌 sponsorLogoVertical: ${sponsorLogoVertical?.length ?? 0}");

    final url = ApiEndpoints.createEvent;
    final token = await AppPreferences.getToken();
    print("🔑 Token: ${token != null ? 'Present (${token.substring(0, 10)}...)' : 'NULL'}");

    final formData = FormData();

    // ---------- Text fields ----------
    formData.fields.addAll([
      MapEntry('step', '2'),
      MapEntry('event_id', eventId.toString()),
      MapEntry('organiser_id', organiserId.toString()),
      MapEntry('promotional_video_url', promotionalVideoUrl),
    ]);

    // Sponsors
    for (var s in sponsors) {
      formData.fields.add(MapEntry('sponsor_name[]', s['name']?.toString() ?? ''));
      formData.fields.add(MapEntry('sponsor_type[]', s['type']?.toString() ?? ''));
      formData.fields.add(MapEntry('sponsor_website[]', s['website']?.toString() ?? ''));
    }

    // Collaborators
    for (var c in collaborators) {
      formData.fields.add(MapEntry('collaborator_name[]', c['name']?.toString() ?? ''));
      formData.fields.add(MapEntry('collaborator_phone[]', c['phone']?.toString() ?? ''));
      formData.fields.add(MapEntry('collaborator_role[]', c['role']?.toString() ?? ''));
      final perms = c['permissions'] as Map?;
      formData.fields.add(MapEntry('collaborator_permissions[]', jsonEncode(perms ?? {})));
    }

    // ---------- Files ----------
    if (bannerHorizontal != null) {
      formData.files.add(MapEntry(
        'banner_horizontal',
        await MultipartFile.fromFile(bannerHorizontal.path, filename: 'banner_horizontal.jpg'),
      ));
    }
    if (bannerVertical != null) {
      formData.files.add(MapEntry(
        'banner_vertical',
        await MultipartFile.fromFile(bannerVertical.path, filename: 'banner_vertical.jpg'),
      ));
    }
    if (promoVideoFile != null) {
      formData.files.add(MapEntry(
        'promotional_video_file',
        await MultipartFile.fromFile(promoVideoFile.path, filename: 'promo_video.mp4'),
      ));
    }
    if (galleryImages != null) {
      for (var file in galleryImages) {
        formData.files.add(MapEntry(
          'gallery',
          await MultipartFile.fromFile(file.path, filename: 'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg'),
        ));
      }
    }
    if (sponsorLogoHorizontal != null) {
      for (var file in sponsorLogoHorizontal) {
        if (file != null) {
          formData.files.add(MapEntry(
            'sponsor_logo_horizontal',
            await MultipartFile.fromFile(file.path, filename: 'sponsor_logo_h_${DateTime.now().millisecondsSinceEpoch}.jpg'),
          ));
        }
      }
    }
    if (sponsorLogoVertical != null) {
      for (var file in sponsorLogoVertical) {
        if (file != null) {
          formData.files.add(MapEntry(
            'sponsor_logo_vertical',
            await MultipartFile.fromFile(file.path, filename: 'sponsor_logo_v_${DateTime.now().millisecondsSinceEpoch}.jpg'),
          ));
        }
      }
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    print("📡 Sending multipart request to: $url");
    print("📦 FormData fields: ${formData.fields.length}");
    print("📦 FormData files: ${formData.files.length}");

    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
      print("✅ Multipart Step 2 RESPONSE >>> ${response.data}");
      print("📊 Status Code: ${response.statusCode}");
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Step 2 failed: ${response.data}');
      }
    } on DioException catch (e) {
      print("❌ DioError: ${e.response?.data ?? e.message}");
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      print("❌ Unexpected error: $e");
      throw Exception('Unexpected error: $e');
    }
  }
}