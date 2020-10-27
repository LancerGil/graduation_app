import 'package:flutter/material.dart';
import 'package:graduationapp/models/lesson_stu.dart';

import 'sceen_choose.dart';

class DialogCreatGroup extends StatefulWidget {
  final List<LessonStu> memberList, wholeList;
  final String groupName;
  final Function updateGroupMemList;
  final String stuID, groupID;

  DialogCreatGroup(
      {Key key,
      this.memberList,
      this.groupName,
      this.wholeList,
      this.updateGroupMemList,
      this.stuID,
      this.groupID})
      : super(key: key);

  @override
  _DialogCreatGroupState createState() => _DialogCreatGroupState();
}

class _DialogCreatGroupState extends State<DialogCreatGroup> {
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    print('当前学生id${widget.stuID}');
    textEditingController = TextEditingController();
    textEditingController.text = widget.groupName;
    textEditingController.addListener(() {
      widget.updateGroupMemList(textEditingController.text, widget.memberList);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "小组名称",
            ),
          ),
          Divider(),
          Text(
            '小组成员-${widget.memberList.length}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _navigateAndDisplaySelection();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                ),
                ...buildSelectedMembers(),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSelectedMembers() {
    return widget.memberList
        .map(
          (f) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ItemMemberSmall(
              assetPath: f.stuImagePath,
              name: f.stuName,
            ),
          ),
        )
        .toList();
  }

  _navigateAndDisplaySelection() async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
        builder: (context) => ChoosePage(
          wholeList: widget.wholeList
            ..removeWhere((element) => element.stuNum == widget.stuID),
          selectedList: widget.memberList,
          thisGroupID: widget.groupID,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        widget.updateGroupMemList(textEditingController.text, result);
      });
    }
  }
}

class ItemMemberSmall extends StatelessWidget {
  final String assetPath, name;

  const ItemMemberSmall({Key key, this.assetPath, this.name}) : super(key: key);

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
              name,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
