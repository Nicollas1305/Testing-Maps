import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testing_maps/utils/location_util.dart';

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
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.latitude, widget.longitude), // Posição inicial do mapa
          zoom: 18, // Zoom inicial
        ),
        onMapCreated: (controller) {
          // Alteração aqui
          setState(() {
            _mapController = controller;
          });
        },
        mapType: _mapType, // Visualização de satélite
        markers: {
          Marker(
            markerId: const MarkerId('userLocation'),
            position: LatLng(
                widget.latitude, widget.longitude), // Posição do marcador
            icon: BitmapDescriptor.defaultMarker, // Ícone do marcador (padrão)
          ),
        },
        myLocationButtonEnabled: false, // Desabilita o botão de GPS
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SpeedDial(
              icon: Icons.layers,
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
                          width: 2), // Adiciona a borda branca
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
                  backgroundColor:
                      Colors.transparent, // Cor de fundo transparente
                  foregroundColor: Colors.white,
                  label: 'Mapa',
                  labelStyle: TextStyle(fontSize: 18.0),
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
                          width: 2), // Adiciona a borda branca
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
                  backgroundColor:
                      Colors.transparent, // Cor de fundo transparente
                  foregroundColor: Colors.white,
                  label: 'Satélite',
                  labelStyle: TextStyle(fontSize: 18.0),
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
                    // Lógica para incluir ponto
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
