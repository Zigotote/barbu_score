import 'package:barbu_score/controller/party.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// A class to handle local storage objects
class MyStorage {
  /// The object to manipulate local storage
  final GetStorage _storage = GetStorage();

  static const String _PARTY_KEY = "party";
  static const String _NB_PLAYERS = "nbPlayers";

  MyStorage() : super() {
    GetStorage.init();
  }

  /// Gets the party saved in the store
  PartyController? getStoredParty() {
    var storedParty = _storage.read(_PARTY_KEY);
    if (storedParty != null) {
      if (storedParty.runtimeType == PartyController) {
        return storedParty;
      }
      this.saveNbPlayers(storedParty["players"].length);
      return PartyController.fromJson(_storage.read(_PARTY_KEY));
    }
    return null;
  }

  void saveParty() {
    try {
      final PartyController party = Get.find<PartyController>();
      _storage.write(_PARTY_KEY, party);
    } catch (_) {}
  }

  /// Get the number of players in the party
  int getNbPlayers() {
    return _storage.read(_NB_PLAYERS);
  }

  /// Saves the number of players for the party (usefull when a party is restored, to be able tu build NoHearts contract)
  void saveNbPlayers(int nb) {
    _storage.write(_NB_PLAYERS, nb);
  }

  /// Deletes the data saved in the store
  void delete() {
    _storage.erase();
  }
}
