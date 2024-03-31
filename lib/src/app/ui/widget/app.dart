import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/app/ui/widget/material_context.dart';
import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/common/utils/talker_logger.dart';
import 'package:base_starter/src/feature/initialization/logic/base_config.dart';
import 'package:base_starter/src/feature/initialization/model/dependencies.dart';
import 'package:base_starter/src/feature/initialization/model/environment.dart';
import 'package:base_starter/src/feature/initialization/ui/widget/dependencies_scope.dart';
import 'package:base_starter/src/feature/initialization/ui/widget/environment_scope.dart';
import 'package:base_starter/src/feature/settings/ui/settings.dart';
import 'package:flutter/material.dart';

/// [App] is an entry point to the application.
///
/// Scopes that don't depend on widgets returned by [MaterialApp]
/// ([Directionality], [MediaQuery], [Localizations]) should be placed here.

class App extends StatefulWidget {
  const App({required this.result, super.key});

  @override
  State<App> createState() => _AppState();

  /// The initialization result from the `InitializationProcessor`
  /// which contains initialized dependencies.
  final InitializationResult result;

  /// Running this function will result in attaching
  /// corresponding [RenderObject] to the root of the tree.
  void attach([VoidCallback? callback]) {
    callback?.call();
    runApp(this);
  }
}

class _AppState extends State<App> {
  late final GoRouter _router;
  String? _environmentKey;

  @override
  void initState() {
    _router = createRouter();
    talker.logTyped(GoodLog('📱 App started'));
    talker.logTyped(
      RouteLog(_router.configuration.debugKnownRoutes()),
    );
    _router.routerDelegate.addListener(() {
      talker.logTyped(
        RouteLog(
          _router.routerDelegate.currentConfiguration.last.matchedLocation,
        ),
      );
    });
    _environmentKey = widget.result.dependencies.sharedPreferences
        .getString(Preferences.environment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => EnvironmentScope(
        config: configMap[_environmentKey] ?? configMap[Environment.prod]!,
        child: DependenciesScope(
          dependencies: widget.result.dependencies,
          repositories: widget.result.repositories,
          child: SettingsScope(
            settingsBloc: widget.result.dependencies.settingsBloc,
            child: MaterialContext(
              routerConfig: _router,
            ),
          ),
        ),
      );
}
