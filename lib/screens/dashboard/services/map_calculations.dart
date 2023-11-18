import 'dart:math';

import 'package:latlong2/latlong.dart';

class MapCalculations {
  double calculateDistance(LatLng point1, LatLng point2) {
    const double radiusOfEarth = 6371.0; // Earth's radius in kilometers

    double lat1 = _degreesToRadians(point1.latitude);
    double lon1 = _degreesToRadians(point1.longitude);
    double lat2 = _degreesToRadians(point2.latitude);
    double lon2 = _degreesToRadians(point2.longitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarth * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double calculateZoomLevel(double distance, double screenWidth) {
    const double zoomFactor = 7.2;
    double zoomLevel = (log(screenWidth / distance) / log(2)) + zoomFactor;
    return zoomLevel;
  }
}
