import 'package:flutter/material.dart';
import 'package:portfolio/pages/contact.dart';
import 'package:portfolio/pages/dashboard.dart';
import 'package:portfolio/pages/skills.dart';
import 'package:portfolio/pages/work.dart';
import 'package:portfolio/templates/app_header.dart';
import 'package:portfolio/viewmodels/startpage-viewmodel.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StartPageViewModel(),
      child: Consumer<StartPageViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(50),
            child: ListView(
              controller: _scrollController,
              children: [
                Header(model, _scrollController),
                HomePage(),
                Skills(),
                Work(),
                Contact(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
