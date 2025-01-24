import 'package:flutter/material.dart';
import 'package:portfolio/resources/enum.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/resources/route_paths.dart' as route;
import 'package:portfolio/templates/common-widgets.dart';
import 'package:portfolio/viewmodels/startpage-viewmodel.dart';

class Header extends StatelessWidget {
  final StartPageViewModel _model;
  static late Header _instance;
  final ScrollController _scrollController;
  final Duration _duration = Duration(seconds: 1);
  final Cubic _curve = Curves.easeInOut;

  Header(this._model, this._scrollController) {
    _instance = this;
  }

  static navigateTo(PageSelection page) {
    _instance._model.pageSelection(page);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        height: size.height,
        width: size.width - 100,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidget.textWidget(
              _model.home,
              route.HomeRoute,
              PageSelection.Home,
              () {
                scrollToFunc(size.height * 1);
              },
            ),
            CommonWidget.textWidget(
              _model.skills,
              route.SkillsRoute,
              PageSelection.Skills,
              () {
                scrollToFunc((size.height + (size.height * .9)));
              },
            ),
            CommonWidget.textWidget(
              _model.work,
              route.WorkRoute,
              PageSelection.Work,
              () {
                scrollToFunc((size.height + (size.height * .8) + (size.height * .7)));
              },
            ),
            CommonWidget.textWidget(
              _model.game,
              "GAME_WITH_FLAME_ENGINE",
              PageSelection.Game,
              () {
                scrollToFunc((size.height + (size.height * .8) + (size.height * .7) + (size.height * .8)));
              },
            ),
            CommonWidget.linkTextWidget(
              "LINKEDIN",
              () => _model.launchInBrowser(Strings.linkedinurl),
            ),
            CommonWidget.linkTextWidget(
              "GITHUB",
              () => _model.launchInBrowser(Strings.githuburl),
            ),
            CommonWidget.linkTextWidget(
              "RESUME",
              () => _model.downloadDoc("${Uri.base}/${Strings.resumeLink}"),
            ),
            CommonWidget.textWidget(
              _model.contact,
              route.ContactRoute,
              PageSelection.Contact,
              () {
                scrollToFunc((size.height + (size.height * .8) + (size.height * .7) + (size.height * .8) + (size.height * .4)));
              },
            ),
          ],
        ),
      ),
    );
  }

  void scrollToFunc(double offsetHeight) {
    _scrollController.animateTo(
      offsetHeight,
      duration: _duration,
      curve: _curve,
    );
  }
}
