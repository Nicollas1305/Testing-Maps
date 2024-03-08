import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testing_maps/utils/location_util.dart';
import 'package:testing_maps/views/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late String _previewImageUrl = '';
  late double _latitude = 0.0;
  late double _longitude = 0.0;

  Future<void> _getCurrentPosition() async {
    final position = await _geolocatorPlatform.getCurrentPosition();

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _previewImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: _latitude,
        longitude: _longitude,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MapScreen(
              latitude: _latitude,
              longitude: _longitude,
            ),
          ),
        );
      },
      child: Column(
        children: [
          if (_previewImageUrl.isNotEmpty)
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Image.network(
                _previewImageUrl,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(
            height: 12,
          ),
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
                            Text(_latitude.toString()),
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
                            Text(_longitude.toString()),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: _getCurrentPosition,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
