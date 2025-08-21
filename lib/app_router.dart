import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myevents/modules/authentication/view/sign_in.dart';
import 'package:myevents/modules/developer/developer_page.dart';
import 'package:myevents/modules/events/create_event/bloc/create_event_bloc.dart';
import 'package:myevents/modules/events/create_event/view/create_event.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/events/event_details/view/event_details_page.dart';
import 'package:myevents/modules/events/event_details_update/bloc/event_details_update_bloc.dart';
import 'package:myevents/modules/events/event_details_update/view/event_details_update.dart';
import 'package:myevents/modules/events/location_instructions_page.dart';
import 'package:myevents/modules/events/scan_event/bloc/scan_event_bloc.dart';
import 'package:myevents/modules/events/scan_event/view/scan_event_page.dart';
import 'package:myevents/modules/events/events_list/bloc/events_list_bloc.dart';
import 'package:myevents/modules/events/events_list/view/events_list_page.dart';
import 'package:myevents/modules/settings/bloc/settings_bloc.dart';
import 'package:myevents/modules/settings/view/settings_page.dart';
import 'package:myevents/modules/splashscreen/splashscreen.dart';
import 'package:myevents/modules/events/scan_event/view/camera_widget.dart';
import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashScreenPage.path,
  navigatorKey: DI.navigatorKey,
  routes: [
    GoRoute(
      path: SignInPage.path,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: "${SplashScreenPage.deeplink}/:id",
      builder: (context, state) => const SplashScreenPage(),
    ),
    GoRoute(
      path: SplashScreenPage.path,
      builder: (context, state) => const SplashScreenPage(),
    ),
    GoRoute(
      path: EventsListPage.path,
      routes: [
        GoRoute(
          path: SettingsPage.path,
          routes: [
            GoRoute(
              path: DeveloperPage.path,
              builder: (context, state) => const DeveloperPage(),
            ),
          ],
          builder:
              (context, state) => BlocProvider(
                create:
                    (context) => SettingsBloc(
                      DI.prefs,
                      DI.permissionsService,
                      DI.authService,
                    )..add(LoadDataEvent()),
                child: const SettingsPage(),
              ),
        ),
        GoRoute(
          path: EventDetailsPage.path,
          builder: (context, state) => const EventDetailsPage(),
        ),
        GoRoute(
          path: EventDetailsUpdatePage.path,
          routes: [
            GoRoute(
              path: LocationInstructionsPage.path,
              builder: (context, state) => const LocationInstructionsPage(),
            ),
          ],
          builder:
              (context, state) => BlocProvider(
                create:
                    (context) =>
                        EventDetailsUpdateBloc(DI.eventDetailsUpdateRepository),
                child: const EventDetailsUpdatePage(),
              ),
        ),
        GoRoute(
          path: ScanEventPage.path,
          builder:
              (context, state) => BlocProvider(
                create: (context) => ScanEventBloc(DI.scanRepository, DI.prefs),
                child: const ScanEventPage(),
              ),
          routes: [
            GoRoute(
              path: ScanQRWidget.path,
              builder: (context, state) => const ScanQRWidget(),
            ),
          ],
        ),
        GoRoute(
          path: CreateEventPage.path,
          builder:
              (context, state) => BlocProvider(
                create: (context) => CreateEventBloc(DI.authRepo),
                child: const CreateEventPage(),
              ),
          routes: [
            GoRoute(
              path: LocationInstructionsPage.path,
              builder: (context, state) => const LocationInstructionsPage(),
            ),
            GoRoute(
              path: SignInPage.path,
              builder: (context, state) => const SignInPage(),
            ),
          ],
        ),
      ],
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    EventsListBloc(DI.eventListRepository)
                      ..add(InitialEventsListEvent()),
            child: EventsListPage(),
          ),
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Page not found: \\${state.uri.path}',
              maxLines: 3,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          AnimatedLogo(rotate: true, iconSize: 50),
        ],
      ),
    );
  },
);
