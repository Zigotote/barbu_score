import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/providers/log.dart';
import '../../../commons/providers/play_game.dart';
import '../../../commons/providers/storage.dart';

/// IconButton displaying the rules of a contract
class RulesButton extends ConsumerWidget {
  /// The contract whose rules should be displayed
  final ContractsInfo contract;

  const RulesButton(this.contract, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(playGameProvider);
    return IconButton.outlined(
      tooltip: context.l10n.rules,
      onPressed: () {
        ref
            .read(logProvider)
            .sendAnalyticEvent(
              "contract_rules",
              parameters: {"contract": contract.name},
            );
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => DraggableScrollableSheet(
            expand: false,
            builder: (_, controller) => SingleChildScrollView(
              controller: controller,
              child: Column(
                spacing: 8,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.0),
                      ),
                      color: Theme.of(context).colorScheme
                          .convertMyColor(contract.color)
                          .withValues(alpha: 0.5),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  onPressed: context.pop,
                                  icon: Icon(Icons.close),
                                  tooltip: context.l10n.close,
                                  style: IconButtonTheme.of(context).style
                                      ?.copyWith(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.transparent,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppBar(
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          title: Text(
                            context.l10n.contractRulesTitle(
                              context.l10n.contractName(contract),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      context.l10n.detailedContractRules(
                        game.currentPlayer.name,
                        contract,
                        ref.read(storageProvider),
                        nbPlayers: game.players.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      icon: Icon(Icons.question_mark_outlined),
    );
  }
}
