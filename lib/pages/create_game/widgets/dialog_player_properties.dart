import 'package:barbu_score/theme/my_themes.dart';
import 'package:barbu_score/utils/screen.dart';
import 'package:barbu_score/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprintf/sprintf.dart';

import '../../../models/player.dart';
import '../../../widgets/player_icon.dart';
import '../create_game_props.dart';
import '../notifiers/create_game.dart';

/// A dialog to change a player's informations
class DialogChangePlayerInfo extends ConsumerWidget {
  /// The player to change the infos
  final Player player;

  /// The function to call on validated button pressed
  final Function() onValidate;

  /// The function to call on deleted button pressed
  final Function() onDelete;

  const DialogChangePlayerInfo(
      {super.key,
      required this.player,
      required this.onValidate,
      required this.onDelete});

  /// Builds the title of the widget
  Widget _buildTitle(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        PlayerIcon(
          image: player.image,
          color: player.color,
          size: ScreenHelper.width * 0.25,
        ),
        Positioned(
          right: -24,
          top: -16,
          child: OutlinedButtonNoBorder(
            onPressed: context.pop,
            child: Icon(Icons.close),
          ),
        )
      ],
    );
  }

  /// Builds the title and list of items the player can modify
  Widget _buildPropertySelection(
      BuildContext context, String text, List<Widget> items) {
    final double buttonSpacing = ScreenHelper.width * 0.05;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(text, style: Theme.of(context).textTheme.titleLarge),
        ),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: buttonSpacing,
          crossAxisSpacing: buttonSpacing,
          crossAxisCount: 3,
          children: items,
        ),
      ],
    );
  }

  ElevatedButton _buildActionButton(
      IconData icon, String text, Color color, Function() action) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: action,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: color, width: 2),
        padding: EdgeInsets.all(8),
        foregroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(createGameProvider);
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: _buildTitle(context),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          height: ScreenHelper.height * 0.643,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertySelection(
                context,
                "Couleur",
                provider.playerColors
                    .map(
                      (color) => OutlinedButtonNoBorder(
                        backgroundColor: color,
                        onPressed: () =>
                            provider.changePlayerColor(player, color),
                        child: Text(
                          provider.getPlayersWithColor(color),
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16),
              _buildPropertySelection(
                context,
                "Avatar",
                List.generate(
                  kNbPlayersMax,
                  (index) => sprintf(kPlayerImageFolder, [index + 1]),
                )
                    .map(
                      (image) => OutlinedButtonNoBorder(
                        onPressed: () =>
                            provider.changePlayerImage(player, image),
                        child: PlayerIcon(image: image, size: double.maxFinite),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
      actions: [
        _buildActionButton(
          Icons.delete_forever_outlined,
          "Supprimer",
          theme.colorScheme.error,
          onDelete,
        ),
        _buildActionButton(
          Icons.done,
          "Valider",
          theme.colorScheme.successColor,
          onValidate,
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    );
  }
}
