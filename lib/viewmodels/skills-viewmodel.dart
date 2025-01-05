import 'package:portfolio/viewmodels/base-viewmodel.dart';

class SkillsViewModel extends BaseModel {
  final double focusedsize = 100;
  final double unfocusedsize = 30;
  late List<Map<String, dynamic>> skillslist;
  late String selectedskill;
  late String techpic;
  final double focusedopacity = 1;
  final double unfocusedopacity = .5;

  SkillsViewModel() {
    selectedskill = "Flutter";
    techpic = "assets/$selectedskill.png";
    skillslist = [
      {
        "title": "Flutter",
        "fontsize": focusedsize,
        "opacity": focusedopacity,
        "skills": [
          "State Managements (Bloc, GetX, Provider)",
          "Databases (Drft, sqlite)",
          "Firebase integration",
          "FCM Push notifications",
          "CICD (Azure, Bitrise, Codemagic)",
          "Unity Integration",
          "IOT projects(Bluetooth, wifi)",
          "Foreign Function Interface (FFI) integration",
        ],
      },
      {
        "title": "Xamarin",
        "fontsize": unfocusedsize,
        "opacity": unfocusedopacity,
        "skills": [
          "Custom renderers.",
          "Styles & behaviors.",
          "Native Android & iOS features.",
          "Styles & behaviors.",
          "Reusable components.",
          "Knowledge of cross-platform structure.",
          "Experience with JSON, XAML/XML, and Web Services.",
          "State management",
        ],
      },
      {
        "title": "DOT_Net_Core",
        "fontsize": unfocusedsize,
        "opacity": unfocusedopacity,
        "skills": [
          "API Development",
          "Dependency Injection",
          "Entity Framework Core (EF Core)",
          "Custom Middleware & Error Handling and Logging",
          "JWT Authentication and Authorization",
        ],
      },
    ];
  }

  void setFontSize(int index, double fontsize) {
    for (var item in skillslist) {
      item["fontsize"] = unfocusedsize;
      item["opacity"] = unfocusedopacity;
    }
    skillslist[index]["fontsize"] = fontsize;
    selectedskill = skillslist[index]["title"];
    techpic = "assets/$selectedskill.png";
    skillslist[index]["opacity"] = focusedopacity;
    notifyListeners();
  }
}
