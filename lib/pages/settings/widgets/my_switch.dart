import 'package:flutter/material.dart';

/// A stateful switch widget
class MySwitch extends StatefulWidget {
  final bool isActive;
  final Function(bool)? onChanged;

  const MySwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
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
    );
  }
}
