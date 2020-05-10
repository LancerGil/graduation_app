import 'package:graduationapp/models/summit_file.dart';

class HWSummit {
  final int id;
  final String smtStu, smtContent;
  final List<SummitFile> fileList;
  final DateTime summitAt;

  HWSummit(this.id, this.smtStu, this.smtContent, this.fileList, this.summitAt);

  static Future<List<HWSummit>> fetch(int count) async {
    return await SummitFile.fetch().then((future) {
      print('-----SummitFile.fetch-----Future:$future');
      List<HWSummit> list = [];
      for (int i = 0; i < count; i++) {
        list
          ..add(HWSummit(
              i,
              'stuName$i',
              'smtContent,文字内容，smtContent,文字内容，smtContent,文字内容，smtContent,文字内容，smtContent,文字内容，smtContent,文字内容，',
              future,
              DateTime.now()));
      }
      return list;
    });
  }

  @override
  String toString() {
    return smtStu + '/' + fileList.toString();
  }
}
