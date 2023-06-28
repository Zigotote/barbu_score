import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../controller/contract.dart';
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

  /// The widgets to fill the scores
  final Widget child;

  /// The indicator to know if the contract is valid
  final bool isValid;

  /// The number of bad item each player gain during the game
  final Map<String, int> itemsByPlayer;

  ContractPage({
    required this.subtitle,
    required this.child,
    required this.contract,
    required this.isValid,
    required this.itemsByPlayer,
  });

  /// Saves the score for this contract and moves to the next player round
  void _saveScore(BuildContext context, PlayGameNotifier provider) {
    if (Routes.isPartOfTrumpsContract() &&
        !(contract is TrumpsScoresController)) {
      // TODO Océane to correct to be able to modify score during trump contract
      /// Adds the contract to the trumps contract
      /*Get.find<TrumpsScoresController>()
          .addContract(this.contract, controller.playerScores);
      Get.toNamed(
        Routes.TRUMPS_SCORES,
        arguments: RouteArgument(
          contractInfo: ContractsInfo.Trumps,
          contractValues: null,
        ),
      );*/
    } else {
      /// Finishes the contract
      final bool isFinished = provider.finishContract(contract, itemsByPlayer);
      if (!isFinished) {
        SnackbarUtils.instance.openSnackBar(
          context: context,
          title: "Scores incorrects",
          text:
              "Le nombre d'éléments ajoutés ne correspond pas au nombre attendu. Veuillez réessayer.",
        );
        return;
      }
      SnackbarUtils.instance.closeSnackBar(context);
      context.go(
          provider.nextPlayer() ? Routes.CHOOSE_CONTRACT : Routes.FINISH_GAME);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(playGameProvider);
    String title = "Tour de ${provider.currentPlayer.name}";
    String validateText = "Valider les scores";
    /*if ((Get.arguments as RouteArgument).isForModification) {
      title = "Modification ${this.contract.displayName}";
      validateText = "Modifier les scores";
    }*/
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
        onPressed: isValid ? () => _saveScore(context, provider) : null,
      ),
    );
  }
}
