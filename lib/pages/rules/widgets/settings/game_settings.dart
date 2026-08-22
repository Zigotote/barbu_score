import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/change_game_settings.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/widgets/setting_question.dart';

/// A page to edit game settings
class GameSettingsWidget extends ConsumerWidget {
  const GameSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameSettings settings = ref.watch(changeGameSettingsProvider);
    return ExpandableCard.type(
      type: ExpandableCardType.settings,
      children: [
        SettingQuestion(
          label: context.l10n.goal,
          input: SegmentedButton(
            key: Key("goal"),
            segments: [
              ButtonSegment(value: true, label: Text(context.l10n.minScore)),
              ButtonSegment(value: false, label: Text(context.l10n.maxScore)),
            ],
            selected: <bool>{settings.goalIsMinScore},
            onSelectionChanged: (newSelection) => ref
                .read(changeGameSettingsProvider.notifier)
                .changeGameSettings(
                  settings.copyWith(goalIsMinScore: newSelection.first),
                ),
          ),
          onTap: null,
        ),
        SizedBox(
          // TODO Océane test de taille de SizedBox juste pour voir si dans l'idée ce design pourrait me plaire
          width: 100,
          child: OutlinedButton(
            onPressed: () {},
            child: Text(
              context.l10n.saveAndLeave,
            ), // TODO Océane le style me plait pas, faut voir si j'ai pas une meilleure idée : l'appli de la SNCF a des cartes du genre avec un petit outlinedButton dedans, centré, c'est pas mal
          ),
        ),
      ],
    );
  }
}
