import 'package:flutter/material.dart';

import '../../main.dart';
import 'my_tabbar.dart';

class MyAppBar extends AppBar {
  MyAppBar(
    BuildContext context,
    String title, {
    super.key,
    bool isHome = false,
    bool hasLeading = false,
    List<Tab>? tabs,
  }) : super(
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          titleSpacing: 0,
          title: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: hasLeading,
                  child: IconButton.outlined(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      try {
                        Navigator.of(context).pop();
                      } catch (_) {
                        Navigator.of(context).pushNamed(Routes.home);
                      }
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: isHome
                      ? Theme.of(context).textTheme.displaySmall
                      : Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          forceMaterialTransparency: true,
          elevation: 0,
          bottom: tabs == null ? null : MyTabBar(tabs),
        );
}
