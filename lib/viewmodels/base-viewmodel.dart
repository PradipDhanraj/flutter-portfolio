import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/resources/locator.dart';
import 'package:portfolio/resources/snippets.dart';
import 'package:portfolio/services/navigation-service.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;
  late String _errorMessage;
  late Widget displaycontainer;
  late double appheight;
  late double appwidth;

  final NavigationService navigationService = locator<NavigationService>();
  final Snippets snippets = locator<Snippets>();


  bool get busy => _busy;
  String get errorMessage => _errorMessage;
  bool get hasErrorMessage => _errorMessage != null && _errorMessage.isNotEmpty;

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
