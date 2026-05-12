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
}
