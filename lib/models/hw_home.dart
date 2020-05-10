class HwAtHome {
  String hwTitle, hwAssetPath, hwLesson, hwDescri;
  int hwState, hwID, hwDoneStu;
  bool enablePeer;
  List<DateTime> ddl;
  List<bool> summitTypeChecks;

  HwAtHome(
      this.hwID,
      this.hwAssetPath,
      this.hwTitle,
      this.hwLesson,
      this.hwState,
      this.hwDoneStu,
      this.hwDescri,
      this.enablePeer,
      this.summitTypeChecks,
      this.ddl);

  static List<HwAtHome> fetchAll(List classIDs) {
    return classIDs
        .map(
          (id) => HwAtHome(
            id,
            'assets/images/nezuko.png',
            '第一章第二节2-1、2、3题',
            '课程名称',
            id % 7,
            30,
            '作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求\n作业具体要求',
            false,
            [false, false, true, false],
            [DateTime.now(), null, null, null],
          ),
        )
        .toList();
  }
}
