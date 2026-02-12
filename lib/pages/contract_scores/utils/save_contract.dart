import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/contract_models.dart';
import '../../../commons/providers/log.dart';
import '../../../commons/providers/play_game.dart';
import '../../../commons/utils/snackbar.dart';
import '../../../main.dart';
import '../notifiers/salad_provider.dart';

mixin SaveContract on Widget {
  /// Saves the contract and moves to the next player round
  void saveContract(
    BuildContext context,
    WidgetRef ref,
    AbstractContractModel contractModel,
  ) {
    final playGame = ref.read(playGameProvider);
    final bool isPartOfSaladContract =
        ref.exists(saladProvider) &&
        !(ContractsInfo.fromName(contractModel.name) == ContractsInfo.salad);
    ref
        .read(logProvider)
        .info(
          "${contractModel.name}.saveContract: save $contractModel ${isPartOfSaladContract ? "in salad" : ""}",
        );

    SnackBarUtils.instance.closeSnackBar(context);
    if (isPartOfSaladContract) {
      /// Adds the contract to the salad contract
      ref
          .read(saladProvider)
          .addContract(contractModel as ContractWithPointsModel);
      context.pop();
    } else {
      playGame.finishContract(contractModel);
      context.go(
        playGame.nextPlayer() ? Routes.chooseContract : Routes.finishGame,
      );
    }
  }
}
