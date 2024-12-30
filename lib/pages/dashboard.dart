import 'package:flutter/material.dart';
import 'package:portfolio/resources/colors.dart';
import 'package:portfolio/resources/enum.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/templates/app_header.dart';

class DarkDashboard extends StatelessWidget {
  DarkDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // bio Section
        Container(
          height: 400,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.bioLine1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        Strings.bioLine2,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        Strings.bioLine3,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          DarkHeader.navigateTo(PageSelection.Work);
                        },
                        child: Text(
                          "Learn more >>",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: selectedColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  maxRadius: 200,
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(
                    Strings.profileimg,
                  ),
                ),
              ],
            ),
          ),
        ),
        // what i do
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Strings.whatido,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
              InkWell(
                onTap: () {
                  DarkHeader.navigateTo(PageSelection.Skills);
                },
                child: Text(
                  Strings.learnmore,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: selectedColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
