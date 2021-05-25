import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './bindings/party.dart';
import './pages/choose_contract.dart';
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
      initialRoute: Routes.HOME,
      getPages: [
        GetPage(
          name: Routes.HOME,
          page: () => CreateParty(),
          binding: PartyBinding(),
        ),
        GetPage(
          name: Routes.CHOOSE_CONTRACT,
          page: () => ChooseContract(),
        ),
      ],
    );
  }
}

/// Names of the routes for the app
class Routes {
  static const HOME = "/";
  static const CHOOSE_CONTRACT = "/choose_contract";
}
