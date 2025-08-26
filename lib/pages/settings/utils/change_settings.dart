import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/models/game.dart';
import '../../../commons/providers/log.dart';
import '../../../commons/providers/storage.dart';

mixin ChangeSettings on Widget {
  /// Saves new settings
  void saveNewSettings(WidgetRef ref, ContractsInfo contract,
      AbstractContractSettings settings) {
    ref.read(storageProvider).saveSettings(contract, settings);
    ref.invalidate(storageProvider);
    ref.read(logProvider).info(
          "MySettings: save ${contract.name} settings $settings",
        );
    ref.read(logProvider).sendAnalyticEvent(
      "modify_settings",
      parameters: {"contract": contract.name},
    );
  }

  /// Returns the players who played this contract
  List<String> playersWithContract(ContractsInfo contract, Game? storedGame) {
    final playersWithContract =
        storedGame?.getPlayersWithPlayedContract(contract);
    if (storedGame?.isFinished == true || playersWithContract == null) {
      return [];
    }
    return playersWithContract;
  }
}
