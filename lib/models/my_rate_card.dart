class MyRateCard {
  final String rateHW, rateLesson, rateStu, rateContent;
  final int rateScore, rateHWState;

  MyRateCard(
    this.rateLesson,
    this.rateHW,
    this.rateStu,
    this.rateHWState,
    this.rateScore,
    this.rateContent,
  );

  static List<MyRateCard> fetchAll(List ids) {
    return ids
        .map(
          (id) => MyRateCard(
            '课程名称',
            '作业题目作业题目作业题目作业题目',
            '被评对象学生',
            2,
            90,
            '评分附加评论评分附加评论评分附加评论评分附加评论评分附加评论',
          ),
        )
        .toList();
  }
}
