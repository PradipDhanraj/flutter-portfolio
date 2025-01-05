import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:portfolio/viewmodels/base-viewmodel.dart';

class WorkViewModel extends BaseModel {
  final double focusedsize = 45;
  final double unfocusedsize = 30;
  late List<Map<String, dynamic>> worklist;
  //String selectedskill;
  //String brand;
  final double focusedopacity = 1;
  final double unfocusedopacity = .5;
  //final double selectedindex = 0;
  int _selectedindex = 0;
  int get selectedindex => _selectedindex;
  set selectedindex(int value) {
    _selectedindex = value;
    notifyListeners();
  }

  Future<bool> loaddata() async {
    var result = await getprojectlist();
    worklist = List.from(result);
    notifyListeners();
    return worklist != null;
  }

  Future<dynamic> getprojectlist() async {
    var jsonbody = await rootBundle.loadString('assets/work.json');
    return json.decode(jsonbody)["result"];
  }
}
