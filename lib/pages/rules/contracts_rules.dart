import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/storage.dart';
import 'widgets/rules_page.dart';
import 'widgets/settings_card.dart';

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
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(context.l10n.contractsRules),
          ),
          ...ContractsInfo.values.where((contract) {
            if (isInGame) {
              return ref.watch(storageProvider).getSettings(contract).isActive;
            }
            return true;
          }).mapIndexed((index, contract) {
            final settings = ref.watch(storageProvider).getSettings(contract);
            return Column(
              key: Key(contract.name),
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                    color: Theme.of(context)
                        .colorScheme
                        .convertMyColor(contract.color)
                        .withValues(alpha: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children: [
                      Text(
                        context.l10n.contractName(contract),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () => context.push(contract.settingsRoute),
                        icon: Icon(Icons.settings),
                        tooltip:
                            "${context.l10n.settings} ${context.l10n.contractName(contract)}",
                        style: IconButtonTheme.of(context).style?.copyWith(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                            ),
                      )
                    ],
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
