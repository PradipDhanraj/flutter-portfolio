import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myevents/app_router.dart';
import 'package:myevents/services/firebase/firebase_options.dart';
import 'package:myevents/services/notification/notification_service.dart';
import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/constants/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey,accessToken: () async{
    return DI.authService.firebaseAuth.currentUser?.refreshToken;
  },);
  await NotificationService.initialize();
  setupLocator();
  await DI.prefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
