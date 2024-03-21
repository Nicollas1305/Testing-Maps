import 'package:utm/utm.dart';

void main() {
  // Coordenadas de latitude e longitude
  double latitude = -10.205758;
  double longitude = -48.36501;

  // Convertendo para UTM
  var utmCoords = UTM.fromLatLon(lat: latitude, lon: longitude);

  // Exibindo as coordenadas UTM
  print(
      'Easting: ${utmCoords.easting}, Northing: ${utmCoords.northing}, Zone: ${utmCoords.zone}');
}