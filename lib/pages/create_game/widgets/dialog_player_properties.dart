import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/player.dart';
import '../../../commons/utils/player_icon_properties.dart';
import '../../../commons/widgets/custom_buttons.dart';
import '../../../commons/widgets/player_icon.dart';
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

  /// Builds the title and list of items the player can modify
  Widget _buildPropertySelection(
      BuildContext context, String text, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(text, style: Theme.of(context).textTheme.titleLarge),
        ),
        GridView.extent(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          maxCrossAxisExtent: 75,
          children: items,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(createGameProvider);
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: PlayerIcon(
        image: player.image,
        color: player.color,
      ),
      icon: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: BorderSide.none,
          ),
          tooltip: context.l10n.close,
        ),
      ),
      iconPadding: const EdgeInsets.only(top: 16, right: 16),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _buildPropertySelection(
                context,
                context.l10n.color,
                playerColors.map(
                  (color) {
                    final playersWithColor =
                        provider.getPlayersWithColor(color);
                    return TextButton(
                      key: Key(color.name),
                      onPressed: () =>
                          provider.changePlayerColor(player, color),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .convertPlayerColor(color),
                      ),
                      child: Text(
                        playersWithColor
                            .map((playerName) =>
                                playerName.characters.first.toUpperCase())
                            .join("/"),
                        semanticsLabel: playersWithColor.isEmpty
                            ? context.l10n.availableColor
                            : playersWithColor.join(","),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
              _buildPropertySelection(
                context,
                context.l10n.avatar,
                playerImages
                    .map(
                      (image) => IconButton(
                        //TODO Océane ça plante sur petits téléphones, et voir si je peux améliorer le mode paysage
                        key: Key(image),
                        onPressed: () =>
                            provider.changePlayerImage(player, image),
                        icon: PlayerIcon(image: image, size: double.maxFinite),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButtonCustomColor(
          icon: Icons.delete_forever_outlined,
          text: context.l10n.delete,
          onPressed: onDelete,
          color: theme.colorScheme.error,
        ),
        ElevatedButtonCustomColor(
          icon: Icons.done,
          text: context.l10n.validate,
          onPressed: onValidate,
          color: theme.colorScheme.success,
        ),
      ],
      actionsOverflowButtonSpacing: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    );
  }
}
