import 'package:flutter/material.dart';
import 'package:portfolio/resources/enum.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/resources/route_paths.dart' as route;
import 'package:portfolio/viewmodels/startpage-viewmodel.dart';

class DarkHeader extends StatelessWidget {
  final model;
  static late DarkHeader _instance;
  DarkHeader(this.model) {
    _instance = this;
  }
  Widget divider() => Transform.scale(
        scale: 1.5,
        child: Text(
          "|",
          style: TextStyle(color: Colors.white),
        ),
      );
  Widget getText(Color textcolor, String text, StartPageViewModel model, PageSelection page) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(
            color: textcolor,
          ),
        ),
      ),
      onTap: () => model.pageSelection(page),
    );
  }

  static navigateTo(PageSelection page) {
    _instance.model.pageSelection(page);
  }

  Widget getLinkText(
    String text,
    String url,
    StartPageViewModel model,
  ) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onTap: () => model.launchInBrowser(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          divider(),
          getText(
            model.home,
            route.HomeRoute,
            model,
            PageSelection.Home,
          ),
          getText(
            model.skills,
            route.SkillsRoute,
            model,
            PageSelection.Skills,
          ),
          getText(
            model.work,
            route.WorkRoute,
            model,
            PageSelection.Work,
          ),
          divider(),
          getLinkText(
            "LinkedIn",
            Strings.linkedinurl,
            model,
          ),
          getLinkText(
            "Github",
            Strings.githuburl,
            model,
          ),
          divider(),
          Spacer(),
          getText(
            model.contact,
            route.ContactRoute,
            model,
            PageSelection.Contact,
          ),
        ],
      ),
    );
  }
}
