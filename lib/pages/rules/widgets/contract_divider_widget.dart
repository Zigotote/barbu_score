import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/notifiers/change_contracts_settings.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';

class ContractDividerWidget extends ConsumerWidget {
  static const Radius borderRadius = Radius.circular(15);

  static const double borderWidth = 3;

  final ContractsInfo contract;
  final Color? previousContractDividerColor;

  const ContractDividerWidget({
    super.key,
    required this.contract,
    this.previousContractDividerColor,
  });

  Color borderColor(BuildContext context) => Theme.of(
    context,
  ).colorScheme.convertMyColor(contract.color, isBackgroundColor: true);

  /// Builds the header of the divider, which contains the contract name, the arrow to expand/collapse the divider and the button to switch between settings and rules display
  Widget _buildHeader(BuildContext context, AbstractContractSettings settings) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildDividerName(context, settings),
        Expanded(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 16,
                decoration: BoxDecoration(color: borderColor(context)),
              ),
              _buildCardButton(context),
            ],
          ),
        ),
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topRight: borderRadius),
            color: borderColor(context),
          ),
        ),
      ],
    );
  }

  /// Builds the button for the card
  Widget _buildCardButton(BuildContext context) {
    return IconButton(
      onPressed: () => context.push(contract.settingsRoute),
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: borderRadius),
            side: BorderSide(width: borderWidth, color: borderColor(context)),
          ),
        ),
      ),
      icon: Icon(Icons.settings),
      tooltip: context.l10n.settings,
    );
  }

  /// Builds the content of divider header, with the name of the contract and the button to toggle expansion
  Widget _buildDividerName(
    BuildContext context,
    AbstractContractSettings settings,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: borderRadius),
        color: borderColor(context),
      ),
      child: Row(
        children: [
          Semantics(
            header: true,
            child: Text(
              context.l10n.contractName(contract),
              style: settings.isActive
                  ? null
                  : const TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.lineThrough,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the rules widget
  Widget _buildRules(
    BuildContext context,
    WidgetRef ref,
    AbstractContractSettings settings,
  ) {
    return Column(
      key: Key(contract.name),
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (!settings.isActive)
          Text(
            context.l10n.deactivatedForGame,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        Text(context.l10n.contractRules(contract, settings)),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(changeContractsSettingsProvider(contract));
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            _buildHeader(context, settings),
            if (previousContractDividerColor != null) ...[
              Positioned(
                left: 0,
                child: Container(
                  width: borderWidth,
                  height: 20,
                  decoration: BoxDecoration(
                    color: previousContractDividerColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: borderRadius,
                    ),
                  ),
                ),
              ),
              Container(
                width: borderWidth,
                height: 40,
                decoration: BoxDecoration(
                  color: previousContractDividerColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: borderRadius,
                  ),
                ),
              ),
            ],
          ],
        ),
        Container(
          color: borderColor(context),
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: borderWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: borderRadius),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: _buildRules(context, ref, settings),
          ),
        ),
      ],
    );
  }
}
