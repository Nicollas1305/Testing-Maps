import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String name;
  final String type;
  final LatLng coordinate;

  MarkerModel({
    required this.name,
    required this.type,
    required this.coordinate,
  });
}

class PolygonModel {
  final String name;
  final String color;
  final List<LatLng> coordinates;

  PolygonModel({
    required this.name,
    required this.color,
    required this.coordinates,
  });
}

class LineModel {
  final String name;
  final String color;
  final List<LatLng> coordinates;

  LineModel({
    required this.name,
    required this.color,
    required this.coordinates,
  });
}
