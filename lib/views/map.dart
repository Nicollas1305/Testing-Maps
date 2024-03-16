import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_maps/models/kml_exporter.dart';
import 'package:testing_maps/models/marker.dart';
import 'package:testing_maps/widgets/add_marker_dialog.dart';
import 'package:testing_maps/widgets/add_main_marker_dialog.dart';
import 'package:testing_maps/widgets/floating_top_bar.dart';
import 'package:testing_maps/widgets/floating_vertical_card.dart';

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
  late GoogleMapController _mapController;
  LatLng _fixedMarkerPosition = const LatLng(0, 0);
  final List<MarkerModel> _markers = [];
  bool isAddingMarker = true;
  late CameraPosition _cameraPosition;
  late double _currentZoom = 18;
  double _mapRotationAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _mapType = MapType.satellite;
    _cameraPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 18,
      bearing: 0,
    );
  }

  void _adicionarMarcador(String nome, String cor, LatLng localizacao) {
    setState(() {
      _markers.add(MarkerModel(nome: nome, cor: cor, localizacao: localizacao));
    });
    print(_markers.length);
    setState(() {});
  }

  void _removerMarcador(String nome) {
    setState(() {
      _markers.removeWhere((marker) => marker.nome == nome);
    });
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo KML exportado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
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
            icon: Image.asset(
              'assets/images/bussola.png',
              width: 25,
              height: 25,
            ),
            onPressed: () {
              if (_mapController != null) {
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        _fixedMarkerPosition.latitude,
                        _fixedMarkerPosition.longitude,
                      ),
                      zoom: _currentZoom,
                      bearing: 0,
                    ),
                  ),
                );
              }
            },
          ),
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'Adicionar marcador') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddMarkerDialog(
                      userLocation: LatLng(
                        widget.latitude,
                        widget.longitude,
                      ),
                      fixedMarkerLocation: _fixedMarkerPosition,
                      adicionarMarcador: _adicionarMarcador,
                    );
                  },
                );
              } else if (value == 'Importar .KML') {
                // Lógica para importar .KML
              } else if (value == 'Exportar .KML') {
                _exportarArquivoKML(_markers);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Adicionar marcador',
                child: Text('Adicionar marcador'),
              ),
              const PopupMenuItem<String>(
                value: 'Importar .KML',
                child: Text('Importar .KML'),
              ),
              const PopupMenuItem<String>(
                value: 'Exportar .KML',
                child: Text('Exportar .KML'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            mapType: _mapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            onCameraMove: (CameraPosition position) {
              setState(() {
                _fixedMarkerPosition = position.target;
                _currentZoom = position.zoom;
                _mapRotationAngle = position.bearing * (3.14 / 180);
                print(_mapRotationAngle);
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _mapType == MapType.normal ? Colors.black : Colors.white,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.012,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
            child: FloatingTopBar(
              mapType: _mapType,
              rotationAngle: _mapRotationAngle,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.03,
            child: FloatingVerticalCard(
              mapType: _mapType,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isAddingMarker) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddMainMarkerDialog(
                  userLocation: LatLng(widget.latitude, widget.longitude),
                  fixedMarkerLocation: _fixedMarkerPosition,
                  adicionarMarcador: _adicionarMarcador,
                );
              },
            );
            isAddingMarker = false;
          } else {
            if (_markers.isNotEmpty) {
              isAddingMarker = true;
              _removerMarcador("identificaçãoMarcadorPrincipal");
            }
          }
        },
        backgroundColor: isAddingMarker ? Colors.green : Colors.red,
        child: Icon(
          isAddingMarker
              ? Icons.add_location_alt_outlined
              : Icons.rotate_left_sharp,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
