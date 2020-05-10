import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/summit_file.dart';
import 'package:flutter/services.dart';
import 'package:graduationapp/utils/file_man.dart';

import 'item_summit_file.dart';

class SummitSheet extends StatefulWidget {
  @override
  _SummitSheetState createState() => _SummitSheetState();
}

class _SummitSheetState extends State<SummitSheet>
    with SingleTickerProviderStateMixin {
  double initialPersentage = 0.15;
  List<SummitFile> fileList;

  GlobalKey<AnimatedListState> _myAnimatedListKey =
      GlobalKey<AnimatedListState>();

  bool _loadingPath = false;
  FileType _pickingType = FileType.any;
  String _extension;

  @override
  void initState() {
    super.initState();
    _iniialFileList();
  }

  _iniialFileList() async {
    var list = await SummitFile.fetch();
    setState(() {
      fileList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: initialPersentage,
        minChildSize: initialPersentage,
        maxChildSize: 0.5,
        builder: (context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(155),
                  offset: Offset(0, -11),
                  blurRadius: 13.0,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned.fill(
                  bottom: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedList(
                        key: _myAnimatedListKey,
                        initialItemCount: fileList.length ?? 0,
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            sizeFactor:
                                animation.drive(Tween(begin: 0, end: 1)),
                            child: ItemSummitFile(
                              summitFile: fileList[index],
                              myAnimatedListKey: _myAnimatedListKey,
                              updateList: updataList,
                              fileList: fileList,
                            ),
                          );
                        },
                        controller: scrollController,
                        // children: _buildList(20)),
                      ),
                    ),
                  ),
                ),
                DragBar(),
                SheetHeader(
                  addFile: _openFileExplorer,
                ),
              ],
            ),
          );
        });
  }

  updataList(filelist) {
    setState(() {
      fileList = filelist;
    });
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    File file;
    try {
      file = await FileManage.getFile(_pickingType, _extension);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      if (file != null) {
        int index = fileList.length;
        fileList = fileList..add(SummitFile.fromPath(index, file.path));
        _myAnimatedListKey.currentState.insertItem(index);
      }
    });
  }
}

class SummitBigIcon extends StatelessWidget {
  final SummitFileType type;
  final double size;

  const SummitBigIcon({Key key, this.type, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (type) {
      case SummitFileType.doc:
        icon = Icons.library_books;
        break;
      case SummitFileType.audio:
        icon = Icons.mic;
        break;
      case SummitFileType.pic:
        icon = Icons.image;
        break;
      default:
    }
    return Container(
      color: Colors.white,
      child: Icon(
        icon,
        size: size,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class DragBar extends StatelessWidget {
  const DragBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: 50,
        height: 8,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  final Function addFile;

  const SheetHeader({Key key, this.addFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '我的提交',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Colors.white),
              ),
              RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                child: Text('添加提交'),
                onPressed: addFile,
              )
            ],
          ),
        ),
      ),
    );
  }
}
