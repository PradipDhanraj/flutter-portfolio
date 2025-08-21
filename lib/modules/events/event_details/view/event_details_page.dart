import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/utils/extensions.dart';
import 'package:myevents/utility/utils/popups.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';
import 'package:myevents/utility/widgets/qr_code_image.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  static String path = '/event-details';
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Event event;
  bool? updateEventList;

  @override
  void initState() {
    if (GoRouter.of(context).state.extra != null &&
        GoRouter.of(context).state.extra is String) {
      var decodedData = jsonDecode(GoRouter.of(context).state.extra as String);
      event = Event.fromJson(decodedData);
    }
    super.initState();
  }

  Widget getTile(IconData icon, String title, void Function()? onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 130,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.black),
              Text(
                title,
                style: TextStyle(
                  fontSize: FontSizes.medium,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Flexible(
                  flex: 2,
                  child: Center(child: AnimatedLogo(rotate: true)),
                ),
                Flexible(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Text(
                          event.event_id!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox.square(
                          dimension: 100,
                          child: QRWidget(event.event_id!, size: 100),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          event.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: FontSizes.large,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          event.event_date.toDDMMYYYYHHMMAmPm(),
                          style: TextStyle(
                            fontSize: FontSizes.medium,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Flex(
                          direction: Axis.horizontal,
                          spacing: 5,
                          children: [
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: FutureBuilder(
                                future: event.isNotificationSubscribed,
                                builder: (context, snapshot) {
                                  return getTile(
                                    Icons.notifications,
                                    snapshot.data == true
                                        ? 'UNSUBSCRIBE'
                                        : 'SUBSCRIBE',
                                    () async {
                                      if (event.event_id != null &&
                                          event.event_id!.isNotEmpty) {
                                        try {
                                          if (snapshot.data == true) {
                                            final confirmed =
                                                await Popups.showConfirmationPopup(
                                                  'Unsubscribe from notifications?',
                                                  'You will no longer receive notifications for this event.',
                                                );
                                            if (confirmed != true) {
                                              return;
                                            }
                                            await FirebaseMessaging.instance
                                                .unsubscribeFromTopic(
                                                  event.event_id!,
                                                );
                                            event
                                                .changeNotificationSubscriptionStatus(
                                                  false,
                                                );
                                            updateEventList = true;
                                            SnackbarUtils.showSnackBar(
                                              'Unsubscribed from notifications.',
                                            );
                                          } else {
                                            await FirebaseMessaging.instance
                                                .subscribeToTopic(
                                                  event.event_id!,
                                                );
                                            event
                                                .changeNotificationSubscriptionStatus(
                                                  true,
                                                );
                                            updateEventList = true;
                                            SnackbarUtils.showSnackBar(
                                              'Subscribed to notifications.',
                                            );
                                          }
                                        } on Exception catch (e) {
                                          SnackbarUtils.showSnackBar(
                                            'Failed to subscribe/unsubscribe to notifications, please try again after some time.',
                                          );
                                        }
                                      } else {
                                        SnackbarUtils.showSnackBar(
                                          'Failed to subscribe to notifications, please try again after some time.',
                                        );
                                      }
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: getTile(Icons.photo, 'UPLOAD', () async {
                                if (event.imageUrl != null) {
                                  try {
                                    await launchUrl(Uri.parse(event.imageUrl!));
                                  } catch (e) {
                                    debugPrint('$e');
                                  }
                                } else {
                                  SnackbarUtils.showSnackBar(
                                    'Google drive link is not available',
                                  );
                                }
                              }),
                            ),
                          ],
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: getTile(
                                Icons.navigation,
                                'NAVIGATE TO VENUE',
                                () async {
                                  if (event.location != null &&
                                      event.location!.isNotEmpty) {
                                    SnackbarUtils.showSnackBar(
                                      'Navigating....',
                                    );
                                    try {
                                      await launchUrl(
                                        Uri.parse(event.location!),
                                      );
                                    } catch (e) {
                                      debugPrint('$e');
                                    }
                                  } else {
                                    SnackbarUtils.showSnackBar(
                                      'Venue location is not available to navigate.',
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                GoRouter.of(context).pop(event);
              },
            ),
          ),
        ],
      ),
    );
  }
}
