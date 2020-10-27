import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/firebase_userinfo.dart';

import '../models/lesson_home.dart';

abstract class BaseLessonRepository {
  /// Throws [NetworkException].
  Future<List<Lesson>> checkLesson(User user);
}

class LessonRepository implements BaseLessonRepository {
  BaseFireBaseStore fireBaseStore = FireBaseStore();
  @override
  Future<List<Lesson>> checkLesson(User user) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () async {
        List<int> listOfLessonId;
        List<Lesson> lessonList;
        List<DocumentSnapshot> lessonDocuments = [], teachersDocument = [];
        DocumentSnapshot lessonDoc, lessonTea;
        if (user.identity == 'teacher') {
          lessonDocuments = await fireBaseStore
              .queryDocuments('lesson', MapEntry('lessonTea', user.userId))
              .then((value) => value.documents);

          listOfLessonId =
              lessonDocuments.map<int>((e) => e.data['lessonID']).toList();
          lessonList = lessonDocuments
              .map<Lesson>(
                  (e) => Lesson.fromSnapshot(e, teacher: user.fullname))
              .toList();
          print(listOfLessonId);
        } else {
          List<DocumentSnapshot> listLessonStu = await fireBaseStore
              .queryDocuments('lesson_stu', MapEntry("stuID", user.userId))
              .then((value) => value.documents);

          listOfLessonId =
              listLessonStu.map<int>((e) => e.data['lessonID']).toList();
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
          lessonList = lessonDocuments
              .map<Lesson>((e) => Lesson.fromSnapshot(e,
                  teacher: teachersDocument[lessonDocuments.indexOf(e)]
                      .data['fullname']))
              .toList();
        }
        return lessonList;
      },
    );
  }
}

class NetworkException implements Exception {}
