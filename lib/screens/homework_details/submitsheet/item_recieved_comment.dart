import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:graduationapp/custom_widgets/circle_image.dart';
import 'package:graduationapp/models/comment_angle.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/screens/homework_details/check_recieved_comment/screen_check_recieved_comment.dart';

class ItemComRecieved extends StatelessWidget {
  final bool teaChecking;
  final int index;
  final CommentAngle commentAngle;
  final Submission submission;

  const ItemComRecieved({
    Key key,
    this.commentAngle,
    this.index,
    this.submission,
    this.teaChecking = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckCommentPage(
              teaChecking: teaChecking,
              index: index,
              commentAngle: commentAngle,
              submission: submission,
            ),
          ),
        );
      },
      child: Hero(
        tag: 'hero_comment$index',
        child: ShadowContainer(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              CircleImage(
                height: 40,
                width: 40,
                imageUrl: 'assets/images/nezuko2.png',
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(commentAngle.commenter),
                  Text(
                    commentAngle.isFromTea
                        ? '教师点评'
                        : commentAngle.isFirstPeriod
                            ? '一稿点评'
                            : '二稿点评',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Icon(Icons.arrow_right_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
