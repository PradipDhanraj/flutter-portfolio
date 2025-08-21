import 'package:flutter/material.dart';
import 'package:myevents/utility/constants/font_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatelessWidget {
  static String path = '/developer';
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated profile picture
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: Duration(seconds: 2),
                    curve: Curves.elasticOut,
                    builder:
                        (context, scale, child) => Transform.scale(
                          scale: scale,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              'https://avatars.githubusercontent.com/u/32770009?v=4',
                            ),
                          ),
                        ),
                  ),
                  SizedBox(height: 32),
                  // Animated bio text
                  AnimatedDefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                    duration: Duration(milliseconds: 800),
                    child: Text(
                      'Wanted to create an app with minimal resources, focusing on simplicity and efficiency. Enjoy the experience!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizes.medium,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                      duration: Duration(milliseconds: 800),
                      child: Text(
                        '- Pradip P. Dhanraj',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: FontSizes.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                      duration: Duration(milliseconds: 800),
                      child: Text(
                        '(House of Dhanraj)',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: FontSizes.small,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Animated underline
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(seconds: 2),
                    builder:
                        (context, value, child) => Container(
                          width: 200 * value,
                          height: 2,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 100,
              left: 20,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                ),
                icon: Icon(
                  Icons.link,
                  size: FontSizes.medium,
                  color: Colors.white,
                ),
                onPressed: () {
                  launchUrl(
                    Uri.parse("https://www.linkedin.com/in/pradip-dhanraj/"),
                  );
                },
                label: Text(
                  'Linkedin'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: FontSizes.small,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 20,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ),
                ),
                icon: Icon(
                  Icons.link,
                  size: FontSizes.medium,
                  color: Colors.white,
                ),
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                      "https://pradipdhanraj.github.io/flutter-portfolio/",
                    ),
                  );
                },
                label: Text(
                  'Portfolio'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: FontSizes.small,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
