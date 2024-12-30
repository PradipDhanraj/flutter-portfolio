import 'package:flutter/material.dart';
import 'package:portfolio/templates/app_header.dart';
import 'package:portfolio/viewmodels/startpage-viewmodel.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StartPageViewModel(),
      child: Consumer<StartPageViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header menu option
                DarkHeader(model),
                // bio Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: model.displaycontainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
