import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'resources/locator.dart';
import 'resources/router.dart' as router;
import 'resources/route_paths.dart' as routes;
import 'services/navigation-service.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final Snippets snippets = Snippets();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pradip Dhanraj Portfolio',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      theme: ThemeData(
        textTheme: GoogleFonts.vt323TextTheme().copyWith(),
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: routes.StartPageRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      // home: ChangeNotifierProvider<CounterBloc>.value(
      //   value: CounterBloc(),
      //   child: CounterPage(
      //     snippets: snippets,
      //   ),
      // ),
    );
  }
}
