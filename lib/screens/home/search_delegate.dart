import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationapp/custom_widgets/inherited_auth.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/models/user.dart';

import 'tab_homework/item_homework.dart';
import 'tab_lesson/item_lesson.dart';

class CustomSearchDelegate extends SearchDelegate {
  final User user;
  final List data;
  List suggestionList;

  CustomSearchDelegate(this.data, this.user);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final queryLow = query.toLowerCase();
    if (data.isNotEmpty) {
      if (data[0] is LessonNow) {
        suggestionList = query.isEmpty
            ? data
            : data
                .where((p) => p.lessonName.toLowerCase().contains(queryLow))
                .toList();
        if (suggestionList.length == 0) {
          suggestionList = query.isEmpty
              ? data
              : data
                  .where((p) => p.lessonTea.toLowerCase().contains(queryLow))
                  .toList();
        }
      } else if (data[0] is HwAtHome) {
        suggestionList = query.isEmpty
            ? data
            : data
                .where((p) => p.hwTitle.toLowerCase().contains(queryLow))
                .toList();
        if (suggestionList.length == 0) {
          suggestionList = query.isEmpty
              ? data
              : data
                  .where((p) => p.hwLesson.toLowerCase().contains(queryLow))
                  .toList();
        }
      }
    } else {}

    return InheritedAuth(
      user: user,
      child: ListView(
          children: suggestionList
              .map((e) => e is HwAtHome ? ItemHomeworkNow(e) : ItemLessonNow(e))
              .toList()),
    );
  }
}
