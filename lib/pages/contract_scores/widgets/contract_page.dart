import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../../main.dart';
import '../../../commons/notifiers/play_game.dart';
import '../../../commons/utils/snackbar.dart';
import '../../../commons/widgets/default_page.dart';
import '../../../commons/widgets/my_subtitle.dart';
import '../notifiers/trumps_provider.dart';

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

  const ContractPage({
    super.key,
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
        ref.exists(trumpsProvider) && !(contract == ContractsInfo.trumps);
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
      SnackBarUtils.instance.closeSnackBar(context);
      if (isPartOfTrumpsContract) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).popAndPushNamed(
            provider.nextPlayer() ? Routes.chooseContract : Routes.finishGame);
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
    final provider = ref.read(playGameProvider);
    String title;
    String validateText;
    if (isModification) {
      title = "Modification ${contract.displayName}";
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
          MySubtitle(subtitle),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
      bottomWidget: ElevatedButton(
        onPressed: isValid ? () => _saveScore(context, ref, provider) : null,
        child: Text(validateText),
      ),
    );
  }
}
