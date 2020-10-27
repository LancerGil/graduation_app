import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/custom_widgets/shadow_loading_card.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/lesson_stu.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/lesson/screen_lesson.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/firebase_userinfo.dart';

import '../search_delegate.dart';
import 'item_lesson.dart';
import 'screen_create_lesson/screen_create_lesson.dart';

class TabLessonAtHome extends StatefulWidget {
  final Function setLessonIDCallBack;
  const TabLessonAtHome({Key key, this.setLessonIDCallBack}) : super(key: key);

  @override
  _TabLessonAtHomeState createState() => _TabLessonAtHomeState();
}

class _TabLessonAtHomeState extends State<TabLessonAtHome>
    with SingleTickerProviderStateMixin {
  TextEditingController lessonNumController;
  List lessonList;
  User user;
  BaseFireBaseStore fireBaseStore;
  BaseUserInfo currentUser;
  bool isLoading = true, isSearching = false;
  AnimationController loadingController;
  List<int> listOfLessonId;

  @override
  void initState() {
    super.initState();
    print('TabLessonAtHome-----initState');

    fireBaseStore = FireBaseStore();
    lessonNumController = TextEditingController();
    loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    listOfLessonId = [];
  }

  @override
  void dispose() {
    print('TabLessonAtHome-----dispose');
    lessonNumController.dispose();
    loadingController.stop();
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = InheritedAuth.of(context).user;
    currentUser = FireBaseUserInfor(user.userId);
    print('TabLessonAtHome-----building');
    if (lessonList == null) {
      getLessons();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('课程'),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () => isLoading ? null : _handleAdd(user.identity),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  isSearching ? CircularProgressIndicator() : Icon(Icons.add),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () => isLoading
                ? null
                : showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(lessonList, user),
                  ),
          ),
        ),
      ),
      body: ListView(
        key: PageStorageKey("lessonScroll"),
        children: isLoading ? _showLoadingAnimation() : buildLessonWidgets(),
      ),
    );
  }

  _showLoadingAnimation() {
    return Lesson.classID
        .map((e) => LoadingCard(controller: loadingController))
        .toList();
  }

  List<Widget> buildLessonWidgets() {
    if (lessonList != null && lessonList.isNotEmpty) {
      return lessonList.map((oneLesson) => ItemLessonNow(oneLesson)).toList();
    }
    return [
      Center(
        child: Container(
          child: Text(
            user.identity == 'teacher'
                ? '尚没有创建课程\n点击右上角\"+\"即可创建'
                : '尚没有加入课程\n点击右上角\"+\"即可加入',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
      )
    ];
  }

  _handleAdd(String identity) {
    switch (identity) {
      case "student":
        _showAddLessonDialog();
        break;
      case "teacher":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateLessonPage(
              user: user,
            ),
          ),
        );
        break;
      default:
    }
  }

  searchLessonInDB(int lessonNum) {
    if (this.mounted) {
      setState(() {
        isSearching = true;
      });
    }
    _searchLesson(lessonNum).then((value) async {
      if (this.mounted) {
        setState(() {
          isSearching = false;
        });
      }
      if (value != null) {
        _joinLessonOnServer(value, user);
        getLessons();

        _navitateToLessonPage(value, user);
      } else {
        _showLessonNotFoundDialog();
      }
    });
  }

  _showAddLessonDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('加入课程'),
          content: Container(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('输入课程码', style: Theme.of(context).textTheme.bodyText1),
                TextField(
                  controller: lessonNumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            FlatButton(
              onPressed: () {
                int lessonNum = int.parse(lessonNumController.text);
                if (listOfLessonId.contains(lessonNum)) {
                  _navitateToLessonPage(
                    lessonList
                        .where((element) => element.lessonID == lessonNum)
                        .toList()[0],
                    user,
                  );
                  return;
                }
                searchLessonInDB(lessonNum);
                Navigator.of(context).pop();
              },
              child: Text('确定'),
            )
          ],
        ));
  }

  _navitateToLessonPage(lesson, user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPage(
          lesson: lesson,
          user: user,
        ),
      ),
    );
  }

  _showLessonNotFoundDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('没有找到该课程'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('确定'),
            ),
          ],
        ));
  }

  getLessons() async {
    setState(() {
      isLoading = true;
      loadingController.forward();
    });
    List<DocumentSnapshot> lessonDocuments = [], teachersDocument = [];
    DocumentSnapshot lessonDoc, lessonTea;
    if (user.identity == 'teacher') {
      lessonDocuments = await fireBaseStore
          .queryDocuments('lesson', MapEntry('lessonTea', user.userId))
          .then((value) => value.documents);

      listOfLessonId =
          lessonDocuments.map<int>((e) => e.data['lessonID']).toList();
      widget.setLessonIDCallBack(listOfLessonId);
      print(listOfLessonId);

      if (this.mounted) {
        setState(() {
          lessonList = lessonDocuments
              .map((e) => Lesson.fromSnapshot(e, teacher: user.fullname))
              .toList();
          isLoading = false;
          loadingController.stop();
        });
      }
    } else {
      List<DocumentSnapshot> listLessonStu = await fireBaseStore
          .queryDocuments('lesson_stu', MapEntry("stuID", user.userId))
          .then((value) => value.documents);

      listOfLessonId =
          listLessonStu.map<int>((e) => e.data['lessonID']).toList();
      widget.setLessonIDCallBack(listOfLessonId);
      print(listOfLessonId);

      for (int i = 0; i < listLessonStu.length; i++) {
        lessonDoc = await fireBaseStore
            .queryDocuments('lesson',
                MapEntry('lessonID', listLessonStu[i].data['lessonID']))
            .then((value) => value.documents[0]);
        lessonDocuments..add(lessonDoc);
      }
      print(lessonDocuments);

      for (int i = 0; i < lessonDocuments.length; i++) {
        lessonTea =
            await FireBaseUserInfor(lessonDocuments[i].data['lessonTea'])
                .getUserExtraInfor()
                .then((value) => value.documents[0]);
        teachersDocument..add(lessonTea);
      }

      if (this.mounted) {
        setState(() {
          lessonList = lessonDocuments
              .map((e) => Lesson.fromSnapshot(e,
                  teacher: teachersDocument[lessonDocuments.indexOf(e)]
                      .data['fullname']))
              .toList();
          print(lessonList);
          isLoading = false;
          loadingController.stop();
          // loadingControler.dispose();
        });
      }
    }
  }

  _searchLesson(lessonNum) async {
    QuerySnapshot lessonSnapshot = await fireBaseStore.queryDocuments(
        'lesson', MapEntry('lessonID', lessonNum));
    if (lessonSnapshot.documents.length > 0) {
      BaseUserInfo info =
          FireBaseUserInfor(lessonSnapshot.documents[0].data["lessonTea"]);
      QuerySnapshot userSnapshot = await info.getUserExtraInfor();
      User tea = User.fromSnapshot(userSnapshot);
      Lesson lesson = Lesson.fromSnapshot(lessonSnapshot.documents[0],
          teacher: tea.fullname);
      return lesson;
    } else {
      return null;
    }
  }

  _joinLessonOnServer(Lesson lesson, User user) {
    LessonStu lessonStu = LessonStu(
      'stuImagePath',
      user.fullname,
      user.stuID,
      0,
      false,
      user.userId,
      lesson.lessonID,
    );
    fireBaseStore.addDocument('lesson_stu', lessonStu.toJson());
  }

  // @override
  // bool get wantKeepAlive => true;
}
