class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "http://fizmaa.gccltd.in";

  // Auth
  static const String organiserLogin = "$baseUrl/api/auth/organiser/login";

  // All events
  static const String organiserEvents = "/api/Event/events";
}