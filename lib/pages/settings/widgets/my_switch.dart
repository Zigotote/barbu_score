import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

/// A stateful switch widget
class MySwitch extends StatefulWidget {
  final bool isActive;
  final Function(bool)? onChanged;

  /// The alert to display before changing the switch value
  final MyAlertDialog? alertOnChange;

  const MySwitch(
      {super.key,
      required this.isActive,
      required this.onChanged,
      this.alertOnChange});

  @override
  State<StatefulWidget> createState() => _MySwitch();
}

class _MySwitch extends State<MySwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.isActive;
  }

  @override
  void didUpdateWidget(covariant MySwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() => value = widget.isActive);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: value ? context.l10n.activated : context.l10n.deactivated,
      child: Switch(
        value: value,
        onChanged: widget.onChanged != null
            ? widget.alertOnChange != null
                ? (_) => showDialog(
                      context: context,
                      builder: (_) => widget.alertOnChange!,
                    )
                : (bool newValue) {
                    setState(() {
                      value = newValue;
                    });
                    widget.onChanged!(newValue);
                  }
            : null,
      ),
    );
  }
}
