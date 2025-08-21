import 'package:flutter/material.dart';
import 'package:myevents/utility/locator.dart';

class SnackbarUtils {
  SnackbarUtils._();
  static void showSnackBar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );
    ScaffoldMessenger.of(
      DI.navigatorKey.currentContext!,
    ).showSnackBar(snackBar);
  }
}
