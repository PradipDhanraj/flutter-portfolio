import 'package:portfolio/viewmodels/base-viewmodel.dart';

class SkillsViewModel extends BaseModel {
  final double focusedsize = 100;
  final double unfocusedsize = 30;
  late List<Map<String, dynamic>> skillslist;
  late String selectedskill;
  late String techpic;
  final double focusedopacity = 1;
  final double unfocusedopacity = .5;
  double _scale = 1;
  SkillsViewModel(double scale) {
    _scale = scale;
    selectedskill = "Flutter";
    techpic = "assets/$selectedskill.png";
    skillslist = [
      {
        "title": "Flutter",
        "fontsize": focusedsize * _scale,
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
        "fontsize": unfocusedsize * _scale,
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
        "fontsize": unfocusedsize * _scale,
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

  void setFontSize(int index, double fontsize, {double scale = 1}) {
    for (var item in skillslist) {
      item["fontsize"] = unfocusedsize * scale;
      item["opacity"] = unfocusedopacity;
    }
    skillslist[index]["fontsize"] = fontsize * scale;
    selectedskill = skillslist[index]["title"];
    techpic = "assets/$selectedskill.png";
    skillslist[index]["opacity"] = focusedopacity;
    notifyListeners();
  }
}
