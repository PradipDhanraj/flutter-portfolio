import 'package:flutter/material.dart';
import 'package:portfolio/resources/colors.dart';
import 'package:portfolio/resources/enum.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/templates/app_header.dart';

class HomePage extends StatelessWidget {
  HomePage();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // bio Section
        SizedBox(
          height: size.height * .9,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontSize: 70,
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
                        fontSize: 25,
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     DarkHeader.navigateTo(PageSelection.Work);
                    //   },
                    //   child: Text(
                    //     "Learn more >>",
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       color: selectedColor,
                    //       fontSize: 15,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // CircleAvatar(
              //   maxRadius: 200,
              //   backgroundColor: Colors.black,
              //   // backgroundImage: NetworkImage(
              //   //   Strings.profileimg,
              //   // ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
