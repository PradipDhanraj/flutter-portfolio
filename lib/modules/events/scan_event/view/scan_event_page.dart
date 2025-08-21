import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/events/events_list/view/events_list_page.dart';
import 'package:myevents/modules/events/scan_event/bloc/scan_event_bloc.dart';
import 'package:myevents/modules/events/scan_event/view/camera_widget.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:myevents/utility/widgets/animated_button.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';

class ScanEventPage extends StatefulWidget {
  static String path = '/event-match';
  const ScanEventPage({super.key});

  @override
  State<ScanEventPage> createState() => _ScanEventPageState();
}

class _ScanEventPageState extends State<ScanEventPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = false;
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<ScanEventBloc, ScanEventState>(
        listenWhen:
            (previous, current) =>
                current is LoadedSuccessfulEvent ||
                current is LoadingEvent ||
                current is ErrorState,
        buildWhen:
            (previous, current) =>
                current is LoadedSuccessfulEvent || current is LoadingEvent,
        listener: (context, state) {
          if (state is LoadedSuccessfulEvent) {
            isSearching = false;
            //DI.prefs.clear();
            GoRouter.of(context).pop(state.event);
          } else if (state is LoadingEvent) {
            isSearching = true;
          } else if (state is ErrorState) {
            setState(() {
              isSearching = false;
            });
            SnackbarUtils.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Container(
              //   decoration: const BoxDecoration(
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 40,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade900.withOpacity(.7),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _controller,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  hintText: 'Event code',
                                  filled: true,
                                  icon: const Icon(
                                    Icons.webhook_sharp,
                                    color: Colors.white,
                                    size: FontSizes.large * 2,
                                  ),
                                  suffixIcon: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 10.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.qr_code_scanner_sharp),
                                          Text(
                                            'Scan QR',
                                            style: TextStyle(
                                              fontSize: FontSizes.small * .7,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      var code = await GoRouter.of(
                                        context,
                                      ).push(
                                        "${EventsListPage.path}${ScanEventPage.path}${ScanQRWidget.path}",
                                      );
                                      if (code is String) {
                                        _controller.text = code;
                                        BlocProvider.of<ScanEventBloc>(
                                          context,
                                        ).add(CreateEvent(_controller.text));
                                      }
                                    },
                                  ),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              AnimatedIconButton(
                                icon: Icons.webhook_sharp,
                                text: 'Search Event',
                                duration: Duration(seconds: 1),
                                rotate: isSearching,
                                onPressed: () {
                                  BlocProvider.of<ScanEventBloc>(
                                    context,
                                  ).add(CreateEvent(_controller.text));
                                },
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
            ],
          );
        },
      ),
    );
  }
}
