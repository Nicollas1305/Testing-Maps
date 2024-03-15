import 'package:flutter/material.dart';

class FloatingTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.star_outline_rounded,
          ),
          Icon(
            Icons.insights_sharp,
          ),
          Icon(
            Icons.turn_right_outlined,
          ),
          Icon(
            Icons.navigation_sharp,
          ),
        ],
      ),
    );
  }
}
