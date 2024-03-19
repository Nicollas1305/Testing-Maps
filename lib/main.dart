import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_maps/providers/marker.dart';
import 'package:testing_maps/views/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MarkerState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing maps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
