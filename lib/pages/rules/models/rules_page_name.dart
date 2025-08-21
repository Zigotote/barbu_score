enum RulesPageName {
  gamePresentation,
  prepareGame,
  gameRound,
  contractRules;

  /// Returns the RulesPageName from its name
  static RulesPageName fromName(String name) {
    return RulesPageName.values.firstWhere((page) => page.name == name);
  }
}
