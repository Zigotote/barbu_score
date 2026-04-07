import 'package:flutter/material.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/game.dart';

mixin ChangeSettings on Widget {
  /// Returns the players who played this contract
  List<String> playersWithContract(ContractsInfo contract, Game? storedGame) {
    final playersWithContract = storedGame?.getPlayersWithPlayedContract(
      contract,
    );
    if (storedGame?.isFinished == true || playersWithContract == null) {
      return [];
    }
    return playersWithContract;
  }
}
