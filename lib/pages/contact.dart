import 'package:flutter/material.dart';
import 'package:portfolio/resources/strings.dart';
import 'package:portfolio/viewmodels/contact-viewmodel.dart';
import 'package:provider/provider.dart';

class Contact extends StatelessWidget {
  final double fontSize = 30;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => ContactViewModel(),
      child: Consumer<ContactViewModel>(
        builder: (context, model, child) => FutureBuilder(
          future: model.loaddata(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return model.profile != null
                ? Container(
                    height: MediaQuery.of(context).size.height * .5,
                    child: Center(
                      child: Table(
                        columnWidths: {
                          0: FractionColumnWidth(.4),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: (width * .09),
                                      backgroundColor: Colors.black,
                                      backgroundImage: AssetImage('assets/profile_pic.jpeg'),
                                      //child: Image.asset('assets/profile_pic.jpeg'),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${model.profile!["name"]} - ${model.profile!["location"]}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  // Text(
                                  //   model.profile!["location"],
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  Text(
                                    "${model.profile!['currentjob']['organization']} - ${model.profile!['currentjob']['position']}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  // Text(
                                  //   model.profile!['location'],
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Contacts : ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: (model.profile!['contatnumber'] as List<dynamic>)
                                            .map(
                                              (m) => Text(
                                                "$m",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontSize,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Emails : ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: (model.profile!['email'] as List<dynamic>)
                                            .map(
                                              (m) => Text(
                                                "$m",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontSize,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "No data available",
                    ),
                  );
          },
        ),
      ),
    );
  }
}
