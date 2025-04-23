import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

/// An indicator to know if the contract is active or disabled in the settings
class ActiveContractIndicator extends StatelessWidget {
  /// True if the contract is active, false otherwise
  final bool isActive;

  const ActiveContractIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final sucessColor = Theme.of(context).colorScheme.success;
    final disabledColor = Theme.of(context).disabledColor;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: isActive ? sucessColor : disabledColor,
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: isActive
            ? Text("ON", style: TextStyle(color: sucessColor))
            : Text("OFF", style: TextStyle(color: disabledColor)),
      ),
    );
  }
}
