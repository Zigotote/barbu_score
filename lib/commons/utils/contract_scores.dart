/// Sums all the scores in the list. Returns null if no scores to sum
Map<String, int>? sumScores(List<Map<String, int>?> playerScores) {
  return playerScores.isEmpty
      ? null
      : playerScores.reduce(
          (scores, contractScore) => scores == null
              ? contractScore
              : (Map.from(scores)
                ..updateAll(
                  (player, playerScores) => contractScore == null
                      ? playerScores
                      : playerScores + contractScore[player]!,
                )),
        );
}
