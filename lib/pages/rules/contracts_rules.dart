import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/rules/widgets/contract_divider_widget.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/storage.dart';
import 'widgets/rules_page.dart';

class ContractsRules extends ConsumerWidget {
  /// The indicator to know if rules are displayed during a game
  final bool isInGame;

  /// The position of the page in the order of rules pages
  final int pageIndex;

  const ContractsRules(this.pageIndex, {super.key, this.isInGame = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RulesPage(
      pageIndex: pageIndex,
      title: context.l10n.contracts,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.contractsRules),
          SizedBox(height: 16),
          ...ContractsInfo.values
              .where((contract) {
                if (isInGame) {
                  return ref
                      .watch(storageProvider)
                      .getSettings(contract)
                      .isActive;
                }
                return true;
              })
              .mapIndexed(
                (index, contract) => ContractDividerWidget(
                  contract: contract,
                  previousContractDividerColor: index - 1 >= 0
                      ? Theme.of(context).colorScheme.convertMyColor(
                          ContractsInfo.values[index - 1].color,
                          isBackgroundColor: true,
                        )
                      : null,
                ),
              ),
          Divider(color: Theme.of(context).colorScheme.onSurface),
        ],
      ),
    );
  }
}
