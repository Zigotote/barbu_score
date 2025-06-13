import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/player_colors.dart';
import '../../commons/providers/storage.dart';
import 'widgets/rules_page.dart';
import 'widgets/settings_card.dart';

class ContractsRules extends ConsumerWidget {
  /// The position of the page in the order of rules pages
  final int pageIndex;

  const ContractsRules(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RulesPage(
      pageIndex: pageIndex,
      title: context.l10n.contracts,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(context.l10n.contractsRules),
          ),
          ...ContractsInfo.values.mapIndexed((index, contract) {
            final settings = ref.read(storageProvider).getSettings(contract);
            return Column(
              key: Key(contract.name),
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                    color: Theme.of(context)
                        .colorScheme
                        .convertPlayerColor(
                          PlayerColors
                              .values[index % PlayerColors.values.length],
                        )
                        .withValues(alpha: 0.5),
                  ),
                  child: Text(
                    context.l10n.contractName(contract),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(context.l10n.contractRules(settings)),
                ),
                if (!settings.isActive)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      context.l10n.deactivatedForGame,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            );
          }),
          const SettingsCard(),
        ],
      ),
    );
  }
}
