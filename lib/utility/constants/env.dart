class Env {
  Env._();
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://default.supabase.co');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'default-anon-key');
}