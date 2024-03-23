import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_maps/models/marker.dart';
import 'package:testing_maps/models/kml_exporter.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class MarkerState extends ChangeNotifier {
  List<MarkerModel> markersList = [];
  List<PolygonModel> polygonList = [];
  List<LineModel> lineList = [];
  final String customMarkerIconUrl =
      'https://upload.wikimedia.org/wikipedia/commons/6/6d/Map_pointer_green.svg';

  // TODO: Adicionar ícone via asset.
  Future<BitmapDescriptor> getCustomMarker() async {
    final ByteData byteData = await rootBundle.load('assets/images/logo.png');
    final Uint8List imageData = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(imageData);
  }

  // TODO: Adicionar ícone via URL.
  Future<BitmapDescriptor> getCustomMarkerFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final imageData = response.bodyBytes;
      return BitmapDescriptor.fromBytes(imageData);
    } else {
      throw Exception('Falha ao carregar o ícone: ${response.statusCode}');
    }
  }

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
    final icon = await getCustomMarkerFromUrl(customMarkerIconUrl);

    final iconUrl = 'http://maps.google.com/mapfiles/kml/shapes/campfire.png';

    await Future.forEach(markersList, (marker) {
      switch (marker.type) {
        case 'Individuo':
          print(marker.type);
          kmlBuilder.addPlacemarkWithIcon(
            marker.name,
            marker.coordinate.latitude,
            marker.coordinate.longitude,
            """Indivíduo ${marker.name}.<br>
              Nº da plaqueta: ---<br>
              Espécie: ---<br>
              CAP/DAP: XX,Xcm<br>
              Altura total: XX,Xm<br>
              Altura comercial: XX,Xm<br>
              Qualidade: ---<br>
              Sanidade: ---<br>
              Material botânico coletado? Sim/Não<br>
              Observação: ---<br>""",
            iconUrl,
          );
          break;
        case 'Parcela':
          print(marker.type);
          kmlBuilder.addPlacemarkWithIcon(
            marker.name,
            marker.coordinate.latitude,
            marker.coordinate.longitude,
            "Descrição da Parcela ${marker.name}.",
            iconUrl,
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
        polygon.color,
      );
    });
    lineList.forEach((line) {
      kmlBuilder.addLine(
        line.name,
        line.coordinates,
        line.color,
      );
    });

    final xmlDoc = kmlBuilder.build();
    final kmlString = xmlDoc.toXmlString(pretty: true);

    // TODO: atualizar diretorio download.
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final file = File('${directory!.path}/IFlorestal_Inventree.kml');
    print(file);
    await file.writeAsString(kmlString);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo KML exportado com sucesso!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> importMarkersFromKML(BuildContext context, File kmlFile) async {
    final xmlDoc = XmlDocument.parse(await kmlFile.readAsString());

    final Map<String, String> styleColors = {};

    xmlDoc.findAllElements('Style').forEach((styleElement) {
      final String styleId = styleElement.getAttribute('id')!;
      final String? color = styleElement
          .findElements('PolyStyle')
          .first
          .findElements('color')
          .firstOrNull
          ?.text;
      if (color != null) {
        styleColors[styleId] = color;
      }
    });

    xmlDoc.findAllElements('Placemark').forEach((element) async {
      final String name = element.findElements('name').first.text;
      final String type = determineType(element);
      final BitmapDescriptor logoIcon = await getCustomMarker();

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
            icon: logoIcon,
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
          final String styleUrl =
              element.findElements('styleUrl').first.text.substring(1);
          final String? color = styleColors[styleUrl];
          if (color != null) {
            final line = LineModel(
              name: name,
              color: color,
              coordinates: points,
            );
            addLine(line);
          }
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
          final String styleUrl =
              element.findElements('styleUrl').first.text.substring(1);
          final String? color = styleColors[styleUrl];
          if (color != null) {
            final polygon = PolygonModel(
              name: name,
              color: color,
              coordinates: points,
            );
            addPolygon(polygon);
          }
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
