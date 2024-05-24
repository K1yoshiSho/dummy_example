import 'dart:async';

import 'package:base_starter/src/common/services/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfigsState {
  final bool isPerformanceTrackingEnabled;
  final bool isInspectorEnabled;

  const AppConfigsState({
    this.isPerformanceTrackingEnabled = false,
    this.isInspectorEnabled = false,
  });

  AppConfigsState copyWith({
    bool? isPerformanceTrackingEnabled,
    bool? isInspectorEnabled,
  }) =>
      AppConfigsState(
        isPerformanceTrackingEnabled:
            isPerformanceTrackingEnabled ?? this.isPerformanceTrackingEnabled,
        isInspectorEnabled: isInspectorEnabled ?? this.isInspectorEnabled,
      );
}

class AppConfigs extends StateNotifier<AppConfigsState> {
  AppConfigs() : super(const AppConfigsState()) {
    _init();
  }

  Future<void> _init() async {
    final isTrackingEnabled = AppConfigsService.isPerformanceTrackingEnabled;
    state = state.copyWith(isPerformanceTrackingEnabled: isTrackingEnabled);
  }

  Future<void> setPerformanceTracking({required bool value}) async {
    await AppConfigsService.setPerformanceTracking(value: value);
    state = state.copyWith(isPerformanceTrackingEnabled: value);
  }

  Future<void> setInspector({required bool value}) async {
    state = state.copyWith(isInspectorEnabled: value);
  }

  bool isPerformanceTrackingEnabled() => state.isPerformanceTrackingEnabled;

  bool isInspectorEnabled() => state.isInspectorEnabled;
}
