import 'package:flutter/material.dart';
import 'package:graduationapp/models/stu_group.dart';

class ItemGroups extends StatefulWidget {
  final StuGroup group;

  const ItemGroups({Key key, this.group}) : super(key: key);

  @override
  _ItemGroupsState createState() => _ItemGroupsState();
}

class _ItemGroupsState extends State<ItemGroups>
    with SingleTickerProviderStateMixin {
  bool folded = true;
  Duration duration = const Duration(milliseconds: 500);
  final Curve curve = Curves.easeOutCirc;

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: folded ? Colors.white : Colors.grey.withAlpha(155),
                  offset: Offset(0, 0),
                  blurRadius: folded ? 0 : 16.0)
            ],
            border: folded
                ? null
                : Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey),
                  )),
        duration: duration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '${widget.group.groupID} - ' + widget.group.groupName,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Spacer(),
                Icon(folded ? Icons.arrow_drop_down : Icons.arrow_drop_up)
              ],
            ),
            AnimatedSize(
              curve: curve,
              duration: duration,
              vsync: this,
              child: Visibility(
                  visible: folded ? false : true,
                  child: Column(
                    children: _buildMembers(),
                  )),
            )
          ],
        ),
      ),
    );
  }

  _buildMembers() {
    return widget.group.memberUserIDs
        .map((f) => ListTile(
              title: Text('f.stuName'),
            ))
        .toList();
  }
}
