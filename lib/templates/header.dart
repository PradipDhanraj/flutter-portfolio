import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/resources/snippets.dart';
import 'package:portfolio/resources/strings.dart';

class Header extends StatelessWidget {
  final Snippets snippets;
  Header({required this.snippets});
  Widget getCircularAvatar(String image, String url, Color outerbackgroundcolor,
      Color innerbackgroundcolor) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CircleAvatar(
        maxRadius: 20,
        backgroundColor: outerbackgroundcolor,
        child: GestureDetector(
          onTap: () {
            //launch url
            snippets?.launchInBrowser(url);
          },
          child: CircleAvatar(
            maxRadius: 15,
            backgroundImage: NetworkImage(
              image,
            ),
            backgroundColor: innerbackgroundcolor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: sushi,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("banner.jpg"), fit: BoxFit.cover)),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          AvatarGlow(
            glowBorderRadius: BorderRadius.all(Radius.circular(140.0)),
            child: Material(
              elevation: 8.0,
              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    maxRadius: 105,
                    backgroundColor: Colors.blueGrey,
                    child: CircleAvatar(
                      maxRadius: 100,
                      backgroundImage: NetworkImage(
                        Strings.profileimg,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                radius: 105.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getCircularAvatar(
                Strings.linkedinimg,
                Strings.linkedinurl,
                Colors.white,
                Colors.white,
              ),
              getCircularAvatar(
                Strings.githubimg,
                Strings.githuburl,
                Colors.white,
                Colors.white,
              ),
              getCircularAvatar(
                Strings.cvimg,
                Strings.githuburl,
                Colors.white,
                Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}
