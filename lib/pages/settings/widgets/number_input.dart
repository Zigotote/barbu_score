import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget to enter some points
class NumberInput extends StatefulWidget {
  /// The contract to wich the score is linked
  final int points;

  /// The function to call on value changed
  final void Function(int)? onChanged;

  /// The object to control input focus
  final FocusNode? focusNode;

  const NumberInput(
      {required this.points,
      required this.onChanged,
      this.focusNode,
      super.key});

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  /// The controller for the text input
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.points.toString());
    _controller.addListener(
      () => widget.onChanged?.call(int.tryParse(_controller.text) ?? 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      child: TextField(
        focusNode: widget.focusNode,
        controller: _controller,
        textAlign: TextAlign.end,
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'-?[0-9]*'))
        ],
        enabled: widget.onChanged != null,
      ),
    );
  }
}
