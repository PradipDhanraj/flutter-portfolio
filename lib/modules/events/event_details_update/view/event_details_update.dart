import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/events/event_details_update/bloc/event_details_update_bloc.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/modules/events/location_instructions_page.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/utils/popups.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';
import 'package:myevents/utility/widgets/qr_code_image.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsUpdatePage extends StatefulWidget {
  static String path = '/event-details-update';
  const EventDetailsUpdatePage({super.key});

  @override
  State<EventDetailsUpdatePage> createState() => _EventDetailsUpdatePageState();
}

class _EventDetailsUpdatePageState extends State<EventDetailsUpdatePage> {
  late final Event event;
  late final TextEditingController titleController;
  late final TextEditingController userNameController;
  late final TextEditingController photoDescController;
  late final TextEditingController locationController;

  late final FocusNode titleFocusNode;
  late final FocusNode userNameFocusNode;
  late final FocusNode photoDescFocusNode;
  late final FocusNode locationFocusNode;
  bool _anyFieldFocused = false;

  @override
  void initState() {
    if (GoRouter.of(context).state.extra != null &&
        GoRouter.of(context).state.extra is String) {
      var decodedData = jsonDecode(GoRouter.of(context).state.extra as String);
      event = Event.fromJson(decodedData);
    }
    titleController = TextEditingController(text: event.title);
    userNameController = TextEditingController(text: event.username);
    photoDescController = TextEditingController(text: event.imageUrl);
    locationController = TextEditingController(text: event.location);

    titleFocusNode = FocusNode();
    userNameFocusNode = FocusNode();
    photoDescFocusNode = FocusNode();
    locationFocusNode = FocusNode();

    titleFocusNode.addListener(_handleFocusChange);
    userNameFocusNode.addListener(_handleFocusChange);
    photoDescFocusNode.addListener(_handleFocusChange);
    locationFocusNode.addListener(_handleFocusChange);

    super.initState();
  }

  void _handleFocusChange() {
    setState(() {
      _anyFieldFocused =
          titleFocusNode.hasFocus ||
          userNameFocusNode.hasFocus ||
          photoDescFocusNode.hasFocus ||
          locationFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    userNameController.dispose();
    photoDescController.dispose();
    locationController.dispose();
    titleFocusNode.dispose();
    userNameFocusNode.dispose();
    photoDescFocusNode.dispose();
    locationFocusNode.dispose();
    super.dispose();
  }

  // Removed duplicate initState

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child:
                      !_anyFieldFocused
                          ? Center(child: AnimatedLogo(rotate: true))
                          : const SizedBox.shrink(),
                ),
                Flexible(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900.withOpacity(.7),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox.square(
                            dimension: 100,
                            child: QRWidget(event.event_id!, size: 100),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            event.event_id!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: titleController,
                            focusNode: titleFocusNode,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Event Title',
                              hintStyle: const TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          // if (event.location != null &&
                          //     event.location!.isNotEmpty)
                          //   const SizedBox(height: 8),
                          // if (event.location != null &&
                          //     event.location!.isNotEmpty)
                          //   Text(
                          //     event.location ?? "NA",
                          //     style: const TextStyle(
                          //       fontSize: 16,
                          //       color: Colors.white70,
                          //     ),
                          //   ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: userNameController,
                            focusNode: userNameFocusNode,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'User name here',
                              hintStyle: const TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: photoDescController,
                            focusNode: photoDescFocusNode,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Google drive link',
                              hintStyle: const TextStyle(color: Colors.black54),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  final clipboardData = await Clipboard.getData(
                                    Clipboard.kTextPlain,
                                  );
                                  if (clipboardData?.text == null) {
                                    SnackbarUtils.showSnackBar(
                                      'Drive link is not copied properly',
                                    );
                                  }
                                  photoDescController.text =
                                      clipboardData?.text ?? "";
                                },
                                child: Container(
                                  width: 80,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.7),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Paste',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: FontSizes.medium,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            child: TextField(
                              controller: locationController,
                              focusNode: locationFocusNode,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Venue location',
                                hintStyle: const TextStyle(
                                  color: Colors.black54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    final clipboardData =
                                        await Clipboard.getData(
                                          Clipboard.kTextPlain,
                                        );
                                    if (clipboardData?.text == null) {
                                      SnackbarUtils.showSnackBar(
                                        'Location link is not copied properly',
                                      );
                                    }
                                    locationController.text =
                                        clipboardData?.text ?? "";
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.7),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Paste',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: FontSizes.medium,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            //width: double.infinity,
                            child: BlocConsumer<
                              EventDetailsUpdateBloc,
                              EventDetailsUpdateState
                            >(
                              listener: (context, state) {
                                if (state is EventDetailsUpdateStatus) {
                                  SnackbarUtils.showSnackBar(state.message);
                                  if (state.status) {
                                    GoRouter.of(context).pop(state.status);
                                  }
                                } else if (state is DeletedRemoteEventState) {
                                  SnackbarUtils.showSnackBar(
                                    'Event deleted successfully.',
                                  );
                                  GoRouter.of(context).pop(true);
                                }
                              },
                              builder: (context, state) {
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    if (state is! LoadingState) {
                                      var updatedEvent = event.copyWith(
                                        title: titleController.text,
                                        username: userNameController.text,
                                        imageUrl: photoDescController.text,
                                        location: locationController.text,
                                        latitude: null,
                                        longitude: null,
                                      );
                                      BlocProvider.of<EventDetailsUpdateBloc>(
                                        context,
                                      ).add(UpdateEvent(event: updatedEvent));
                                    }
                                  },
                                  icon: AnimatedLogo(
                                    rotate: state is LoadingState,
                                    iconSize: 20,
                                    color: Colors.black,
                                    duration: Duration(seconds: 1),
                                  ),
                                  label: const Text(
                                    'Update details',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.white,
                                    elevation: 10,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
                GoRouter.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 80,
            right: 10,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () async {
                  var isConfirmed = await Popups.showConfirmationPopup(
                    'Confirmation Alert',
                    'Do you really want to delete the event?',
                  );
                  if (isConfirmed != null && isConfirmed) {
                    BlocProvider.of<EventDetailsUpdateBloc>(
                      context,
                    ).add(DeleteRemoteEvent(event: event));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.delete, color: Colors.white, size: 30),
                    SizedBox(height: 5),
                    Text(
                      'Delete event',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: FontSizes.small * .7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (Platform.isAndroid)
            Positioned(
              top: 150,
              right: 10,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    String deeplink =
                        "Hey!!\nDownload Hnoss and follow my event ;)\nhttps://pradip-dhanraj.github.io/link/${event.event_id}";
                    launchUrl(Uri.parse("whatsapp://send?text=$deeplink"));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.link, color: Colors.white, size: 30),
                      Text(
                        'Share on whatsapp',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: FontSizes.small * .7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 50,
            bottom: 100,
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  GoRouter.of(context).push(
                    "${GoRouter.of(context).state.fullPath}${LocationInstructionsPage.path}",
                  );
                },
                child: Text(
                  'How to get the links?',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: FontSizes.small,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
