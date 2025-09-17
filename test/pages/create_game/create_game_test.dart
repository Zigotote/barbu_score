import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/create_game/create_game.dart';
import 'package:barbu_score/pages/create_game/widgets/create_player.dart';
import 'package:barbu_score/pages/create_game/widgets/dialog_player_properties.dart';
import 'package:barbu_score/pages/prepare_game/prepare_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

const basePlayerName = "Player";

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(_createPage($));

    expect($.tester.takeException(), isNull);
    expect($("Créer les joueurs"), findsOneWidget);
    expect($(CreatePlayer), findsNWidgets(nbPlayersByDefault));
    // await checkAccessibility($.tester); not accessible because delete player button is too small. But players can be deleted by clicking on there icon, so it's OK
  });
  for (var nbPlayers = 1; nbPlayers < kNbPlayersMin; nbPlayers++) {
    patrolWidgetTest("should not allow start game if $nbPlayers players", (
      $,
    ) async {
      await $.pumpWidget(_createPage($));

      // Remove players
      for (var i = kNbPlayersMin; i >= nbPlayers; i--) {
        await $(Icons.close).tap();
      }

      expect($(CreatePlayer), findsNWidgets(nbPlayers));
      expect(
        ($.tester.firstWidget($(ElevatedButton).containing($("Suivant")))
                as ElevatedButton)
            .onPressed,
        isNull,
      );
    });
  }
  for (var nbPlayers = kNbPlayersMin; nbPlayers <= kNbPlayersMax; nbPlayers++) {
    patrolWidgetTest("should start game with $nbPlayers players", ($) async {
      await $.pumpWidget(_createPage($));

      // Remove excedent players
      for (var i = nbPlayers; i < nbPlayersByDefault; i++) {
        await $(Icons.close).tap();
      }
      // Add missing players
      for (var i = nbPlayersByDefault + 1; i <= nbPlayers; i++) {
        await $(Icons.add).tap();
      }
      expect($(CreatePlayer), findsNWidgets(nbPlayers));
      for (var i = 1; i <= nbPlayers; i++) {
        expect($("Nom du joueur $i"), findsOneWidget);
      }

      await _fillPlayerNames($, nbPlayers);

      expect($(CreatePlayer), findsNWidgets(nbPlayers));
      await $("Suivant").tap();

      expect($(PrepareGame), findsOneWidget);
      for (var nbNames = 0; nbNames < nbPlayers; nbNames++) {
        expect($("$basePlayerName $nbNames"), findsOneWidget);
      }
    });
  }
  patrolWidgetTest("should show error if 2 players have same name", ($) async {
    await $.pumpWidget(_createPage($));

    await $(CreatePlayer).at(0).enterText(basePlayerName);
    await $(CreatePlayer).at(1).enterText(basePlayerName);

    await $("Suivant").tap();
    expect($("Nom déjà pris."), findsNWidgets(2));
  });
  patrolWidgetTest("should show error if player has no name", ($) async {
    await $.pumpWidget(_createPage($));

    await $("Suivant").tap();
    expect($("Indiquer un nom."), findsNWidgets(nbPlayersByDefault));
  });
  group("Actions in dialog", () {
    for (var tapClose in [true, false]) {
      patrolWidgetTest(
        "should change player color after tap ${tapClose ? "close" : "validate"} button",
        ($) async {
          await $.pumpWidget(_createPage($));
          expect(findPlayerIcon($).color, playerColors[0]);

          await $(PlayerIcon).at(0).tap();
          expect($(DialogChangePlayerInfo), findsOneWidget);

          final newPlayerColor = playerColors[nbPlayersByDefault + 1];
          await $(Key(newPlayerColor.name)).tap();

          if (tapClose) {
            await $(Icons.close).tap();
          } else {
            await $("Valider").tap();
          }
          expect(findPlayerIcon($).color, newPlayerColor);
        },
      );
      patrolWidgetTest("should change player icon", ($) async {
        await $.pumpWidget(_createPage($));
        expect(findPlayerIcon($).image, playerImages[0]);

        await $(PlayerIcon).at(0).tap();
        expect($(DialogChangePlayerInfo), findsOneWidget);

        final newPlayerImage = playerImages[nbPlayersByDefault + 1];
        await $(Key(newPlayerImage)).tap();

        if (tapClose) {
          await $(Icons.close).tap();
        } else {
          await $("Valider").tap();
        }
        expect(findPlayerIcon($).image, newPlayerImage);
      });
      patrolWidgetTest("should show error if 2 players have same color", (
        $,
      ) async {
        await $.pumpWidget(_createPage($));
        final firstPlayerColor = playerColors[0];

        await $(PlayerIcon).at(1).tap();
        expect($(DialogChangePlayerInfo), findsOneWidget);
        await $(Key(playerColors[0].name)).tap();

        await $(Icons.close).tap();

        expect(findPlayerIcon($).color, firstPlayerColor);
        expect(findPlayerIcon($, index: 1).color, firstPlayerColor);
        await _fillPlayerNames($, nbPlayersByDefault);
        await $("Suivant").tap();

        expect($("Couleur déjà prise."), findsNWidgets(2));
        expect($(PrepareGame), findsNothing);
      });
    }
    patrolWidgetTest("should remove player", ($) async {
      await $.pumpWidget(_createPage($));
      expect($(CreatePlayer), findsNWidgets(nbPlayersByDefault));

      await $(PlayerIcon).at(0).tap();
      expect($(DialogChangePlayerInfo), findsOneWidget);
      await $("Supprimer").tap();

      expect($(CreatePlayer), findsNWidgets(nbPlayersByDefault - 1));
    });
  });
}

Future<void> _fillPlayerNames(PatrolTester $, int nbPlayers) async {
  for (var nbNames = 0; nbNames < nbPlayers; nbNames++) {
    await $(CreatePlayer).at(nbNames).enterText("$basePlayerName $nbNames");
  }
}

Widget _createPage(PatrolTester $) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 3600);
  return UncontrolledProviderScope(
    container: ProviderContainer(
      overrides: [logProvider.overrideWithValue(MockMyLog())],
    ),
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => CreateGame()),
          GoRoute(
            path: Routes.prepareGame,
            builder: (_, _) => const PrepareGame(),
          ),
        ],
      ),
    ),
  );
}
