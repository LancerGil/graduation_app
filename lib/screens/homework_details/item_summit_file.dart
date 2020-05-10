import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/summit_file.dart';
import 'package:graduationapp/utils/file_man.dart';

import 'summitsheet.dart';

class ItemSummitFile extends StatefulWidget {
  final SummitFile summitFile;
  final GlobalKey<AnimatedListState> myAnimatedListKey;
  final Function updateList;
  final List<SummitFile> fileList;

  ItemSummitFile(
      {Key key,
      this.summitFile,
      this.myAnimatedListKey,
      this.updateList,
      this.fileList})
      : super(key: key);

  @override
  _ItemSummitFileState createState() => _ItemSummitFileState();
}

class _ItemSummitFileState extends State<ItemSummitFile>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 96,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          SummitBigIcon(
            type: SummitFile.identifyTpye(
                widget.summitFile.filename.split('.').last),
            size: 80,
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.summitFile.filename,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    Text(
                      '提交日期：summit.date',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        _tapReplaceFile(widget.summitFile.id);
                      },
                      child: Text(
                        '替换',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        _tapDeleteFile(context, widget.summitFile.id);
                      },
                      child: Text(
                        '删除',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  _tapReplaceFile(index) async {
    File preFile, newFile;

    try {
      preFile = File(widget.summitFile.path);
      newFile = await FileManage.getFile(FileType.any, null);
    } catch (e) {}
    if (newFile != null) {
      preFile.deleteSync();
      widget.myAnimatedListKey.currentState.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation.drive(Tween(begin: 0, end: 1)),
          child: Container(
            color: Colors.green,
          ),
        ),
      );
      widget.fileList[index] = SummitFile.fromPath(index, newFile.path);
      widget.updateList(widget.fileList);
      widget.myAnimatedListKey.currentState.insertItem(index);
    }
  }

  _tapDeleteFile(context, index) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 10,
              title: Text('确定删除？'),
              content: Text('删除$index。'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text('no'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isLoading = !isLoading;
                    });
                    try {
                      File file = File(widget.summitFile.path);
                      file.deleteSync();
                    } catch (e) {}
                    widget.updateList(widget.fileList..removeAt(index));
                    widget.myAnimatedListKey.currentState.removeItem(
                      index,
                      (context, animation) => SizeTransition(
                        sizeFactor: animation.drive(Tween(begin: 0, end: 1)),
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                    );
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text(
                    'yes',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
    );
  }
}
