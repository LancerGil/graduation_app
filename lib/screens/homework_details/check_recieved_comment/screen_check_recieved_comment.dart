import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/animated_icon.dart';
import 'package:graduationapp/custom_widgets/animated_shadow_container.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/reply.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/check_recieved_comment/item_comment_angle_readonly.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/flutter_toast.dart';
import 'package:numberpicker/numberpicker.dart';

class CheckCommentPage extends StatefulWidget {
  final teaChecking;
  final int index;
  final Submission submission;
  final CommentAngle commentAngle;

  const CheckCommentPage({
    Key key,
    this.commentAngle,
    this.submission,
    this.index,
    this.teaChecking = false,
  }) : super(key: key);

  @override
  _CheckCommentPageState createState() => _CheckCommentPageState();
}

class _CheckCommentPageState extends State<CheckCommentPage> {
  bool editingReply = false;
  Size size;
  TextEditingController replyController;
  int replyScrore = 0;
  FireBaseStore fireBaseStore;
  Reply existingReply;
  User user;

  @override
  void initState() {
    replyController = TextEditingController();
    fireBaseStore = FireBaseStore();
    checkExistingReply();
    super.initState();
  }

  _rate() {
    showDialog<int>(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 5,
            initialIntegerValue: replyScrore,
          ),
        );
      },
    ).then((onValue) {
      if (onValue != null) {
        setState(() {
          replyScrore = onValue;
        });
      }
    });
  }

  checkExistingReply() async {
    QuerySnapshot snapshot = await fireBaseStore.queryDocuments(
      'reply',
      MapEntry(
        'commentDocID',
        widget.commentAngle.docID,
      ),
    );
    if (snapshot.documents != null && snapshot.documents.isNotEmpty) {
      existingReply = Reply.fromSnapshot(snapshot.documents.first);
      replyController.text = existingReply.content;
      replyScrore = existingReply.score;
      if (mounted) setState(() {});
    }
  }

  submitReply(context) {
    if (checkIfFilled()) {
      var reply = Reply(
        existingReply != null ? existingReply.docID : 'defaultID',
        widget.commentAngle.docID,
        replyController.text,
        widget.commentAngle.commentUserID,
        widget.commentAngle.commenter,
        widget.submission.userID,
        widget.submission.stuName,
        widget.commentAngle.homeworkTitle,
        widget.commentAngle.lessonName,
        replyScrore,
        DateTime.now(),
      );
      if (existingReply == null)
        fireBaseStore.addDocument('reply', reply.toJson());
      else
        fireBaseStore.updateDocument(
            'reply', existingReply.docID, reply.toJson());
      MyFlutterToast.showToast('提交成功', context);
      setState(() {
        editingReply = !editingReply;
      });
    } else {
      MyFlutterToast.showToast('请给出评价和非零评分', context);
    }
  }

  checkIfFilled() {
    if (replyController.text.isEmpty) return false;
    if (replyScrore == 0) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var updateAt = widget.commentAngle?.updateAt.toString().split('.').first;

    buildCommentOfEachAngle() {
      List<Widget> commentOfEachAngleWidget = List(CommentAngle.ANGLE.length);
      for (int i = 0; i < CommentAngle.ANGLE.length; i++) {
        commentOfEachAngleWidget[i] = ItemCommentFromAngleReadOnly(
          size: size,
          angle: CommentAngle.ANGLE[i],
          content: widget.commentAngle.commentContent[i],
          index: i,
          score: widget.commentAngle.score[i],
        );
      }
      return commentOfEachAngleWidget;
    }

    var appBar = AppBar(
      title: Text('点评'),
      centerTitle: true,
    );
    var body = Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ShadowContainer(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '提交作业',
                        ),
                        Spacer(),
                        Text(
                          widget.commentAngle.isFirstPeriod ? '一稿' : '二稿',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '作业内容:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.submission.hwContent_2.isEmpty
                          ? widget.submission.hwContent_1
                          : widget.commentAngle.isFirstPeriod
                              ? widget.submission.hwContent_1
                              : widget.submission.hwContent_2,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
              ShadowContainer(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 64),
                width: size.width,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '点评人',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(widget.commentAngle.commenter),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '更新时间',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(updateAt),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      ...buildCommentOfEachAngle()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: editingReply,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                editingReply = !editingReply;
              });
            },
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.grey.withAlpha(100),
            ),
          ),
        ),
      ],
    );

    var floatingActionReplay = Visibility(
      visible: !widget.commentAngle.isFromTea && !widget.teaChecking,
      child: AnimatedShadowContainer(
        margin: EdgeInsets.only(left: 32, right: 32, top: 280),
        width: size.width,
        height: editingReply ? 240 : 70,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        curve: Curves.easeInOutCirc,
        duration: Duration(milliseconds: 400),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('回评'),
                    Text(
                      '评价来自同伴的点评质量',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Spacer(),
                AnimatedIconButton(
                  size: 30,
                  showInitAsDefault: !editingReply,
                  initalIcon: Icons.arrow_drop_up,
                  anotherIcon: Icons.arrow_drop_down,
                  doSomeThing: () {
                    setState(() {
                      if (editingReply)
                        FocusScope.of(context).unfocus();
                      else
                        FocusScope.of(context).requestFocus();
                      editingReply = !editingReply;
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: editingReply ? true : false,
              child: Column(
                children: [
                  Divider(),
                  TextField(
                    controller: replyController,
                    maxLines: 3,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _rate(),
                        child: Text(
                          '评分(1~5)：$replyScrore',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          submitReply(context);
                        },
                        child: ShadowContainer(
                          radius: 8,
                          padding: const EdgeInsets.all(10.0),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            '提交',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionReplay,
      floatingActionButtonLocation: editingReply
          ? FloatingActionButtonLocation.centerTop
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: MyFloatingActionButtonAnimator(),
    );
  }
}

class MyFloatingActionButtonAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    return Offset(0, begin.dy + (end.dy - begin.dy) * progress);
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 0.0, end: 0.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    // The animations will cross at value 0, and the train will return to 1.0.
    return CurvedAnimation(
        parent: TrainHoppingAnimation(
          Tween<double>(begin: 1.0, end: 1.0).animate(parent),
          Tween<double>(begin: 1.0, end: 1.0).animate(parent),
        ),
        curve: Curves.easeInOutCirc);
  }
}
