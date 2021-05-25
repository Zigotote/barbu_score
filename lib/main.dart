import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './pages/create_party.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
