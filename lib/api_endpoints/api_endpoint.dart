class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "http://fizmaa.gccltd.in";

  static const String organiserLogin = "$baseUrl/api/auth/organiser/login";
  static const String organiserEvents = "$baseUrl/api/Event/events";
  static const String createEvent = "$baseUrl/api/Event/Create_events";
    static String getOrganiserVenues(int organiserId) =>
      '$baseUrl/api/Event/organiser-venues/organiser_id/$organiserId';
      static const String submitVenues = '$baseUrl/api/Event/venue';

    static String getEventVenues(int eventId) =>
      '$baseUrl/api/Event/venue/event/$eventId';

      static const String addEventSlots = '$baseUrl/api/Event/add-event-slot';

      static const String createTicket = '/api/Event/create-ticket';
      static const String tableTickets = '/api/Event/table-tickets';

      static String getVolunteers(int organiserId) =>
      '/api/volunteer/organiser/$organiserId';

      static const String assignVolunteers = '/api/volunteer/assign-volunteers';

        // ✅ Publish Event
      static const String publishEvent = '/api/Event/publish-event';

      // create volunteer
      static String createVolunteer() => '$baseUrl/api/volunteer/create-volunteer';

      // get all events
      static const String events = '/api/Event/events';

        static String getBusinessDetails(int organiserId) =>
      '$baseUrl/api/organisers/$organiserId/business-details';

      static String updateBusinessDetails(int organiserId) =>
      '$baseUrl/api/organisers/$organiserId/business-details';

        static String kycDetails(int organiserId) =>
      '$baseUrl/api/kyc/$organiserId/kyc';

      static String profile(int organiserId) =>
      '$baseUrl/api/auth/profile/$organiserId';

          static String bankDetails(int organiserId) =>
      '$baseUrl/api/Bank/$organiserId/bank-details';

       static String createCoupon(int organiserId) =>
      '$baseUrl/api/coupon/$organiserId/coupons';

      static String getCoupons(int organiserId, {String? status}) {
    final uri = Uri.parse('$baseUrl/api/coupon/$organiserId/coupons');
    if (status != null && status.isNotEmpty) {
      return uri.replace(queryParameters: {'status': status}).toString();
    }
    return uri.toString();
  }


}