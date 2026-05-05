class VenueSlotsStore {
  static final Map<String, List<String>> _venueSlots = {
    '1': <String>['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '03:00 PM'],
    '2': <String>['10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '04:00 PM', '05:00 PM'],
    '3': <String>['08:00 AM', '09:00 AM', '10:00 AM', '02:00 PM', '03:00 PM'],
    '4': <String>['11:00 AM', '12:00 PM', '01:00 PM', '03:00 PM', '04:00 PM'],
    '5': <String>['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '03:00 PM'],
    '6': <String>['10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '04:00 PM', '05:00 PM'],
    '7': <String>['08:00 AM', '09:00 AM', '10:00 AM', '02:00 PM', '03:00 PM'],
    '8': <String>['11:00 AM', '12:00 PM', '01:00 PM', '03:00 PM', '04:00 PM'],
    '9': <String>['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '03:00 PM'],
    '10': <String>['10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '04:00 PM', '05:00 PM'],
    '11': <String>['08:00 AM', '09:00 AM', '10:00 AM', '02:00 PM', '03:00 PM'],
    '12': <String>['11:00 AM', '12:00 PM', '01:00 PM', '03:00 PM', '04:00 PM'],
  };

  static List<String> getSlots(String venueId) {
    return _venueSlots[venueId] ?? <String>[];
  }
}