// lib/models_n_services/create_ticket/create_ticket_model.dart

// ---------- REQUEST MODELS ----------

class CreateTicketRequest {
  final int eventId;
  final int venueId;
  final int? slotId;
  final String ticketName;
  final bool freeTicket;
  final int totalTickets;
  final int ticketPrice;
  final bool maxPersonsEnabled;
  final int maxPersonsPerTicket;
  final int eventCapacity;
  final String ageRestriction;
  final int maleAllocation;
  final int femaleAllocation;
  final int otherAllocation;
  final String description;
  final bool dynamicPricingEnabled;
  final int dynamicThreshold;
  final int dynamicIncreasePercentage;
  final bool advancePaymentEnabled;
  final int? advancePercentage;
  final String availabilityStart;
  final String availabilityEnd;
  final int minTickets;
  final int maxTickets;
  final bool guestListEnabled;
  final List<Guest> guestList;
  final List<Addon> addons;
  final bool additionalInfoEnabled;
  final List<AdditionalInfo> additionalInfo;
  final bool isActive;

  CreateTicketRequest({
    required this.eventId,
    required this.venueId,
    this.slotId,
    required this.ticketName,
    required this.freeTicket,
    required this.totalTickets,
    required this.ticketPrice,
    required this.maxPersonsEnabled,
    required this.maxPersonsPerTicket,
    required this.eventCapacity,
    required this.ageRestriction,
    required this.maleAllocation,
    required this.femaleAllocation,
    required this.otherAllocation,
    required this.description,
    required this.dynamicPricingEnabled,
    required this.dynamicThreshold,
    required this.dynamicIncreasePercentage,
    required this.advancePaymentEnabled,
    this.advancePercentage,
    required this.availabilityStart,
    required this.availabilityEnd,
    required this.minTickets,
    required this.maxTickets,
    required this.guestListEnabled,
    required this.guestList,
    required this.addons,
    required this.additionalInfoEnabled,
    required this.additionalInfo,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'event_id': eventId,
    'venue_id': venueId,
    if (slotId != null) 'slot_id': slotId,
    'ticket_name': ticketName,
    'free_ticket': freeTicket,
    'total_tickets': totalTickets,
    'ticket_price': ticketPrice,
    'max_persons_enabled': maxPersonsEnabled,
    'max_persons_per_ticket': maxPersonsPerTicket,
    'event_capacity': eventCapacity,
    'age_restriction': ageRestriction,
    'male_allocation': maleAllocation,
    'female_allocation': femaleAllocation,
    'other_allocation': otherAllocation,
    'description': description,
    'dynamic_pricing_enabled': dynamicPricingEnabled,
    'dynamic_threshold': dynamicThreshold,
    'dynamic_increase_percentage': dynamicIncreasePercentage,
    'advance_payment_enabled': advancePaymentEnabled,
    if (advancePercentage != null) 'advance_percentage': advancePercentage,
    'availability_start': availabilityStart,
    'availability_end': availabilityEnd,
    'min_tickets': minTickets,
    'max_tickets': maxTickets,
    'guest_list_enabled': guestListEnabled,
    'guest_list': guestList.map((e) => e.toJson()).toList(),
    'addons': addons.map((e) => e.toJson()).toList(),
    'additional_info_enabled': additionalInfoEnabled,
    'additional_info': additionalInfo.map((e) => e.toJson()).toList(),
    'is_active': isActive,
  };
}

class Guest {
  final String mobile;
  final String name;
  final String email;

  Guest({
    required this.mobile,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'mobile': mobile,
    'name': name,
    'email': email,
  };
}

class Addon {
  final String title;
  final int price;

  Addon({
    required this.title,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
  };
}

class AdditionalInfo {
  final String fieldName;
  final bool mandatory;
  final bool numbersOnly;
  final bool lettersAndSigns;
  final bool boolean;
  final int limitLength;

  AdditionalInfo({
    required this.fieldName,
    required this.mandatory,
    required this.numbersOnly,
    required this.lettersAndSigns,
    required this.boolean,
    required this.limitLength,
  });

  Map<String, dynamic> toJson() => {
    'field_name': fieldName,
    'mandatory': mandatory,
    'numbers_only': numbersOnly,
    'letters_and_signs': lettersAndSigns,
    'boolean': boolean,
    'limit_length': limitLength,
  };
}

// ---------- RESPONSE MODELS ----------

class CreateTicketResponse {
  final bool success;
  final String message;
  final TicketData data;

  CreateTicketResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    return CreateTicketResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TicketData.fromJson(json['data'] ?? {}),
    );
  }
}

class TicketData {
  final int ticketId;
  final int eventId;
  final int venueId;
  final int slotId;
  final String ticketName;
  final int totalTickets;
  final int ticketPrice;

  TicketData({
    required this.ticketId,
    required this.eventId,
    required this.venueId,
    required this.slotId,
    required this.ticketName,
    required this.totalTickets,
    required this.ticketPrice,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      ticketId: json['ticket_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      venueId: json['venue_id'] ?? 0,
      slotId: json['slot_id'] ?? 0,
      ticketName: json['ticket_name'] ?? '',
      totalTickets: json['total_tickets'] ?? 0,
      ticketPrice: json['ticket_price'] ?? 0,
    );
  }
}