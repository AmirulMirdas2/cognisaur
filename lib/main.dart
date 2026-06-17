import 'package:flutter/material.dart';
import 'screens/halaman_opening.dart';

void main() {
  runApp(const CogniSaurApp());
}

class CogniSaurApp extends StatelessWidget {
  const CogniSaurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CogniSaur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'sans-serif'),
      home: const Opening1(),
    );
  }
}
