import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:sprintf/sprintf.dart';

import 'globals.dart';

/// A class to get the properties available to configure players icons
class PlayerIconProperties {
  static final _isDecember = DateTime.now().month == 12;

  PlayerIconProperties._();

  /// Returns the list of player images available
  static List<String> get playerImages {
    const nbImages = 13;
    const christmasImageSuffix = "_christmas";
    return List.generate(nbImages, (index) {
      if (_isDecember) {
        if (index == 0) {
          return sprintf(kPlayerImageFolder, [christmasImageSuffix]);
        } else {
          return sprintf(kPlayerImageFolder, [index]);
        }
      } else {
        if (index == nbImages - 1) {
          return sprintf(kPlayerImageFolder, [christmasImageSuffix]);
        } else {
          return sprintf(kPlayerImageFolder, [index + 1]);
        }
      }
    });
  }

  /// Returns the list of colors available to customize the player
  static List<PlayerColors> get playerColors {
    if (_isDecember) {
      return [
        PlayerColors.red,
        ...PlayerColors.values.where((color) => color != PlayerColors.red)
      ];
    }
    return PlayerColors.values;
  }
}
