import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/pages/create_game/notifiers/create_game.dart';
import 'package:barbu_score/pages/create_game/widgets/dialog_player_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../utils.dart';

main() {
  patrolWidgetTest("should display dialog", ($) async {
    final players = _generatePlayers();
    await $.pumpWidget(_createPage(players));

    expect($.tester.takeException(), isNull);
    expect($("Couleur"), findsOneWidget);
    expect($("Avatar"), findsOneWidget);
    expect($("X"), findsNWidgets(nbPlayersByDefault));

    // Verify player icon
    final player = players[0];
    expect(findPlayerIcon($).color, player.color);
    expect(findPlayerIcon($).image, player.image);
  });
  for (var hasName in [true, false]) {
    patrolWidgetTest(
        "should display ${hasName ? "" : "default "}player names in colors",
        ($) async {
      final players = _generatePlayers(withName: hasName);
      await $.pumpWidget(_createPage(players));

      for (var (index, color) in playerColors.indexed) {
        final playerInitials = hasName && index < players.length
            ? players[index].name.characters.first
            : "X";
        expect(
          _findPlayerNameInColor($, color, playerInitials),
          index < players.length ? findsOneWidget : findsNothing,
        );
      }
    });
  }
  patrolWidgetTest("should display player names with same colors", ($) async {
    final players = _generatePlayers(withName: true, withSameColor: true);
    await $.pumpWidget(_createPage(players));

    final playerInitials =
        players.map((player) => player.name.characters.first).join("/");
    expect(
      _findPlayerNameInColor($, playerColors[0], playerInitials),
      findsOneWidget,
    );
  });
  patrolWidgetTest("should change player color", ($) async {
    final players = _generatePlayers(withName: true);
    await $.pumpWidget(_createPage(players));

    final playerInitial = players[0].name.characters.first;
    final oldColor = players[0].color;
    expect(findPlayerIcon($).color, oldColor);
    expect(
      _findPlayerNameInColor($, oldColor, playerInitial),
      findsOneWidget,
    );

    final newColor = playerColors[playerColors.length - 1];
    await $(Key(newColor.name)).tap();

    expect(
      _findPlayerNameInColor($, oldColor, ""),
      findsOneWidget,
    );
    expect(
      _findPlayerNameInColor($, newColor, playerInitial),
      findsOneWidget,
    );
    expect(findPlayerIcon($).color, newColor);
  });
  patrolWidgetTest("should change player icon", ($) async {
    final players = _generatePlayers(withName: true);
    await $.pumpWidget(_createPage(players));

    final oldImage = players[0].image;
    expect(findPlayerIcon($).image, oldImage);

    final newImage = playerImages[playerImages.length - 1];
    await $(Key(newImage)).tap();

    expect(findPlayerIcon($).image, newImage);
  });
}

Finder _findPlayerNameInColor(
    PatrolTester $, PlayerColors color, String playerInitials) {
  return find.descendant(
    of: $(Key(color.name)),
    matching: $(playerInitials),
  );
}

List<Player> _generatePlayers(
    {bool withName = false, bool withSameColor = false}) {
  return List.generate(
    nbPlayersByDefault,
    (index) => Player.create(
      name: withName ? defaultPlayerNames[index] : null,
      color: playerColors[withSameColor ? 0 : index],
      image: playerImages[index],
    ),
  );
}

Widget _createPage(List<Player> players) {
  final container = ProviderContainer(
    overrides: [
      createGameProvider.overrideWith((ref) => CreateGameNotifier(players)),
    ],
  );
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: DialogChangePlayerInfo(
        player: players[0],
        onDelete: () {},
        onValidate: () {},
      ),
    ),
  );
}
