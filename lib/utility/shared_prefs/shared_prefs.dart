import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/utility/shared_prefs/prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }

  // Future<bool> changeNotificationSubscriptionStatus(String eventId) async {
  //   late Map<String, bool> map;
  //   if (_prefs!.containsKey(PrefsKeys.notificationMap)) {
  //     final jsonString = _prefs?.getString(PrefsKeys.notificationMap);
  //     if (jsonString != null) {
  //       map = jsonDecode(jsonString);
  //       map[eventId] = !(map[eventId] as bool);
  //     }
  //   } else {
  //     map = {};
  //     map[eventId] = true;
  //   }
  //   return await _prefs?.setString(
  //         PrefsKeys.notificationMap,
  //         jsonEncode(map),
  //       ) ??
  //       false;
  // }

  // Future<bool> isNotificationSubscribed(String eventId) async {
  //   final jsonString = _prefs?.getString(PrefsKeys.notificationMap);
  //   if (jsonString != null) {
  //     final Map<String, dynamic> map = jsonDecode(jsonString);
  //     return map[eventId] ?? false;
  //   } else {
  //     final Map<String, dynamic> map = {};
  //     map[eventId] = false;
  //     await _prefs?.setString(PrefsKeys.notificationMap, jsonEncode(map));
  //   }
  //   return isNotificationSubscribed(eventId);
  // }

  Future<List<Event>> addNewEvent(Event newEvent) async {
    if (_prefs?.containsKey(PrefsKeys.eventDetails) == true) {
      // If event details exist, update them
      var existingEvents = _prefs?.getString(PrefsKeys.eventDetails);
      if (existingEvents != null) {
        var eventList =
            (jsonDecode(existingEvents) as List)
                .map((e) => Event.fromJson(e))
                .toList();
        throwIf(
          eventList.any((element) => element.event_id == newEvent.event_id),
          "Event with ID ${newEvent.event_id} already exists",
        );
        // if (eventList.any((element) => element.event_id == newEvent.event_id)) {
        //   // If event with same ID exists, update it
        //   eventList[eventList.indexWhere((e) => e.event_id == newEvent.event_id)] = newEvent;
        // }
        eventList.add(newEvent);
        var isAdded = await _prefs?.setString(
          PrefsKeys.eventDetails,
          jsonEncode(eventList),
        );
        debugPrint("$isAdded");
      }
    } else {
      // If no event details exist, create a new list
      var eventList = [newEvent];
      await _prefs?.setString(PrefsKeys.eventDetails, jsonEncode(eventList));
    }
    return await getAllEvents();
  }

  Future<List<Event>> getAllEvents() async {
    if (_prefs?.containsKey(PrefsKeys.eventDetails) == true) {
      // If event details exist, update them
      var existingEvents = _prefs?.getString(PrefsKeys.eventDetails);
      if (existingEvents != null) {
        var eventList =
            (jsonDecode(existingEvents) as List)
                .map((e) => Event.fromJson(e))
                .toList();
        return eventList;
      }
    }
    return [];
  }

  Future<void> updateEventInPrefs(Event event) async {
    if (_prefs?.containsKey(PrefsKeys.eventDetails) == true) {
      var existingEvents = _prefs?.getString(PrefsKeys.eventDetails);
      if (existingEvents != null) {
        var eventList =
            (jsonDecode(existingEvents) as List)
                .map((e) => Event.fromJson(e))
                .toList();
        var index = eventList.indexWhere((e) => e.event_id == event.event_id);
        if (index != -1) {
          eventList[index] = event;
          await _prefs?.setString(
            PrefsKeys.eventDetails,
            jsonEncode(eventList),
          );
        }
      }
    }
  }

  bool containsKey(String notificationMap) {
    return _prefs!.containsKey(notificationMap);
  }
}
