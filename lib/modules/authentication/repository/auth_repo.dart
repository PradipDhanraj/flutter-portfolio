import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/services/authentication/auth_service.dart';
import 'package:myevents/services/database/db_tables.dart';
import 'package:myevents/utility/locator.dart';

abstract class AuthRepo {
  final AuthService authService;
  AuthRepo(this.authService);
  Future<Event> getEventDetailsById(String table, String eventId);
  String generateEventCode();
  Future<Event> createEvent(Event event);
}

class AuthRepoImpl extends AuthRepo {
  AuthRepoImpl(super.authService);
  /// Generates a unique 6-character alphanumeric code based on timestamp and randomness
  @override
  String generateEventCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    // Use microseconds since epoch for uniqueness
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final buffer = StringBuffer();
    // Mix timestamp digits and random chars for uniqueness
    final tsStr = timestamp.toRadixString(36).toUpperCase();
    for (int i = 0; i < 6; i++) {
      if (i < tsStr.length) {
        buffer.write(tsStr[i]);
      } else {
        buffer.write(chars[rand.nextInt(chars.length)]);
      }
    }
    return buffer.toString();
  }

  @override
  Future<Event> getEventDetailsById(String table, String eventId) async {
    var data = await DI.databaseService.getWhere(table, 'event_id', eventId);
    return Event.fromJson(data.first);
  }

  @override
  Future<Event> createEvent(Event event) async {
    try {
      var user = FirebaseAuth.instance.currentUser!;
      var newObj = event.copyWith(
        created_at: DateTime.now(),
        owner_id: user.uid,
        username: user.displayName,
      );
      var rowsAffected = await DI.databaseService.insert(
        DatabaseTables.weddingTable,
        newObj.toJson(),
      );
      if (rowsAffected.isNotEmpty) {
        return Future.value(Event.fromJson(rowsAffected.first));
      } else {
        throw Exception('Failed to create event');
      }
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }
}
