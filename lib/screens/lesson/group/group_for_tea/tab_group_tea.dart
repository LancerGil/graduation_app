import 'package:flutter/material.dart';
import 'package:graduationapp/models/stu_group.dart';
import 'package:graduationapp/screens/lesson/group/group_for_tea/item_group.dart';

class TabGroupForTea extends StatefulWidget {
  @override
  _TabGroupForTeaState createState() => _TabGroupForTeaState();
}

class _TabGroupForTeaState extends State<TabGroupForTea> {
  static const String OUTPORT = 'outport';
  List<StuGroup> groups;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    groups = StuGroup.fetch();
    var appBar = AppBar(
      centerTitle: true,
      title: Text(
        '班级分组',
        style: Theme.of(context).textTheme.body1.copyWith(
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: OUTPORT,
                child: Text('导出分组'),
              ),
            ];
          },
          onSelected: (_) {
            _onMenuSelected(_);
          },
        ),
      ],
    );
    var body = Container(
      child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: _buildGroup()),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  _onMenuSelected(_) {
    switch (_) {
      case OUTPORT:
        _outportGroup();
        break;
      default:
    }
  }

  _buildGroup() {
    return groups.map((f) => ItemGroups(group: f)).toList();
  }

  _outportGroup() {
    //TOTO:导出分组为表格
  }
}
