import 'package:barbu_score/pages/play_game/contracts/notifiers/trumps_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../main.dart';
import '../../../../utils/snackbar.dart';
import '../../../../widgets/default_page.dart';
import '../../../../widgets/my_subtitle.dart';
import '../../models/contract_info.dart';
import '../../notifiers/play_game.dart';

class ContractPage extends ConsumerWidget {
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

  ContractPage({
    required this.contract,
    required this.subtitle,
    this.isModification = false,
    required this.isValid,
    required this.itemsByPlayer,
    required this.child,
  });

  /// Saves the score for this contract and moves to the next player round
  void _saveScore(
      BuildContext context, WidgetRef ref, PlayGameNotifier provider) {
    final bool isPartOfTrumpsContract =
        ref.exists(trumpsProvider) && !(contract == ContractsInfo.Trumps);
    bool isFinished;
    if (isPartOfTrumpsContract) {
      /// Adds the contract to the trumps contract
      isFinished =
          ref.read(trumpsProvider).addContract(contract, itemsByPlayer);
    } else {
      /// Finishes the contract
      isFinished = provider.finishContract(contract, itemsByPlayer);
    }
    if (isFinished) {
      SnackbarUtils.instance.closeSnackBar(context);
      if (isPartOfTrumpsContract) {
        context.pop();
      } else {
        context.go(provider.nextPlayer()
            ? Routes.CHOOSE_CONTRACT
            : Routes.FINISH_GAME);
      }
    } else {
      SnackbarUtils.instance.openSnackBar(
        context: context,
        title: "Scores incorrects",
        text:
            "Le nombre d'éléments ajoutés ne correspond pas au nombre attendu. Veuillez réessayer.",
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(playGameProvider);
    String title;
    String validateText;
    if (isModification) {
      title = "Modification ${this.contract.displayName}";
      validateText = "Modifier les scores";
    } else {
      title = "Tour de ${provider.currentPlayer.name}";
      validateText = "Valider les scores";
    }
    return DefaultPage(
      title: title,
      hasLeading: true,
      content: Column(
        children: [
          MySubtitle(this.subtitle),
          SizedBox(height: 8),
          Expanded(child: this.child),
        ],
      ),
      bottomWidget: ElevatedButton(
        child: Text(validateText),
        onPressed: isValid ? () => _saveScore(context, ref, provider) : null,
      ),
    );
  }
}
