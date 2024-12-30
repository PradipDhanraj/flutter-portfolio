import 'package:flutter/material.dart';
import 'package:portfolio/viewmodels/work-viewmodel.dart';
import 'package:provider/provider.dart';

class Work extends StatelessWidget {
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
            fontSize: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            item["description"],
            style: TextStyle(
              color: Colors.white,
            ),
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
                    onTap: () => {
                      if (e["url"] != "")
                        model.snippets.launchInBrowser(e["url"])
                    },
                    child: Image.asset(
                      "${e["os"]}.png",
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
    //var width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => WorkViewModel(),
      child: Consumer<WorkViewModel>(
        builder: (context, model, child) => FutureBuilder(
          future: model.loaddata(),
          builder: (context, snapshot) => snapshot.hasData
              ? Container(
                  height: height * .8,
                  child: Center(
                    child: Table(
                      columnWidths: {
                        0: FractionColumnWidth(.4),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.worklist.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                    child: Opacity(
                                      opacity: model.selectedindex == i
                                          ? model.focusedopacity
                                          : model.unfocusedopacity,
                                      child: Text(
                                        model.worklist[i]["title"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: model.selectedindex == i
                                              ? model.focusedsize
                                              : model.unfocusedsize,
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
