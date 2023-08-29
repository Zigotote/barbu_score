import 'package:flutter/material.dart';

import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/utils/screen.dart';
import '../../../commons/widgets/my_tabbar.dart';
import '../../create_game/create_game_props.dart';
import 'number_input.dart';

/// A widget to display the scores of each player depending on the current settings
class DominoExample extends StatelessWidget {
  /// The current settings of the contract
  final DominoContractSettings settings;

  /// The number of examples to display
  final int _nbExamples = kNbPlayersMax - kNbPlayersMin + 1;

  final List<String> _positionNames = [
    "1er",
    "2ème",
    "3ème",
    "4ème",
    "5ème",
    "6ème"
  ];

  DominoExample({super.key, required this.settings});

  /// Builds the column to display example values
  Column _buildExamples(BuildContext context, int nbPlayers) {
    return Column(
      children: settings
          .calculatePoints(nbPlayers)
          .asMap()
          .entries
          .map((entry) => _buildPositionPoints(context, entry.key, entry.value))
          .toList(),
    );
  }

  /// Builds the widget to display the points for a position
  Widget _buildPositionPoints(BuildContext context, int position, int points) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16),
      child: Row(
        children: [
          Expanded(child: Text(_positionNames[position])),
          const SizedBox(width: 8),
          NumberInput(points: points, onChanged: null)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                (index) => _buildExamples(context, index + kNbPlayersMin),
              ),
            ),
          )
        ],
      ),
    );
  }
}
