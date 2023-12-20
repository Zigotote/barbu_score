import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/contract_settings_provider.dart';

/// An indicator to know if the contract is active or disabled in the settings
class ActiveContractIndicator extends ConsumerStatefulWidget {
  /// The contract linked to this indicator
  final ContractsInfo contract;

  const ActiveContractIndicator({super.key, required this.contract});

  @override
  ConsumerState<ActiveContractIndicator> createState() =>
      _ActiveContractIndicatorState();
}

class _ActiveContractIndicatorState
    extends ConsumerState<ActiveContractIndicator> {
  late bool isActive;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(contractSettingsProvider(widget.contract));
    isActive = provider.settings.isActive;

    final sucessColor = Theme.of(context).colorScheme.success;
    final disabledColor = Theme.of(context).disabledColor;
    return OutlinedButton(
      onPressed: provider.canModify
          ? () => provider.modifySetting((_) {
                provider.settings.isActive = !isActive;
                setState(() => isActive = !isActive);
              })!.call(null)
          : null,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isActive ? sucessColor : disabledColor,
          width: 2,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(0, 0),
        padding: const EdgeInsets.all(8),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        disabledForegroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: isActive
            ? sucessColor.withOpacity(0.3)
            : disabledColor.withOpacity(0.3),
      ),
      child: isActive ? const Text("ON") : const Text("OFF"),
    );
  }
}
