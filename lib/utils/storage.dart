import 'package:barbu_score/controller/party.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';

/// A class to handle local storage objects
class MyStorage extends SuperController {
  /// The object to manipulate local storage
  final GetStorage _storage = GetStorage();

  static const String _PARTY_KEY = "party";

  MyStorage() : super() {
    GetStorage.init();
  }

  /// Loads the party to resume it
  loadParty() {
    final PartyController party = _storage.read(_PARTY_KEY);
    if (party != null) {
      Get.deleteAll();
      Get.put(party);
      Get.toNamed(Routes.CHOOSE_CONTRACT);
    }
  }

  /// Gets the players from the party saved in the store
  String getStoredPartyPlayers() {
    final PartyController party = _storage.read(_PARTY_KEY);
    if (party != null) {
      return party.playerNames;
    } else {
      return "";
    }
  }

  /// Deletes the data saved in the store
  delete() {
    _storage.erase();
  }

  @override
  void onInactive() {
    _saveParty();
  }

  @override
  void onDetached() {
    _saveParty();
  }

  @override
  void onPaused() {
    _saveParty();
  }

  @override
  void onResumed() {}

  @override
  void onClose() {
    _saveParty();
    super.onClose();
  }

  _saveParty() {
    try {
      final PartyController party = Get.find<PartyController>();
      _storage.write(_PARTY_KEY,
          party); // This is throwing an error, TODO Océane to correct
      print(party);
      print(_storage.read(_PARTY_KEY));
    } catch (_) {}
  }
}
