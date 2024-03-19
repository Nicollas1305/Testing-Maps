import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testing_maps/models/marker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_maps/models/kml_exporter.dart';

class MarkerState extends ChangeNotifier {
  List<MarkerModel> _markers = [];

  List<MarkerModel> get markers => _markers;

  void addMarker(MarkerModel marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void removeMarker(String name) {
    _markers.removeWhere((marker) => marker.nome == name);
    notifyListeners();
  }

  Future<void> exportMarkersAsKML(BuildContext context) async {
    final kmlBuilder = KMLBuilder();
    _markers.forEach((marker) {
      kmlBuilder.addPlacemark(
        marker.nome,
        marker.localizacao.latitude,
        marker.localizacao.longitude,
      );
    });

    final xmlDoc = kmlBuilder.build();
    final kmlString = xmlDoc.toXmlString(pretty: true);

    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final file = File('${directory!.path}/markers.kml');
    print(file);
    print(_markers[0].nome);
    print(_markers[0].cor);
    print(_markers[0].localizacao);
    await file.writeAsString(kmlString);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo KML exportado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
