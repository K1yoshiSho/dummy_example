import 'dart:io';
import 'package:base_starter/src/common/services/cache/base.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

final class AppCacheManager implements BaseCacheService {
  @override
  Future<void> deleteCacheDir({
    required DefaultCacheManager cache,
    required bool isAndroid,
  }) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final appDir = await getApplicationSupportDirectory();

      if (cacheDir.existsSync()) {
        await cacheDir.delete(recursive: true);
        talker.info("Cleared: cacheDir: ${cacheDir.path}");
      }

      if (appDir.existsSync()) {
        await appDir.delete(recursive: true);
        talker.info("Cleared: appDir: ${appDir.path}");
      }

      if (isAndroid) {
        final List<Directory>? list = await getExternalCacheDirectories();
        if (list != null) {
          for (final Directory dir in list) {
            if (dir.existsSync()) {
              await dir.delete(recursive: true);
              talker.info("Cleared: ${dir.path}");
            }
          }
        }
      }

      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      talker.info(
        "Cleared: imageCache: ${PaintingBinding.instance.imageCache.currentSize}, clearLiveImages: ${PaintingBinding.instance.imageCache.liveImageCount}",
      );

      await cache.emptyCache();
    } on Exception catch (e, st) {
      talker.handle(
        e,
        st,
        "Failed to clear cache",
      );
    }
  }

  @override
  Future<double> getCacheSize() {
    throw UnimplementedError();
  }

  @override
  Future<List<File>> getFiles() {
    throw UnimplementedError();
  }
}
