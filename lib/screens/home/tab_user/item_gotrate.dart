import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/hw_state_text.dart';

class ItemGotRateCard extends StatefulWidget {
  final String rateHW, rateLesson, rateStu, rateContent;
  final int rateScore, rateHWState;

  ItemGotRateCard(
    this.rateHW,
    this.rateLesson,
    this.rateStu,
    this.rateContent,
    this.rateScore,
    this.rateHWState,
  );

  @override
  _ItemGotRateCardState createState() => _ItemGotRateCardState(
        rateHW,
        rateLesson,
        rateStu,
        rateContent,
        rateScore,
        rateHWState,
      );
}

class _ItemGotRateCardState extends State<ItemGotRateCard> {
  final String rateHW, rateLesson, rateStu, rateContent;
  final int rateScore, rateHWState;

  bool _folded = true;

  _ItemGotRateCardState(
    this.rateHW,
    this.rateLesson,
    this.rateStu,
    this.rateContent,
    this.rateScore,
    this.rateHWState,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => LessonPage(
        //               lessonName: _lessonName,
        //               teacherName: _lessonTur,
        //             )));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withAlpha(155),
                      offset: Offset(0, 5),
                      blurRadius: 7.0)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        rateLesson,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '评分阶段:',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(width: 2),
                          HwStateText(hwState: rateHWState),
                        ],
                      ),
                    ],
                  ),
                  Text(rateHW),
                  SizedBox(
                    height: 3.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('评分人:$rateStu'),
                      RichText(
                          text: TextSpan(
                              text: '分数:',
                              style: Theme.of(context).textTheme.bodyText2,
                              children: <TextSpan>[
                            TextSpan(
                                text: '$rateScore',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.green))
                          ]))
                    ],
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.78,
                        child: Text(
                          '评语:$rateContent$rateContent',
                          overflow: TextOverflow.fade,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 13),
                          maxLines: _folded ? 2 : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _folded = !_folded;
                          });
                        },
                        child: _folded
                            ? Icon(Icons.keyboard_arrow_down)
                            : Icon(Icons.keyboard_arrow_up),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
