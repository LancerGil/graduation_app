import 'package:flutter/material.dart';
import 'package:graduationapp/models/my_rate_card.dart';
import 'package:graduationapp/screens/home/tab_user/item_myrate.dart';

class RateCommentPage extends StatelessWidget {
  final classID = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final String screenTitle;

  RateCommentPage({Key key, this.screenTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      title: Text(screenTitle),
      centerTitle: true,
    );

    var body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        children: _buildList(screenTitle),
      ),
    );

    return Scaffold(
      appBar: appbar,
      body: body,
    );
  }

  List<Widget> buildMyRateCards(List classID) {
    List<MyRateCard> classList = MyRateCard.fetchAll(classID);
    return classList
        .map((e) => ItemMyRateCard(
              e.rateHW,
              e.rateLesson,
              e.rateStu,
              e.rateContent,
              e.rateScore,
              e.rateHWState,
            ))
        .toList();
  }

  List<Widget> _buildList(String screenTitle) {
    switch (screenTitle) {
      case '我的评分':
        return buildMyRateCards(classID);
        break;
      case '收到评分':
        return buildMyRateCards(classID);
        break;
      case '我的回评':
        return buildMyRateCards(classID);
        break;
      case '收到回评':
        return buildMyRateCards(classID);
        break;
      default:
        return null;
    }
  }
}
