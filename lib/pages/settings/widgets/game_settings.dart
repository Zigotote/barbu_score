import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/notifiers/change_game_settings_provider.dart';
import 'package:barbu_score/pages/settings/widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'setting_question.dart';

/// A page to edit game settings
class GameSettingsWidget extends ConsumerWidget {
  const GameSettingsWidget({super.key});

  void _changeGameSettings(WidgetRef ref, GameSettings gameSettings) {
    ref
        .read(changeGameSettingsProvider.notifier)
        .changeGameSettings(gameSettings);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameSettings settings = ref.watch(changeGameSettingsProvider);
    return MyCard(
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
            onSelectionChanged: (newSelection) => _changeGameSettings(
              ref,
              settings.copyWith(goalIsMinScore: newSelection.first),
            ),
          ),
          onTap: null,
        ),
        SettingQuestion(
          tooltip: context.l10n.nbTricksTooltip,
          label: context.l10n.nbTricksQuestion,
          input: SegmentedButton(
            key: Key("nbTricks"),
            segments: [
              ButtonSegment(value: false, label: Text(context.l10n.optimized)),
              ButtonSegment(
                value: true,
                label: Text(context.l10n.defaultNbTricks),
              ),
            ],
            selected: <bool>{settings.fixedNbTricks},
            onSelectionChanged: (newSelection) => _changeGameSettings(
              ref,
              settings.copyWith(fixedNbTricks: newSelection.first),
            ),
          ),
          onTap: null,
        ),
        if (!settings.fixedNbTricks)
          SettingQuestion(
            label: context.l10n.deckQuestion,
            input: SegmentedButton(
              key: Key("deck"),
              segments: [
                ButtonSegment(
                  value: kNbCardsInSmallDeck,
                  label: Text(context.l10n.nbCards(kNbCardsInSmallDeck)),
                ),
                ButtonSegment(
                  value: kNbCardsInDeck,
                  label: Text(context.l10n.nbCards(kNbCardsInDeck)),
                ),
              ],
              selected: <int>{settings.nbCardsInDeck},
              onSelectionChanged: (newSelection) => _changeGameSettings(
                ref,
                settings.copyWith(nbCardsInDeck: newSelection.first),
              ),
            ),
            onTap: null,
          ),
        SettingQuestion(
          label: context.l10n.discardedCards,
          input: SegmentedButton(
            key: Key("discardedCards"),
            segments: [
              ButtonSegment(value: true, label: Text(context.l10n.randoms)),
              ButtonSegment(value: false, label: Text(context.l10n.lowest)),
            ],
            selected: <bool>{settings.discardRandomCards},
            onSelectionChanged: (newSelection) => _changeGameSettings(
              ref,
              settings.copyWith(discardRandomCards: newSelection.first),
            ),
          ),
          onTap: null,
        ),
      ],
    );
  }
}
