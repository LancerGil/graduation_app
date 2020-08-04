import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/custom_widgets/loading_card.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/tab_homework/item_homework.dart';
import 'package:graduationapp/screens/homework_details/create_hw.dart';
import 'package:graduationapp/utils/firebase_store.dart';

class TabHomeWork extends StatefulWidget {
  final Lesson currentLesson;

  const TabHomeWork({Key key, this.currentLesson}) : super(key: key);

  @override
  _TabHomeWorkState createState() => _TabHomeWorkState();
}

class _TabHomeWorkState extends State<TabHomeWork>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  BaseFireBaseStore _fireBaseStore;

  AnimationController loadingController;
  List<Homework> hwList;

  @override
  void initState() {
    hwList = [];
    loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fireBaseStore = FireBaseStore();
    getActivatedHomework();
    super.initState();
  }

  @override
  void dispose() {
    loadingController.stop();
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = InheritedAuth.of(context).user;

    var appbar = AppBar(
      centerTitle: true,
      title: Text(
        '课程作业',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        Visibility(
          visible: user.identity == "teacher",
          child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateHWPage(
                              currentLesson: widget.currentLesson,
                            )));
              }),
        ),
      ],
    );
    var body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        children: isLoading ? _showLoadingAnimation() : buildHomeworkWidgets(),
      ),
    );
    return Scaffold(appBar: appbar, body: body);
  }

  _showLoadingAnimation() {
    return Lesson.classID
        .map((e) => LoadingCard(controller: loadingController))
        .toList();
  }

  List<Widget> buildHomeworkWidgets() {
    if (hwList != null && hwList.isNotEmpty) {
      return hwList.map((oneHw) => ItemHomeworkNow(oneHw)).toList();
    }
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Icon(
            Icons.library_books,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "尚无作业记录",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      )
    ];
  }

  getActivatedHomework() async {
    List<DocumentSnapshot> documentSnapshots = await getHomeworkFromServer();
    if (documentSnapshots != null && documentSnapshots.isNotEmpty) {
      hwList
        ..addAll(documentSnapshots
            .map<Homework>(
                (e) => Homework.fromDocSnapshot(e)..hwLessonID = 3333)
            .toList());
    }
    if (this.mounted) {
      print("hwList---------$hwList");
      isLoading = false;

      loadingController.stop();
      setState(() {});
    }
  }

  Future<List<DocumentSnapshot>> getHomeworkFromServer() async {
    List<DocumentSnapshot> hwDoc;
    hwDoc = await _fireBaseStore
        .queryDocuments(
            'homework', MapEntry('hwLessonID', widget.currentLesson.lessonID))
        .then((value) => value.documents);
    return hwDoc;
  }
}
