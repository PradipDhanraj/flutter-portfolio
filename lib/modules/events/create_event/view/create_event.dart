import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/events/create_event/bloc/create_event_bloc.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/modules/events/location_instructions_page.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/utils/popups.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:myevents/utility/widgets/animated_button.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';

class CreateEventPage extends StatefulWidget {
  static String path = '/create-event';
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _photoDescController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  String _eventCode = '';
  bool _isLoading = false;
  final FocusNode _titleFocusNode = FocusNode();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  void _generateCode() {
    setState(() {
      _eventCode = DI.authRepo.generateEventCode();
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _validationsFailed() {
    if (_titleController.text.isEmpty) {
      SnackbarUtils.showSnackBar('Please enter the event title');
      return true;
    }
    if (_selectedDate == null) {
      SnackbarUtils.showSnackBar('Please select the event date');
      return true;
    }
    if (_usernameController.text.isEmpty) {
      SnackbarUtils.showSnackBar('Please enter the user name');
      return true;
    }
    // if (_photoDescController.text.isEmpty) {
    //   SnackbarUtils.showSnackBar('Please enter the Google drive link');
    //   //return true;
    // }
    if (_locationController.text.isEmpty) {
      SnackbarUtils.showSnackBar('Please enter the venue location');
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _photoDescController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Widget _pageView() {
    return PageView(
      allowImplicitScrolling: false,
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(24),
          height: 300,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  filled: true,
                  fillColor: Colors.transparent,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Event Date',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select date'
                        : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: TextFormField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Unique Code',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      controller: TextEditingController(text: _eventCode),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _generateCode,
                    tooltip: 'Generate new code',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                child: AnimatedIconButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(Durations.extralong4, () {
                      setState(() {
                        _isLoading = false;
                      });
                      _pageController.nextPage(
                        duration: Durations.extralong4,
                        curve: Curves.easeInOut,
                      );
                    });
                    _titleFocusNode.unfocus();
                  },
                  rotate: _isLoading,
                  text: 'Next',
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _photoDescController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    labelText: 'Google drive link',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                        _photoDescController.text = clipboardData?.text ?? "";
                      },
                      child: Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Paste',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: FontSizes.medium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: 'Venue location',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      suffixIcon: InkWell(
                        onTap: () async {
                          final clipboardData = await Clipboard.getData(
                            Clipboard.kTextPlain,
                          );
                          if (clipboardData?.text == null) {
                            SnackbarUtils.showSnackBar(
                              'Location link is not copied properly',
                            );
                          }
                          _locationController.text = clipboardData?.text ?? "";
                        },
                        child: Container(
                          height: 60,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.7),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Paste',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: FontSizes.medium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
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
                const SizedBox(height: 16),
                SizedBox(
                  //width: double.infinity,
                  child: BlocConsumer<CreateEventBloc, CreateEventState>(
                    listener: (context, state) {
                      if (state is SuccessState) {
                        GoRouter.of(context).pop(state.event);
                      } else if (state is ErrorState) {
                        SnackbarUtils.showSnackBar(state.message);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton.icon(
                        onPressed: () async {
                          if (_validationsFailed()) {
                            return;
                          }
                          if (_photoDescController.text.trim().isEmpty) {
                            var result = await Popups.showConfirmationPopup(
                              'Do you want to continue without Google Drive link?',
                              'Without link your audience won\'t be able to upload photos for the events.',
                            );
                            if (result != true) {
                              return;
                            }
                          }
                          var newEvent = Event(
                            title: _titleController.text,
                            username: _usernameController.text,
                            imageUrl: _photoDescController.text,
                            location: _locationController.text,
                            latitude: null,
                            longitude: null,
                            event_date: _selectedDate!,
                            event_id: _eventCode,
                          );
                          BlocProvider.of<CreateEventBloc>(
                            context,
                          ).add(CreateEvent(newEvent));
                        },
                        icon: AnimatedLogo(
                          rotate: state is LoadingState,
                          iconSize: 20,
                          color: Colors.black,
                          duration: Duration(seconds: 1),
                        ),
                        label: const Text(
                          'Create Event',
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
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
                Flexible(flex: 6, child: _pageView()),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 25,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                if (_pageController.page == 1) {
                  _pageController.previousPage(
                    duration: Durations.medium4,
                    curve: Curves.easeInOut,
                  );
                } else {
                  GoRouter.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
