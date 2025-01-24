import 'package:download/download.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/pages/contact.dart';
import 'package:portfolio/pages/dashboard.dart';
import 'package:portfolio/pages/game-section.dart';
import 'package:portfolio/pages/skills.dart';
import 'package:portfolio/pages/work.dart';
import 'package:portfolio/resources/colors.dart';
import 'package:portfolio/resources/enum.dart';
import 'package:portfolio/viewmodels/base-viewmodel.dart';

class StartPageViewModel extends BaseModel {
  Color home = Colors.white;
  Color skills = Colors.white;
  Color work = Colors.white;
  Color contact = Colors.white;
  Color game = Colors.white;

  void _resetColors() {
    home = Colors.white;
    skills = Colors.white;
    work = Colors.white;
    contact = Colors.white;
  }

  void launchInBrowser(String url) => snippets.launchInBrowser(url);

  void downloadDoc(String url) async {
    // final directory = await getDownloadsDirectory();
    // await FileSaver.instance.saveAs(
    //   name: 'PRADIP_DHANRAJ_RESUME',
    //   ext: 'pdf',
    //   mimeType: MimeType.pdf,
    //   filePath: directory?.path,
    // );
    downloadUrl(url);
  }

  Future pageSelection(PageSelection page) async {
    switch (page) {
      case PageSelection.Home:
        _resetColors();
        home = selectedColor;
        displaycontainer = HomePage();
        break;
      case PageSelection.Skills:
        _resetColors();
        skills = selectedColor;
        displaycontainer = Skills();
        break;
      case PageSelection.Work:
        _resetColors();
        work = selectedColor;
        displaycontainer = Work();
        break;
      case PageSelection.Game:
        _resetColors();
        work = selectedColor;
        displaycontainer = GameSection(this);
        break;
      case PageSelection.Contact:
        _resetColors();
        contact = selectedColor;
        displaycontainer = Contact();
        break;
    }
    notifyListeners();
  }

  StartPageViewModel() {
    //displaycontainer = DarkDashboard();
    //displaycontainer = Skills();
    //displaycontainer = Work();
    displaycontainer = Contact();
  }
}
