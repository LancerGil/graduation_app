import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/shadow_container.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/for_tea.dart/single_submission_detail.dart';

class ItemSubmission extends StatelessWidget {
  final Submission submission;
  final Homework homework;
  final User user;
  const ItemSubmission({Key key, this.submission, this.homework, this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double windowsWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleSubmissionDetail(
              submission: submission,
              homework: homework,
              user: user,
            ),
          ),
        );
      },
      child: ShadowContainer(
        margin:
            EdgeInsets.symmetric(horizontal: windowsWidth * 0.02, vertical: 8),
        width: windowsWidth * 0.94,
        child: Padding(
          padding: EdgeInsets.all(windowsWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(submission.stuName),
                Row(
                  children: [
                    Text(submission.stuID),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_right,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ]),
              Text(
                submission.updateAt.toString().split('.').first,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
