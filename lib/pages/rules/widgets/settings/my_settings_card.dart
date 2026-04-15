import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

class MySettingsCard extends StatefulWidget {
  /// The children to display in the card
  final List<Widget> children;

  const MySettingsCard({super.key, required this.children});

  @override
  State<MySettingsCard> createState() => _MySettingsCardState();
}

class _MySettingsCardState extends State<MySettingsCard>
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
        child: Container(
          constraints: BoxConstraints(minHeight: 48),
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                spacing: 8,
                children: [
                  Icon(Icons.settings),
                  Expanded(
                    child: Text(
                      context.l10n.settings,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(
                    isOpened
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                  ),
                ],
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
