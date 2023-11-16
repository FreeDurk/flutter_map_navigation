import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';
import 'package:ryde_navi_app/screens/dashboard/model/destination_model.dart';
import 'package:ryde_navi_app/screens/dashboard/services/map_calculations.dart';
import 'package:ryde_navi_app/screens/dashboard/services/location_service.dart';

enum MarkerPosition { myPosition, destination }

class MapScreen extends StatefulWidget {
  final LocationData? currentLocation;
  final Stream<DestinationModel?> destinationStream;

  const MapScreen(
      {Key? key, this.currentLocation, required this.destinationStream})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final AuthRepository authRepo = AuthRepository();
  final AppLocationService appLocationService = AppLocationService();
  final MapCalculations calc = MapCalculations();

  late LatLng initialCenter;
  late final AnimatedMapController _animatedMapController =
      AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    curve: Curves.fastOutSlowIn,
  );

  final List<Marker> markers = [];
  final List<LatLng> polylines = [];
  late LocationData myPosition;
  late StreamSubscription<LocationData> locationStream;
  bool locationStreamActive = false;

  late StreamSubscription<DestinationModel?> destinationSubscription;
  late DestinationModel? destLocation;

  @override
  void initState() {
    super.initState();
    myPosition = widget.currentLocation!;
    destinationSubscription =
        widget.destinationStream.listen((DestinationModel? destination) {
      if (destination != null) {
        setState(() {
          destLocation = destination;
          getPolylines();
        });
      }
    });
    mapSetup();
  }

  @override
  void dispose() {
    super.dispose();
    _animatedMapController.dispose();
    destinationSubscription.cancel();
  }

  void mapSetup() async {
    initialCenter = LatLng(
      myPosition.latitude!,
      myPosition.longitude!,
    );
    setMarkers(
        initialCenter, const Key('currentPosition'), MarkerPosition.myPosition);
  }

  void setMarkers(LatLng current, Key? key, MarkerPosition markerPosition) {
    const double size = 70;
    String asset = markerPosition == MarkerPosition.myPosition
        ? "assets/images/currentLocation.png"
        : "assets/images/destination.png";

    if (markerPosition != MarkerPosition.destination) {
      markers.clear();
    }

    markers.add(
      Marker(
        point: current,
        child: Image.asset(
          asset,
          height: size,
          width: size,
        ),
      ),
    );
    setState(() {});
  }

  void startTracking() {
    Location location = Location();
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 0,
    );
    locationStream = location.onLocationChanged.listen((LocationData position) {
      LatLng coords = LatLng(position.latitude!, position.longitude!);
      setState(() {
        locationStreamActive = true;
        myPosition = position;
        updateMarkerPosition(coords, 'currentPosition');
      });
    });
  }

  void updateMarkerPosition(LatLng newPosition, String markerKey) {
    markers.removeWhere((marker) => marker.key == Key(markerKey));
    setMarkers(newPosition, Key(markerKey), MarkerPosition.myPosition);
  }

  void resetMap() {
    polylines.clear();
    if (locationStreamActive) {
      locationStream.cancel();
    }

    _animatedMapController.animateTo(
      dest: LatLng(myPosition.latitude!, myPosition.longitude!),
      zoom: 17.5,
      rotation: 0,
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> getPolylines() async {
    double screenWidth = MediaQuery.of(context).size.width;
    PolylinePoints polylinePoints = PolylinePoints();

    PointLatLng origin =
        PointLatLng(myPosition.latitude!, myPosition.longitude!);
    PointLatLng destination = PointLatLng(destLocation!.geometry.location.lat,
        destLocation!.geometry.location.lng);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['GOOGLE_API_KEY']!,
      origin,
      destination,
    );

    if (result.points.isNotEmpty) {
      polylines.clear();
      polylines.addAll(
        result.points.map(
            (PointLatLng latlng) => LatLng(latlng.latitude, latlng.longitude)),
      );
    }

    LatLngBounds bounds = LatLngBounds.fromPoints(polylines);
    LatLng dest = LatLng(destination.latitude, destination.longitude);

    double distance =
        calc.calculateDistance(bounds.northEast, bounds.southWest);
    double zoomLevel = calc.calculateZoomLevel(distance, screenWidth);

    _animatedMapController.animatedFitCamera(
      cameraFit: CameraFit.insideBounds(bounds: bounds, maxZoom: zoomLevel),
    );

    setMarkers(
      dest,
      const Key("destinationMarker"),
      MarkerPosition.destination,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        _buildMap(),
        _buildMapControlls(),
      ],
    );
  }

  FlutterMap _buildMap() {
    return FlutterMap(
      mapController: _animatedMapController.mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: 17.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(
          markers: markers,
          rotate: true,
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: polylines,
              color: Colors.blue,
              strokeWidth: 6.5,
            ),
          ],
        ),
      ],
    );
  }

  Column _buildMapControlls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: startTracking,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16.0),
          ),
          child: Image.asset(
            "assets/images/tracking.png",
            height: 30,
            width: 30,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
          onPressed: resetMap,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(14),
          ),
          child: Image.asset(
            "assets/images/reset.png",
            height: 30,
            width: 30,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
