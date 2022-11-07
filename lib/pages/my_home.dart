import 'package:barbu_score/controller/party.dart';
import 'package:barbu_score/utils/snackbar.dart';
import 'package:barbu_score/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/my_appbar.dart';

class MyHome extends GetView {
  _confirmLoadParty(BuildContext context) {
    PartyController? previousParty = MyStorage().getStoredParty();
    if (previousParty == null) {
      SnackbarUtils.openSnackbar(
        "Aucune partie trouvée",
        "La partie précédente n'a pas été retrouvée. Lancement d'une nouvelle partie.",
      );
      Get.toNamed(Routes.CREATE_PARTY);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return AlertDialog(
              title: Text("Charger une partie"),
              content: Text(
                  "Reprendre la partie précédente avec ${previousParty.playerNames} ?"),
              actions: [
                ElevatedButtonCustomColor(
                  color: Get.theme.errorColor,
                  textSize: 16,
                  text: "Non, nouvelle partie",
                  onPressed: () => Get.toNamed(Routes.CREATE_PARTY),
                ),
                ElevatedButtonCustomColor(
                  color: Get.theme.highlightColor,
                  textSize: 16,
                  text: "Oui",
                  onPressed: () {
                    Get.deleteAll();
                    Get.put(previousParty);
                    Get.toNamed(Routes.CHOOSE_CONTRACT);
                  },
                ),
              ],
            );
          });
    }
  }

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
              child: Text("Démarrer une partie"),
              onPressed: () => Get.toNamed(Routes.CREATE_PARTY),
            ),
            ElevatedButtonFullWidth(
              child: Text("Charger une partie"),
              onPressed: () => _confirmLoadParty(context),
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
