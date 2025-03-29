import 'dart:math';

import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../../../commons/models/player_colors.dart';

class _MovingCard {
  final String iconName;
  final Color iconColor;
  Offset direction;
  Offset position;

  _MovingCard(
      {required this.iconName,
      required this.iconColor,
      required this.position,
      required this.direction});
}

class MovingCards extends StatefulWidget {
  const MovingCards({super.key});

  @override
  State<MovingCards> createState() => _MovingCardsState();
}

class _MovingCardsState extends State<MovingCards>
    with TickerProviderStateMixin {
  static const double _cardSize = 64;

  late final AnimationController controller;

  // The list of moving card has to be initialized here so that context is accessible, to choose the color and position of each card
  late final List<_MovingCard> movingCards = [
    _createRandomCard("heart"),
    _createRandomCard("diamond"),
    _createRandomCard("clover"),
    _createRandomCard("spades"),
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    );
    controller.addListener(() {
      setState(() {
        // Randomly move cards, from https://medium.com/@sheikhbahaie.golnar/create-random-objects-movement-in-flutter-b5991d2ab866
        for (_MovingCard card in movingCards) {
          card.position += card.direction;

          if (card.position.dx <= 0 ||
              card.position.dx + _cardSize >=
                  MediaQuery.of(context).size.width) {
            card.direction = Offset(-card.direction.dx, card.direction.dy);
          }
          if (card.position.dy <= 0 ||
              card.position.dy + _cardSize >=
                  MediaQuery.of(context).size.height) {
            card.direction = Offset(card.direction.dx, -card.direction.dy);
          }
        }
      });
    });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Creates a card with an icon and rondom color, position and direction
  _MovingCard _createRandomCard(String image) {
    return _MovingCard(
      iconName: "assets/icons/$image.png",
      iconColor: Theme.of(context).colorScheme.convertPlayerColor(
            PlayerColors
                .values[Random().nextInt(PlayerColors.values.length - 1)],
          ),
      position: Offset(
        Random().nextInt(MediaQuery.of(context).size.width.toInt()).toDouble(),
        Random().nextInt(MediaQuery.of(context).size.height.toInt()).toDouble(),
      ),
      direction: Offset(
        Random().nextBool() ? -1.0 : 1.0,
        Random().nextBool() ? -1.0 : 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...movingCards.map(
          (card) => Positioned(
            top: card.position.dy,
            left: card.position.dx,
            child: Image.asset(card.iconName, color: card.iconColor),
          ),
        ),
      ],
    );
  }
}
