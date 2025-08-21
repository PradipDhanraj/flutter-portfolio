import 'package:myevents/services/authentication/auth_service.dart';
import 'package:myevents/utility/constants/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  SupabaseClient _client = Supabase.instance.client;
  final AuthService _authService;
  DatabaseService(this._authService);

  Future<void> _checkSupabaseSession() async {
    var jwtToken = await _authService.firebaseAuth.currentUser!.getIdToken();
    _client = SupabaseClient(
      Env.supabaseUrl,
      Env.supabaseAnonKey,
      headers: {'Authorization': 'Bearer $jwtToken'},
      accessToken: () async {
        return jwtToken;
      },
    );
  }

  // Insert a row into a table
  Future<List<Map<String, dynamic>>> insert(
    String table,
    Map<String, dynamic> values,
  ) async {
    await _checkSupabaseSession();
    final response =
        await _client.from(table).insert([values]).select().single();
    return [response];
  }

  // Get all rows from a table
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final response = await _client.from(table).select();
    return response;
  }

  // Get rows with filter
  Future<List<Map<String, dynamic>>> getWhere(
    String table,
    String column,
    dynamic value,
  ) async {
    final response = await _client.from(table).select().eq(column, value);
    return response;
  }

  // Update rows
  Future<List<Map<String, dynamic>>> update(
    String table,
    Map<String, dynamic> values,
    String column,
    dynamic value,
  ) async {
    await _checkSupabaseSession();
    final response =
        await _client.from(table).update(values).eq(column, value).select();
    return response;
  }

  // Delete rows
  Future<List<Map<String, dynamic>>> delete(
    String table,
    String column,
    dynamic value,
  ) async {
    await _checkSupabaseSession();
    final response =
        await _client.from(table).delete().eq(column, value).select();
    return response;
  }

  // Example: Get by ID
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    final response = await _client.from(table).select().eq('id', id).single();
    return response;
  }
}
