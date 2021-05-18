import 'player.dart';

/// List the names of the contracts for a party
enum ContractsNames {
  Barbu,
  NoHearts,
  NoQueens,
  NoTricks,
  NoLastTrick,
  Trumps,
  Domino
}

extension ContractsInfos on ContractsNames {
  int maximumScore(int nbPlayers) {
    switch (this) {
      case ContractsNames.Barbu:
        return 50;
      case ContractsNames.NoHearts:
        return nbPlayers * 2 * 5;
      case ContractsNames.NoQueens:
        return 40;
      case ContractsNames.NoTricks:
        return 40;
      case ContractsNames.NoLastTrick:
        return 40;
      case ContractsNames.Trumps:
        return 50 + 40 * 3 + (nbPlayers * 2 * 5);
      case ContractsNames.Domino:
        return 0;
    }
    return 0;
  }
}

/// A specific contract scores
class Contract {
  /// The name of the contract
  ContractsNames name;

  /// The scores of all the players for this contract
  Map<Player, int> scores;
}
