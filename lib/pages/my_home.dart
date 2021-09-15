import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../widgets/button_full_width.dart';
import '../widgets/my_appbar.dart';

class MyHome extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyAppBar(
              "Le Barbu",
              isHome: true,
            ),
            ElevatedButtonFullWidth(
              text: "Démarrer une partie",
              onPressed: () => Get.toNamed(Routes.CREATE_PARTY),
            ),
            ElevatedButtonFullWidth(
              text: "Charger une partie",
              onPressed: () => Get.toNamed(Routes.CREATE_PARTY),
            ),
            ElevatedButton(
              child: Text("Règles du jeu"),
              onPressed: () => print("rules"),
            ),
            IconButton(
              onPressed: null,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.settings,
                color: Get.theme.colorScheme.onSurface,
                size: Get.width * 0.15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
