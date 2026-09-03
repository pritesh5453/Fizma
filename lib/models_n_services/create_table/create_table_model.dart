class TableTicketRequest {
  final int eventId;
  final int venueId;
  final int slotId;
  final String tableName;
  final int reservation;
  final String description;
  final int totalTable;
  final double tablePrice;
  final int maxPersonsPerTable;
  final String ageRestriction;
  final int maleAllocation;
  final int femaleAllocation;
  final int otherAllocation;
  final int dynamicPricingEnabled;
  final int dynamicThreshold;
  final double dynamicIncreasePercentage;
  final int advancePaymentEnabled;
  final double advancePercentage;
  final int minTables;
  final int maxTables;
  final int extraPersonEnabled;
  final int maxExtraGuests;
  final double pricePerMaleGuest;
  final double pricePerFemaleGuest;
  final int oneTimeCheckIn;
  final int isActive;

  TableTicketRequest({
    required this.eventId,
    required this.venueId,
    required this.slotId,
    required this.tableName,
    required this.reservation,
    required this.description,
    required this.totalTable,
    required this.tablePrice,
    required this.maxPersonsPerTable,
    required this.ageRestriction,
    required this.maleAllocation,
    required this.femaleAllocation,
    required this.otherAllocation,
    required this.dynamicPricingEnabled,
    required this.dynamicThreshold,
    required this.dynamicIncreasePercentage,
    required this.advancePaymentEnabled,
    required this.advancePercentage,
    required this.minTables,
    required this.maxTables,
    required this.extraPersonEnabled,
    required this.maxExtraGuests,
    required this.pricePerMaleGuest,
    required this.pricePerFemaleGuest,
    required this.oneTimeCheckIn,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'venue_id': venueId,
      'slot_id': slotId,
      'table_name': tableName,
      'reservation': reservation,
      'description': description,
      'total_table': totalTable,
      'table_price': tablePrice,
      'max_persons_per_table': maxPersonsPerTable,
      'age_restriction': ageRestriction,
      'male_allocation': maleAllocation,
      'female_allocation': femaleAllocation,
      'other_allocation': otherAllocation,
      'dynamic_pricing_enabled': dynamicPricingEnabled,
      'dynamic_threshold': dynamicThreshold,
      'dynamic_increase_percentage': dynamicIncreasePercentage,
      'advance_payment_enabled': advancePaymentEnabled,
      'advance_percentage': advancePercentage,
      'min_tables': minTables,
      'max_tables': maxTables,
      'extra_person_enabled': extraPersonEnabled,
      'max_extra_guests': maxExtraGuests,
      'price_per_male_guest': pricePerMaleGuest,
      'price_per_female_guest': pricePerFemaleGuest,
      'one_time_check_in': oneTimeCheckIn,
      'is_active': isActive,
    };
  }
}


// Response model for table ticket creation

class TableTicketResponse {
  final int id;
  final int eventId;
  final int venueId;
  final int slotId;
  final String tableName;
  final int reservation;
  final String description;
  final int totalTables;
  final String tablePrice;
  final int maxPersonsPerTable;
  final String ageRestriction;
  final int maleAllocation;
  final int femaleAllocation;
  final int otherAllocation;
  final int dynamicPricingEnabled;
  final int dynamicThreshold;
  final String dynamicIncreasePercentage;
  final String currentPrice;
  final String triggeredPrice;
  final int advancePaymentEnabled;
  final String advancePercentage;
  final dynamic availabilityStart; // null or String
  final dynamic availabilityEnd;
  final int minTables;
  final int maxTables;
  final int extraPersonEnabled;
  final int maxExtraGuests;
  final String pricePerMaleGuest;
  final String pricePerFemaleGuest;
  final int oneTimeCheckIn;
  final String status;
  final int isActive;
  final String createdAt;
  final String updatedAt;

  TableTicketResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        eventId = json['event_id'],
        venueId = json['venue_id'],
        slotId = json['slot_id'],
        tableName = json['table_name'],
        reservation = json['reservation'],
        description = json['description'],
        totalTables = json['total_tables'],
        tablePrice = json['table_price'].toString(),
        maxPersonsPerTable = json['max_persons_per_table'],
        ageRestriction = json['age_restriction'],
        maleAllocation = json['male_allocation'],
        femaleAllocation = json['female_allocation'],
        otherAllocation = json['other_allocation'],
        dynamicPricingEnabled = json['dynamic_pricing_enabled'],
        dynamicThreshold = json['dynamic_threshold'],
        dynamicIncreasePercentage = json['dynamic_increase_percentage'].toString(),
        currentPrice = json['current_price'].toString(),
        triggeredPrice = json['triggered_price'].toString(),
        advancePaymentEnabled = json['advance_payment_enabled'],
        advancePercentage = json['advance_percentage'].toString(),
        availabilityStart = json['availability_start'],
        availabilityEnd = json['availability_end'],
        minTables = json['min_tables'],
        maxTables = json['max_tables'],
        extraPersonEnabled = json['extra_person_enabled'],
        maxExtraGuests = json['max_extra_guests'],
        pricePerMaleGuest = json['price_per_male_guest'].toString(),
        pricePerFemaleGuest = json['price_per_female_guest'].toString(),
        oneTimeCheckIn = json['one_time_check_in'],
        status = json['status'],
        isActive = json['is_active'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];
}