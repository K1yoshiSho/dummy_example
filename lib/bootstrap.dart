import 'dart:async';

import 'package:base_starter/src/app/logic/app_runner.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/features/initialization/logic/initialization_processor.dart';
import 'package:base_starter/src/features/initialization/model/dependencies.dart';
import 'package:base_starter/src/features/initialization/model/initialization_hook.dart';
import 'package:base_starter/src/features/initialization/ui/widget/initialization_failed_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ispect/ispect.dart';

/// `bootstrap` function is the entry point of the application.
Future<void> bootstrap() async {
  InitializationHook? hook;
  hook = InitializationHook.setup(
    onInitializing: _onInitializing,
    onInitialized: _onInitialized,
    onError: (step, error, stackTrace) {
      _onErrorFactory(
        step,
        error,
        stackTrace,
        hook!,
      );
    },
    onInit: _onInit,
  );

  await runZonedGuarded(
    () => AppRunner().initializeAndRun(
      hook!,
    ),
    (error, stackTrace) {
      talkerWrapper.handle(
        message: error.toString(),
        exception: error,
        stackTrace: stackTrace,
      );
    },
  );
}

// ==================== Initialization Callbacks ====================

/// `_onInitializing` is a callback function that is called when the initialization process is started.
void _onInitializing(InitializationStepInfo info) {
  final percentage = ((info.step / info.stepsCount) * 100).toInt();
  talkerWrapper.info(
    '🌀 Inited ${info.stepName} in ${info.msSpent} ms | '
    'Progress: $percentage%',
  );
}

/// `_onInitialized` is a callback function that is called when the initialization process is completed.
void _onInitialized(InitializationResult result) {
  talkerWrapper.good(
    '🎉 Initialization completed in ${result.msSpent} ms',
  );
}

/// `_onErrorFactory` is a factory function that creates an error handling function.
void _onErrorFactory(
  int step,
  Object error,
  StackTrace stackTrace,
  InitializationHook hook,
) {
  talkerWrapper.error(
    message: '❗️ Initialization failed on step $step with error: $error',
  );
  FlutterNativeSplash.remove();
  runApp(
    InitializationFailedApp(
      error: error,
      stackTrace: stackTrace,
      retryInitialization: () => AppRunner().initializeAndRun(hook),
    ),
  );
}

/// `_onInit` is a callback function that is called when the initialization process is started.
void _onInit() {
  talkerWrapper.initHandling(talker: talker);
  talkerWrapper.info('🚀 Initialization started');
}
