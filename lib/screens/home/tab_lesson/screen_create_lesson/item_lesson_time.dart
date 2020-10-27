import 'package:flutter/material.dart';
import 'package:graduationapp/models/index.dart';

class ItemLessonTime extends StatefulWidget {
  final int index;
  final LessonTime lessonTime;
  final Function deleteThis, updateThis;

  ItemLessonTime(
      {Key key, this.lessonTime, this.deleteThis, this.index, this.updateThis})
      : super(key: key);

  @override
  _ItemLessonTimeState createState() => _ItemLessonTimeState();
}

class _ItemLessonTimeState extends State<ItemLessonTime> {
  int weekDay = 1;
  String startAt, finishAt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    startAt = widget.lessonTime.startAt.format(context);
    finishAt = widget.lessonTime.finishAt.format(context);
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          SizedBox(width: 30),
          Text('${widget.index + 1}'),
          Spacer(),
          Text('星期'),
          GestureDetector(
            onTap: () {
              widget.lessonTime.setWeekDay(value: weekDay++ % 7);
              widget.updateThis(context, widget.index, widget.lessonTime);
            },
            child: Text(
              '${widget.lessonTime.weekday}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              TimeOfDay result = await _pickATimeOfDay();
              if (result == null) {
                return;
              }
              widget.lessonTime.setStartAt(result);
              widget.updateThis(context, widget.index, widget.lessonTime);
            },
            child: Text(
              '$startAt',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Text(' — '),
          GestureDetector(
            onTap: () async {
              TimeOfDay result = await _pickATimeOfDay();
              if (result == null) {
                return;
              }
              widget.lessonTime.setFinishAt(result);
              widget.updateThis(context, widget.index, widget.lessonTime);
            },
            child: Text(
              '$finishAt',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              widget.deleteThis(context, widget.index);
            },
            child: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }

  Future<TimeOfDay> _pickATimeOfDay() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }
}
