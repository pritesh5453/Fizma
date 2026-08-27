// lib/models_n_services/event_slot/event_slot_model.dart

// ---------- REQUEST MODELS ----------

class AddEventSlotRequest {
  final int eventId;
  final int step;
  final List<SlotItemRequest> slots;

  AddEventSlotRequest({
    required this.eventId,
    required this.step,
    required this.slots,
  });

  Map<String, dynamic> toJson() => {
    'event_id': eventId,
    'step': step,
    'slots': slots.map((e) => e.toJson()).toList(),
  };
}

class SlotItemRequest {
  final String slotTitle;
  final int venueId;
  final String fromDate;
  final String toDate;
  final String registrationDeadline;
  final bool allDay;
  final String? startTime;
  final String? endTime;
  final bool repeatWeekly;
  final List<String> repeatDays;
  final String status;

  SlotItemRequest({
    required this.slotTitle,
    required this.venueId,
    required this.fromDate,
    required this.toDate,
    required this.registrationDeadline,
    required this.allDay,
    this.startTime,
    this.endTime,
    required this.repeatWeekly,
    required this.repeatDays,
    this.status = 'active',
  });

  Map<String, dynamic> toJson() => {
    'slot_title': slotTitle,
    'venue_id': venueId,
    'from_date': fromDate,
    'to_date': toDate,
    'registration_deadline': registrationDeadline,
    'all_day': allDay,                // ✅ boolean
    if (startTime != null) 'start_time': startTime,
    if (endTime != null) 'end_time': endTime,
    'repeat_weekly': repeatWeekly,    // ✅ boolean
    'repeat_days': repeatDays,
    'status': status,
  };
}

// ---------- RESPONSE MODELS ----------

class AddEventSlotResponse {
  final bool success;
  final String message;
  final int totalSlots;
  final List<SlotResponseItem> data;

  AddEventSlotResponse({
    required this.success,
    required this.message,
    required this.totalSlots,
    required this.data,
  });

  factory AddEventSlotResponse.fromJson(Map<String, dynamic> json) {
    return AddEventSlotResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      totalSlots: json['total_slots'] ?? 0,
      data: json['data'] != null
          ? List<SlotResponseItem>.from(
              json['data'].map((e) => SlotResponseItem.fromJson(e)),
            )
          : [],
    );
  }
}

class SlotResponseItem {
  final int id;
  final int eventId;
  final String slotTitle;
  final int venueId;
  final String venueName;
  final String fromDate;
  final String toDate;
  final String registrationDeadline;
  final int allDay;
  final String? startTime;
  final String? endTime;
  final int durationMinutes;
  final int repeatWeekly;
  final String repeatDays;
  final String status;
  final String createdAt;
  final String updatedAt;

  SlotResponseItem({
    required this.id,
    required this.eventId,
    required this.slotTitle,
    required this.venueId,
    required this.venueName,
    required this.fromDate,
    required this.toDate,
    required this.registrationDeadline,
    required this.allDay,
    this.startTime,
    this.endTime,
    required this.durationMinutes,
    required this.repeatWeekly,
    required this.repeatDays,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SlotResponseItem.fromJson(Map<String, dynamic> json) {
    return SlotResponseItem(
      id: json['id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      slotTitle: json['slot_title'] ?? '',
      venueId: json['venue_id'] ?? 0,
      venueName: json['venue_name'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      registrationDeadline: json['registration_deadline'] ?? '',
      allDay: json['all_day'] ?? 0,
      startTime: json['start_time'],
      endTime: json['end_time'],
      durationMinutes: json['duration_minutes'] ?? 0,
      repeatWeekly: json['repeat_weekly'] ?? 0,
      repeatDays: json['repeat_days'] ?? '[]',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  bool get isAllDay => allDay == 1;
  bool get isRepeatWeekly => repeatWeekly == 1;

  List<String> get repeatDaysList {
    try {
      return (repeatDays as List).cast<String>();
    } catch (_) {
      return [];
    }
  }
}