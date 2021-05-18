import './pages/create_party.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barbu Score',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Barbu scores"),
        ),
        body: CreateParty(),
      ),
    );
  }
}
