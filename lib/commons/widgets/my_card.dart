import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final List<Widget> children;

  const MyCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.greyBackground,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: children.length,
        separatorBuilder: (_, _) => Divider(),
        itemBuilder: (_, index) => children[index],
      ),
    );
  }
}
