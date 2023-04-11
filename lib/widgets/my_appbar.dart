import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends AppBar {
  MyAppBar(String title, {bool isHome = false, bool hasLeading = false})
      : super(
          leading: Visibility(
            child: BackButton(
              color: Get.theme.colorScheme.onSurface,
              onPressed: Get.back,
            ),
            visible: hasLeading,
          ),
          leadingWidth: hasLeading ? 32 : 0,
          title: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Divider(thickness: 1),
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
            ],
          ),
          elevation: 0,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
        );
}
