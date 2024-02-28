import 'package:flutter/material.dart';
import 'package:testing_maps/widgets/location_input.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            LocationInput(),
          ],
        ),
      ),
    );
  }
}
