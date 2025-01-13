import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/viewmodels/startpage-viewmodel.dart';

class GameSection extends StatefulWidget {
  final StartPageViewModel model;
  const GameSection(this.model, {super.key});

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var isSmallScreen = constraints.maxWidth < 600;
        var size = MediaQuery.of(context).size;
        return SizedBox(
          height: size.height * .8,
          width: size.width,
          child: isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Image(
                        image: AssetImage('assets/game.png'),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            Strings.gameDescription,
                            style: TextStyle(color: Colors.white, fontSize: size.width * .05),
                          ),
                          InkWell(
                            onTap: () {
                              onTapFunction(isSmallScreen, context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Strings.playNowText,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: size.width * .05,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.games_outlined,
                                  color: Colors.orange,
                                  size: size.width * .05,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Image(
                        image: AssetImage('assets/game.png'),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            Strings.gameDescription,
                            style: TextStyle(color: Colors.white, fontSize: size.width * .022),
                          ),
                          InkWell(
                            onTap: () => onTapFunction(isSmallScreen, context),
                            child: Row(
                              children: [
                                Text(
                                  Strings.playNowText,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: size.width * .022,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.games_outlined,
                                  color: Colors.orange,
                                  size: size.width * .022,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }

  void onTapFunction(bool isSmallScreen, BuildContext context) {
    if (!isSmallScreen) {
      widget.model.launchInBrowser(Strings.gameurl);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Notice"),
            content: Text(
                "Its offline multiplayer game needs keyboard to play with friend. Please open this link on large screen device attached with keyboard."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
