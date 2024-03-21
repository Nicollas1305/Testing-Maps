import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testing_maps/models/marker.dart';
import 'package:testing_maps/providers/marker_provider.dart';
import 'package:testing_maps/widgets/add_marker_dialog.dart';
import 'package:testing_maps/widgets/add_main_marker_dialog.dart';
import 'package:testing_maps/widgets/floating_top_bar.dart';
import 'package:testing_maps/widgets/floating_vertical_card.dart';

class MapScreen extends StatefulWidget {
  final void Function(MarkerModel) onMarkerAdded;

  const MapScreen({Key? key, required this.onMarkerAdded}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapType _mapType;
  late GoogleMapController _mapController;
  LatLng _fixedMarkerPosition = const LatLng(0, 0);
  bool isAddingMarker = true;
  CameraPosition? _cameraPosition;
  late double _currentZoom = 19;
  late final double _currentBearing = 0;
  late double _latitude = 0.0;
  late double _longitude = 0.0;
  double _mapRotationAngle = 0.0;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    _mapType = MapType.satellite;
  }

  Future<void> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    final position = await _geolocatorPlatform.getCurrentPosition();

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _cameraPosition = CameraPosition(
        target: LatLng(_latitude, _longitude),
        zoom: _currentZoom,
        bearing: _currentBearing,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final markerState = Provider.of<MarkerState>(context);

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
            icon: const Icon(Icons.gps_fixed),
            onPressed: () {
              if (_mapController != null) {
                print(_currentZoom);
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(_latitude, _longitude),
                      zoom: 19,
                    ),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'Adicionar marcador') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddMarkerDialog(
                      userLocation: LatLng(
                        _latitude,
                        _longitude,
                      ),
                      fixedMarkerLocation: _fixedMarkerPosition,
                      adicionarMarcador: (nome, cor, localizacao) {
                        final marker = MarkerModel(
                          name: nome,
                          type: 'Individuo',
                          coordinate: localizacao,
                        );
                        markerState.addMarker(marker);
                        print(markerState.markersList.length);
                        setState(() {
                          _fixedMarkerPosition = localizacao;
                        });
                      },
                    );
                  },
                );
              } else if (value == 'Importar .KML') {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                  //allowedExtensions: ['kml'],
                );

                if (result != null) {
                  File kmlFile = File(result.files.single.path!);
                  await markerState.importMarkersFromKML(context, kmlFile);
                } else {
                  // Usuário cancelou a seleção do arquivo
                }
              } else if (value == 'Exportar .KML') {
                markerState.exportMarkersAsKML(context);
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
      body: _latitude != 0 && _longitude != 0
          ? Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _cameraPosition ??
                      const CameraPosition(target: LatLng(0, 0)),
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
                      // TODO: adicionar outra forma de pegar atualização do zoom
                      _currentZoom = position.zoom;
                      print(_currentZoom);
                      _mapRotationAngle = position.bearing * (3.14 / 180);
                    });
                  },
                  markers: Set.from(
                    markerState.markersList.map(
                      (marker) {
                        return Marker(
                          markerId: MarkerId(marker.name),
                          position: marker.coordinate,
                        );
                      },
                    ),
                  ),
                  polylines: Set.from(
                    markerState.lineList.map(
                      (line) {
                        return Polyline(
                          polylineId: PolylineId(line.name),
                          points: line.coordinates,
                          color: Colors.blue,
                          width: 5,
                        );
                      },
                    ),
                  ),
                  polygons: Set.from(
                    markerState.polygonList.map(
                      (polygon) {
                        return Polygon(
                          polygonId: PolygonId(polygon.name),
                          points: polygon.coordinates,
                          fillColor: Colors.green.withOpacity(0.5),
                          strokeColor: Colors.green,
                          strokeWidth: 2,
                        );
                      },
                    ),
                  ),
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
                      color: _mapType == MapType.normal
                          ? Colors.black
                          : Colors.white,
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
                    zoom: _currentZoom,
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
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isAddingMarker) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddMainMarkerDialog(
                  userLocation: LatLng(_latitude, _longitude),
                  fixedMarkerLocation: _fixedMarkerPosition,
                  adicionarMarcador: (nome, cor, localizacao) {
                    final marker = MarkerModel(
                      name: nome,
                      type: 'Parcela',
                      coordinate: localizacao,
                    );
                    markerState.addMarker(marker);
                    setState(() {
                      _fixedMarkerPosition = localizacao;
                    });
                  },
                );
              },
            );
            isAddingMarker = false;
          } else {
            if (markerState.markersList.isNotEmpty) {
              isAddingMarker = true;
              markerState.removeMarker(
                  markerState.markersList.first.name, 'Individuo');
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
