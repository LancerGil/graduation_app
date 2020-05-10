import 'package:flutter/material.dart';
import 'package:graduationapp/models/hw_home.dart';

class HwDetailForTeaPage extends StatefulWidget {
  final HwAtHome homework;

  const HwDetailForTeaPage({Key key, this.homework}) : super(key: key);
  @override
  _HwDetailForTeaPageState createState() => _HwDetailForTeaPageState();
}

class _HwDetailForTeaPageState extends State<HwDetailForTeaPage>
    with SingleTickerProviderStateMixin {
  HwAtHome thisHw;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    thisHw = widget.homework;

    var appBar = AppBar(
      centerTitle: true,
      title: Text('作业详情'),
    );

    var body = SingleChildScrollView(
      child: Container(
        // color: Colors.green,
        child: Column(
          children: <Widget>[
            Text('作业详情'),
          ],
        ),
      ),
    );

    return Scaffold(appBar: appBar, body: body);
  }
}
