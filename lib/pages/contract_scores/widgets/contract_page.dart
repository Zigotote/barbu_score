import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_models.dart';
import '../../../commons/providers/contracts_manager.dart';
import '../../../commons/providers/log.dart';
import '../../../commons/providers/play_game.dart';
import '../../../commons/utils/snackbar.dart';
import '../../../commons/widgets/default_page.dart';
import '../../../commons/widgets/my_appbar.dart';
import '../../../commons/widgets/my_subtitle.dart';
import '../../../main.dart';
import '../notifiers/trumps_provider.dart';

class SubContractPage extends ConsumerWidget {
  /// The contract actually displayed
  final ContractsInfo contract;

  /// The subtitle to explain the action that needs to be done
  final String subtitle;

  /// The indicator to know if the contract is being modified
  final bool isModification;

  /// The widgets to fill the scores
  final Widget child;

  /// The indicator to know if the contract is valid
  final bool isValid;

  /// The number of bad item each player gain during the game
  final Map<String, int> itemsByPlayer;

  const SubContractPage({
    super.key,
    required this.contract,
    required this.subtitle,
    this.isModification = false,
    required this.isValid,
    required this.itemsByPlayer,
    required this.child,
  });

  /// Saves this contract and moves to the next player round
  void _saveContract(BuildContext context, WidgetRef ref) {
    final playGame = ref.read(playGameProvider);
    final bool isPartOfTrumpsContract =
        ref.exists(trumpsProvider) && !(contract == ContractsInfo.trumps);
    final contractModel = (ref
        .read(contractsManagerProvider)
        .getContractManager(contract)
        .model as AbstractSubContractModel);
    final bool isFinished = contractModel.setItemsByPlayer(itemsByPlayer);
    ref.read(logProvider).info(
          "SubContractPage.saveContract: save $contractModel ${isPartOfTrumpsContract ? "in trumps" : ""}",
        );

    if (isPartOfTrumpsContract) {
      /// Adds the contract to the trumps contract
      ref.read(trumpsProvider).addContract(contractModel);
    } else {
      playGame.finishContract(contractModel);
    }

    if (isFinished) {
      SnackBarUtils.instance.closeSnackBar(context);
      if (isPartOfTrumpsContract) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).popAndPushNamed(
            playGame.nextPlayer() ? Routes.chooseContract : Routes.finishGame);
      }
    } else {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: "Scores incorrects",
        text:
            "Le nombre d'éléments ajoutés ne correspond pas au nombre attendu. Veuillez réessayer.",
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String titleText;
    String validateText;
    if (isModification) {
      titleText = "Modification ${contract.displayName}";
      validateText = "Modifier les scores";
    } else {
      titleText = "Tour de ${ref.read(playGameProvider).currentPlayer.name}";
      validateText = "Valider les scores";
    }
    return DefaultPage(
      appBar: MyAppBar(titleText, context: context, hasLeading: true),
      content: Column(
        children: [
          MySubtitle(subtitle),
          child,
        ],
      ),
      bottomWidget: ElevatedButton(
        onPressed: isValid ? () => _saveContract(context, ref) : null,
        child: Text(validateText),
      ),
    );
  }
}
