import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/stu_card.dart';

import 'sceen_choose.dart';

class DialogCreatGroup extends StatefulWidget {
  List<LessonStu> memberList;
  String groupName;

  DialogCreatGroup({Key key, this.memberList, this.groupName})
      : super(key: key);

  @override
  _DialogCreatGroupState createState() => _DialogCreatGroupState();
}

class _DialogCreatGroupState extends State<DialogCreatGroup> {
  List<LessonStu> wholeList;

  @override
  void initState() {
    super.initState();
    // widgetmemberList = List();
    wholeList = LessonStu.fetchAll(Lesson.classID);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "小组名称",
                prefixText: widget.groupName),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '小组成员-${widget.memberList.length}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 5,
          ),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              GestureDetector(
                onTap: () {
                  _navigateAndDisplaySelection(context);
                },
                child: ClipOval(
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.black,
                    child: Container(
                      color: Colors.white,
                      width: 55,
                      height: 55,
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              ),
            ]..addAll(
                buildSelectedMembers(),
              ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSelectedMembers() {
    return widget.memberList
        .map(
          (f) => ItemMemberSmall(assetPath: f.stuImagePath),
        )
        .toList();
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
        builder: (context) => ChoosePage(
          wholeList: wholeList,
          selectedList: widget.memberList,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        widget.memberList = result;
      });
    }
  }
}

class ItemMemberSmall extends StatelessWidget {
  final String assetPath;

  const ItemMemberSmall({Key key, this.assetPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              width: 60,
              height: 60,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(colors: [
                    Colors.grey[300],
                    Colors.grey[300],
                  ]).createShader(bounds);
                },
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              '张  三',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
