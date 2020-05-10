import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';

class FileManage {
  static Future<String> get storePath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  static Future<String> get cachePath async {
    final directory = await getExternalCacheDirectories();
    return directory[0].path;
  }

  static Future<File> getFile(FileType _pickingType, String _extension) async {
    String _path;
    String storePath = await FileManage.storePath;

    try {
      _path = await FilePicker.getFilePath(
          type: _pickingType,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll(' ', '')?.split(',')
              : null);
    } catch (e) {
      // If encountering an error, return 0.
      print(e);
      return null;
    }

    if (_path != null && storePath != null) {
      File file = File(_path);
      storePath += '/' + file.path.split('/').last;
      return file.copySync(storePath);
    } else {
      return null;
    }
  }

  static Future<bool> shareFile(filePath) async {
    await FlutterShare.shareFile(
      title: 'File share',
      filePath: filePath,
    );
  }

  static List getFilesPathList(containerPath) {
    try {
      return Directory("$containerPath").listSync();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static void deleteFile(filepath) {
    try {
      final dir = Directory(filepath);
      dir.deleteSync();
    } catch (e) {
      throw e.toString();
    }
  }
}
