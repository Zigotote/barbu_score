import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import 'widgets/moving_cards.dart';

class MyError extends StatelessWidget {
  const MyError({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO Océane améliorer avec l'image et les idées de Léa
    // Et penser à traduire en anglais
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MovingCards(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Placeholder(),
                Column(
                  spacing: 8,
                  children: [
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Text(
                        "Oups...",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: const Text(
                        "Une erreur s'est glissée dans l'application",
                      ),
                    )
                  ],
                ),
                ElevatedButtonFullWidth(
                  onPressed: () => context.go(Routes.home),
                  child: Text("Revenir à l'accueil"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
