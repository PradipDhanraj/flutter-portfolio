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

  late Map<String, dynamic> profile;

  Future<bool> loaddata() async {
    var jsonbody = await rootBundle.loadString('profile.json');
    profile = json.decode(jsonbody);
    notifyListeners();
    return profile != null;
  }
}
