import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_maps/models/kml_exporter.dart';
import 'package:testing_maps/models/marker.dart';
import 'package:testing_maps/utils/location_util.dart';
import 'package:testing_maps/widgets/add_highlighter_dialog.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapType _mapType;
  late String _previewImageUrlSatellite = '';
  late String _previewImageUrlTerrain = '';
  late GoogleMapController _mapController;
  LatLng _fixedMarkerPosition = const LatLng(0, 0);
  List<MarkerModel> _markers = [];

  @override
  void initState() {
    super.initState();
    _mapType = MapType.satellite;
    _previewImageUrlSatellite =
        LocationUtil.generateLocationPreviewMapCircleSatellite(
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    _previewImageUrlTerrain =
        LocationUtil.generateLocationPreviewMapCircleTerrain(
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    print("latitude do widget: $widget.latitude");
    print("longitude do widget: $widget.longitude");
  }

  void _adicionarMarcador(String nome, String cor, LatLng localizacao) {
    setState(() {
      _markers.add(MarkerModel(nome: nome, cor: cor, localizacao: localizacao));
    });
    print(_markers.length);
    setState(() {});
  }

  // Método para construir marcadores no mapa
  List<Marker> _buildMarkers() {
    return _markers.map((marker) {
      return Marker(
        markerId: MarkerId(marker.nome),
        position: marker.localizacao,
        icon: BitmapDescriptor.defaultMarkerWithHue(_getColorHue(marker.cor)),
      );
    }).toList();
  }

  double _getColorHue(String color) {
    switch (color) {
      case 'Verde':
        return BitmapDescriptor.hueGreen;
      case 'Laranja':
        return BitmapDescriptor.hueOrange;
      case 'Azul':
        return BitmapDescriptor.hueBlue;
      case 'Vermelho':
        return BitmapDescriptor.hueRed;
      case 'Amarelo':
        return BitmapDescriptor.hueYellow;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void _exportarArquivoKML(List<MarkerModel> markers) async {
    final kmlBuilder = KMLBuilder();
    markers.forEach((marker) {
      kmlBuilder.addPlacemark(marker.nome, marker.localizacao.latitude,
          marker.localizacao.longitude);
    });

    final xmlDoc = kmlBuilder.build();
    final kmlString = xmlDoc.toXmlString(pretty: true);

    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final file = File('${directory!.path}/markers.kml');
    print(file);
    await file.writeAsString(kmlString);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Arquivo KML exportado com sucesso!'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Mapa"),
        actions: [
          IconButton(
            icon: _mapType == MapType.normal
                ? const Icon(Icons.layers_outlined)
                : const Icon(Icons.layers),
            onPressed: () {
              setState(() {
                _mapType = _mapType == MapType.normal
                    ? MapType.satellite
                    : MapType.normal;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.gps_fixed),
            onPressed: () {
              if (_mapController != null) {
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(widget.latitude, widget.longitude),
                      zoom: 18,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.latitude,
                widget.longitude,
              ),
              zoom: 18,
            ),
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            mapType: _mapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (latLng) {
              setState(() {
                _fixedMarkerPosition = latLng;
              });
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _fixedMarkerPosition = position.target;
              });
            },
            markers: Set.from(_buildMarkers()),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    kToolbarHeight) /
                2,
            left: (MediaQuery.of(context).size.width - 10) / 2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SpeedDial(
              icon: Icons.layers_outlined,
              //icon: Icons.layers,
              activeIcon: Icons.close,
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              curve: Curves.easeInOut,
              children: [
                SpeedDialChild(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        _previewImageUrlTerrain,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  label: 'Mapa',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () {
                    setState(() {
                      _mapType = MapType.normal;
                    });
                  },
                ),
                SpeedDialChild(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        _previewImageUrlSatellite,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  label: 'Satélite',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () {
                    setState(() {
                      _mapType = MapType.satellite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(width: 16),
            SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.white,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              curve: Curves.easeInOut,
              children: [
                SpeedDialChild(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.add_location_alt_outlined,
                        color: Colors.black),
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  label: 'Incluir ponto',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddHighlighterDialog(
                          userLocation: LatLng(
                            widget.latitude,
                            widget.longitude,
                          ),
                          fixedMarkerLocation: _fixedMarkerPosition,
                          adicionarMarcador: _adicionarMarcador,
                        );
                      },
                    );
                  },
                ),
                SpeedDialChild(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.mobile_screen_share_outlined,
                        color: Colors.black),
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  label: 'Importar Arquivo',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () {
                    // Lógica para importar arquivo
                  },
                ),
                SpeedDialChild(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.edit_document,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  label: 'Exportar Arquivo',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () {
                    _exportarArquivoKML(_markers);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
