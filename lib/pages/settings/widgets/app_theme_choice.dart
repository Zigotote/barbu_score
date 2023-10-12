import 'package:barbu_score/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import '../../../commons/utils/screen.dart';
import 'setting_question.dart';

/// A widget to choose app theme
class AppThemeChoice extends ConsumerStatefulWidget {
  const AppThemeChoice({super.key});

  @override
  ConsumerState<AppThemeChoice> createState() => _AppThemeChoiceState();
}

class _AppThemeChoiceState extends ConsumerState<AppThemeChoice>
    with WidgetsBindingObserver {
  /// The name of the rive animation
  final String _riveStateName = "Switch theme";

  /// The state of the switch (true or false)
  late final SMIInput<bool>? _switchState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    // Reloads theme value if platform brightness changed
    _updateTheme();
  }

  /// Updates isDark value and modify switch value accordingly
  void _updateTheme() {
    _switchState?.change(ref.read(isDarkThemeProvider) ??
        ScreenHelper.brightness == Brightness.dark);
  }

  /// Initializes riverpod animation
  void _initStateMachine(Artboard artboard) {
    final StateMachineController? animationController =
        StateMachineController.fromArtboard(artboard, _riveStateName);

    if (animationController != null) {
      artboard.addController(animationController);
      _switchState = animationController.findInput("isDark")!;
      _updateTheme();
    }
  }

  /// Inverts the theme of the app
  _invertTheme() {
    if (_switchState != null) {
      ref.read(isDarkThemeProvider.notifier).changeTheme(!_switchState!.value);
      _switchState!.change(!_switchState!.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingQuestion(
      label: "Thème de l'application",
      input: GestureDetector(
        onTap: () => _invertTheme(),
        onHorizontalDragStart: (_) => _invertTheme(),
        child: SizedBox(
          height: ScreenHelper.width * 0.18,
          width: ScreenHelper.width * 0.18,
          child: RiveAnimation.asset(
            "assets/switch.riv",
            stateMachines: [_riveStateName],
            onInit: _initStateMachine,
          ),
        ),
      ),
    );
  }
}
