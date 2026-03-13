import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/rules/widgets/settings/my_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/providers/log.dart';
import '../../../../commons/widgets/setting_question.dart';

/// A page to edit game settings
class GameSettingsWidget extends ConsumerWidget {
  const GameSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameSettings settings = ref.watch(storageProvider).getGameSettings();
    return MySettingsCard(
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
            onSelectionChanged: (newSelection) {
              final newSettings = settings.copyWith(
                goalIsMinScore: newSelection.first,
              );
              ref.read(storageProvider).saveGameSettings(newSettings);
              ref.invalidate(storageProvider);
              ref
                  .read(logProvider)
                  .info("MySettings: change game settings $newSettings");
              ref.read(logProvider).sendAnalyticEvent("modify_game_settings");
            },
          ),
          onTap: null,
        ),
      ],
    );
  }
}
