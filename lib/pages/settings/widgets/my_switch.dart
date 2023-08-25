import 'package:flutter/material.dart';

/// A statefull switch widget
class MySwitch extends StatefulWidget {
  final bool isActive;
  final Function(bool) onChanged;

  const MySwitch({super.key, required this.isActive, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _MySwitch();
}

class _MySwitch extends State<MySwitch> {
  bool? value;

  @override
  void initState() {
    super.initState();
    value = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value!,
      onChanged: (bool newValue) {
        setState(() {
          value = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
