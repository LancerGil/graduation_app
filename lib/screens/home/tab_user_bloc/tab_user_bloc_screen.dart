import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationapp/custom_widgets/circle_image.dart';

import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/item_history_lesson.dart';
import 'package:graduationapp/screens/home/tab_user_bloc/index.dart';

class TabUserBlocScreen extends StatefulWidget {
  const TabUserBlocScreen({
    Key key,
    @required TabUserBlocBloc tabUserBlocBloc,
    @required User user,
  })  : _tabUserBlocBloc = tabUserBlocBloc,
        _user = user,
        super(key: key);

  final TabUserBlocBloc _tabUserBlocBloc;
  final User _user;

  @override
  TabUserBlocScreenState createState() {
    return TabUserBlocScreenState();
  }
}

class TabUserBlocScreenState extends State<TabUserBlocScreen> {
  static const List<String> MENU_LIST = [
    '我的评分',
    '收到评分',
    '我的回评',
    '收到回评',
  ];
  TabUserBlocScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _buildHeader() {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CustomPaint(
              size: Size(size.width, 107),
              painter: BNBCustomPainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleImage(
              height: 88,
              width: 88,
              imageUrl: 'assets/images/nezuko2.png',
            ),
          ),
          Positioned(
            left: 24,
            bottom: 32,
            right: 24,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '用户名',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${widget._user.fullname}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '身份',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${widget._user.identity}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Visibility(
                      visible: widget._user.identity == 'student',
                      child: Text(
                        '学号',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Visibility(
                      visible: widget._user.identity == 'student',
                      child: Text(
                        '${widget._user.stuID}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text('我的课程'),
          ),
          BlocBuilder<TabUserBlocBloc, TabUserBlocState>(
              cubit: widget._tabUserBlocBloc,
              builder: (
                BuildContext context,
                TabUserBlocState currentState,
              ) {
                if (currentState is UnTabUserBlocState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (currentState is ErrorTabUserBlocState) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(currentState.errorMessage ?? 'Error'),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text('reload'),
                          onPressed: _load,
                        ),
                      ),
                    ],
                  ));
                }
                if (currentState is InTabUserBlocState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: currentState.lessonList
                                  .map<Widget>((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16),
                                        child: ItemHistoryLesson(e),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
          Visibility(
            visible: widget._user.identity == 'student',
            child: Column(
              children: [
                Divider(
                  indent: 16,
                  endIndent: 16,
                ),
                ..._buildReviewReplyList()
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildReviewReplyList() {
    return MENU_LIST
        .map(
          (f) => Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/r_and_c',
                      arguments: {'title': f, 'user': widget._user});
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(f),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
            ],
          ),
        )
        .toList();
  }

  void _load([bool isError = false]) {
    widget._tabUserBlocBloc.add(LoadLessonBlocEvent(widget._user));
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height - 32); // Start
    path.arcToPoint(Offset(32, size.height),
        radius: Radius.circular(32.0), clockwise: false);
    path.lineTo(size.width * 0.35, size.height);
    path.quadraticBezierTo(
        size.width * 0.43, size.height, size.width * 0.40, size.height - 16);
    path.arcToPoint(Offset(size.width * 0.60, size.height - 16),
        radius: Radius.circular(49.0), clockwise: true, largeArc: true);
    path.quadraticBezierTo(
        size.width * 0.57, size.height, size.width * 0.65, size.height);
    path.lineTo(size.width - 32, size.height);
    path.arcToPoint(Offset(size.width, size.height - 32),
        radius: Radius.circular(32.0), clockwise: false);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawShadow(path, Colors.black, 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
