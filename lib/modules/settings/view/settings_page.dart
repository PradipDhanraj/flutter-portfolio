import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myevents/modules/developer/developer_page.dart';
import 'package:myevents/modules/settings/bloc/settings_bloc.dart';
import 'package:myevents/modules/splashscreen/splashscreen.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:myevents/utility/widgets/animated_logo.dart';

class SettingsPage extends StatefulWidget {
  static const String path = '/settings';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SettingsBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onTap: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // SwitchListTile(
                    //   activeTrackColor: Colors.white,
                    //   activeColor: Colors.black,
                    //   inactiveThumbColor: Colors.black,
                    //   inactiveTrackColor: Colors.white,
                    //   title: const Text(
                    //     'Dark Theme',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   value: _isDarkTheme,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _isDarkTheme = value;
                    //       // TODO: Implement theme change logic
                    //     });
                    //   },
                    // ),
                    BlocConsumer<SettingsBloc, SettingsState>(
                      buildWhen:
                          (previous, current) => current is SettingsInitial,
                      listener: (context, state) {},
                      builder: (context, state) {
                        return SwitchListTile(
                          activeTrackColor: Colors.white,
                          activeColor: Colors.black,
                          inactiveThumbColor: Colors.black,
                          inactiveTrackColor: Colors.white,
                          title: const Text(
                            'Notification Alerts',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: bloc.notificationsEnabled,
                          onChanged: (value) {
                            BlocProvider.of<SettingsBloc>(
                              context,
                            ).add(ChangeNotificationEvent());
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 10,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            if (bloc.isUsedLoggedIn) {
                              SnackbarUtils.showSnackBar('Logging out...');
                              await bloc.authService.signOut();
                              GoRouter.of(
                                context,
                              ).replace(SplashScreenPage.path);
                              SnackbarUtils.showSnackBar('logged out!');
                            } else {
                              SnackbarUtils.showSnackBar('Signing in...');
                              (User?, String) result =
                                  await BlocProvider.of<SettingsBloc>(
                                    context,
                                  ).authService.signInWithGoogle();
                              SnackbarUtils.showSnackBar('Signed in...');
                              GoRouter.of(context).pop(result.$1 != null);
                            }
                          } catch (e) {
                            GoRouter.of(context).pop(false);
                          }
                        },
                        icon: AnimatedLogo(
                          rotate: false,
                          iconSize: 20,
                          color: Colors.black,
                          duration: Duration(seconds: 1),
                        ),
                        label: Text(
                          bloc.isUsedLoggedIn ? 'Logout' : 'Log in',
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
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                  icon: Icon(
                    Icons.adb,
                    size: FontSizes.medium,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    GoRouter.of(context).push("${GoRouter.of(context).state.fullPath}${DeveloperPage.path}");
                  },
                  label: Text(
                    'Developer\'s Note',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: FontSizes.small,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
