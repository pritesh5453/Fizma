class EventFormData {
  String eventName = '';
  String eventCategory = '';
  List<String> artists = [];
  String ageRestriction = '';
  List<String> languages = [];
  String description = '';
  List<String> tags = [];
  String termsConditions = '';
  List<String> facilities = [];
  String status = 'draft';
  String promotionalVideoUrl = '';
  int organiserId = 0;
  String eventDate = '';
  String startTime = '';
  String endTime = '';
  
  // 👇 नए fields
  int? step;          // step number (1,2,3...)
  int? eventId;       // existing event ID (if editing)
  
  List<Sponsor> sponsors = [];
  List<Collaborator> collaborators = [];
}

class Sponsor {
  String name;
  String? type;
  String website;
  String logoUrl;
  Sponsor({this.name = '', this.type, this.website = '', this.logoUrl = ''});
}

class Collaborator {
  String name;
  String? role;
  bool hasAccess;
  Collaborator({this.name = '', this.role, this.hasAccess = true});
}