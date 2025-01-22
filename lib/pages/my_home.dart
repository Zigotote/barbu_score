import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../commons/models/game.dart';
import '../commons/models/player.dart';
import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/providers/storage.dart';
import '../commons/utils/snackbar.dart';
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
    final provider = ref.read(playGameProvider);
    provider.load(game);
    if (!game.isFinished) {
      provider.moveToFirstPlayerWithAvailableContracts();
    }
    if (provider.game.isFinished) {
      ref.read(storageProvider).saveGame(provider.game);
      Navigator.of(context).pushNamed(Routes.finishGame);
    } else {
      Navigator.of(context).pushNamed(Routes.prepareGame);
    }
    ref.read(logProvider).info("MyHome.loadGame: load $game");
    ref.read(logProvider).sendAnalyticEvent("Load game");
  }

  /// Starts a new game
  _startGame(BuildContext context, WidgetRef ref) {
    ref.read(logProvider).info("MyHome.startGame: start game");
    ref.read(logProvider).sendAnalyticEvent("Start game");
    Navigator.of(context).pushNamed(Routes.createGame);
  }

  bool _verifyHasActiveContracts(BuildContext context, WidgetRef ref) {
    if (ref.read(storageProvider).getActiveContracts().isEmpty) {
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
    if (!_verifyHasActiveContracts(context, ref)) {
      return;
    }
    Game? previousGame;
    try {
      previousGame = ref.read(storageProvider).getStoredGame();
    } catch (e) {
      ref.read(logProvider).error("MyHome.confirmLoadGame: $e");
    }

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
            return MyAlertDialog(
              context: context,
              title: "Charger une partie",
              content:
                  "${previousGame!.isFinished ? "Revoir" : "Reprendre"} la partie précédente avec ${_playerNames(previousGame.players)} ?",
              actions: [
                AlertDialogActionButton(
                  isDestructive: true,
                  text: "Non, nouvelle partie",
                  onPressed: () => _startGame(context, ref),
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
    if (!_verifyHasActiveContracts(context, ref)) {
      return;
    }
    try {
      Game? previousGame = ref.read(storageProvider).getStoredGame();
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
                    onPressed: () => _startGame(context, ref),
                  ),
                ],
              );
            });
      } else {
        _startGame(context, ref);
      }
    } catch (e) {
      ref.read(logProvider).error("MyHome.confirmStartGame: $e");
      _startGame(context, ref);
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
                child: const Text(
                  "Démarrer une partie",
                  textAlign: TextAlign.center,
                ),
                onPressed: () => _confirmStartGame(context, ref),
              ),
              ElevatedButtonFullWidth(
                child: const Text(
                  "Charger une partie",
                  textAlign: TextAlign.center,
                ),
                onPressed: () => _confirmLoadGame(context, ref),
              ),
              ElevatedButton(
                child: const Text(
                  "Règles du jeu",
                  textAlign: TextAlign.center,
                ),
                onPressed: () => Navigator.of(context).pushNamed(Routes.rules),
              ),
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.settings),
                icon: const Icon(Icons.settings),
                iconSize: 55,
                tooltip: "Paramètres",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
