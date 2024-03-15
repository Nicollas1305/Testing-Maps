import 'package:flutter/material.dart';

class FloatingVerticalCard extends StatefulWidget {
  @override
  _FloatingVerticalCardState createState() => _FloatingVerticalCardState();
}

class _FloatingVerticalCardState extends State<FloatingVerticalCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.height * 0.15,
        width: _expanded
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.18,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: _expanded
                  ? const Icon(Icons.arrow_back_ios_new)
                  : const Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Indivíduos",
                    maxLines: 1, // Limita o número de linhas do texto a 1
                    overflow: TextOverflow
                        .ellipsis, // Adiciona reticências caso o texto seja muito longo
                  ),
                ),
              ],
            ),
            _buildIconButton(Icons.location_on, 'Parcelas', () {
              print('Parcelas');
            }),
            _buildIconButton(Icons.location_off, 'Outros', () {
              print('Outros');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String title, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 1, // Limita o número de linhas do texto a 1
              overflow: TextOverflow
                  .ellipsis, // Adiciona reticências caso o texto seja muito longo
            ),
          ),
        ],
      ),
    );
  }
}
