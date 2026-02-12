import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

class MyDropdownMenu extends DropdownMenu {
  MyDropdownMenu({
    super.key,
    required BuildContext context,
    required super.dropdownMenuEntries,
    super.initialSelection,
    super.onSelected,
  }) : super(
         width: MediaQuery.of(context).textScaler.scale(100),
         trailingIcon: Semantics(
           label: context.l10n.unfold,
           child: const Icon(Icons.keyboard_arrow_down),
         ),
         selectedTrailingIcon: Semantics(
           label: context.l10n.fold,
           child: const Icon(Icons.keyboard_arrow_up),
         ),
       );
}
