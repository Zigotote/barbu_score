import 'dart:math';

import 'package:barbu_score/controller/party.dart';
import 'package:barbu_score/controller/player.dart';
import 'package:barbu_score/widgets/player_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import '../main.dart';
import '../widgets/page_layouts.dart';

/// A page to be sure the players and the cards are ready to start
class PrepareParty extends GetView<PartyController> {
  final double _circleDiameter = Get.width * 0.5;
  final double _playerIconSize = Get.width * 0.125;

  double get _circleRadius => _circleDiameter / 2;

  /// Returns the values of the cards to take out for the party
  List<int> _getCardsToTakeOut() {
    return List.generate(
        (52 - controller.nbPlayers * 8) ~/ 4, (index) => 2 + index);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Préparer la partie",
      hasLeading: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Text("Retirer toutes les cartes"),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _getCardsToTakeOut().join(", "),
                  style: Get.textTheme.subtitle2,
                ),
              ),
              Text("du paquet."),
            ],
          ),
          Container(
            width: double.infinity,
            height: _circleDiameter + _playerIconSize * 2,
            child: _buildTable(),
          ),
        ],
      ),
      bottomWidget: ElevatedButton(
        child: Text("C'est parti !"),
        onPressed: () {
          Wakelock.enable();
          Get.toNamed(Routes.CHOOSE_CONTRACT);
        },
      ),
    );
  }

  Stack _buildTable() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: CircularText(
            children: [
              TextItem(
                text: Text(
                  "La table",
                  style: Get.textTheme.subtitle2!.copyWith(
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
                space: 6,
                startAngle: 270,
                startAngleAlignment: StartAngleAlignment.center,
              )
            ],
            radius: _circleRadius + _playerIconSize,
          ),
        ),
        Positioned(
          top: _playerIconSize,
          child: Container(
            width: _circleDiameter,
            height: _circleDiameter,
            margin: EdgeInsets.all(_playerIconSize / 2),
            decoration: new BoxDecoration(
              border: Border.all(
                color: Get.theme.colorScheme.onSurface,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: _buildPlayers(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPlayers() {
    final theta = ((pi * 2) / (controller.nbPlayers * 2));
    return List.generate(
      controller.nbPlayers * 2,
      (index) {
        final angle = (theta * index);
        final topPosition = _circleRadius * -cos(angle) + _circleRadius;
        final leftPosition = _circleRadius * sin(angle) + _circleRadius;
        if (index % 2 == 0) {
          PlayerController player = controller.players[index ~/ 2];
          return Positioned(
            top: topPosition - _playerIconSize / 2,
            left: leftPosition - _playerIconSize,
            // specifies a width to be able to position the widget from its center (otherwise players with long names are not centered)
            width: _playerIconSize * 2,
            child: Column(
              children: [
                PlayerIcon(
                  image: player.image,
                  color: player.color,
                  size: _playerIconSize,
                ),
                Text(
                  player.name,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Positioned(
            top: topPosition - _playerIconSize / 3.5,
            left: leftPosition - _playerIconSize / 3.5,
            width: _playerIconSize / 2,
            height: _playerIconSize / 2,
            child: Transform.rotate(
              angle: angle,
              child: Icon(Icons.arrow_forward_ios_rounded),
            ),
          );
        }
      },
    ).toList();
  }
}
