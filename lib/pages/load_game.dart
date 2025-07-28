import 'package:barbu_score/commons/providers/locale_provider.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/default_page.dart';
import 'package:barbu_score/commons/widgets/my_appbar.dart';
import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LoadGame extends ConsumerWidget {
  const LoadGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storedGames = ref.watch(storageProvider).getStoredGames();
    return DefaultPage(
      appBar: MyAppBar(Text(context.l10n.loadGame), context: context),
      content: storedGames?.isNotEmpty ?? false
          ? ListView.separated(
              padding: EdgeInsets.only(top: 16),
              separatorBuilder: (_, __) => SizedBox(height: 16),
              itemCount: storedGames!.length,
              itemBuilder: (_, index) {
                final game = storedGames[index];
                return ElevatedButton(
                  child: Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMd(
                                ref.read(localeProvider).languageCode,
                              ).format(game.startDate),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 8),
                            Text(
                              game.players
                                  .map((player) => player.name)
                                  .join(", "),
                            ),
                            SizedBox(height: 16),
                            Row(
                              spacing: 8,
                              children: game.players
                                  .map(
                                    (player) => PlayerIcon(
                                      image: player.image,
                                      color: player.color,
                                      size: 40,
                                    ),
                                  )
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                  onPressed: () {},
                );
              },
            )
          : Text("Empty"),
    );
  }
}
