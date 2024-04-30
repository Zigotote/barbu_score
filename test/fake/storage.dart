import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:flutter/foundation.dart';

class FakeStorage extends MyStorage2 {
  final Game? storedGame;
  late Map<ContractsInfo, AbstractContractSettings> storedSettings;
  late final ValueNotifier settingsNotifier;

  FakeStorage({this.storedGame, required List<ContractsInfo> activeContracts}) {
    storedSettings = Map.fromIterable(
      ContractsInfo.values,
      value: (contract) {
        var settings = contract.defaultSettings;
        settings.isActive = activeContracts.contains(contract);
        return settings;
      },
    );
    settingsNotifier = ValueNotifier(storedSettings);
  }

  @override
  bool? getIsDarkTheme() => false;

  @override
  AbstractContractSettings getSettings(ContractsInfo contractsInfo) =>
      storedSettings[contractsInfo]!.copy();

  @override
  Game? getStoredGame() => storedGame;

  @override
  void saveSettings(
      ContractsInfo contractsInfo, AbstractContractSettings settings) {
    storedSettings[contractsInfo] = settings;
    settingsNotifier.notifyListeners();
  }

  @override
  ValueListenable listenContractsSettings() => settingsNotifier;
}
