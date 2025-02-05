import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

final turnPageProvider = Provider.autoDispose(
  (_) => TurnPageController(startCorner: TurnCorner.bottomRight),
);
