import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/contract.dart';
import 'custom_buttons.dart';
import 'my_appbar.dart';

/// A page with a beautiful layout
class DefaultPage extends GetWidget {
  /// The title of the page
  final String title;

  /// The widget for the content of the page
  final Widget content;

  /// The widget to display at the bottom of the page
  final Widget bottomWidget;

  /// True if the background has to be drawn
  final bool hasBackground;

  DefaultPage(
      {@required this.title,
      @required this.content,
      @required this.bottomWidget,
      this.hasBackground = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(this.title),
      body: Container(
        decoration: this.hasBackground
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.015,
        ),
        child: this.content,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.015,
        ),
        child: this.bottomWidget,
      ),
    );
  }
}

/// A page for a contract scores
class ContractPage extends GetWidget<PartyController> {
  /// The controller for the contract, to know if the selected score is valid
  final ContractController contractController;

  /// The name of the current contract
  final String contractName;

  /// The widgets to fill the scores
  final Widget child;

  /// The function to call on next player button pressed
  final Function() onNextPlayer;

  ContractPage({
    @required this.contractName,
    @required this.child,
    @required this.onNextPlayer,
    this.contractController,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Tour de ${controller.currentPlayer.name}",
      content: Column(
        children: [
          Center(
            child: Text(
              this.contractName,
              style: Get.textTheme.subtitle2,
            ),
          ),
          this.child,
        ],
      ),
      bottomWidget: Obx(
        () => ElevatedButtonCustomColor(
          text: "Joueur suivant",
          color: contractController.isValid
              ? Get.theme.colorScheme.onSurface
              : Get.theme.disabledColor,
          onPressed: contractController.isValid ? this.onNextPlayer : null,
        ),
      ),
    );
  }
}
