import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends AppBar {
  final bool isHome;

  MyAppBar(String title, {this.isHome = false})
      : super(
          title: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Divider(
                color: Get.theme.colorScheme.onSurface,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: isHome
                      ? Get.theme.textTheme.headline3
                          .copyWith(color: Get.theme.colorScheme.onSurface)
                      : Get.theme.textTheme.headline5
                          .copyWith(color: Get.theme.colorScheme.onSurface),
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          leadingWidth: 0,
        );
}
