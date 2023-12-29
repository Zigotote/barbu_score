import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:flutter/foundation.dart';

class FakeStorage extends MyStorage2 {
  final Game? storedGame;
  final bool hasActiveContracts;

  FakeStorage({required this.storedGame, required this.hasActiveContracts});

  @override
  List<ContractsInfo> getActiveContracts() =>
      hasActiveContracts ? ContractsInfo.values : [];

  @override
  bool? getIsDarkTheme() => false;

  @override
  AbstractContractSettings getSettings(ContractsInfo contractsInfo) =>
      contractsInfo.settings;

  @override
  Game? getStoredGame() => storedGame;

  @override
  ValueListenable listenContractsSettings() => ValueNotifier(null);
}
