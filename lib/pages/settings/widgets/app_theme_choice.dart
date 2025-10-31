import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import '../../../theme/theme_provider.dart';
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

  /// The hint to describe theme state. Initialized to a temporary value because it's required but the state is not ready when the widget is created
  String _switchHint = " ";

  /// The hint to describe what will happen if switch is tapped. Initialized to a temporary value because it's required but the state is not ready when the widget is created
  String _switchOnTapHint = " ";

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
    final isDarkTheme =
        ref.read(isDarkThemeProvider) ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    _switchState?.change(isDarkTheme);
    setState(() {
      _switchHint = isDarkTheme
          ? context.l10n.hintDarkMode
          : context.l10n.hintLightMode;
      _switchOnTapHint = isDarkTheme
          ? context.l10n.hintForLightMode
          : context.l10n.hintForLightMode;
    });
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
  void _invertTheme() {
    if (_switchState != null) {
      ref.read(isDarkThemeProvider.notifier).changeTheme(!_switchState.value);
      _updateTheme();
      SemanticsService.announce(_switchHint, TextDirection.ltr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingQuestion(
      label: context.l10n.appTheme,
      onTap: _invertTheme,
      input: SizedBox(
        height: 60,
        width: 60,
        child: Semantics(
          label: _switchHint,
          onTapHint: _switchOnTapHint,
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
