import 'package:flutter/material.dart';
import 'package:portfolio/resources/strings.dart';

class HomePage extends StatelessWidget {
  HomePage();
  double scale = 1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    scale = size.height > size.width ? size.width * .001 : 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // bio Section
        SizedBox(
          height: size.height,
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
                        fontSize: 70 * scale,
                      ),
                    ),
                    Text(
                      Strings.bioLine2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50 * scale,
                      ),
                    ),
                    Text(
                      Strings.bioLine3,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25 * scale,
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
