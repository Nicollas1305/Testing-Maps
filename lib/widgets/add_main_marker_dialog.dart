import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMainMarkerDialog extends StatelessWidget {
  final LatLng userLocation;
  final LatLng fixedMarkerLocation;
  final Function(String, String, LatLng) adicionarMarcador;

  const AddMainMarkerDialog({
    Key? key,
    required this.userLocation,
    required this.fixedMarkerLocation,
    required this.adicionarMarcador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Center(
        child: Text(
          "Em qual posição deseja salvar a localização?",
          textAlign: TextAlign.center, // Centralizando o texto
          style: TextStyle(fontSize: 16),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: rever a identificação do marcador.
                    const String nome = 'identificaçãoMarcadorPrincipal';
                    const String cor = 'Verde';
                    final LatLng localizacao =
                        LatLng(userLocation.latitude, userLocation.longitude);
                    adicionarMarcador(nome, cor, localizacao);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    minimumSize: const Size(
                        140, 60), // Padronizando o tamanho dos botões
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Center(
                    child: Wrap(
                      alignment: WrapAlignment.center, // Centralizando o texto
                      children: [
                        Text(
                          "Atual",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4), // Espaço entre as linhas de texto
                        Text(
                          "(GPS)",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    const String nome = 'identificaçãoMarcadorPrincipal';
                    const String cor = 'Verde';
                    final LatLng localizacao = fixedMarkerLocation;
                    adicionarMarcador(nome, cor, localizacao);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.black,
                    minimumSize:
                        Size(140, 60), // Padronizando o tamanho dos botões
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Center(
                    child: Wrap(
                      alignment: WrapAlignment.center, // Centralizando o texto
                      children: [
                        Text(
                          "Centro da tela",
                          style: TextStyle(fontSize: 16),
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
    );
  }
}
