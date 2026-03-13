import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/my_card.dart';
import 'package:flutter/material.dart';

class MySettingsCard extends MyCard {
  const MySettingsCard({super.key, required super.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(Icons.settings),
            Text(
              context.l10n.settings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        super.build(context),
      ],
    );
  }
}
