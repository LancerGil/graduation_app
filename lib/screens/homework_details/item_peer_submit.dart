import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/submission.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/screens/homework_details/peer_comment/screen_peercomment.dart';

class ItemPeerSubmit extends StatefulWidget {
  final Homework homework;
  final Submission submission;
  final User user;

  const ItemPeerSubmit({Key key, this.submission, this.user, this.homework})
      : super(key: key);

  @override
  _ItemPeerSubmitState createState() => _ItemPeerSubmitState();
}

class _ItemPeerSubmitState extends State<ItemPeerSubmit>
    with SingleTickerProviderStateMixin {
  bool isFirstPeriodOfComment;

  @override
  void initState() {
    super.initState();
    isFirstPeriodOfComment = widget.homework.hwState == 2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PeerCommentPage(
              homework: widget.homework,
              submission: widget.submission,
              isFirstPeriodOfComment: isFirstPeriodOfComment,
              user: widget.user,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.arrow_right),
                  Text(
                    widget.submission.stuName,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  )
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
