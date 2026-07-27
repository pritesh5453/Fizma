import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyOrganiserId = 'organiser_id';
  static const String _keyToken = 'token';
  static const String _keyEmail = 'email';
  static const String _keyPhone = 'phone';
  static const String _keyOrganisationName = 'organisation_name';

  // Save organiser ID
  static Future<void> setOrganiserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyOrganiserId, id);
  }

  // Get organiser ID (returns null if not set)
  static Future<int?> getOrganiserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyOrganiserId);
  }

  // Save token
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Save organiser details (optional)
  static Future<void> setOrganiserDetails({
    required String email,
    required String phone,
    required String organisationName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPhone, phone);
    await prefs.setString(_keyOrganisationName, organisationName);
  }

  // Get saved organiser details
  static Future<Map<String, String?>> getOrganiserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyEmail),
      'phone': prefs.getString(_keyPhone),
      'organisationName': prefs.getString(_keyOrganisationName),
    };
  }

  // Clear all preferences (logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}