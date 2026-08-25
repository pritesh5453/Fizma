import 'package:dio/dio.dart';
import 'package:fizma/api_endpoints/api_endpoint.dart';
import 'package:fizma/models_n_services/add_venue/add_venue_model.dart';
import 'package:fizma/models_n_services/venue_list/venue_list_model.dart';
import 'package:fizma/utils/app_preference.dart';

class VenueService {
  final Dio _dio;
  VenueService({Dio? dio}) : _dio = dio ?? Dio();

  /// Get all venues for a specific organiser
  Future<VenueResponse> getOrganiserVenues(int organiserId) async {
    final url = '${ApiEndpoints.baseUrl}/api/Event/organiser-venues/organiser_id/$organiserId';

    final token = await AppPreferences.getToken();
    final headers = <String, dynamic>{};
    if (token != null) headers['Authorization'] = 'Bearer $token';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      print('Venue API RESPONSE >>> ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VenueResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch venues: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get venues and convert to VenueOption list (for dropdown)
  Future<List<VenueOption>> getVenueOptions(int organiserId) async {
    final response = await getOrganiserVenues(organiserId);
    return response.data.map((venue) => venue.toVenueOption()).toList();
  }

  /// ✅ NEW: Add a new venue
  Future<AddVenueResponse> addVenue(AddVenueRequest request) async {
    final url = '${ApiEndpoints.baseUrl}/api/Event/Add-organiser-venue';

    final token = await AppPreferences.getToken();
    final headers = <String, dynamic>{};
    if (token != null) headers['Authorization'] = 'Bearer $token';

    try {
      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(headers: headers),
      );
      print('Add Venue API RESPONSE >>> ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddVenueResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to add venue: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}