/// A class for the points of a domino contract
class DominoPointsProps {
  /// The indicator if points are fix (that is points[0] always goes to 1st player, points[1] always goes to 2nd...) or are adapted depending on the number of players
  final bool isFix;

  /// The points for each player rank
  final List<int> points;

  const DominoPointsProps({required this.isFix, required this.points});
}
