import 'package:cloud_firestore/cloud_firestore.dart';

class CommentAngle {
  static const List<String> ANGLE = [
    '思想表达',
    '组织结构',
    '语言的准确度',
    '语言的流利度',
    '语言的复杂度',
  ];
  static const List<String> ANGLEINTRO = [
    '根据作文如何表达思想给出评语并评定等级，你可以参考以下文本特征:内容切题、观点明确、论据有力、论据与论点一致、表达清晰、说服力强、区分事实与观点、达到交际目的。',
    '根据作文的组织结构给出评语并评定等级，你可以参考以下文本特征:段落间过渡自然、每段有主题句、第一段提出观点、最后一段得出结论、语意连贯、语言结构完整。',
    '根据语言的准确度给出评语并评定等级，你可以参考以下文本特征:语法正确、句间衔接自然、句子结构正确、用词准确、固定搭配正确、习语正确、格式正确，语言表达符合要求。',
    '根据语言的流利度给出评语并评定等级，你可以参考以下文本特征:作文长度、无错误子句单词总数和子句长度。',
    '根据语言的复杂度给出评语并评定等级，你可以参考以下文本特征:词汇丰富、句子形式多样、衔接手段多样、使用从句、使用长句或结构复杂的句式',
  ];

  List commentContent, score;
  String docID,
      submitID,
      submiter,
      commentUserID,
      commenter,
      submitUserID,
      homeworkTitle,
      lessonName;
  bool isFirstPeriod, isFromTea;
  DateTime updateAt;

  CommentAngle(
    this.submitID,
    this.submitUserID,
    this.submiter,
    this.commentUserID,
    this.commenter,
    this.lessonName,
    this.homeworkTitle,
    this.isFirstPeriod,
    this.isFromTea,
    this.commentContent,
    this.score,
    this.updateAt, {
    this.docID = 'defaultID',
  });

  static CommentAngle fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    DateTime updateAt = (data['updateAt'] as Timestamp)?.toDate();
    return CommentAngle(
        data['submitID'],
        data['submitUserID'],
        data['submiter'],
        data['commentUserID'],
        data['commenter'],
        data['lessonName'],
        data['homeworkTitle'],
        data['isFirstPeriod'],
        data['isFromTea'],
        data['commentContent'],
        data['score'],
        updateAt,
        docID: snapshot.documentID);
  }

  Map<String, dynamic> toJson() {
    return {
      'docID': docID,
      'submitID': submitID,
      'submitUserID': submitUserID,
      'submiter': submiter,
      'commentUserID': commentUserID,
      'commenter': commenter,
      'lessonName': lessonName,
      'homeworkTitle': homeworkTitle,
      'isFirstPeriod': isFirstPeriod,
      'isFromTea': isFromTea,
      'commentContent': commentContent,
      'score': score,
      'updateAt': updateAt,
    };
  }
}
