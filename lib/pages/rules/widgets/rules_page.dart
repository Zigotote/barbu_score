import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/widgets/default_page.dart';
import '../../../commons/widgets/my_appbar.dart';
import '../notifiers/turn_page.dart';
import 'arrow_icon.dart';

class RulesPage extends ConsumerWidget {
  /// The title of the page
  final String title;

  /// The widget for the content of the page
  final Widget content;

  /// The position of the page in the order of rules pages
  final int pageIndex;

  const RulesPage(
      {super.key,
      required this.title,
      required this.content,
      required this.pageIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultPage(
      appBar: MyAppBar(
        Text(title),
        context: context,
        hasLeading: false,
        trailing: IconButton.outlined(
          onPressed: context.pop,
          icon: const Icon(Icons.close),
          tooltip: "Fermer",
        ),
      ),
      content: SingleChildScrollView(child: content),
      bottomWidget: Stack(
        alignment: Alignment.center,
        children: [
          if (pageIndex != 0)
            Align(
              alignment: Alignment.centerLeft,
              heightFactor: 1,
              child: IconButton(
                onPressed: ref.read(turnPageProvider).previousPage,
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ArrowIcon(isForward: false),
                    Text(context.l10n.previous),
                  ],
                ),
              ),
            ),
          Text("${pageIndex + 1}/4"),
          if (pageIndex != 3)
            Align(
              alignment: Alignment.centerRight,
              heightFactor: 1,
              child: IconButton(
                onPressed: ref.read(turnPageProvider).nextPage,
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ArrowIcon(isForward: true),
                    Text(context.l10n.next),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
