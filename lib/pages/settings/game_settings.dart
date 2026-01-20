import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/widgets/number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/providers/storage.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import 'widgets/my_switch.dart';
import 'widgets/setting_question.dart';

// TODO Océane tester cette page quand elle aura été finalisée + bloquer l'édition si une partie est en cours
/// A page to edit game settings
class GameSettingsPage extends ConsumerStatefulWidget {
  const GameSettingsPage({super.key});

  @override
  ConsumerState<GameSettingsPage> createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends ConsumerState<GameSettingsPage> {
  late GameSettings settings;
  late final MyStorage storage;

  @override
  void initState() {
    super.initState();
    settings = ref.read(storageProvider).getGameSettings();
    storage = ref.read(storageProvider);
  }

  @override
  void dispose() {
    storage.saveGameSettings(
      settings,
    ); // TODO Océane ça marche pas comme ça, faut repasser comme pour l'édition de contrat
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fixedNbTricksFocusNode = FocusNode();
    return MyDefaultPage(
      appBar: MyAppBar(
        Column(
          children: [Text(context.l10n.settings), Text(context.l10n.game)],
        ),
        context: context,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingQuestion(
            label: context.l10n.gameScoreObjective,
            input: MySwitch(
              isActive: settings.goalIsMinScore,
              onChanged: (value) => setState(
                () => settings = settings.copyWith(goalIsMinScore: value),
              ),
            ),
            onTap: () => setState(
              () => settings = settings.copyWith(
                goalIsMinScore: !settings.goalIsMinScore,
              ),
            ),
          ),
          SettingQuestion(
            label: "Nombre de plis fixe ?",
            input: MySwitch(
              isActive: settings.fixedNbTricks != null,
              onChanged: (value) => setState(
                () => settings = value
                    ? settings.copyWith(fixedNbTricks: kNbTricksByRound)
                    : settings.copyWith(
                        nbTricksByPlayer: kNbTricksByRoundByPlayer,
                      ),
              ),
            ),
            onTap: () =>
                (value) => setState(
                  () => settings = value
                      ? settings.copyWith(fixedNbTricks: kNbTricksByRound)
                      : settings.copyWith(
                          nbTricksByPlayer: kNbTricksByRoundByPlayer,
                        ),
                ),
          ),
          if (settings.fixedNbTricks != null)
            SettingQuestion(
              label: "Nombre de plis par manche",
              input: NumberInput(
                value: settings.fixedNbTricks!,
                onChanged: (value) => setState(
                  () => settings = settings.copyWith(fixedNbTricks: value),
                ),
              ),
              onTap: fixedNbTricksFocusNode.requestFocus,
            ),
          if (settings.nbTricksByPlayer != null) ...[
            Text("Nombre de plis par manche selon le nombre de joueurs"),
            ...List.generate(kNbPlayersMax - kNbPlayersMin, (index) {
              final nbPlayers = index + kNbPlayersMin;
              return SettingQuestion(
                label: "$nbPlayers joueurs",
                input: NumberInput(
                  value: settings.getNbTricksByRound(nbPlayers),
                  onChanged: (value) =>
                      settings.nbTricksByPlayer![nbPlayers] = value,
                ),
                onTap: () {},
              );
            }),
          ],
          SettingQuestion(
            label: "Cartes retirées aléatoirement ?",
            input: MySwitch(
              isActive: settings.withdrawRandomCards,
              onChanged: (value) => setState(
                () => settings = settings.copyWith(withdrawRandomCards: value),
              ),
            ),
            onTap: () => setState(
              () => settings = settings.copyWith(
                withdrawRandomCards: !settings.withdrawRandomCards,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
