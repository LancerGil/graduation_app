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
}
