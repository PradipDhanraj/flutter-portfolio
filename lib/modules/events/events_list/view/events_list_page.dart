import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/events/create_event/view/create_event.dart';
import 'package:myevents/modules/events/event_details/view/event_details_page.dart';
import 'package:myevents/modules/events/event_details_update/view/event_details_update.dart';
import 'package:myevents/modules/events/events_list/bloc/events_list_bloc.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/modules/events/scan_event/view/scan_event_page.dart';
import 'package:myevents/modules/settings/view/settings_page.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/utils/extensions.dart';
import 'package:myevents/utility/utils/popups.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsListPage extends StatefulWidget {
  static String path = '/event-list';
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  List<Event> events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<EventsListBloc, EventsListState>(
        listenWhen:
            (previous, current) =>
                //current is OpenEventOnCreateState ||
                current is NavigateToEventDetailsPageState,
        listener: (context, state) {
          // if (state is OpenEventOnCreateState) {
          //   GoRouter.of(context).push(
          //     '${EventsListPage.path}${EventDetailsPage.path}',
          //     extra: jsonEncode((state).event),
          //   );
          //   // .then((value) {
          //   //   if (value != null) {
          //   //     BlocProvider.of<EventsListBloc>(
          //   //       context,
          //   //     ).add(InitialEventsListEvent());
          //   //   }
          //   // });
          // } else
          if (state is NavigateToEventDetailsPageState) {
            if (state.event.isEventOrganizer) {
              GoRouter.of(context)
                  .push(
                    '${EventsListPage.path}${EventDetailsUpdatePage.path}',
                    extra: jsonEncode(state.event),
                  )
                  .then((isUpdatedSuccessfully) {
                    var bloc = BlocProvider.of<EventsListBloc>(context);
                    bloc.add(InitialEventsListEvent());
                    if (isUpdatedSuccessfully == true) {
                      bloc.add(
                        BroadcastMessageEvent(
                          state.event.event_id!,
                          'Event update'.toUpperCase(),
                          'Event details has been updated, refresh the events list'
                              .toUpperCase(),
                          data: {},
                        ),
                      );
                      bloc.add(RefreshList());
                    }
                  });
            } else {
              GoRouter.of(context)
                  .push(
                    '${EventsListPage.path}${EventDetailsPage.path}',
                    extra: jsonEncode(state.event),
                  )
                  .then((updatedEvent) {
                    if (updatedEvent is Event) {
                      BlocProvider.of<EventsListBloc>(
                        context,
                      ).add(UpdateEvent(updatedEvent));
                    }
                  });
            }
          }
        },
        buildWhen:
            (previous, current) =>
                current is EventsListLoaded || current is EventsListLoading,
        builder: (context, state) {
          if (state is EventsListLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedLogo(
                  rotate: true,
                  iconSize: 50,
                  duration: Duration(milliseconds: 500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Loading...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          } else if (state is EventsListLoaded) {
            events = [...state.events];
            events.sort((a, b) => a.isEventOrganizer ? -1 : 1);
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              // Container(
              //   decoration: const BoxDecoration(
              //     color: Colors.black,
              //     image: DecorationImage(
              //       image: AssetImage('assets/png/bg1.png'),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              SafeArea(
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Center(
                        child: AnimatedLogo(
                          icon: Icons.webhook_sharp,
                          rotate: true,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: RefreshIndicator.noSpinner(
                        onRefresh: () async {
                          BlocProvider.of<EventsListBloc>(
                            context,
                          ).add(RefreshList());
                        },
                        child: ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            Color? backgroundColor =
                                event.isEventOrganizer
                                    ? Colors.white
                                    : Colors.blueGrey.shade900.withOpacity(.8);
                            Color? textColor =
                                event.isEventOrganizer
                                    ? Colors.black
                                    : Colors.white;
                            return Dismissible(
                              confirmDismiss: (direction) async {
                                if (!event.isEventOrganizer) {
                                  return await Popups.showConfirmationPopup(
                                    'Do you want delete the event?',
                                    'It will be deleted from the app but you can rescan it to add it again.',
                                  );
                                }
                                return Future.value(false);
                              },
                              key: Key(event.event_id!),
                              direction: DismissDirection.endToStart,
                              secondaryBackground: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                margin: EdgeInsets.only(right: 10.0),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                BlocProvider.of<EventsListBloc>(
                                  context,
                                ).add(DeleteLocalEvent(event));
                              },
                              child: Card(
                                color: backgroundColor,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    BlocProvider.of<EventsListBloc>(
                                      context,
                                    ).add(NavigateToEventDetailsPage(event));
                                  },
                                  visualDensity:
                                      VisualDensity.adaptivePlatformDensity,
                                  dense: true,
                                  leading: InkWell(
                                    onTap: () async {
                                      await Popups.showQRCodePopup(
                                        context,
                                        event.event_id!,
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 0,
                                        ),
                                        child: Icon(
                                          Icons.qr_code_2_outlined,
                                          size: 30,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    event.title.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: FontSizes.medium,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (event.isEventOrganizer)
                                        SizedBox.square(
                                          dimension: 40,
                                          child: InkWell(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                            //splashColor: Colors.transparent,
                                            onTap: () async {
                                              await Popups.showSendMessageBottomDialog(
                                                context,
                                                event,
                                                onSend: (title, message) async {
                                                  BlocProvider.of<
                                                    EventsListBloc
                                                  >(context).add(
                                                    BroadcastMessageEvent(
                                                      event.event_id!,
                                                      title,
                                                      message,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(
                                              Icons.send,
                                              size: 25,
                                              color: textColor.withOpacity(.7),
                                            ),
                                          ),
                                        ),
                                      if (event.location != null &&
                                          event.location!.isNotEmpty)
                                        IconButton(
                                          icon: Icon(
                                            Icons.share_location,
                                            size: 30,
                                          ),
                                          color: textColor.withOpacity(.7),
                                          onPressed: () async {
                                            try {
                                              await launchUrl(
                                                Uri.parse(event.location!),
                                              );
                                            } catch (e) {
                                              debugPrint('$e');
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ${event.event_date.toDDMMYYYY()}',
                                        style: TextStyle(
                                          color: textColor,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Location ',
                                            style: TextStyle(color: textColor),
                                          ),
                                          event.location != null &&
                                                  event.location!.isNotEmpty
                                              ? Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                                size: 12,
                                              )
                                              : Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                                size: 12,
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 80,
                right: 25,
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context)
                        .push('${EventsListPage.path}${CreateEventPage.path}')
                        .then((event) {
                          if (event is Event) {
                            EventsListBloc bloc =
                                BlocProvider.of<EventsListBloc>(context);
                            bloc.add(AddNewEvent(event));
                            //bloc.add(NavigateToEventDetailsPage(event));
                          }
                        });
                  },
                  child: Icon(Icons.event, color: Colors.white, size: 30),
                ),
              ),
              Positioned(
                top: 80,
                left: 25,
                child: InkWell(
                  onTap:
                      () => GoRouter.of(context)
                          .push('${EventsListPage.path}${SettingsPage.path}')
                          .then((isUserLoggedin) {
                            BlocProvider.of<EventsListBloc>(
                              context,
                            ).add(InitialEventsListEvent());
                          }),
                  child: Icon(Icons.settings, color: Colors.white, size: 30),
                ),
              ),
              if (events.isNotEmpty)
                Positioned(
                  top: 150,
                  right: 25,
                  child: InkWell(
                    onTap:
                        () => GoRouter.of(context)
                            .push('${EventsListPage.path}${ScanEventPage.path}')
                            .then((value) {
                              if (value is Event) {
                                var bloc = BlocProvider.of<EventsListBloc>(
                                  context,
                                );
                                bloc.add(InitialEventsListEvent());
                                bloc.add(NavigateToEventDetailsPage(value));
                              }
                            }),
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              if (events.isEmpty)
                Center(
                  child: InkWell(
                    onTap:
                        () => GoRouter.of(context)
                            .push('${EventsListPage.path}${ScanEventPage.path}')
                            .then((value) {
                              if (value is Event) {
                                var bloc = BlocProvider.of<EventsListBloc>(
                                  context,
                                );
                                bloc.add(InitialEventsListEvent());
                                bloc.add(NavigateToEventDetailsPage(value));
                              }
                            }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_2_rounded,
                          color: Colors.white,
                          size: 100,
                        ),
                        Text(
                          'Scan or Enter code'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: FontSizes.large,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
