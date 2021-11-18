import 'package:flutter/material.dart';

import './contract_models.dart';
import './contract_names.dart';

/// A class to specify arguments to navigate to a route contract
class RouteArgument {
  /// The name of the contract
  final ContractsNames contractName;

  /// The model of the contract, with some values, if it has already been filled
  final AbstractContractModel contractValues;

  RouteArgument({@required this.contractName, @required this.contractValues});

  /// Returns true if the route is made to modify a contract, false if it is a new one
  bool get isForModification => contractValues != null;
}
