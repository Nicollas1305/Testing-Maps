import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddHighlighterDialog extends StatefulWidget {
  final LatLng userLocation;
  final LatLng fixedMarkerLocation;
  final Function(String, String, LatLng) adicionarMarcador;

  const AddHighlighterDialog({
    Key? key,
    required this.userLocation,
    required this.fixedMarkerLocation,
    required this.adicionarMarcador,
  }) : super(key: key);

  @override
  _AddHighlighterDialogState createState() => _AddHighlighterDialogState();
}

class _AddHighlighterDialogState extends State<AddHighlighterDialog> {
  String _selectedColor = 'Verde';
  String _selectedPosition = 'Atual';
  final TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_location),
            Text("Incluir marcador", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nome',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Posição',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Atual',
                      groupValue: _selectedPosition,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPosition = value!;
                        });
                      },
                    ),
                    const Text('Atual'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Indicar na tela',
                      groupValue: _selectedPosition,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPosition = value!;
                        });
                      },
                    ),
                    const Text('Indicar na tela'),
                  ],
                )
              ],
            ),
            const Text(
              'Marcador',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              hint: const Text('Selecione uma cor'),
              value: _selectedColor,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedColor = newValue!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: 'Verde',
                  child: Row(
                    children: [
                      Icon(Icons.place, color: Colors.greenAccent),
                      SizedBox(width: 10),
                      Text('Verde'),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Laranja',
                  child: Row(
                    children: [
                      Icon(Icons.place, color: Colors.orange),
                      SizedBox(width: 10),
                      Text('Laranja'),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Azul',
                  child: Row(
                    children: [
                      Icon(Icons.place, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Azul'),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Vermelho',
                  child: Row(
                    children: [
                      Icon(Icons.place, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Vermelho'),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Amarelo',
                  child: Row(
                    children: [
                      Icon(Icons.place, color: Colors.yellow),
                      SizedBox(width: 10),
                      Text('Amarelo'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final String nome = _nomeController.text;
            final String selectedColor = _selectedColor;
            final String selectedPosition = _selectedPosition;
            final LatLng localizacao = selectedPosition == 'Atual'
                ? LatLng(
                    widget.userLocation.latitude, widget.userLocation.longitude)
                : widget.fixedMarkerLocation;

            widget.adicionarMarcador(nome, selectedColor, localizacao);

            // Fechar o diálogo
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
          ),
          child: const Text("Incluir", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}
