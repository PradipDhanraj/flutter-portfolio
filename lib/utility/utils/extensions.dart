import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/shared_prefs/prefs_keys.dart';

extension DateTimeFormatting on DateTime {
  String toDDMMYYYYHHMMAmPm() {
    final day = _twoDigits(this.day);
    final month = _twoDigits(this.month);
    final year = this.year.toString();
    int hour12 = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final hour = _twoDigits(hour12);
    final minute = _twoDigits(this.minute);
    final period = this.hour < 12 ? 'AM' : 'PM';
    return '$day/$month/$year $hour:$minute $period';
  }

  _twoDigits(int n) => n.toString().padLeft(2, '0');

  String toDDMMYYYY() {
    final day = _twoDigits(this.day);
    final month = _twoDigits(this.month);
    final year = this.year.toString();
    return '$day/$month/$year';
  }
}

// extension MapFormatting on Map<String, dynamic> {
//   static List<String> unwantedKeys = ['isNotificationSubscribed', 'isOwner'];
//   Map<String, dynamic> extractUnwantedData() {
//     Map<String, dynamic> extractedData = {};
//     for (var key in unwantedKeys) {
//       if (this.containsKey(key)) {
//         extractedData[key] = this[key];
//         this.remove(key);
//       }
//     }
//     return extractedData;
//   }

//   Map<String, dynamic> addUnwantedData(Map<String, dynamic> map) {
//     unwantedKeys.forEach((element) {
//       this[element] = map[element];
//     });
//     return this;
//   }
// }

extension EventModelExtension on Event {
  bool get isEventOrganizer =>
      FirebaseAuth.instance.currentUser != null &&
      FirebaseAuth.instance.currentUser!.uid == owner_id;

  Future<bool> get isNotificationSubscribed async =>
      await _isNotificationSubscribedFunc();

  Future<bool> changeNotificationSubscriptionStatus(bool status) async {
    late Map<String, dynamic> map;
    if (DI.prefs.containsKey(PrefsKeys.notificationMap)) {
      final jsonString = DI.prefs.getString(PrefsKeys.notificationMap);
      if (jsonString != null) {
        map = jsonDecode(jsonString);
        map[event_id!] = status;
      }
    } else {
      map = {};
      map[event_id!] = status;
    }
    return await DI.prefs.setString(PrefsKeys.notificationMap, jsonEncode(map));
  }

  Future<bool> _isNotificationSubscribedFunc() async {
    final jsonString = DI.prefs.getString(PrefsKeys.notificationMap);
    if (jsonString != null) {
      final Map<String, dynamic> map = jsonDecode(jsonString);
      return map[event_id] ?? false;
    } else {
      final Map<String, bool> map = {};
      map[event_id!] = false;
      await DI.prefs.setString(PrefsKeys.notificationMap, jsonEncode(map));
    }
    return isNotificationSubscribed;
  }

  Future<bool> removeLocalSubscriptionData() async {
    late Map<String, dynamic> map;
    if (DI.prefs.containsKey(PrefsKeys.notificationMap)) {
      final jsonString = DI.prefs.getString(PrefsKeys.notificationMap);
      if (jsonString != null) {
        map = jsonDecode(jsonString);
        map.remove(event_id);
      }
    }
    return await DI.prefs.setString(PrefsKeys.notificationMap, jsonEncode(map));
  }
}
