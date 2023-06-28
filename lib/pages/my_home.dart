import 'package:barbu_score/controller/party.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:barbu_score/utils/screen.dart';
import 'package:barbu_score/utils/snackbar.dart';
import 'package:barbu_score/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock/wakelock.dart';

import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/my_appbar.dart';

class MyHome extends StatelessWidget {
  /// Loads a previous party and resumes it
  _loadParty(PartyController previousParty) {
    Get.deleteAll();
    Get.put(previousParty);
    Get.toNamed(Routes.PREPARE_GAME);
  }

  /// Starts a new party
  _startParty(BuildContext context) {
    context.go(Routes.CREATE_GAME);
  }

  /// Builds the widgets to load a saved party
  _confirmLoadParty(BuildContext context) {
    PartyController? previousParty;
    try {
      previousParty = MyStorage().getStoredParty();
    } catch (_) {}

    if (previousParty == null) {
      SnackbarUtils.instance.openSnackBar(
        context: context,
        title: "Aucune partie trouvée",
        text:
            "La partie précédente n'a pas été retrouvée. Lancement d'une nouvelle partie.",
      );
      _startParty(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return AlertDialog(
              title: Text("Charger une partie"),
              content: Text(
                  "Reprendre la partie précédente avec ${previousParty!.playerNames} ?"),
              actions: [
                ElevatedButtonCustomColor(
                    color: Theme.of(context).colorScheme.error,
                    textSize: 16,
                    text: "Non, nouvelle partie",
                    onPressed: () => _startParty(context)),
                ElevatedButtonCustomColor(
                  color: Theme.of(context).colorScheme.successColor,
                  textSize: 16,
                  text: "Oui",
                  onPressed: () => _loadParty(previousParty!),
                ),
              ],
            );
          });
    }
  }

  /// Builds the widgets to start a new party
  _confirmStartParty(BuildContext context) {
    try {
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
                    color: Theme.of(context).colorScheme.error,
                    textSize: 16,
                    text: "Non, reprendre la partie",
                    onPressed: () => _loadParty(previousParty),
                  ),
                  ElevatedButtonCustomColor(
                    color: Theme.of(context).colorScheme.successColor,
                    textSize: 16,
                    text: "Oui",
                    onPressed: () => _startParty(context),
                  ),
                ],
              );
            });
      } else {
        _startParty(context);
      }
    } catch (_) {
      _startParty(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.disable();
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
              context,
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
              onPressed: () => context.push(Routes.RULES),
            ),
            IconButton(
              onPressed: () => SnackbarUtils.instance.openSnackBar(
                  context: context,
                  title: "Patience...",
                  text: "Cette page arrivera dans une future version."),
              iconSize: ScreenHelper.width * 0.15,
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              style: IconButton.styleFrom(side: BorderSide.none),
            ),
          ],
        ),
      ),
    );
  }
}
