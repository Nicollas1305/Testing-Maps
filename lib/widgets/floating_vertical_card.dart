import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FloatingVerticalCard extends StatefulWidget {
  final MapType mapType;

  const FloatingVerticalCard({Key? key, required this.mapType})
      : super(key: key);

  @override
  _FloatingVerticalCardState createState() => _FloatingVerticalCardState();
}

class _FloatingVerticalCardState extends State<FloatingVerticalCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    Color stateColor =
        widget.mapType == MapType.normal ? Colors.white : Colors.black;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: MediaQuery.of(context).size.height * 0.15,
      width: _expanded
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.18,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: widget.mapType == MapType.satellite
            ? Colors.white.withOpacity(0.70)
            : Colors.black.withOpacity(0.70),
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
                ? Icon(
                    Icons.keyboard_arrow_left,
                    color: stateColor,
                  )
                : Icon(
                    Icons.keyboard_arrow_right,
                    color: stateColor,
                  ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              print('Indivíduos');
            },
            child: Row(
              children: [
                const Icon(
                  Icons.location_off_outlined,
                  color: Colors.green,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Indivíduos',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: stateColor),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print('Parcelas');
            },
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.indigo[700]),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Parcelas',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: stateColor),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print('Outros');
            },
            child: Row(
              children: [
                Icon(Icons.location_off_outlined, color: stateColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Outros',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: stateColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
