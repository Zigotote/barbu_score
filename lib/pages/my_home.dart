import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../commons/models/game.dart';
import '../commons/models/player.dart';
import '../commons/notifiers/play_game.dart';
import '../commons/utils/snackbar.dart';
import '../commons/utils/storage.dart';
import '../commons/widgets/alert_dialog.dart';
import '../commons/widgets/custom_buttons.dart';
import '../commons/widgets/my_appbar.dart';
import '../main.dart';

class MyHome extends ConsumerWidget {
  const MyHome({super.key});

  /// Returns the players names separated by commas
  String _playerNames(List<Player> players) {
    return players.map((player) => player.name).join(", ");
  }

  /// Loads a previous game and resumes it
  _loadGame(BuildContext context, WidgetRef ref, Game game) {
    ref.read(playGameProvider).load(game);
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (game.isFinished) {
      Navigator.of(context).pushNamed(Routes.finishGame);
    } else {
      Navigator.of(context).pushNamed(Routes.prepareGame);
    }
  }

  /// Starts a new game
  _startGame(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushNamed(Routes.createGame);
  }

  bool _verifyHasActiveContracts(BuildContext context) {
    if (MyStorage.getActiveContracts().isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return MyAlertDialog(
              context: context,
              title: "Impossible de lancer une partie",
              content:
                  "Tous les contrats sont désactivés dans les paramètres. Il faut au moins un contrat activé pour pouvoir jouer.",
              actions: [
                AlertDialogActionButton(
                  text: "Modifier les paramètres",
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushNamed(Routes.settings);
                  },
                ),
              ],
            );
          });
      return false;
    }
    return true;
  }

  /// Builds the widgets to load a saved game
  _confirmLoadGame(BuildContext context, WidgetRef ref) {
    if (!_verifyHasActiveContracts(context)) {
      return;
    }
    Game? previousGame;
    try {
      previousGame = MyStorage.getStoredGame();
    } catch (_) {}

    if (previousGame == null) {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: "Aucune partie trouvée",
        text:
            "La partie précédente n'a pas été retrouvée. Lancement d'une nouvelle partie.",
      );
      _startGame(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return MyAlertDialog(
              context: context,
              title: "Charger une partie",
              content:
                  "${previousGame!.isFinished ? "Revoir" : "Reprendre"} la partie précédente avec ${_playerNames(previousGame.players)} ?",
              actions: [
                AlertDialogActionButton(
                  isDestructive: true,
                  text: "Non, nouvelle partie",
                  onPressed: () => _startGame(context),
                ),
                AlertDialogActionButton(
                  text: "Oui",
                  onPressed: () => _loadGame(context, ref, previousGame!),
                ),
              ],
            );
          });
    }
  }

  /// Builds the widgets to start a new game
  _confirmStartGame(BuildContext context, WidgetRef ref) {
    if (!_verifyHasActiveContracts(context)) {
      return;
    }
    try {
      Game? previousGame = MyStorage.getStoredGame();
      if (previousGame != null && !previousGame.isFinished) {
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return MyAlertDialog(
                context: context,
                title: "Une partie sauvegardée existe",
                content:
                    "Confirmer la création d'une nouvelle partie ? Si oui, la partie précédente avec ${_playerNames(previousGame.players)} sera perdue.",
                actions: [
                  AlertDialogActionButton(
                    text: "Non, reprendre la partie",
                    onPressed: () => _loadGame(context, ref, previousGame),
                  ),
                  AlertDialogActionButton(
                    isDestructive: true,
                    text: "Oui",
                    onPressed: () => _startGame(context),
                  ),
                ],
              );
            });
      } else {
        _startGame(context);
      }
    } catch (_) {
      _startGame(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WakelockPlus.disable();
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                "Le Barbu",
                context: context,
                isHome: true,
                hasLeading: false,
              ),
              ElevatedButtonFullWidth(
                child: const Text("Démarrer une partie"),
                onPressed: () => _confirmStartGame(context, ref),
              ),
              ElevatedButtonFullWidth(
                child: const Text("Charger une partie"),
                onPressed: () => _confirmLoadGame(context, ref),
              ),
              ElevatedButton(
                child: const Text("Règles du jeu"),
                onPressed: () => Navigator.of(context).pushNamed(Routes.rules),
              ),
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.settings),
                icon: const Icon(Icons.settings),
                style: IconButton.styleFrom(
                  side: BorderSide.none,
                  iconSize: 55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
