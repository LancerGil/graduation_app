import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/animated_icon.dart';
import 'package:graduationapp/models/hw_summit.dart';
import 'package:graduationapp/models/summit_file.dart';
import 'package:graduationapp/screens/homework_details/summitsheet.dart';
import 'package:graduationapp/utils/file_man.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:open_file/open_file.dart';

class ItemPeerSummit extends StatefulWidget {
  final HWSummit summit;

  const ItemPeerSummit({Key key, this.summit}) : super(key: key);

  @override
  _ItemPeerSummitState createState() => _ItemPeerSummitState();
}

class _ItemPeerSummitState extends State<ItemPeerSummit>
    with SingleTickerProviderStateMixin {
  bool folded = true;
  // FocusNode focusNode;
  Duration duration = const Duration(milliseconds: 500);
  final Curve curve = Curves.easeOutCirc;
  int score = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          folded = !folded;
        });
      },
      child: AnimatedContainer(
        curve: curve,
        margin: EdgeInsets.symmetric(vertical: folded ? 0 : 16),
        duration: duration,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: folded ? Colors.white : Colors.grey.withAlpha(155),
                offset: Offset(0, 0),
                blurRadius: folded ? 0 : 16.0)
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.summit.smtStu,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  GestureDetector(
                    onTap: () {
                      _rate();
                    },
                    child: Text(
                      '评分：$score',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  )
                ],
              ),
              AnimatedSize(
                curve: curve,
                child: Visibility(
                  visible: !folded,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: _buildFile(),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextField(
                        maxLines: 6,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '撰写评论...',
                            alignLabelWithHint: true),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {},
                          child: Text(
                            '提交',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                duration: duration,
                vsync: this,
              )
            ],
          ),
        ),
      ),
    );
  }

  _rate() {
    showDialog<int>(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 100,
            initialIntegerValue: score,
          ),
        );
      },
    ).then((onValue) {
      if (onValue != null) {
        setState(() => score = onValue);
      }
    });
  }

  _buildFile() {
    final list = widget.summit.fileList;
    return list
        .map(
          (f) => Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            margin: const EdgeInsets.only(left: 32),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade300),
                top: BorderSide(
                    width: list.indexOf(f) == 0 ? 1 : 0,
                    color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: <Widget>[
                SummitBigIcon(
                  type: f.type,
                  size: 40,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    f.filename,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                buildOperation(f),
              ],
            ),
          ),
        )
        .toList();
  }

  buildOperation(SummitFile file) {
    if (file.type == SummitFileType.audio) {
      return AnimeIconButton(animatedIcons: AnimatedIcons.play_pause, size: 20);
    } else {
      return IconButton(
        iconSize: 20,
        icon: Icon(Icons.open_in_new),
        onPressed: () => shareFile(file.filename),
      );
    }
  }

  shareFile(String filename) async {
    try {
      final storePath = await FileManage.storePath;
      // FlutterShare.shareFile(
      //     title: '用第三方应用打开', filePath: '$storePath/$filename');
      OpenResult result = await OpenFile.open('$storePath/$filename');
      if (result.type == ResultType.done) {
        return;
      }
      String errorMsg;
      switch (result.type) {
        case ResultType.error:
          errorMsg = '发生未知错误！';
          break;
        case ResultType.fileNotFound:
          errorMsg = '没有找到该文件！';
          break;
        case ResultType.permissionDenied:
          errorMsg = '没有授予访问权限！';
          break;
        case ResultType.noAppToOpen:
          errorMsg = '手机没有应用可以打开该文件！';
          break;
        default:
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('无法打开文件！'),
              content: Text(errorMsg),
              elevation: 10,
            );
          });
    } catch (e) {
      // If encountering an error, return 0.
      print(e);
      return 0;
    }
  }
}
