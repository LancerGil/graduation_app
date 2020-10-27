import 'package:flutter/material.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/screens/homework_details/peer_comment/comment_one_angle.dart';
import 'package:graduationapp/screens/homework_details/peer_comment/item_comment_angle.dart';
import 'package:graduationapp/screens/homework_details/submitsheet/submitsheet.dart';

class TeaCommentSheetBody extends StatelessWidget {
  const TeaCommentSheetBody({
    Key key,
    @required double initialPersentage,
    @required this.submit,
    @required this.updateCommentList,
    @required this.commentFromEachAngle,
    @required this.commentAngle,
  })  : _initialPersentage = initialPersentage,
        super(key: key);

  final double _initialPersentage;
  final Function submit, updateCommentList;
  final List<CommentOfOneAngle> commentFromEachAngle;
  final CommentAngle commentAngle;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var updateAt = commentAngle?.updateAt.toString().split('.').first;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        initialChildSize: _initialPersentage,
        minChildSize: _initialPersentage,
        maxChildSize: 0.9,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
              width: MediaQuery.of(context).size.width,
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
              child: Stack(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 105,
                        bottom: size.height * 0.45),
                    controller: scrollController,
                    itemCount: CommentAngle.ANGLE.length,
                    itemBuilder: (context, index) {
                      return ItemCommentFromAngle(
                        size: size,
                        index: index,
                        angle: CommentAngle.ANGLE[index],
                        angleIntro: CommentAngle.ANGLEINTRO[index],
                        updateCommentList: updateCommentList,
                        commentOfOneAngle: commentFromEachAngle[index],
                      );
                    },
                  ),
                  Positioned(top: 0, child: DragBar()),
                  Positioned(
                    width: size.width,
                    top: 20,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '提交师评',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  '上次修改于$updateAt',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 36,
                    child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      child: Text('提交点评'),
                      onPressed: () {
                        submit();
                      },
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
