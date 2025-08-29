import '../../theme/my_theme_colors.dart';

final _isDecember = DateTime.now().month == 12;

/// Returns the list of player images available
List<String> get playerImages {
  const nbImages = 13;
  const christmasImageSuffix = "_christmas";
  return List.generate(nbImages, (index) {
    if (_isDecember) {
      if (index == 0) {
        return _playerImagePath(christmasImageSuffix);
      } else {
        return _playerImagePath("$index");
      }
    } else {
      if (index == nbImages - 1) {
        return _playerImagePath(christmasImageSuffix);
      } else {
        return _playerImagePath("${index + 1}");
      }
    }
  });
}

/// Returns the path of the player image
String _playerImagePath(String imageName) =>
    "assets/players/player$imageName.png";

/// Returns the list of colors available to customize the player
List<MyThemeColors> get playerColors {
  if (_isDecember) {
    return [
      MyThemeColors.red,
      ...MyThemeColors.values.where((color) => color != MyThemeColors.red)
    ];
  }
  return MyThemeColors.values;
}
