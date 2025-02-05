import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../../../commons/widgets/custom_buttons.dart';
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
          const Text(
            "Les contrats sont modifiables dans la page de paramètres, pour personnaliser leurs points et variations.",
            textAlign: TextAlign.center,
          ),
          ElevatedButtonFullWidth(
            onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.settings),
                Text(
                  "Paramètres",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
