import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:portfolio/viewmodels/base-viewmodel.dart';

class ContactViewModel extends BaseModel {
  // Future logout({bool success = true}) async {
  //   setBusy(true);
  //   await Future.delayed(Duration(seconds: 1));

  //   if (!success) {
  //     setErrorMessage('Error has occured during sign out');
  //   } else {
  //     _navigationService.goBack();
  //   }
  // }

  Map<String, dynamic>? profile;

  Future<bool> loaddata() async {
    try {
      var jsonbody = await rootBundle.loadString('assets/profile.json');
      profile = json.decode(jsonbody);
      notifyListeners();
      return profile != null;
    } catch (e) {
      return false;
    }
  }
}
