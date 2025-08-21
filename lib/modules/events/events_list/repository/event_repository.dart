import 'dart:convert';

import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/services/database/database_service.dart';
import 'package:myevents/services/database/db_tables.dart';
import 'package:myevents/services/map_services/map_service.dart';
import 'package:myevents/services/notification/notification_service.dart';
import 'package:myevents/utility/shared_prefs/prefs_keys.dart';
import 'package:myevents/utility/shared_prefs/shared_prefs.dart';
import 'package:myevents/utility/utils/extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventListRepository {
  final DatabaseService _databaseService;
  final MapService _mapService;
  final SharedPrefs _prefs;

  EventListRepository(this._databaseService, this._mapService, this._prefs);

  Future<List<Event>> fetchEvents() async {
    var eventsList = await _databaseService.getAll(DatabaseTables.weddingTable);
    return eventsList.map((e) => Event.fromJson(e)).toList();
  }

  Future<bool> refreshList() async {
    var list = await fetchEvents();
    var existingEvents = await _prefs.getAllEvents();
    list =
        list
            .where(
              (value) =>
                  existingEvents.any((e) => e.event_id == value.event_id),
            )
            .toList();
    return await _prefs.setString(PrefsKeys.eventDetails, jsonEncode(list));
  }

  Future<List<Event>> fetchAllLocalEvents() async {
    return await _prefs.getAllEvents();
  }

  void openMap(double latitude, double longitude) {
    _mapService.openMap(latitude, longitude);
  }

  Future<void> updateEvent(Event event) async {
    await _prefs.updateEventInPrefs(event);
  }

  Future<void> deleteLocalEvent(Event event) async {
    var list = await _prefs.getAllEvents();
    list.removeWhere((e) => e.event_id == event.event_id);
    NotificationService.unsubscribeToTopic(event.event_id!);
    await event.removeLocalSubscriptionData();
    await _prefs.setString(PrefsKeys.eventDetails, jsonEncode(list));
  }

  Future<void> broadcastMessage(Map<String, dynamic> map) async {
    await Supabase.instance.client.functions.invoke(
      'broadcast-messages',
      body: map,
    );
  }

  Future<List<Event>> addNewEvent(Event event) async {
    return await _prefs.addNewEvent(event);
  }
}
