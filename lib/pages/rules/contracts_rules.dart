import 'package:barbu_score/theme/my_themes.dart';
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
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text("Le jeu du Barbu comporte les 7 contrats suivants :"),
            ...ContractsInfo.values.indexed.map((c) {
              final contract = c.$2;
              final index = c.$1;
              final settings = ref.read(storageProvider).getSettings(contract);
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
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
                ),
              );
            }),
            // TODO Océane mettre une redirection vers les paramètres ?
          ],
        ),
      ),
    );
  }
}
