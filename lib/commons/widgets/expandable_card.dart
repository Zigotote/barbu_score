import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

enum ExpandableCardType {
  settings(Icons.settings),
  rules(Icons.history_edu_outlined);

  final IconData icon;

  const ExpandableCardType(this.icon);

  String title(BuildContext context) {
    return switch (this) {
      ExpandableCardType.settings => context.l10n.settings,
      ExpandableCardType.rules => context.l10n.rules,
    };
  }
}

class ExpandableCard extends StatefulWidget {
  /// The type of the card. The header of the card changes depending on its type. If no type, title must be set
  final ExpandableCardType? type;

  /// The title of the card. Used to overload [type.title]
  final String? title;

  /// The children to display in the card
  final List<Widget> children;

  const ExpandableCard({super.key, required this.title, required this.children})
    : type = null;

  const ExpandableCard.type({
    super.key,
    required this.type,
    required this.children,
  }) : title = null;

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with TickerProviderStateMixin {
  /// The indicator to know if card is opened or not
  bool isOpened = false;

  /// The controller for the animation
  late final AnimationController _controller;

  /// The animation
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: () {
          final newIsOpened = !isOpened;
          setState(() => isOpened = newIsOpened);
          if (newIsOpened) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        customBorder: Theme.of(context).cardTheme.shape,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 32),
                child: Row(
                  spacing: 8,
                  children: [
                    if (widget.type != null) Icon(widget.type!.icon),
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          widget.title ?? widget.type!.title(context),
                          style: widget.title != null && !isOpened
                              ? textTheme.titleLarge
                              : textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Icon(
                      isOpened
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                    ),
                  ],
                ),
              ),
              SizeTransition(
                sizeFactor: _animation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.children.length,
                    separatorBuilder: (_, _) => Divider(),
                    itemBuilder: (_, index) => widget.children[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
