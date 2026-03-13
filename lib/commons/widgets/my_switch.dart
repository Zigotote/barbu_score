import 'package:flutter/material.dart';

/// A stateful switch widget
class MySwitch extends StatefulWidget {
  final bool isActive;
  final Function(bool)? onChanged;

  /// The icon to use if switch is active. If not set, use default switch icon
  final Icon? isActiveIcon;

  /// The icon to use if switch is inactive. If not set, use default switch icon
  final Icon? isInactiveIcon;

  const MySwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
    this.isActiveIcon,
    this.isInactiveIcon,
  });

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
    return Switch(
      value: value,
      onChanged: widget.onChanged != null
          ? (bool newValue) async {
              if (await widget.onChanged!(newValue) != false) {
                setState(() {
                  value = newValue;
                });
              }
            }
          : null,
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.any((element) => (element == WidgetState.selected))) {
          return widget.isActiveIcon;
        }
        return widget.isInactiveIcon;
      }),
    );
  }
}
