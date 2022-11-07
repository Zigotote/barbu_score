import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends AppBar {
  MyAppBar(String title, {bool isHome = false, bool hasLeading = false})
      : super(
          leading: hasLeading
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                  onPressed: Get.back,
                )
              : null,
          leadingWidth: hasLeading ? 32 : 0,
          title: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Divider(),
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: isHome
                      ? Get.textTheme.headline3!
                          .copyWith(color: Get.theme.colorScheme.onSurface)
                      : Get.textTheme.headline5!
                          .copyWith(color: Get.theme.colorScheme.onSurface),
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
        );
}
