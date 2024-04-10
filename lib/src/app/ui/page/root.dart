import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/ui/widgets/other/feedback_body.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/core/localization/localization.dart';
import 'package:base_starter/src/feature/initialization/ui/widget/environment_scope.dart';
import 'package:base_starter/src/feature/ispect/inspector/inspector.dart';
import 'package:base_starter/src/feature/settings/state/app_config.dart';
import 'package:base_starter/src/feature/settings/ui/settings.dart';
import 'package:feedback_plus/feedback_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'view/root_view.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({required this.navigationShell, super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.of(context).theme;
    final locale = SettingsScope.of(context).locale;
    final config = EnvironmentScope.of(context);
    final appConfigState = ref.watch(appConfigsProvider);
    return BetterFeedback(
      themeMode: theme.mode,
      localizationsDelegates: Localization.localizationDelegates,
      localeOverride: locale,
      theme: FeedbackThemeData(
        background: Colors.grey[800]!,
        feedbackSheetColor: theme.lightTheme.colorScheme.surface,
        activeFeedbackModeColor: theme.lightTheme.colorScheme.primary,
        cardColor: theme.lightTheme.scaffoldBackgroundColor,
        bottomSheetDescriptionStyle:
            theme.lightTheme.textTheme.bodyMedium!.copyWith(
          color: Colors.grey[800],
        ),
        dragHandleColor: Colors.grey[400],
        inactiveColor: Colors.grey[700]!,
        textColor: Colors.grey[800]!,
      ),
      darkTheme: FeedbackThemeData(
        background: Colors.grey[800]!,
        feedbackSheetColor: theme.darkTheme.colorScheme.surface,
        activeFeedbackModeColor: theme.darkTheme.colorScheme.primary,
        cardColor: theme.darkTheme.scaffoldBackgroundColor,
        bottomSheetDescriptionStyle:
            theme.lightTheme.textTheme.bodyMedium!.copyWith(
          color: Colors.grey[300],
        ),
        dragHandleColor: Colors.grey[400],
        inactiveColor: Colors.grey[600]!,
        textColor: Colors.grey[300]!,
      ),
      mode: FeedbackMode.navigate,
      feedbackBuilder: (context, extras, scrollController) =>
          simpleFeedbackBuilder(
        context,
        extras,
        scrollController,
        theme.computeTheme(),
      ),
      child: Inspector(
        navigatorKey: navigatorKey,
        isPanelVisible: config.isDev,
        child: _RootView(
          widget.navigationShell,
        ),
      ),
    );
  }
}
