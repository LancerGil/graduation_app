import 'package:cloud_firestore/cloud_firestore.dart';

class HWQuestion {
  final int id, hwID, stuID;
  final String question, answer;
  final DateTime updateAt;

  HWQuestion(this.id, this.hwID, this.stuID, this.question, this.answer,
      this.updateAt);

  static fetch(count) {
    List list = [];
    for (int i = 0; i < count; i++) {
      list
        ..add(
          HWQuestion(
            i,
            i,
            i,
            '请问老师，这个题目指的是xxxxxxxx吗，还是xxxxxxxxx？，请问老师，这个题目指的是xxxxxxxx吗，还是xxxxxxxxx？',
            '这里的xxxxxxxxxx指的是xxxxxxxxxx。',
            DateTime.now(),
          ),
        );
    }
    return list;
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;

    return HWQuestion(
      data['id'],
      data['hwID'],
      data['stuID'],
      data['question'],
      data['answer'],
      DateTime.parse(data['updateAt']),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'hwID': hwID,
      'stuID': stuID,
      'question': question,
      'answer': answer,
      'updateAt': updateAt.toString(),
    };
  }
}
