import 'package:graduationapp/models/stu_card.dart';

class StuGroup {
  final int groupID;
  final String groupName;
  final List<LessonStu> members;

  StuGroup(this.groupID, this.groupName, this.members);

  static fetch() {
    List<StuGroup> groups = new List();
    List<LessonStu> members = LessonStu.fetchAll([0, 1, 2, 3]);
    for (int i = 0; i < 10; i++) {
      groups..add(StuGroup(i, 'groupName-$i', members));
    }

    return groups;
  }
}
