class StudentCard {
  final String stuName, stuImagePath;
  final int stuID, stuAvgScore;
  final bool isLeader;

  StudentCard(this.stuImagePath, this.stuName, this.stuID, this.stuAvgScore,
      this.isLeader);

  static List<StudentCard> fetchAll(List classIDs) {
    return classIDs
        .map(
          (id) => StudentCard(
            'assets/images/nezuko.png',
            '学生名字',
            20161003441,
            90,
            id % 4 == 0 ? true : false,
          ),
        )
        .toList();
  }
}
