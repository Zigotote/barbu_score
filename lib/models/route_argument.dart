import './contract_info.dart';
import './contract_models.dart';

/// A class to specify arguments to navigate to a route contract
class RouteArgument {
  /// The info of the contract
  final ContractsInfo contractInfo;

  /// The model of the contract, with some values, if it has already been filled
  final AbstractContractModel? contractValues;

  RouteArgument({required this.contractInfo, required this.contractValues});

  /// Returns true if the route is made to modify a contract, false if it is a new one
  bool get isForModification => contractValues != null;
}
