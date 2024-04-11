import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_starter/src/common/services/cache/cache_service.dart';
import 'package:base_starter/src/common/services/file/src/file_service.dart'
    as fs;
import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gap/gap.dart';
import 'package:simple_app_cache_manager/simple_app_cache_manager.dart';

part 'view/view.dart';
part 'controller/controller.dart';

class AppDataPage extends StatefulWidget {
  const AppDataPage({super.key});

  @override
  State<AppDataPage> createState() => _AppDataPageState();
}

class _AppDataPageState extends State<AppDataPage> with CacheMixin {
  final _controller = AppDataController();

  @override
  void initState() {
    _controller.loadFilesList(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _AppDataView(
        controller: _controller,
        deleteFile: (value) {
          _controller.deleteFile(context: context, index: value);
        },
        deleteFiles: () {
          _controller.deleteFiles(context: context);
        },
        cacheSizeNotifier: cacheSizeNotifier,
        clearCache: () async {
          cacheManager.clearCache();
          await appCacheManager.deleteCacheDir(
            cache: defaultCacheManager,
            isAndroid: context.theme.platform == TargetPlatform.android,
          );
          await updateCacheSize();
          if (context.mounted) {
            await _controller.loadFilesList(context: context);
          }
          if (context.mounted) {
            await Toaster.showSuccessToast(
              context,
              title: context.l10n.cache_cleared,
            );
          }
        },
      );
}

mixin CacheMixin on State<AppDataPage> {
  late final AppCacheManager appCacheManager;
  late final SimpleAppCacheManager cacheManager;
  late final DefaultCacheManager defaultCacheManager;
  late ValueNotifier<String> cacheSizeNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    appCacheManager = AppCacheManager();
    cacheManager = SimpleAppCacheManager();
    defaultCacheManager = DefaultCacheManager();
    updateCacheSize();
  }

  Future<void> updateCacheSize() async {
    final cacheSize = await cacheManager.getTotalCacheSize();
    cacheSizeNotifier.value = cacheSize;
  }

  @override
  void dispose() {
    cacheSizeNotifier.dispose();
    defaultCacheManager.dispose();
    super.dispose();
  }
}
