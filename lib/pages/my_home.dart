import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../commons/models/game.dart';
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

  /// Loads a previous game and resumes it
  void _loadGame(BuildContext context, WidgetRef ref, Game game) {
    final provider = ref.read(playGameProvider);
    provider.load(game);
    if (!game.isFinished) {
      provider.moveToFirstPlayerWithAvailableContracts();
    }
    if (provider.game.isFinished) {
      ref.read(storageProvider).saveGame(provider.game);
      context.push(Routes.finishGame);
    } else {
      context.push(Routes.prepareGame);
    }
    ref.read(logProvider).info("MyHome.loadGame: load $game");
    ref.read(logProvider).sendAnalyticEvent("load_game");
  }

  /// Starts a new game
  void _startGame(BuildContext context, WidgetRef ref) {
    ref.read(logProvider).info("MyHome.startGame: start game");
    ref.read(logProvider).sendAnalyticEvent("start_game");
    context.push(Routes.createGame);
  }

  bool _hasActiveContracts(BuildContext context, WidgetRef ref) {
    if (ref.read(storageProvider).getActiveContracts().isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return MyAlertDialog(
              context: context,
              title: context.l10n.errorLaunchGame,
              content: context.l10n.errorLaunchGameDetails,
              actions: [
                AlertDialogActionButton(
                  text: context.l10n.modifySettings,
                  onPressed: () {
                    context.push(Routes.settings);
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
  void _confirmLoadGame(BuildContext context, WidgetRef ref) {
    if (!_hasActiveContracts(context, ref)) {
      return;
    }

    if (ref.read(storageProvider).hasStoredGames()) {
      context.push(Routes.loadGame);
    } else {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: context.l10n.noGameFound,
        text: context.l10n.noGameFoundDetails,
      );
      _startGame(context, ref);
    }
  }

  /// Builds the widgets to start a new game
  void _confirmStartGame(BuildContext context, WidgetRef ref) {
    if (!_hasActiveContracts(context, ref)) {
      return;
    }
    try {
      _startGame(context, ref);
    } catch (e) {
      ref.read(logProvider).error("MyHome.confirmStartGame: $e");
      _startGame(context, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WakelockPlus.disable();
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
              Text(
                context.l10n.appName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              context: context,
              hasLeading: false,
            ),
            ElevatedButtonFullWidth(
              child: Text(
                context.l10n.startGame,
                textAlign: TextAlign.center,
              ),
              onPressed: () => _confirmStartGame(context, ref),
            ),
            ElevatedButtonFullWidth(
              child: Text(context.l10n.loadGame, textAlign: TextAlign.center),
              onPressed: () => _confirmLoadGame(context, ref),
            ),
            ElevatedButton(
              child: Text(context.l10n.rules, textAlign: TextAlign.center),
              onPressed: () => context.push(Routes.rules),
            ),
            IconButton(
              onPressed: () => context.push(Routes.settings),
              icon: const Icon(Icons.settings),
              iconSize: 55,
              tooltip: context.l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
