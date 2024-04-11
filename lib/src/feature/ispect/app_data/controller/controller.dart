part of '../app_data.dart';

class AppDataController extends ChangeNotifier {
  var _files = <File>[];
  List<File> get files => _files;

  Future<void> loadFilesList({
    required BuildContext context,
  }) async {
    try {
      final f = await fs.FileService.instance.getFiles();
      _files = f;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } on Exception catch (e, st) {
      if (context.mounted &&
          !e.toString().contains("No such file or directory")) {
        talker.handle(e, st);
        await Toaster.showErrorToast(
          context,
          title: e.toString(),
        );
      }
    }
  }

  Future<void> deleteFile({
    required BuildContext context,
    required int index,
  }) async {
    try {
      await _files[index].delete();
      if (context.mounted) {
        await loadFilesList(
          context: context,
        );
      }
    } on Exception catch (e, st) {
      talker.handle(e, st);
      if (context.mounted) {
        await Toaster.showErrorToast(
          context,
          title: e.toString(),
        );
      }
    }
  }

  Future<void> deleteFiles({
    required BuildContext context,
  }) async {
    try {
      for (final file in _files) {
        await file.delete();
      }
      if (context.mounted) {
        await loadFilesList(
          context: context,
        );
      }
    } on Exception catch (e, st) {
      talker.handle(e, st);
      if (context.mounted) {
        await Toaster.showErrorToast(
          context,
          title: e.toString(),
        );
      }
    }
  }
}
