import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './my_appbar.dart';
import '../controller/contract.dart';
import '../controller/party.dart';
import '../main.dart';
import '../models/contract_names.dart';
import '../models/route_argument.dart';
import '../widgets/my_subtitle.dart';

/// A page with a beautiful layout
class DefaultPage extends GetWidget {
  /// The title of the page
  final String title;

  /// The widget for the content of the page
  final Widget content;

  /// The widget to display at the bottom of the page
  final Widget? bottomWidget;

  /// True if the background has to be drawn
  final bool hasBackground;

  /// True if a go back leading should be displayed before the title of the page
  final bool hasLeading;

  DefaultPage(
      {required this.title,
      required this.content,
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
          horizontal: 16,
          vertical: 16,
        ),
        child: this.content,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
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
    required this.subtitle,
    required this.child,
    required this.contract,
  });

  /// Saves the score for this contract and moves to the next player round
  void _saveScore() {
    if (Routes.isPartOfTrumpsContract() &&
        !(controller is TrumpsScoresController)) {
      /// Adds the contract to the trumps contract
      Get.find<TrumpsScoresController>()
          .addContract(this.contract, controller.playerScores);
      Get.toNamed(
        Routes.TRUMPS_SCORES,
        arguments: RouteArgument(
          contractName: ContractsNames.Trumps,
          contractValues: null,
        ),
      );
    } else {
      /// Finishes the contract
      party.finishContract(contract, controller.playerScores);
    }
    Get.delete<T>();
  }

  @override
  Widget build(BuildContext context) {
    String title = "Tour de ${party.currentPlayer.name}";
    String validateText = "Valider les scores";
    if ((Get.arguments as RouteArgument).isForModification) {
      title = "Modification ${this.contract.displayName}";
      validateText = "Modifier les scores";
    }
    return DefaultPage(
      title: title,
      hasLeading: true,
      content: Column(
        children: [
          MySubtitle(this.subtitle),
          this.child,
        ],
      ),
      bottomWidget: Obx(
        () => ElevatedButton(
          child: Text(validateText),
          onPressed: controller.isValid ? _saveScore : null,
        ),
      ),
    );
  }
}
