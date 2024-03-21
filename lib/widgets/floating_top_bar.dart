import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FloatingTopBar extends StatelessWidget {
  final MapType mapType;
  final double rotationAngle;
  final double zoom;

  const FloatingTopBar(
      {Key? key,
      required this.mapType,
      required this.rotationAngle,
      required this.zoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color stateColor = mapType == MapType.normal ? Colors.white : Colors.black;

    String calculateProportion(double zoom) {
      if (zoom <= 5) {
        return "1:50000";
      } else if (zoom <= 10) {
        return "1:25000";
      } else if (zoom <= 20) {
        return "1:10000";
      } else {
        return "1:1000";
      }
    }

    double calculateMapMeter(double zoom) {
      return 156543.03392 * cos(zoom * pi / 180) / pow(2, zoom);
    }

    double mapMeter = calculateMapMeter(zoom);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: mapType == MapType.satellite
            ? Colors.white.withOpacity(0.70)
            : Colors.black.withOpacity(0.70),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "${mapMeter.round()}m",
                    style: TextStyle(fontSize: 13, color: stateColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    calculateProportion(mapMeter!),
                    style: TextStyle(fontSize: 13, color: stateColor),
                  ),
                ],
              ),
              Icon(
                Icons.star_outline_rounded,
                color: stateColor,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: null,
                icon: Image.asset(
                  'assets/images/satellite.png',
                  width: 20,
                  height: 20,
                  color: stateColor,
                ),
              ),
              Text(
                '5/5',
                style: TextStyle(
                  color: stateColor,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Text(
            'Precisão: 2,10m',
            style: TextStyle(
              color: stateColor,
              fontSize: 15,
            ),
          ),
          Transform.rotate(
            angle: -rotationAngle, // Definindo o ângulo de rotação
            child: IconButton(
              onPressed: null,
              icon: Image.asset(
                'assets/images/cardinal-point.png',
                width: 30,
                height: 30,
                color: stateColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
