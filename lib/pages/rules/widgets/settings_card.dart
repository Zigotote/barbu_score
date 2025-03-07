import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

/// A card to go to settings page
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Theme.of(context).colorScheme.grey.withOpacity(0.25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        spacing: 8,
        children: [
          const Icon(Icons.lightbulb_outline),
          Text(
            context.l10n.modifyContractsSettings,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.settings),
                  Text(
                    context.l10n.settings,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
