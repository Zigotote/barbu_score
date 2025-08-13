import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:go_router/go_router.dart';

extension MyGoRouterState on GoRouterState {
  static const contractParameter = "contract";
  static const playerParameter = "player";
  static const rulesPage = "rulesPage";

  ContractsInfo get contract =>
      ContractsInfo.fromName(pathParameters[contractParameter] ?? "");
}
