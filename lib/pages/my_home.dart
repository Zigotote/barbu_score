import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';

import '../commons/models/game.dart';
import '../commons/models/player.dart';
import '../commons/notifiers/play_game.dart';
import '../commons/utils/screen.dart';
import '../commons/utils/snackbar.dart';
import '../commons/utils/storage.dart';
import '../commons/widgets/custom_buttons.dart';
import '../commons/widgets/my_appbar.dart';
import '../main.dart';
import '../theme/my_themes.dart';

class MyHome extends ConsumerWidget {
  const MyHome({super.key});

  /// Returns the players names separated by commas
  String _playerNames(List<Player> players) {
    return players.map((player) => player.name).join(", ");
  }

  /// Loads a previous game and resumes it
  _loadGame(BuildContext context, WidgetRef ref, Game game) {
    ref.read(playGameProvider).load(game);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushNamed(Routes.prepareGame);
  }

  /// Starts a new party
  _startGame(BuildContext context, WidgetRef ref) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushNamed(Routes.createGame);
  }

  /// Builds the widgets to load a saved game
  _confirmLoadGame(BuildContext context, WidgetRef ref) {
    Game? previousGame;
    try {
      previousGame = MyStorage().getStoredGame();
    } catch (_) {}

    if (previousGame == null) {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: "Aucune partie trouvée",
        text:
            "La partie précédente n'a pas été retrouvée. Lancement d'une nouvelle partie.",
      );
      _startGame(context, ref);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return AlertDialog(
              title: const Text("Charger une partie"),
              content: Text(
                  "Reprendre la partie précédente avec ${_playerNames(previousGame!.players)} ?"),
              actions: [
                ElevatedButtonCustomColor(
                  color: Theme.of(context).colorScheme.error,
                  textSize: 16,
                  text: "Non, nouvelle partie",
                  onPressed: () => _startGame(context, ref),
                ),
                ElevatedButtonCustomColor(
                  color: Theme.of(context).colorScheme.successColor,
                  textSize: 16,
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
    try {
      Game? previousGame = MyStorage().getStoredGame();
      if (previousGame != null) {
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return AlertDialog(
                title: const Text("Une partie sauvegardée existe"),
                content: Text(
                    "Confirmer la création d'une nouvelle partie ? Si oui, la partie précédente avec ${_playerNames(previousGame.players)} sera perdue."),
                actions: [
                  ElevatedButtonCustomColor(
                    color: Theme.of(context).colorScheme.error,
                    textSize: 16,
                    text: "Non, reprendre la partie",
                    onPressed: () => _loadGame(context, ref, previousGame),
                  ),
                  ElevatedButtonCustomColor(
                    color: Theme.of(context).colorScheme.successColor,
                    textSize: 16,
                    text: "Oui",
                    onPressed: () => _startGame(context, ref),
                  ),
                ],
              );
            });
      } else {
        _startGame(context, ref);
      }
    } catch (_) {
      _startGame(context, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Wakelock.disable();
    return WillPopScope(
      onWillPop: () async => false,
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
                context,
                "Le Barbu",
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
                onPressed: () {
                  if (kDebugMode) {
                    Navigator.of(context).pushNamed(Routes.settings);
                  } else {
                    SnackBarUtils.instance.openSnackBar(
                        context: context,
                        title: "Patience...",
                        text: "Cette page arrivera dans une future version.");
                  }
                },
                iconSize: ScreenHelper.width * 0.15,
                icon: const Icon(Icons.settings),
                style: IconButton.styleFrom(side: BorderSide.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
