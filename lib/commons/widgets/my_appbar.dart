import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../models/player.dart';
import 'my_tabbar.dart';
import 'player_icon.dart';

class MyAppBar extends AppBar {
  /// The tabs to display at the bottom of the appBar
  final List<Tab>? tabs;

  MyAppBar(
    Widget title, {
    super.key,
    required BuildContext context,
    bool hasLeading = true,
    IconButton? trailing,
    this.tabs,
  }) : super(
          toolbarHeight: _calculateToolbarHeight(context, title),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          centerTitle: true,
          forceMaterialTransparency: true,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.center,
              height: _calculateToolbarHeight(context, title),
              child: Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          leading: hasLeading && context.canPop()
              ? IconButton.outlined(
                  tooltip: "Retour",
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      context.pop();
                    } catch (_) {
                      context.push(Routes.home);
                    }
                  })
              : null,
          title: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Semantics(header: true, child: title),
          ),
          actions: trailing != null ? [trailing] : null,
          bottom: tabs == null ? null : MyTabBar(tabs),
        );

  static double _calculateToolbarHeight(BuildContext context, Widget title) {
    return (Theme.of(context).textTheme.titleLarge?.fontSize ?? 1) *
        (title is Text ? 2 : 4);
  }
}

class MyPlayerAppBar extends MyAppBar {
  MyPlayerAppBar({
    super.key,
    required Player player,
    required super.context,
    super.trailing,
  }) : super(
          Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayerIcon(
                image: player.image,
                color: player.color,
                size: 60,
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(context.l10n.playerTurn), Text(player.name)],
                ),
              )
            ],
          ),
        );
}
