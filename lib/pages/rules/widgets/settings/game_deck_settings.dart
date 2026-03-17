import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/rules/widgets/settings/my_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/widgets/setting_question.dart';
import '../../notifiers/change_game_settings.dart';

/// A page to edit game settings
class GameDeckSettings extends ConsumerWidget {
  const GameDeckSettings({super.key});

  void _changeGameSettings(WidgetRef ref, GameSettings gameSettings) {
    ref
        .read(changeGameSettingsProvider.notifier)
        .changeGameSettings(gameSettings);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameSettings settings = ref.watch(changeGameSettingsProvider);
    return MySettingsCard(
      children: [
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
