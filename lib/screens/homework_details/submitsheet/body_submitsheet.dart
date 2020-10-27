import 'package:flutter/material.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/screens/homework_details/submitsheet/item_recieved_comment.dart';
import 'package:graduationapp/screens/homework_details/submitsheet/submitsheet.dart';
import 'package:graduationapp/screens/homework_details/submitsheet/submitsheet_header.dart';

class MyDraggableScrollableSheet extends StatelessWidget {
  const MyDraggableScrollableSheet({
    Key key,
    @required this.initialPersentage,
    @required this.currentStatus,
    @required this.peerComments,
    @required this.isFirstSubmit,
    @required Submission submission,
    @required this.ableORnot,
    @required this.articleToSubmit,
    @required this.submitHW,
  })  : _submission = submission,
        super(key: key);

  final double initialPersentage;
  final MapEntry<int, DateTime> currentStatus;
  final List<CommentAngle> peerComments;
  final bool isFirstSubmit;
  final Submission _submission;
  final Map<String, bool> ableORnot;
  final TextEditingController articleToSubmit;
  final Function submitHW;

  @override
  Widget build(BuildContext context) {
    buildPeerComment(bool isFromTea) {
      if (peerComments != null && peerComments.isNotEmpty) {
        List<Widget> result = [];
        result.addAll(
          peerComments.where((e) => e.isFromTea == isFromTea).map(
                (e) => ItemComRecieved(
                  commentAngle: e,
                  index: peerComments.indexOf(e),
                  submission: _submission,
                ),
              ),
        );
        return result;
      } else {
        return [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '尚未收到点评',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.grey),
              ),
            ),
          )
        ];
      }
    }

    return DraggableScrollableSheet(
        initialChildSize: initialPersentage,
        minChildSize: initialPersentage,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, ScrollController scrollController) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(155),
                  offset: Offset(0, -11),
                  blurRadius: 13.0,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
                children: <Widget>[
                  Positioned(top: 0, child: DragBar()),
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 270.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  '收到的同伴点评',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          currentStatus.key == 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0, vertical: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '该作业无需同伴互评',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: peerComments == null
                                            ? [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              ]
                                            : buildPeerComment(false),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  '教师点评',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: buildPeerComment(true),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    child: SheetHeader(
                      submit: submitHW,
                      firstSubmit: isFirstSubmit,
                      submission: _submission,
                      ableORnot: ableORnot,
                    ),
                  ),
                  Positioned(
                    top: 70,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: TextField(
                            enabled: ableORnot['submit'],
                            controller: articleToSubmit,
                            maxLines: 6,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          color: Theme.of(context).primaryColor,
                          child: Divider(
                            color: Colors.white,
                            indent: 16,
                            endIndent: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
