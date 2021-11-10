import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/contract_names.dart';
import '../controller/party.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a contract
class ContractScores extends GetView<PartyController> {
  /// The contract the player choose
  final ContractsNames contract = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      subtitle: contract.displayName,
      contract: ContractsNames.Trumps,
      child: Text("Not yet implemented"),
    );
  }
}
