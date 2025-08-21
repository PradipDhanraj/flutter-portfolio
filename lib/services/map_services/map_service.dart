import 'package:maps_launcher/maps_launcher.dart';

class MapService {
  // Method to open a map location
  void openMap(double latitude, double longitude) {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }
}
