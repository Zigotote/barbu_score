import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/storage.dart';
import '../settings/widgets/change_contract_activation.dart';
import '../settings/widgets/my_switch.dart';
import '../settings/widgets/number_input.dart';
import '../settings/widgets/setting_question.dart';
import 'widgets/rules_page.dart';
import 'widgets/settings_card.dart';

class ContractsRules extends ConsumerWidget {
  /// The indicator to know if rules are displayed during a game
  final bool isInGame;

  /// The position of the page in the order of rules pages
  final int pageIndex;

  const ContractsRules(this.pageIndex, {super.key, this.isInGame = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RulesPage(
      pageIndex: pageIndex,
      title: context.l10n.contracts,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.contractsRules),
          SizedBox(height: 16),
          ...ContractsInfo.values
              .where((contract) {
                if (isInGame) {
                  return ref
                      .watch(storageProvider)
                      .getSettings(contract)
                      .isActive;
                }
                return true;
              })
              .mapIndexed((index, contract) {
                return TestAnimatedWidget(
                  contract: contract,
                  previousContract: index - 1 >= 0
                      ? ContractsInfo.values[index - 1]
                      : null,
                );
              }),
          SizedBox(height: 16),
          const SettingsCard(),
        ],
      ),
    );
  }
}

class TestAnimatedWidget extends ConsumerStatefulWidget {
  final ContractsInfo contract;
  final ContractsInfo? previousContract;

  const TestAnimatedWidget({
    super.key,
    required this.contract,
    this.previousContract,
  });

  @override
  ConsumerState<TestAnimatedWidget> createState() => _TestAnimatedWidgetState();
}

class _TestAnimatedWidgetState extends ConsumerState<TestAnimatedWidget>
    with TickerProviderStateMixin {
  bool showSettings = false;
  bool isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _tweenAnimation;
  final Tween<double> _expandTween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _tweenAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Saves new settings
  void saveNewSettings(
    WidgetRef ref,
    ContractsInfo contract,
    AbstractContractSettings settings,
  ) {
    ref.read(storageProvider).saveSettings(contract, settings);
    ref.invalidate(storageProvider);
    ref
        .read(logProvider)
        .info("MySettings: save ${contract.name} settings $settings");
    ref
        .read(logProvider)
        .sendAnalyticEvent(
          "modify_settings",
          parameters: {"contract": contract.name},
        );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(storageProvider).getSettings(widget.contract);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            final newIsExpanded = !isExpanded;
            setState(() => isExpanded = newIsExpanded);
            if (newIsExpanded) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: BoxBorder.symmetric(
                    vertical: BorderSide(
                      color: Theme.of(context).colorScheme.convertMyColor(
                        widget.contract.color,
                        isBackgroundColor: true,
                      ),
                    ),
                  ),
                  color: Theme.of(context).colorScheme.convertMyColor(
                    widget.contract.color,
                    isBackgroundColor: true,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    Text(
                      context.l10n.contractName(widget.contract),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down_outlined
                            : Icons.keyboard_arrow_up_outlined,
                      ),
                      tooltip:
                          "${context.l10n.settings} ${context.l10n.contractName(widget.contract)}",
                      style: IconButtonTheme.of(context).style?.copyWith(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: _expandTween.animate(_tweenAnimation),
          child: Container(
            decoration: BoxDecoration(
              border: BoxBorder.symmetric(
                vertical: BorderSide(
                  color: Theme.of(context).colorScheme.convertMyColor(
                    widget.contract.color,
                    isBackgroundColor: true,
                  ),
                  width: 2,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: showSettings
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChangeContractActivation(widget.contract, settings),
                        SettingQuestion(
                          label: context.l10n.contractPoints,
                          onTap: null,
                          input: NumberInput(
                            value:
                                (settings as ContractWithPointsSettings).points,
                            onChanged: (value) {
                              if (value != settings.points) {
                                settings.points = value;
                                saveNewSettings(ref, widget.contract, settings);
                              }
                            },
                            focusNode: null,
                          ),
                        ),
                        if (settings.canInvertScore)
                          SettingQuestion(
                            tooltip: context.l10n.invertScoreNegativeDetails,
                            label: context.l10n.invertScore,
                            onTap: () {
                              settings.invertScore = !settings.invertScore;
                              saveNewSettings(ref, widget.contract, settings);
                            },
                            input: MySwitch(
                              isActive: settings.invertScore,
                              onChanged: (value) {
                                settings.invertScore = value;
                                saveNewSettings(ref, widget.contract, settings);
                              },
                            ),
                          ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  setState(() => showSettings = !showSettings),
                              child: Text("Annuler"),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setState(() => showSettings = !showSettings),
                              child: Text("Appliquer"),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      key: Key(widget.contract.name),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          context.l10n.contractRules(
                            widget.contract,
                            ref.read(storageProvider),
                          ),
                        ),
                        if (!settings.isActive)
                          Text(
                            context.l10n.deactivatedForGame,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton.icon(
                            onPressed: () =>
                                setState(() => showSettings = !showSettings),
                            icon: Icon(Icons.settings),
                            label: Text(
                              "Modifier",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: BoxBorder.symmetric(
              vertical: BorderSide(
                color: Theme.of(context).colorScheme.convertMyColor(
                  widget.contract.color,
                  isBackgroundColor: true,
                ),
                width: 2,
              ),
            ),
          ),
          height: 8,
        ),
      ],
    );
  }
}
