import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String nome;
  final String cor;
  final LatLng localizacao;

  MarkerModel({
    required this.nome,
    required this.cor,
    required this.localizacao,
  });
}
