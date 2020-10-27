import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/custom_widgets/shadow_loading_card.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/home/search_delegate.dart';
import 'package:graduationapp/utils/firebase_store.dart';

import 'item_homework.dart';

class TabHWatHome extends StatefulWidget {
  final List<int> lessonID;

  const TabHWatHome({Key key, this.lessonID}) : super(key: key);

  @override
  _TabHWatHomeState createState() => _TabHWatHomeState();
}

class _TabHWatHomeState extends State<TabHWatHome>
    with SingleTickerProviderStateMixin {
  BaseFireBaseStore _fireBaseStore;
  List<Homework> hwList;
  bool isLoading = true;
  String identity;
  AnimationController loadingController;

  @override
  void initState() {
    super.initState();
    loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fireBaseStore = FireBaseStore();
    getActivatedHomework();
    hwList = [];
    // hwList = Homework.fetchAll(Lesson.classID);
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = InheritedAuth.of(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('作业'),
        centerTitle: true,
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
                    delegate: CustomSearchDelegate(hwList, user)),
          ),
        ),
      ),
      body: ListView(
        key: PageStorageKey("hwScroll"),
        children: isLoading
            ? _showLoadingAnimation()
            : buildHomeworkWidgets(user.identity),
      ),
    );
  }

  _showLoadingAnimation() {
    return Lesson.classID
        .map((e) => LoadingCard(controller: loadingController))
        .toList();
  }

  List<Widget> buildHomeworkWidgets(String identity) {
    List<Widget> result = [];
    if (hwList != null && hwList.isNotEmpty) {
      for (var oneHw in hwList) {
        MapEntry currentStatus = oneHw.getCurrentStatus();
        oneHw.hwState = currentStatus.key;
        if (identity == 'teacher'
            ? currentStatus.key < 7
            : currentStatus.key < 6) {
          MapEntry hwState = oneHw.getCurrentStatus();
          if (hwState.value != null) result.add(ItemHomeworkNow(oneHw));
        }
      }
    }
    if (result.isEmpty) {
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
            Text(
              "暂时没有进行中的作业",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        )
      ];
    } else
      return result;
  }

  getActivatedHomework() async {
    List<List<DocumentSnapshot>> querySnapshots =
        await getHomeworkFromServer(widget.lessonID);
    print("querySnapshots:---:$querySnapshots");
    if (querySnapshots != null && querySnapshots.isNotEmpty) {
      for (int i = 0; i < querySnapshots.length; i++) {
        hwList
          ..addAll(querySnapshots[i]
              .map<Homework>((e) => Homework.fromDocSnapshot(e))
              .toList());
      }
    }
    if (this.mounted) {
      print("hwList---------$hwList");
      isLoading = false;

      loadingController.stop();
      setState(() {});
    }
  }

  Future<List<List<DocumentSnapshot>>> getHomeworkFromServer(
      List<int> lessonID) async {
    print("getActivatedHomework---lessonID:$lessonID");
    List<List<DocumentSnapshot>> querySnapshots = [];
    List<DocumentSnapshot> hwDoc;
    if (lessonID != null && lessonID.isNotEmpty) {
      print("getHomeworkFromServer--lessonID-length:---:${lessonID.length}");

      for (int i = 0; i < lessonID.length; i++) {
        hwDoc = await _fireBaseStore
            .queryDocuments('homework', MapEntry('hwLessonID', lessonID[i]))
            .then((value) => value.documents);
        querySnapshots..add(hwDoc);
      }
    }
    return querySnapshots;
  }
}
