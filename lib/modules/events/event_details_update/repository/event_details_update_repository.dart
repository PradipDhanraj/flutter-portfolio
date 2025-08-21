import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/services/database/database_service.dart';
import 'package:myevents/services/database/db_tables.dart';
import 'package:myevents/utility/shared_prefs/shared_prefs.dart';

class EventDetailsUpdateRepository {
  final DatabaseService _databaseService;
  final SharedPrefs _prefs;

  EventDetailsUpdateRepository(this._databaseService, this._prefs);

  Future<Event> updateEvent(Event event) async {
    try {
      var updatedRows = await _databaseService.update(
        DatabaseTables.weddingTable,
        event.toJson(),
        'event_id',
        event.event_id.toString(),
      );
      if (updatedRows.isNotEmpty) {
        _prefs.updateEventInPrefs(Event.fromJson(updatedRows.first));
        return Event.fromJson(updatedRows.first);
      }
      throw Exception('Event not updated');
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteRemoteEvent(Event event) async {
    try {
      await _databaseService.delete(
        DatabaseTables.weddingTable,
        'event_id',
        event.event_id,
      );
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
