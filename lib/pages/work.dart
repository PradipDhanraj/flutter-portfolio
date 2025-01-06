import 'package:flutter/material.dart';
import 'package:portfolio/pages/skills.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/viewmodels/work-viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:portfolio/resources/route_paths.dart' as route;

class Work extends StatelessWidget {
  double scale = 1;
  Widget getList(WorkViewModel model) {
    var item = model.worklist[model.selectedindex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item["projecttitle"],
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30 * scale,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            item["description"],
            style: TextStyle(color: Colors.white, fontSize: 22 * scale),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          child: Row(
            children: (item["platform"] as List<dynamic>)
                .map(
                  (e) => GestureDetector(
                    onTap: () => {if (e["url"] != "") model.snippets.launchInBrowser(e["url"])},
                    child: Image.asset(
                      "assets/${e["os"]}.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;
    scale = size.height > size.width ? 0.8 : 1;
    return ChangeNotifierProvider(
      create: (context) => WorkViewModel(),
      child: Consumer<WorkViewModel>(
        builder: (context, model, child) => FutureBuilder(
          future: model.loaddata(),
          builder: (context, snapshot) => snapshot.hasData
              ? SizedBox(
                  height: height * .7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        route.WorkRoute,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50 * scale,
                        ),
                      ),
                      Table(
                        columnWidths: {
                          0: FractionColumnWidth(.4),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: model.worklist.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                      child: Opacity(
                                        opacity: model.selectedindex == i ? model.focusedopacity : model.unfocusedopacity,
                                        child: Text(
                                          model.worklist[i]["title"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                (model.selectedindex == i ? model.focusedsize : model.unfocusedsize) * scale,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        model.selectedindex = i;
                                      }
                                      //model.setFontSize(i, model.focusedsize),
                                      );
                                },
                              ),
                              getList(model),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  height: height * .8,
                  child: Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
