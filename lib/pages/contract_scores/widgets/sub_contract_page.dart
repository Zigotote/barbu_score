import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_models.dart';
import '../../../commons/providers/contracts_manager.dart';
import '../../../commons/providers/log.dart';
import '../../../commons/providers/play_game.dart';
import '../../../commons/utils/snackbar.dart';
import '../../../commons/widgets/custom_buttons.dart';
import '../../../commons/widgets/my_appbar.dart';
import '../../../commons/widgets/my_default_page.dart';
import '../../../commons/widgets/my_subtitle.dart';
import '../../../main.dart';
import '../notifiers/salad_provider.dart';
import 'rules_button.dart';

class SubContractPage extends ConsumerWidget {
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

  const SubContractPage({
    super.key,
    required this.contract,
    required this.subtitle,
    required this.isValid,
    required this.itemsByPlayer,
    required this.child,
  });

  /// Saves this contract and moves to the next player round
  void _saveContract(BuildContext context, WidgetRef ref) {
    final playGame = ref.read(playGameProvider);
    final bool isPartOfSaladContract =
        ref.exists(saladProvider) && !(contract == ContractsInfo.salad);
    final contractModel =
        (ref.read(contractsManagerProvider).getContractManager(contract).model
                as ContractWithPointsModel)
            .copyWith(itemsByPlayer: itemsByPlayer);
    ref
        .read(logProvider)
        .info(
          "SubContractPage.saveContract: save $contractModel ${isPartOfSaladContract ? "in salad" : ""}",
        );

    SnackBarUtils.instance.closeSnackBar(context);
    if (isPartOfSaladContract) {
      /// Adds the contract to the salad contract
      ref.read(saladProvider).addContract(contractModel);
      context.pop();
    } else {
      playGame.finishContract(contractModel);
      context.go(
        playGame.nextPlayer() ? Routes.chooseContract : Routes.finishGame,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyDefaultPage(
      appBar: MyPlayerAppBar(
        player: ref.watch(playGameProvider).currentPlayer,
        context: context,
        trailing: RulesButton(contract),
      ),
      content: Column(
        spacing: 24,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(28.0)),
              color: Theme.of(context).colorScheme
                  .convertMyColor(contract.color)
                  .withValues(alpha: 0.5),
            ),
            padding: EdgeInsets.all(8),
            child: MySubtitle(subtitle),
          ),
          child,
        ],
      ),
      bottomWidget: ElevatedButtonFullWidth(
        onPressed: isValid ? () => _saveContract(context, ref) : null,
        child: Text(context.l10n.validateScores, textAlign: TextAlign.center),
      ),
    );
  }
}
