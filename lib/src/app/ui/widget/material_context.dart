import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/ui/widgets/builder/performance_builder.dart';
import 'package:base_starter/src/common/ui/widgets/draggable_button.dart';
import 'package:base_starter/src/core/localization/localization.dart';
import 'package:base_starter/src/feature/initialization/ui/widget/environment_scope.dart';
import 'package:base_starter/src/feature/settings/state/app_config.dart';
import 'package:base_starter/src/feature/settings/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// [MaterialContext] is an entry point to the material context.
/// This widget sets locales, themes and routing.
class MaterialContext extends ConsumerWidget {
  const MaterialContext({
    required this.routerConfig,
    super.key,
  });

  final GoRouter routerConfig;

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;
    final config = EnvironmentScope.of(context);
    final appConfigState = ref.watch(appConfigsProvider);

    return PerformanceOverlayBuilder(
      config: config,
      appConfigState: appConfigState,
      theme: theme,
      child: MaterialApp.router(
        key: _globalKey,
        title: config.appName,
        onGenerateTitle: (context) => config.appName,
        theme: theme.lightTheme,
        darkTheme: theme.darkTheme,
        themeMode: theme.mode,
        localizationsDelegates: Localization.localizationDelegates,
        supportedLocales: Localization.supportedLocales,
        locale: locale,
        routerConfig: routerConfig,
        builder: (context, child) {
          child = EasyLoading.init()(context, child);

          child = MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.0,
            maxScaleFactor: 2.0,
            child: child,
          );

          child = FToastBuilder()(context, child);
          return child;
        },
      ),
    );
  }
}
