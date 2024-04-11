// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, implementation_imports

import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/feature/ispect/settings/settings_card.dart';
import 'package:base_starter/src/feature/ispect/widget/base_bottom_sheet.dart';
import 'package:base_starter/src/feature/settings/state/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerSettingsBottomSheets extends ConsumerStatefulWidget {
  const TalkerSettingsBottomSheets({
    required this.talkerScreenTheme,
    required this.talker,
    required this.isStandart,
    super.key,
  });

  /// Theme for customize [TalkerScreen]
  final TalkerScreenTheme talkerScreenTheme;

  /// Talker implementation
  final ValueNotifier<Talker> talker;

  final bool isStandart;

  @override
  ConsumerState<TalkerSettingsBottomSheets> createState() =>
      _TalkerSettingsBottomSheetState();
}

class _TalkerSettingsBottomSheetState
    extends ConsumerState<TalkerSettingsBottomSheets> {
  @override
  void initState() {
    widget.talker.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = <Widget>[
      TalkerSettingsCardItem(
        talkerScreenTheme: widget.talkerScreenTheme,
        title: context.l10n.enabled,
        enabled: widget.talker.value.settings.enabled,
        backgroundColor: widget.talkerScreenTheme.cardColor,
        onChanged: (enabled) {
          (enabled ? widget.talker.value.enable : widget.talker.value.disable)
              .call();
          widget.talker.notifyListeners();
        },
      ),
      TalkerSettingsCardItem(
        canEdit: widget.talker.value.settings.enabled,
        talkerScreenTheme: widget.talkerScreenTheme,
        title: context.l10n.use_console_logs,
        backgroundColor: widget.talkerScreenTheme.cardColor,
        enabled: widget.talker.value.settings.useConsoleLogs,
        onChanged: (enabled) {
          widget.talker.value.configure(
            settings: widget.talker.value.settings.copyWith(
              useConsoleLogs: enabled,
            ),
          );
          widget.talker.notifyListeners();
        },
      ),
      TalkerSettingsCardItem(
        canEdit: widget.talker.value.settings.enabled,
        talkerScreenTheme: widget.talkerScreenTheme,
        title: context.l10n.use_history,
        backgroundColor: widget.talkerScreenTheme.cardColor,
        enabled: widget.talker.value.settings.useHistory,
        onChanged: (enabled) {
          widget.talker.value.configure(
            settings: widget.talker.value.settings.copyWith(
              useHistory: enabled,
            ),
          );
          widget.talker.notifyListeners();
        },
      ),
      if (!widget.isStandart) ...[
        TalkerSettingsCardItem(
          talkerScreenTheme: widget.talkerScreenTheme,
          title: context.l10n.performance_tracker,
          backgroundColor: widget.talkerScreenTheme.cardColor,
          enabled: ref.watch(appConfigsProvider).isPerformanceTrackingEnabled,
          onChanged: (enabled) {
            ref.read(appConfigsProvider.notifier).setPerformanceTracking(
                  value: enabled,
                );
            widget.talker.notifyListeners();
          },
        ),
      ],
    ];

    return BaseBottomSheet(
      title: context.l10n.settings,
      talkerScreenTheme: widget.talkerScreenTheme,
      child: Expanded(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ...settings.map((e) => SliverToBoxAdapter(child: e)),
          ],
        ),
      ),
    );
  }
}
