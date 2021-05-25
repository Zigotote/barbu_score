import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './bindings/party.dart';
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
      initialRoute: "/home",
      getPages: [
        GetPage(
          name: "/home",
          page: () => CreateParty(),
          binding: PartyBinding(),
        ),
      ],
    );
  }
}
