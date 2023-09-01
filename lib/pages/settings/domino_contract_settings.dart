import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/utils/screen.dart';
import '../../commons/widgets/my_tabbar.dart';
import '../create_game/create_game_props.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit domino contract settings
class DominoContractSettingsPage extends ConsumerWidget {
  /// The number of examples to display
  final int _nbExamples = kNbPlayersMax - kNbPlayersMin + 1;

  const DominoContractSettingsPage({super.key});

  /// Builds the widget to display the points for a position
  Widget _buildPositionPoints(BuildContext context, int position, int points) {
    final List<String> positionNames = [
      "1er",
      "2ème",
      "3ème",
      "4ème",
      "5ème",
      "6ème"
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16),
      child: Row(
        children: [
          Expanded(child: Text(positionNames[position])),
          const SizedBox(width: 8),
          NumberInput(points: points, onChanged: null)
        ],
      ),
    );
  }

  Widget _buildExample(BuildContext context, DominoContractSettings settings) {
    return DefaultTabController(
      length: _nbExamples,
      child: Column(
        children: [
          MyTabBar(
            List.generate(
              _nbExamples,
              (index) => Tab(
                text: "${index + kNbPlayersMin} joueurs",
              ),
            ),
          ),
          SizedBox(
            height: ScreenHelper.height * 0.6,
            child: TabBarView(
              children: List.generate(
                _nbExamples,
                (index) => Column(
                  children: settings
                      .calculatePoints(kNbPlayersMin + index)
                      .asMap()
                      .entries
                      .map((entry) =>
                          _buildPositionPoints(context, entry.key, entry.value))
                      .toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.domino));
    final settings = provider.settings as DominoContractSettings;
    return ContractSettingsPage(
      contract: ContractsInfo.domino,
      children: [
        SettingQuestion(
          label: "Score du premier joueur",
          input: NumberInput(
            points: settings.pointsFirstPlayer,
            onChanged: provider.modifySetting(
              (value) => settings.pointsFirstPlayer = value,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SettingQuestion(
          label: "Score du dernier joueur",
          input: NumberInput(
            points: settings.pointsLastPlayer,
            onChanged: provider.modifySetting(
              (value) => settings.pointsLastPlayer = value,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Scores calculés"),
            IconButton(
              icon: const Icon(Icons.link),
              onPressed: () {
                debugPrint("not yet implemented");
              },
              style: IconButton.styleFrom(side: BorderSide.none),
            )
          ],
        ),
        const SizedBox(height: 8),
        _buildExample(context, settings),
      ],
    );
  }
}
