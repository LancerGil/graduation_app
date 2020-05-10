import 'dart:io';

import 'package:graduationapp/utils/file_man.dart';

enum SummitFileType { doc, pic, audio }
const List IMAGE_SUFFIX = ['jpg', 'jpeg', 'png', 'bmp'];
const List DOC_SUFFIX = ['doc', 'docx', 'png'];
const List AUDIO_SUFFIX = [
  'mp3',
  'm3u',
  'm4a',
  'm4b',
  'm4p',
  'mp2',
  'mpga',
  'ogg',
  'rmvb',
  'wma',
  'wmv',
  'wav',
];

class SummitFile {
  final String filename, path;
  final int id;
  final SummitFileType type;
  final DateTime summitAt;

  SummitFile(this.id, this.filename, this.type, this.summitAt, this.path);

  static Future<List> fetch() async {
    List<FileSystemEntity> pathes = await _getFileList();
    print('文件列表$pathes');

    List<SummitFile> list = [];
    for (int i = 0; i < pathes.length; i++) {
      list..add(fromPath(i, pathes[i].path));
    }
    return list;
  }

  static SummitFile fromPath(id, path) {
    var filename = path.split('/').last;
    var type;
    if (IMAGE_SUFFIX.contains(path.split('.').last)) {
      type = SummitFileType.pic;
    } else if (path.split('.').last == 'doc') {
      type = SummitFileType.doc;
    }
    return SummitFile(id, filename, type, DateTime.now(), path);
  }

  static Future<List> _getFileList() async {
    var containerPath = await FileManage.storePath;
    return FileManage.getFilesPathList(containerPath);
  }

  static SummitFileType identifyTpye(String suffix) {
    if (IMAGE_SUFFIX.contains(suffix)) {
      return SummitFileType.pic;
    }
    if (DOC_SUFFIX.contains(suffix)) {
      return SummitFileType.doc;
    }
    if (AUDIO_SUFFIX.contains(suffix)) {
      return SummitFileType.audio;
    }
    return null;
  }

  @override
  String toString() {
    return filename + '/' + type.toString() + '/' + summitAt.toString();
  }
}
