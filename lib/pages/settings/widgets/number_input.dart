import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../commons/utils/screen.dart';

/// A widget to enter some points
class NumberInput extends StatelessWidget {
  /// The contract to wich the score is linked
  final int points;

  /// The function to call on value changed
  final void Function(int) onChanged;

  /// The controller for the text input
  final TextEditingController _controller;

  NumberInput({required this.points, required this.onChanged, super.key})
      : _controller = TextEditingController(text: points.toString());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenHelper.width * 0.15,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'-?[0-9]*'))
        ],
        onTapOutside: (_) => onChanged(int.parse(_controller.value.text)),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          isDense: true,
        ),
      ),
    );
  }
}
