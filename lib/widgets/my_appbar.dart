import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends AppBar {
  MyAppBar(BuildContext context, String title,
      {bool isHome = false, bool hasLeading = false})
      : super(
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
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: isHome
                      ? Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)
                      : Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  child: IconButton.outlined(
                    icon: Icon(Icons.arrow_back),
                    onPressed: Get.back,
                  ),
                  visible: hasLeading,
                ),
              ),
            ],
          ),
          forceMaterialTransparency: true,
          elevation: 0,
        );
}
