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
  static const darkThemeAnimationName = "idllOn";
  static const lightThemeAnimationName = "idllOff";

  /// The state of the switch (true or false)
  //late final SMIInput<bool>? _switchState;
  late final riveFileLoader =
      FileLoader.fromAsset("assets/switch.riv", riveFactory: Factory.flutter);

  bool _isDarkTheme = false;

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
    setState(() {
      _isDarkTheme = isDarkTheme;
      _switchHint =
      isDarkTheme ? context.l10n.hintDarkMode : context.l10n.hintLightMode;
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
      input: SizedBox(
        height: 60,
        width: 60,
        child: Semantics(
          label: _switchHint,
          onTapHint: _switchOnTapHint,
          child: RiveWidgetBuilder(
            fileLoader: riveFileLoader,
            builder: (context, state) => switch (state) {
              // TODO Océane mettre des switchs classique au loading + fail
              RiveLoading() => Center(child: CircularProgressIndicator()),
              RiveFailed() => ErrorWidget.withDetails(
                  message: state.error.toString(),
                  error: FlutterError(state.error.toString()),
                ),
              RiveLoaded() => RiveArtboardWidget(
                  artboard: state.file.defaultArtboard()!,
                  // TODO Océane ça marche mais c'est saquadé
                  painter: SingleAnimationPainter(
                    _isDarkTheme
                        ? darkThemeAnimationName
                        : lightThemeAnimationName,
                  ),
                  /*
                StateMachinePainter(
                      stateMachineName: "Switch theme",
                      withStateMachine: (s) => print(s)),
                )
                 */
                )
            },
          ),
          /*.asset(
            "assets/switch.riv",
            stateMachines: [_riveStateName],
            onInit: _initStateMachine,
          )*/
        ),
      ),
    );
  }
}
