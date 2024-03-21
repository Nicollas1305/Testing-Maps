import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_maps/providers/marker_provider.dart';
import 'package:testing_maps/utils/location_util.dart';
import 'package:testing_maps/views/map.dart';
import 'package:utm/utm.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Future<String> _convertToUTM(double latitude, double longitude) async {
    var utmCoords = UTM.fromLatLon(lat: latitude, lon: longitude);
    return 'Easting: ${utmCoords.easting.toString()} \nNorthing: ${utmCoords.northing.toString()} \nZone: ${utmCoords.zone.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final markerState = Provider.of<MarkerState>(context);

    return Column(
      children: [
        if (markerState.markersList.isEmpty)
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            color: Colors.grey[400],
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MapScreen(
                      onMarkerAdded: (marker) {
                        markerState.addMarker(marker);
                      },
                    ),
                  ),
                );
              },
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Adicionar Marcador',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(
                      Icons.add_location_alt_outlined,
                      color: Colors.black,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
          ),
        if (markerState.markersList.isNotEmpty)
          Column(
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.network(
                  LocationUtil.generateLocationPreviewImage(
                    latitude: markerState.markersList.first.coordinate.latitude,
                    longitude:
                        markerState.markersList.first.coordinate.longitude,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Latitude'),
                                Text(
                                  markerState
                                      .markersList.first.coordinate.latitude
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1.0,
                          height: 50.0,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Longitude'),
                                Text(
                                  markerState
                                      .markersList.first.coordinate.longitude
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Novo Container com as coordenadas UTM convertidas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UTM'),
                  FutureBuilder(
                    future: _convertToUTM(
                        markerState.markersList.first.coordinate.latitude,
                        markerState.markersList.first.coordinate.longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Erro ao converter');
                      } else {
                        return Text(snapshot.data.toString());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
