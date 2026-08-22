import 'package:barbu_score/commons/providers/log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_settings.dart';
import 'storage.dart';

final changeGameSettingsProvider =
    NotifierProvider<ChangeGameSettingsProvider, GameSettings>(
      ChangeGameSettingsProvider.new,
      isAutoDispose: true,
    );

class ChangeGameSettingsProvider extends Notifier<GameSettings> {
  @override
  GameSettings build() {
    return ref.read(storageProvider).getGameSettings();
  }

  void changeGameSettings(GameSettings gameSettings) {
    state = gameSettings;
  }

  void saveGameSettings() {
    final storage = ref.read(storageProvider);

    if (storage.getGameSettings() != state) {
      final log = ref.read(logProvider);
      ref.read(storageProvider).saveGameSettings(state);
      log.info("MyRules: save new game settings $state");
      log.sendAnalyticEvent("modify_game_settings");
    }
  }
}
