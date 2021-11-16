import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './custom_buttons.dart';
import './my_appbar.dart';
import '../controller/contract.dart';
import '../controller/party.dart';
import '../main.dart';
import '../models/contract_names.dart';

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

  /// True if a go back leading should be displayed before the title of the page
  final bool hasLeading;

  DefaultPage(
      {@required this.title,
      @required this.content,
      this.bottomWidget,
      this.hasBackground = false,
      this.hasLeading = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        this.title,
        hasLeading: this.hasLeading,
      ),
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
class ContractPage<T extends AbstractContractController> extends GetWidget<T> {
  final PartyController party = Get.find<PartyController>();

  /// The contract actually displayed
  final ContractsNames contract;

  /// The subtitle to explain the action that needs to be done
  final String subtitle;

  /// The widgets to fill the scores
  final Widget child;

  ContractPage({
    @required this.subtitle,
    @required this.child,
    @required this.contract,
  });

  /// Saves the score for this contract and moves to the next player round
  void _saveScore() {
    try {
      final TrumpsScoresController trumpsController =
          Get.find<TrumpsScoresController>();
      if (controller != trumpsController) {
        trumpsController.addContract(this.contract, controller.playerScores);
        Get.toNamed(Routes.TRUMPS_SCORES);
      } else {
        party.finishContract(contract, controller.playerScores);
      }
    } on String catch (_) {
      // When their is no TrumpsScoresController, which means it is a regular contract that needs to be finished
      party.finishContract(contract, controller.playerScores);
    } finally {
      Get.delete<T>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Tour de ${party.currentPlayer.name}",
      content: Column(
        children: [
          Center(
            child: Text(
              this.subtitle,
              style: Get.textTheme.subtitle2,
            ),
          ),
          this.child,
        ],
      ),
      bottomWidget: Obx(
        () => ElevatedButtonCustomColor(
          text: "Valider les scores",
          color: controller.isValid
              ? Get.theme.colorScheme.onSurface
              : Get.theme.disabledColor,
          onPressed: controller.isValid ? _saveScore : null,
        ),
      ),
    );
  }
}
