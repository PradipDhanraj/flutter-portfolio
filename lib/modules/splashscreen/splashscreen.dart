import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/modules/events/events_list/view/events_list_page.dart';
import 'package:myevents/services/notification/notification_service.dart';
import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/utils/extensions.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:myevents/utility/widgets/animation_scale.dart';

class SplashScreenPage extends StatefulWidget {
  static String path = '/';
  static String deeplink = '/link';
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      var state = GoRouter.of(context).state;
      if (state.path!.contains(SplashScreenPage.deeplink) &&
          state.pathParameters.containsKey('id')) {
        String? eventid;
        try {
          eventid = state.pathParameters['id'];
          Event eventObj = await DI.scanRepository.getEventDetailsById(
            eventid!,
          );
          var list = await DI.prefs.addNewEvent(eventObj);
          if (list.any((element) => element.event_id == eventid)) {
            await eventObj.changeNotificationSubscriptionStatus(true);
            NotificationService.subscribeToTopic(eventid);
            SnackbarUtils.showSnackBar('Added ${eventObj.title} event');
          }
        } catch (e) {
          SnackbarUtils.showSnackBar('Event with ID $eventid already exists');
        }
      }
      GoRouter.of(context).replace(EventsListPage.path);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(child: AnimationScaleWidget()),
    );
  }
}
