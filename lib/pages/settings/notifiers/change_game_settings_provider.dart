import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
