import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';
import 'package:ryde_navi_app/screens/dashboard/services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final AuthRepository authRepo = AuthRepository();
  Completer<GoogleMapController> googleMapController = Completer();
  LocationData? currentLocation;
  Set<Marker> markers = {};
  AppLocationService appLocationService = AppLocationService();

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 13,
  );

  @override
  void initState() {
    mapSetup();
    super.initState();
  }

  mapSetup() {
    appLocationService.checkService().then(
          (value) => {
            if (value)
              {
                appLocationService.getLocation().then((location) {
                  currentLocation = location;

                  markerSetup(location);
                  setCameraPosition(location);
                  setState(() {});
                })
              }
          },
        );
  }

  markerSetup(location) async {
    markers.add(
      Marker(
        markerId: const MarkerId("current"),
        position: LatLng(location.latitude, location.longitude),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(15, 15),
          ),
          "assets/images/marker.png",
        ),
      ),
    );
  }

  setCameraPosition(location) async {
    GoogleMapController controller = await googleMapController.future;

    if (currentLocation != null) {
      LatLng newPosition = LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPosition,
            zoom: 16,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        googleMapController.complete(controller);
      },
      initialCameraPosition: initialCameraPosition,
      markers: markers,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
    );
  }
}
