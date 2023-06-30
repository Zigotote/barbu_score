import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock/wakelock.dart';

import '../commons/utils/screen.dart';
import '../commons/utils/snackbar.dart';
import '../commons/utils/storage.dart';
import '../commons/widgets/custom_buttons.dart';
import '../commons/widgets/my_appbar.dart';
import '../controller/party.dart';
import '../main.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  /// Loads a previous party and resumes it
  _loadParty(PartyController previousParty) {
    Get.deleteAll();
    Get.put(previousParty);
    Get.toNamed(Routes.prepareGame);
  }

  /// Starts a new party
  _startParty(BuildContext context) {
    context.go(Routes.createGame);
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
              title: const Text("Charger une partie"),
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
                title: const Text("Une partie sauvegardée existe"),
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
        decoration: const BoxDecoration(
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
              child: const Text("Démarrer une partie"),
              onPressed: () => _confirmStartParty(context),
            ),
            ElevatedButtonFullWidth(
              child: const Text("Charger une partie"),
              onPressed: () => _confirmLoadParty(context),
            ),
            ElevatedButton(
              child: const Text("Règles du jeu"),
              onPressed: () => context.push(Routes.rules),
            ),
            IconButton(
              onPressed: () => SnackbarUtils.instance.openSnackBar(
                  context: context,
                  title: "Patience...",
                  text: "Cette page arrivera dans une future version."),
              iconSize: ScreenHelper.width * 0.15,
              icon: const Icon(Icons.settings),
              style: IconButton.styleFrom(side: BorderSide.none),
            ),
          ],
        ),
      ),
    );
  }
}
