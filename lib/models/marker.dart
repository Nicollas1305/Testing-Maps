import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String name;
  final String type;
  final LatLng coordinate;
  BitmapDescriptor? icon;
  final double iconSize;

  MarkerModel({
    required this.name,
    required this.type,
    required this.coordinate,
    required this.icon,
    this.iconSize = 48.0,
  });
}

class PolygonModel {
  final String name;
  final String description;
  final Color color;
  final int lineWidth;
  final double lineOpacity;
  final String areaType;
  final double areaOpacity;
  final List<LatLng> coordinates;

  PolygonModel({
    required this.name,
    required this.description,
    required this.color,
    required this.lineWidth,
    required this.lineOpacity,
    required this.areaType,
    required this.areaOpacity,
    required this.coordinates,
  });
}

class LineModel {
  final String name;
  final Color color;
  final int width;
  final double opacity;
  final List<LatLng> coordinates;

  LineModel({
    required this.name,
    required this.color,
    required this.width,
    required this.opacity,
    required this.coordinates,
  });
}
