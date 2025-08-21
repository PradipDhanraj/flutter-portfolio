import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:myevents/modules/events/event_details_update/repository/event_details_update_repository.dart';
import 'package:myevents/modules/events/events_list/repository/event_repository.dart';
import 'package:myevents/modules/authentication/repository/auth_repo.dart';
import 'package:myevents/modules/events/scan_event/repository/scan_repository.dart';
import 'package:myevents/services/authentication/auth_service.dart';
import 'package:myevents/services/database/database_service.dart';
import 'package:myevents/services/map_services/map_service.dart';
import 'package:myevents/services/permissions/permissions_service.dart';
import 'package:myevents/utility/shared_prefs/shared_prefs.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AuthService>(AuthServiceImpl(FirebaseAuth.instance));
  locator.registerSingleton<DatabaseService>(DatabaseService(DI.authService));
  locator.registerSingleton<SharedPrefs>(SharedPrefs());
  locator.registerSingleton<AuthRepo>(AuthRepoImpl(DI.authService));
  locator.registerSingleton<MapService>(MapService());
  locator.registerSingleton<PermissionsService>(PermissionsService(DI.prefs));
  locator.registerSingleton<ScanRepository>(ScanRepository(DI.prefs, DI.databaseService));
  locator.registerSingleton<EventListRepository>(EventListRepository(DI.databaseService, DI.mapService, DI.prefs));
  locator.registerSingleton<EventDetailsUpdateRepository>(EventDetailsUpdateRepository(DI.databaseService, DI.prefs));
}

class DI {
  // Keys
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  DI._();
  static AuthService get authService => locator<AuthService>();
  static DatabaseService get databaseService => locator<DatabaseService>();
  static SharedPrefs get prefs => locator<SharedPrefs>();
  static MapService get mapService => locator<MapService>();
  static PermissionsService get permissionsService => locator<PermissionsService>();

  // REPOSITORIES
  static AuthRepo get authRepo => locator<AuthRepo>();
  static EventListRepository get eventListRepository => locator<EventListRepository>();
  static ScanRepository get scanRepository => locator<ScanRepository>();
  static EventDetailsUpdateRepository get eventDetailsUpdateRepository => locator<EventDetailsUpdateRepository>();
}
