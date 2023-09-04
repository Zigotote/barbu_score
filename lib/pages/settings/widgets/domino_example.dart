import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/utils/screen.dart';
import '../../../commons/widgets/my_tabbar.dart';
import '../notifiers/contract_settings_provider.dart';
import 'number_input.dart';

class DominoExample extends ConsumerStatefulWidget {
  const DominoExample({super.key});

  @override
  ConsumerState<DominoExample> createState() => _DominoExampleState();
}

class _DominoExampleState extends ConsumerState<DominoExample> {
  bool areLinked = true;

  @override
  void initState() {
    super.initState();
    areLinked = !(ref
            .read(contractSettingsProvider(ContractsInfo.domino))
            .settings as DominoContractSettings)
        .overridePoints;
  }

  /// Builds the widget to display the points for a position
  Widget _buildPositionPoints(BuildContext context, int position, int points,
      Function(int)? onChanged) {
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
          NumberInput(
            points: points,
            onChanged: areLinked ? null : onChanged,
          )
        ],
      ),
    );
  }

  Widget _buildExample(BuildContext context, ContractSettingsNotifier provider,
      DominoContractSettings settings) {
    return DefaultTabController(
      length: settings.points.length,
      child: Column(
        children: [
          MyTabBar(settings.points.keys
              .map((nbPlayers) => Tab(text: "$nbPlayers joueurs"))
              .toList()),
          SizedBox(
            height: ScreenHelper.height * 0.6,
            child: TabBarView(
              children: settings.points.entries
                  .map(
                    (points) => Column(
                        children: points.value
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildPositionPoints(
                                  context,
                                  entry.key,
                                  entry.value,
                                  provider.modifySetting((value) => settings
                                      .points[points.key]?[entry.key] = value)),
                            )
                            .toList()),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.domino));
    final settings = provider.settings as DominoContractSettings;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Scores calculés"),
            IconButton(
              icon: Icon(
                areLinked ? Icons.link : Icons.link_off,
              ),
              onPressed: () {
                final settings = (ref
                    .read(contractSettingsProvider(ContractsInfo.domino))
                    .settings as DominoContractSettings);
                settings.overridePoints = areLinked;
                if (!areLinked) {
                  settings.points = settings.generatePointsLists();
                }
                setState(() {
                  areLinked = !areLinked;
                });
              },
              style: IconButton.styleFrom(side: BorderSide.none),
            )
          ],
        ),
        const SizedBox(height: 8),
        _buildExample(context, provider, settings),
      ],
    );
  }
}
