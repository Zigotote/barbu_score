import 'package:barbu_score/controller/party.dart';
import 'package:barbu_score/utils/snackbar.dart';
import 'package:barbu_score/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/my_appbar.dart';

class MyHome extends GetView {
  /// Loads a previous party and resumes it
  _loadParty(PartyController previousParty) {
    Get.deleteAll();
    Get.put(previousParty);
    Get.toNamed(Routes.CHOOSE_CONTRACT);
  }

  /// Starts a new party
  _startParty() {
    Get.toNamed(Routes.CREATE_PARTY);
  }

  /// Builds the widgets to load a saved party
  _confirmLoadParty(BuildContext context) {
    PartyController? previousParty = MyStorage().getStoredParty();
    if (previousParty == null) {
      SnackbarUtils.openSnackbar(
        "Aucune partie trouvée",
        "La partie précédente n'a pas été retrouvée. Lancement d'une nouvelle partie.",
      );
      _startParty();
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
                    onPressed: _startParty),
                ElevatedButtonCustomColor(
                  color: Get.theme.highlightColor,
                  textSize: 16,
                  text: "Oui",
                  onPressed: () => _loadParty(previousParty),
                ),
              ],
            );
          });
    }
  }

  /// Builds the widgets to start a new party
  _confirmStartParty(BuildContext context) {
    PartyController? previousParty = MyStorage().getStoredParty();
    if (previousParty != null) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return AlertDialog(
              title: Text("Une partie sauvegardée existe"),
              content: Text(
                  "Confirmer la création d'une nouvelle partie ? Si oui, la partie précédente avec ${previousParty.playerNames} sera perdue."),
              actions: [
                ElevatedButtonCustomColor(
                  color: Get.theme.errorColor,
                  textSize: 16,
                  text: "Non, reprendre la partie",
                  onPressed: () => _loadParty(previousParty),
                ),
                ElevatedButtonCustomColor(
                  color: Get.theme.highlightColor,
                  textSize: 16,
                  text: "Oui",
                  onPressed: _startParty,
                ),
              ],
            );
          });
    } else {
      _startParty();
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
              hasLeading: false,
            ),
            ElevatedButtonFullWidth(
              child: Text("Démarrer une partie"),
              onPressed: () => _confirmStartParty(context),
            ),
            ElevatedButtonFullWidth(
              child: Text("Charger une partie"),
              onPressed: () => _confirmLoadParty(context),
            ),
            ElevatedButton(
              child: Text("Règles du jeu"),
              onPressed: () => Get.toNamed(Routes.RULES),
            ),
            IconButton(
              onPressed: () => Get.toNamed(Routes.SETTINGS),
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
