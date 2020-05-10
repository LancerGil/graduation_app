import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LessonTime extends Model {
  String _weekDay = '一';
  TimeOfDay _startAt = TimeOfDay.now(), _finishAt = TimeOfDay.now();

  String get weekday => _weekDay;
  setWeekDay(int value) {
    String weekDayInChinese = '一';
    switch (value) {
      case 1:
        weekDayInChinese = '二';
        break;
      case 2:
        weekDayInChinese = '三';
        break;
      case 3:
        weekDayInChinese = '四';
        break;
      case 4:
        weekDayInChinese = '五';
        break;
      case 5:
        weekDayInChinese = '六';
        break;
      case 6:
        weekDayInChinese = '七';
        break;
      default:
        break;
    }
    _weekDay = weekDayInChinese;
  }

  TimeOfDay get startAt => _startAt;
  setStartAt(TimeOfDay value) {
    _startAt = value;
  }

  TimeOfDay get finishAt => _finishAt;
  setFinishAt(TimeOfDay value) {
    _finishAt = value;
  }
}
