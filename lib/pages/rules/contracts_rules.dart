import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/storage.dart';
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
  bool isExpanded = true;
  late final AnimationController _controller;

  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    if (isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
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

  BoxDecoration _cardDecoration(Color color) {
    return BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      color: color,
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildCardName(context),
        Expanded(
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.convertMyColor(
                widget.contract.color,
                isBackgroundColor: true,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            border: Border.all(
              width: 3,
              color: Theme.of(context).colorScheme.convertMyColor(
                widget.contract.color,
                isBackgroundColor: true,
              ),
            ),
          ),
          child: IconButton(
            onPressed: () => context.push(widget.contract.settingsRoute),
            icon: Icon(Icons.settings),
            visualDensity: VisualDensity.compact,
          ),
        ),
        Container(
          height: 16,
          width: 15,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
            ),
            color: Theme.of(context).colorScheme.convertMyColor(
              widget.contract.color,
              isBackgroundColor: true,
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector _buildCardName(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final newIsExpanded = !isExpanded;

        setState(() => isExpanded = newIsExpanded);
        if (newIsExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 0, 8),
        decoration: _cardDecoration(
          Theme.of(context).colorScheme.convertMyColor(
            widget.contract.color,
            isBackgroundColor: true,
          ),
        ),
        child: Row(
          children: [
            Semantics(
              header: true,
              child: Text(context.l10n.contractName(widget.contract)),
            ),
            IconButton(
              onPressed: () => setState(() => isExpanded = !isExpanded),
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down_outlined
                    : Icons.keyboard_arrow_up_outlined,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRules(AbstractContractSettings settings) {
    return Column(
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(storageProvider).getSettings(widget.contract);
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            _buildHeader(context),
            if (widget.previousContract != null)
              Container(
                width: 3,
                color: Theme.of(context).colorScheme.convertMyColor(
                  widget.previousContract!.color,
                  isBackgroundColor: true,
                ),
                height: 40,
              ),
          ],
        ),
        Container(
          color: Theme.of(context).colorScheme.convertMyColor(
            widget.contract.color,
            isBackgroundColor: true,
          ),
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 3),
            decoration: _cardDecoration(
              Theme.of(context).scaffoldBackgroundColor,
            ),
            child: SizeTransition(
              sizeFactor: _animation,
              child: _buildRules(settings),
            ),
          ),
        ),
      ],
    );
  }
}
