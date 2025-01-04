import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/pages/contact.dart';
import 'package:portfolio/pages/dashboard.dart';
import 'package:portfolio/pages/skills.dart';
import 'package:portfolio/pages/startpage.dart';
import 'package:portfolio/pages/work.dart';
import 'route_paths.dart' as routes;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.StartPageRoute:
      return MaterialPageRoute(builder: (context) => StartPage());
    case routes.SkillsRoute:
      return MaterialPageRoute(builder: (context) => Skills());
    case routes.HomeRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    case routes.WorkRoute:
      return MaterialPageRoute(builder: (context) => Work());
    case routes.ContactRoute:
      return MaterialPageRoute(builder: (context) => Contact());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}
