import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/models/contract_info.dart';
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
                  isFirst: index == 0,
                  contract: contract,
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

  final bool isFirst;

  const TestAnimatedWidget({
    super.key,
    required this.contract,
    this.isFirst = false,
  });

  @override
  ConsumerState<TestAnimatedWidget> createState() => _TestAnimatedWidgetState();
}

class _TestAnimatedWidgetState extends ConsumerState<TestAnimatedWidget>
    with TickerProviderStateMixin {
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
                width: double.infinity,
                height: 35,
                decoration: BoxDecoration(
                  border: widget.isFirst
                      ? null
                      : BoxBorder.symmetric(
                          vertical: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.only(top: widget.isFirst ? 0 : 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
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
                      onPressed: () =>
                          context.push(widget.contract.settingsRoute),
                      icon: Icon(Icons.settings),
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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            padding: EdgeInsets.only(top: 8),
            child: Column(
              key: Key(widget.contract.name),
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    context.l10n.contractRules(
                      widget.contract,
                      ref.read(storageProvider),
                    ),
                  ),
                ),
                if (!settings.isActive)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      context.l10n.deactivatedForGame,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
