import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_maps/models/marker.dart';
import 'package:testing_maps/models/kml_exporter.dart';
import 'package:xml/xml.dart';

class MarkerState extends ChangeNotifier {
  List<MarkerModel> markersList = [];
  List<PolygonModel> polygonList = [];
  List<LineModel> lineList = [];

  void addMarker(MarkerModel marker) {
    switch (marker.type) {
      case 'Individuo':
        markersList.add(marker);
        break;
      case 'Parcela':
        markersList.add(marker);
        break;
      default:
        throw Exception('Tipo de marcador inválido: ${marker.type}');
    }
    notifyListeners();
  }

  void addPolygon(PolygonModel polygon) {
    polygonList.add(polygon);
    notifyListeners();
  }

  void addLine(LineModel line) {
    lineList.add(line);
    notifyListeners();
  }

  void removeMarker(String name, String type) {
    switch (type) {
      case 'Individuo':
        markersList.removeWhere((marker) => marker.name == name);
        break;
      case 'Parcela':
        markersList.removeWhere((marker) => marker.name == name);
        break;
      default:
        throw Exception('Tipo de marcador inválido: $type');
    }
    notifyListeners();
  }

  Future<void> exportMarkersAsKML(BuildContext context) async {
    final kmlBuilder = KMLBuilder();
    markersList.forEach((marker) {
      switch (marker.type) {
        case 'Individuo':
          kmlBuilder.addPlacemark(
            marker.name,
            marker.coordinate.latitude,
            marker.coordinate.longitude,
          );
          break;
        case 'Parcela':
          kmlBuilder.addPlacemark(
            marker.name,
            marker.coordinate.latitude,
            marker.coordinate.longitude,
          );
          break;
        default:
          throw Exception('Tipo de marcador inválido: ${marker.type}');
      }
    });
    polygonList.forEach((polygon) {
      kmlBuilder.addPolygon(
        polygon.name,
        polygon.coordinates,
      );
    });
    lineList.forEach((line) {
      kmlBuilder.addLine(
        line.name,
        line.coordinates,
      );
    });

    final xmlDoc = kmlBuilder.build();
    final kmlString = xmlDoc.toXmlString(pretty: true);

    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final file = File('${directory!.path}/markers.kml');
    print(file);
    await file.writeAsString(kmlString);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo KML exportado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> importMarkersFromKML(BuildContext context, File kmlFile) async {
    final xmlDoc = XmlDocument.parse(await kmlFile.readAsString());

    xmlDoc.findAllElements('Placemark').forEach((element) {
      final String name = element.findElements('name').first.text;
      final String type = determineType(element);

      print(name);
      print(type);

      switch (type) {
        case 'Point':
          final coordinates = element
              .findElements('Point')
              .first
              .findElements('coordinates')
              .first
              .text
              .trim()
              .split(',');
          final double latitude = double.parse(coordinates[1]);
          final double longitude = double.parse(coordinates[0]);
          final marker = MarkerModel(
            name: name,
            type: 'Individuo',
            coordinate: LatLng(latitude, longitude),
          );
          addMarker(marker);
          break;
        case 'LineString':
          final coordinates = element
              .findElements('LineString')
              .first
              .findElements('coordinates')
              .first
              .text
              .trim()
              .split(' ');
          final List<LatLng> points = coordinates.map((coord) {
            final latLng = coord.split(',');
            final double latitude = double.parse(latLng[1]);
            final double longitude = double.parse(latLng[0]);
            return LatLng(latitude, longitude);
          }).toList();
          final line = LineModel(
            name: name,
            color: 'TODO',// TODO: Adicionar cor a linha
            coordinates: points,
          );
          addLine(line);
          break;
        case 'Polygon':
          final coordinates = element
              .findElements('Polygon')
              .first
              .findElements('outerBoundaryIs')
              .first
              .findElements('LinearRing')
              .first
              .findElements('coordinates')
              .first
              .text
              .trim()
              .split(' ');
          final List<LatLng> points = coordinates.map((coord) {
            final latLng = coord.split(',');
            final double latitude = double.parse(latLng[1]);
            final double longitude = double.parse(latLng[0]);
            return LatLng(latitude, longitude);
          }).toList();
          final polygon = PolygonModel(
            name: name,
            color: 'TODO', // TODO: Adicionar cor ao Polygon
            coordinates: points,
          );
          addPolygon(polygon);
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo KML importado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String determineType(XmlElement element) {
    if (element.findElements('Point').isNotEmpty) {
      return 'Point';
    } else if (element.findElements('LineString').isNotEmpty) {
      return 'LineString';
    } else if (element.findElements('Polygon').isNotEmpty) {
      return 'Polygon';
    }
    throw Exception('Tipo de elemento desconhecido.');
  }
}
