import 'package:flutter/material.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/viewmodels/skills-viewmodel.dart';
import 'package:provider/provider.dart';

class Skills extends StatelessWidget {
  double scale = 1;
  Widget getList(SkillsViewModel model) {
    var item = model.skillslist.firstWhere((element) => element["title"] == model.selectedskill)["skills"];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: item.length,
      itemBuilder: (context, i) {
        return Text(
          "- ${item[i]}",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25 * scale,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    scale = size.height > size.width ? 0.6 : 1;
    return SizedBox(
      height: size.height * .7,
      child: ChangeNotifierProvider(
        create: (context) => SkillsViewModel(scale),
        child: Consumer<SkillsViewModel>(
          builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.techStack,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50 * scale,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Table(
                  columnWidths: {
                    0: FractionColumnWidth(.4),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              model.techpic,
                              height: 200 * scale,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.skillslist.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  child: Opacity(
                                    opacity: model.skillslist[i]["opacity"],
                                    child: Text(
                                      model.skillslist[i]["title"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: model.skillslist[i]["fontsize"] * scale,
                                      ),
                                    ),
                                  ),
                                  onTap: () => model.setFontSize(i, model.focusedsize, scale: scale),
                                );
                              },
                            ),
                          ],
                        ),
                        getList(model),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
