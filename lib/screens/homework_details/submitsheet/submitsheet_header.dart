import 'package:flutter/material.dart';
import 'package:graduationapp/models/submission.dart';

class SheetHeader extends StatelessWidget {
  final Function submit;
  final bool firstSubmit;
  final Submission submission;
  final Map<String, bool> ableORnot;

  const SheetHeader(
      {Key key, this.submit, this.firstSubmit, this.submission, this.ableORnot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var updateAt = submission?.updateAt.toString().split('.').first;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '我的提交',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white),
                ),
                Text(
                  submission == null ? '' : '上次修改于$updateAt',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(
                  visible: !ableORnot['submit'],
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '(已截止)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ),
                RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.white,
                  child: Text(firstSubmit ? '添加提交' : '修改提交'),
                  onPressed: !ableORnot['submit'] ? null : submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
