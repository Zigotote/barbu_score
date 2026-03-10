import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/providers/storage.dart';
import '../../settings/contract_with_points_settings.dart';
import '../../settings/domino_contract_settings.dart';
import '../../settings/salad_contract_settings.dart';

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
  late final Animation<double> _animation;

  @override
  void initState() {
    _isExpanded = ref
        .read(storageProvider)
        .getSettings(widget.contract)
        .isActive;
    _controller = AnimationController(
      vsync: this,
      duration: kTabScrollDuration,
    );
    _animation = CurvedAnimation(
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

  void _toggleExpansion() {
    final newIsExpanded = !_isExpanded;

    setState(() => _isExpanded = newIsExpanded);
    if (newIsExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  /// Builds the header of the divider, which contains the contract name, the arrow to expand/collapse the divider and the button to switch between settings and rules display
  Row _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildDividerName(),
        Expanded(
          child: Container(
            height: 16,
            decoration: BoxDecoration(color: borderColor),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: borderRadius,
              topRight: borderRadius,
            ),
            border: Border.all(width: borderWidth, color: borderColor),
          ),
          child: TextButton(
            onPressed: () async {
              setState(() => _isSettingsView = !_isSettingsView);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                spacing: 4,
                children: [
                  Icon(
                    _isSettingsView
                        ? Icons.history_edu_outlined
                        : Icons.settings,
                  ),
                  Text(
                    _isSettingsView ? "Règles" : "Paramètres",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
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
    );
  }

  /// Builds the content of divider header, with the name of the contract and the button to toggle expansion
  GestureDetector _buildDividerName() {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 0, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: borderRadius),
          color: borderColor,
        ),
        child: Row(
          children: [
            Semantics(
              header: true,
              child: Text(context.l10n.contractName(widget.contract)),
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
            textAlign: TextAlign.justify,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        Text(
          context.l10n.contractRules(
            widget.contract,
            ref.read(storageProvider),
          ),
          textAlign: TextAlign.justify,
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
      ContractsInfo.noLastTrick => ContractWithPointsSettingsPage(
        widget.contract,
      ),
      ContractsInfo.salad => SaladContractSettingsPage(),
      ContractsInfo.domino => DominoContractSettingsPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(storageProvider).getSettings(widget.contract);
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            _buildHeader(),
            if (widget.previousContractDividerColor != null)
              Container(
                width: borderWidth,
                color: widget.previousContractDividerColor,
                height: MediaQuery.textScalerOf(context).scale(40),
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
              sizeFactor: _animation,
              child: _buildRules(settings),
            ),
          ),
        ),
      ],
    );
  }
}
