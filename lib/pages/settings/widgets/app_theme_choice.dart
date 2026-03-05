import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
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
  /// The rive animation file
  File? _riveFile;

  /// The controller to control animation
  RiveWidgetController? _controller;

  /// The indicator to know if theme is dark or light
  bool _isDarkTheme = false;

  /// The hint to describe theme state. Initialized to a temporary value because it's required but the state is not ready when the widget is created
  String _switchHint = " ";

  /// The hint to describe what will happen if switch is tapped. Initialized to a temporary value because it's required but the state is not ready when the widget is created
  String _switchOnTapHint = " ";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initRiveAnimation();
  }

  void _initRiveAnimation() async {
    _riveFile = await File.asset(
      "assets/switch.riv",
      riveFactory: Factory.flutter,
    );
    if (_riveFile != null) {
      setState(() => _controller = RiveWidgetController(_riveFile!));
    }
    _updateTheme();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _riveFile?.dispose();
    _controller?.dispose();
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

    if (_controller != null) {
      (_controller?.stateMachine.inputs.first as BooleanInput).value =
          isDarkTheme;
    }

    setState(() {
      _isDarkTheme = isDarkTheme;
      _switchHint = isDarkTheme
          ? context.l10n.hintDarkMode
          : context.l10n.hintLightMode;
      _switchOnTapHint = _isDarkTheme
          ? context.l10n.hintForLightMode
          : context.l10n.hintForLightMode;
    });
  }

  /// Inverts the theme of the app
  void _invertTheme() {
    ref.read(isDarkThemeProvider.notifier).changeTheme(!_isDarkTheme);
    _updateTheme();
    SemanticsService.announce(_switchHint, TextDirection.ltr);
  }

  @override
  Widget build(BuildContext context) {
    return SettingQuestion(
      label: context.l10n.appTheme,
      onTap: _invertTheme,
      input: Semantics(
        label: _switchHint,
        onTapHint: _switchOnTapHint,
        child: _riveFile == null
            ? MySwitch(
                isActive: !_isDarkTheme,
                onChanged: (_) => _invertTheme(),
                isActiveIcon: Icon(Icons.sunny),
                isInactiveIcon: Icon(Icons.nightlight_outlined),
              )
            : SizedBox(
                height: 60,
                width: 60,
                child: RiveWidget(controller: _controller!),
              ),
      ),
    );
  }
}
