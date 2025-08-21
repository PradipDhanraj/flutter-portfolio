import 'package:flutter/material.dart';
import 'package:myevents/utility/shared_prefs/prefs_keys.dart';
import 'package:myevents/utility/shared_prefs/shared_prefs.dart';
import 'package:myevents/utility/utils/snackbar_utils.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO : Add Android/iOS project setting for permission handler
// https://pub.dev/packages/permission_handler

class PermissionsService {
  final SharedPrefs prefs;
  PermissionsService(this.prefs);

  Future<void> checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      debugPrint("Notification permission is granted");
      // Perform actions that require notification access
    } else if (status.isDenied) {
      debugPrint("Notification permission is denied");
      // Optionally, request permission
      requestNotificationPermission();
    } else if (status.isPermanentlyDenied) {
      debugPrint(
        "Notification permission is permanently denied. Open settings to enable.",
      );
      // Optionally, open app settings to allow user to enable permission
      openAppSettings();
    }
  }

  Future<bool> isNotificationPermissionGranted() async {
    PermissionStatus status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    await prefs.setBool(PrefsKeys.notificationEnabled, status.isGranted);
    if (status.isGranted) {
      debugPrint("Notification permission granted after request");
      // Perform actions that require notification access
      SnackbarUtils.showSnackBar('Notification permission granted!');
    } else {
      SnackbarUtils.showSnackBar('Notification permission denied!');
      debugPrint("Notification permission denied after request");
    }
  }
}
