import 'dart:async';
import 'dart:convert';

import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ryde_navi_app/screens/dashboard/model/destination_model.dart';
import 'package:ryde_navi_app/screens/dashboard/model/place_suggestion.dart';

class AppLocationService {
  final String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];
  final Location location = Location();
  LocationData? locationData;

  LocationData? get myLocation => locationData;
  StreamController<LocationData> locationStreamController =
      StreamController<LocationData>.broadcast();
  late StreamSubscription<LocationData> locationSubscription;

  Stream<LocationData> get locationStream => locationStreamController.stream;

  onChange() {
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 3000,
      distanceFilter: 200,
    );
    return location.onLocationChanged;
  }

  locationChange() {
    locationSubscription = location.onLocationChanged.listen(
      (LocationData currentLocation) {
        locationStreamController.add(currentLocation);
      },
    );
  }

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

  Future<List<PlaceSuggestionModel>> searchLocation({String query = ''}) async {
    final Completer<List<PlaceSuggestionModel>> completer =
        Completer<List<PlaceSuggestionModel>>();

    final currentLocation = await getLocation();

    // EasyDebounce.debounce(
    //   'search_place',
    //   const Duration(microseconds: 300),
    //   () async {
    //     print("asdasda");

    //   },
    // );

    final double? lat = currentLocation!.latitude;
    final double? lng = currentLocation.longitude;

    try {
      final Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/place/autocomplete/json",
        {
          'input': query,
          'location': '$lat,$lng',
          'components': 'country:PH',
          'key': googleApiKey,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<PlaceSuggestionModel> suggestions =
            (json.decode(response.body)['predictions'] as List)
                .map((data) => PlaceSuggestionModel.fromJson(data))
                .toList();
        completer.complete(suggestions);
      } else {
        completer.completeError(Exception(
            'Failed to load place suggestions: ${response.statusCode}'));
      }
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<DestinationModel?> destination(String placeId) async {
    final Uri uri = Uri.https(
      "maps.googleapis.com",
      "/maps/api/place/details/json",
      {'place_id': placeId, 'key': dotenv.env['GOOGLE_API_KEY']},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = json.decode(response.body)['result'];
      return DestinationModel.fromJson(result);
    }

    return null;
  }

  void close() {
    locationSubscription.cancel();
    locationStreamController.close();
  }
}
