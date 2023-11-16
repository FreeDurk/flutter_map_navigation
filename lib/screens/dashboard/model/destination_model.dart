import 'dart:convert';

class DestinationModel {
  Geometry geometry;

  DestinationModel({
    required this.geometry,
  });

  factory DestinationModel.fromRawJson(String str) =>
      DestinationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DestinationModel.fromJson(Map<String, dynamic> json) =>
      DestinationModel(
        geometry: Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry.toJson(),
      };
}

class Geometry {
  GeoLocation location;
  Viewport viewport;

  Geometry({
    required this.location,
    required this.viewport,
  });

  factory Geometry.fromRawJson(String str) =>
      Geometry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: GeoLocation.fromJson(json["location"]),
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "viewport": viewport.toJson(),
      };
}

class GeoLocation {
  double lat;
  double lng;

  GeoLocation({
    required this.lat,
    required this.lng,
  });

  factory GeoLocation.fromRawJson(String str) =>
      GeoLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  GeoLocation northeast;
  GeoLocation southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromRawJson(String str) =>
      Viewport.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: GeoLocation.fromJson(json["northeast"]),
        southwest: GeoLocation.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}
