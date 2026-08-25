class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "http://fizmaa.gccltd.in";

  static const String organiserLogin = "$baseUrl/api/auth/organiser/login";
  static const String organiserEvents = "$baseUrl/api/Event/events";
  static const String createEvent = "$baseUrl/api/Event/Create_events";
    static String getOrganiserVenues(int organiserId) =>
      '$baseUrl/api/Event/organiser-venues/organiser_id/$organiserId';
  
}