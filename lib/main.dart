import 'package:flutter/material.dart';
import 'package:seven/ImageLabeling.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ML Kit Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageLabeling(),
    );
  }
}
