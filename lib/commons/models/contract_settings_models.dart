import 'package:hive/hive.dart';

part 'contract_settings_models.g.dart';

/// An abstract class to save the settings of a contract
abstract class AbstractContractSettings {
  /// The indicator to know if the user wants to have this contract in its games or not
  @HiveField(0)
  bool isActive;

  AbstractContractSettings({this.isActive = true});
}

/// A class to save the settings for a contract where an item has points
@HiveType(typeId: 9)
class PointsContractSettings extends AbstractContractSettings {
  /// The points for this contract item
  @HiveField(1)
  int points;

  PointsContractSettings({required this.points});
}

/// A class to save the settings for a contract where multiple players can have some points
@HiveType(typeId: 10)
class IndividualScoresContractSettings extends PointsContractSettings {
  /// The indicator to know if the score should be inverted if one players wins all contract items
  @HiveField(2)
  bool invertScore;

  IndividualScoresContractSettings(
      {required super.points, this.invertScore = true});
}

/// A trumps contract settings
@HiveType(typeId: 11)
class TrumpsContractSettings extends AbstractContractSettings {
  TrumpsContractSettings() : super();
}

/// A domino contract settings
@HiveType(typeId: 12)
class DominoContractSettings extends AbstractContractSettings {
  DominoContractSettings() : super();
}
