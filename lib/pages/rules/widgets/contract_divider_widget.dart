import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/rules/notifiers/change_contracts_settings.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import 'settings/contract_with_points_settings.dart';
import 'settings/domino_contract_settings.dart';
import 'settings/salad_contract_settings.dart';

class ContractDividerWidget extends ConsumerStatefulWidget {
  final ContractsInfo contract;
  final Color? previousContractDividerColor;

  const ContractDividerWidget({
    super.key,
    required this.contract,
    this.previousContractDividerColor,
  });

  @override
  ConsumerState<ContractDividerWidget> createState() =>
      _ContractDividerWidgetState();
}

class _ContractDividerWidgetState extends ConsumerState<ContractDividerWidget>
    with TickerProviderStateMixin {
  static const Radius borderRadius = Radius.circular(15);

  static const double borderWidth = 3;

  Color get borderColor => Theme.of(
    context,
  ).colorScheme.convertMyColor(widget.contract.color, isBackgroundColor: true);

  /// Indicates if the widget is in rules view, or settings view
  bool _isSettingsView = false;

  /// Indicates if the content of the widget is displayed
  late bool _isExpanded;

  /// The controller for the open/close animation
  late final AnimationController _controller;
  late final Animation<double> _animationContent;
  late final Animation<double> _animationButton;

  @override
  void initState() {
    _isExpanded = ref
        .read(changeContractsSettingsProvider(widget.contract))
        .isActive;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationContent = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _animationButton = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    if (_isExpanded) {
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

  void _toggleExpansion() async {
    final newIsExpanded = !_isExpanded;

    setState(() => _isExpanded = newIsExpanded);
    if (newIsExpanded) {
      _controller.forward();
    } else {
      await _controller.reverse();
      setState(() => _isSettingsView = false);
    }
  }

  /// Builds the header of the divider, which contains the contract name, the arrow to expand/collapse the divider and the button to switch between settings and rules display
  Widget _buildHeader(AbstractContractSettings settings) {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildDividerName(settings),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 16,
                  decoration: BoxDecoration(color: borderColor),
                ),
                SizeTransition(
                  sizeFactor: _animationButton,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: _buildCardButton(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: borderRadius),
              color: borderColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the button for the card
  Widget _buildCardButton() {
    return TextButton(
      onPressed: () {
        setState(() => _isSettingsView = !_isSettingsView);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topLeft: borderRadius,
              topRight: borderRadius,
            ),
            side: BorderSide(width: borderWidth, color: borderColor),
          ),
        ),
      ),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 400),
        firstChild: _buildButtonText(
          Icons.history_edu_outlined,
          context.l10n.rules,
        ),
        secondChild: _buildButtonText(Icons.settings, context.l10n.settings),
        crossFadeState: _isSettingsView
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }

  Widget _buildButtonText(IconData icon, String text) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canDisplayText =
            constraints.maxWidth >
            MediaQuery.textScalerOf(context).scale(11) * text.length;
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(icon, semanticLabel: text),
            if (canDisplayText)
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      },
    );
  }

  /// Builds the content of divider header, with the name of the contract and the button to toggle expansion
  Widget _buildDividerName(AbstractContractSettings settings) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: borderRadius),
        color: borderColor,
      ),
      child: Row(
        children: [
          Semantics(
            header: true,
            child: Text(
              context.l10n.contractName(widget.contract),
              style: settings.isActive
                  ? null
                  : const TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.lineThrough,
                    ),
            ),
          ),
          IconButton(
            onPressed: _toggleExpansion,
            icon: Icon(
              _isExpanded
                  ? Icons.keyboard_arrow_down_outlined
                  : Icons.keyboard_arrow_up_outlined,
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the rules widget
  Widget _buildRules(AbstractContractSettings settings) {
    return Column(
      key: Key(widget.contract.name),
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (!settings.isActive)
          Text(
            context.l10n.deactivatedForGame,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        Text(
          // TODO Océane c'est cassé là parce que je suis pas branché sur changeContractsSettings
          context.l10n.contractRules(widget.contract, settings),
        ),
      ],
    );
  }

  /// Builds the settings widget
  Widget _buildSettings() {
    return switch (widget.contract) {
      ContractsInfo.barbu ||
      ContractsInfo.noHearts ||
      ContractsInfo.noQueens ||
      ContractsInfo.noTricks ||
      ContractsInfo.noLastTrick ||
      ContractsInfo.trumps => ContractWithPointsSettingsPage(widget.contract),
      ContractsInfo.salad => SaladContractSettingsPage(),
      ContractsInfo.domino => SizedBox(
        height: 580 + MediaQuery.textScalerOf(context).scale(110),
        child: DominoContractSettingsPage(),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(
      changeContractsSettingsProvider(widget.contract),
    );
    return Semantics(
      expanded: _isExpanded,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              _buildHeader(settings),
              if (widget.previousContractDividerColor != null)
                Container(
                  width: borderWidth,
                  color: widget.previousContractDividerColor,
                  height: 40,
                ),
            ],
          ),
          Container(
            color: borderColor,
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(horizontal: borderWidth),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: borderRadius),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SizeTransition(
                sizeFactor: _animationContent,
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 400),
                    firstChild: _buildRules(settings),
                    secondChild: _buildSettings(),
                    crossFadeState: _isSettingsView
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
