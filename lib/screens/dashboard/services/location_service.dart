import 'package:location/location.dart';

class AppLocationService {
  final Location location = Location();
  LocationData? locationData;

  LocationData? get myLocation => locationData;

  Future<bool> checkService() async {
    bool isLocationServiceEnabled;
    PermissionStatus permissionGranted;
    isLocationServiceEnabled = await location.serviceEnabled();

    if (!isLocationServiceEnabled) {
      isLocationServiceEnabled = await location.requestService();

      if (!isLocationServiceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<LocationData?> getLocation() async {
    return await location.getLocation();
  }
}
