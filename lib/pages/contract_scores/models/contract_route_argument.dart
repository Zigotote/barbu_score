import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_models.dart';

/// A class to specify arguments to navigate to a route contract
class ContractRouteArgument {
  /// The info of the contract
  final ContractsInfo contractInfo;

  /// The model of the contract, with some values, if it has already been filled
  final AbstractSubContractModel? contractModel;

  ContractRouteArgument({required this.contractInfo, this.contractModel});

  /// Returns true if the route is made to modify a contract, false if it is a new one
  bool get isForModification => contractModel != null;
}
