import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends AppBar {
  MyAppBar(String title, {bool isHome = false, bool hasLeading = false})
      : super(
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          titleSpacing: 0,
          title: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Divider(
                thickness: 1,
                color: Get.theme.colorScheme.onSurface,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: isHome
                      ? Get.textTheme.displaySmall!
                          .copyWith(color: Get.theme.colorScheme.onSurface)
                      : Get.textTheme.headlineSmall!
                          .copyWith(color: Get.theme.colorScheme.onSurface),
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
