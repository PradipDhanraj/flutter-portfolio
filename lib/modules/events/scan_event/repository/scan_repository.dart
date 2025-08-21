import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/services/database/database_service.dart';
import 'package:myevents/services/database/db_tables.dart';
import 'package:myevents/utility/shared_prefs/shared_prefs.dart';

class ScanRepository {
  final SharedPrefs _prefs;
  final DatabaseService _databaseService;

  ScanRepository(this._prefs, this._databaseService);

  Future<void> saveScanEvent(Event event) async {
    await _prefs.addNewEvent(event);
  }

  Future<Event> getEventDetailsById(
    String eventId, [
    String table = DatabaseTables.weddingTable,
  ]) async {
    var data = await _databaseService.getWhere(table, 'event_id', eventId);
    return Event.fromJson(data.first);
  }
}
