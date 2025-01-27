import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/player_colors.dart';
import '../../commons/providers/storage.dart';
import 'widgets/rules_page.dart';

class ContractsRules extends ConsumerWidget {
  /// The position of the page in the order of rules pages
  final int pageIndex;

  const ContractsRules(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RulesPage(
      pageIndex: pageIndex,
      title: "Contrats",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
                "Le jeu du Barbu comporte les ${ContractsInfo.values.length} contrats suivants :"),
          ),
          ...ContractsInfo.values.mapIndexed((index, contract) {
            final settings = ref.read(storageProvider).getSettings(contract);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        .withOpacity(0.5),
                  ),
                  child: Text(
                    contract.displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(settings.filledRules(contract.rules)),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
