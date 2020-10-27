import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graduationapp/models/app_model.dart';
import 'package:graduationapp/models/hw_home.dart';
import 'package:graduationapp/models/lesson_home.dart';
import 'package:graduationapp/utils/firebase_store.dart';
import 'package:graduationapp/utils/flutter_toast.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateHWPage extends StatefulWidget {
  final Homework homework;
  final Lesson currentLesson;
  final Function updateHomework;

  const CreateHWPage(
      {Key key, this.homework, this.currentLesson, this.updateHomework})
      : super(key: key);

  @override
  _CreateHWPageState createState() => _CreateHWPageState();
}

class _CreateHWPageState extends State<CreateHWPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _titleController, _detailsController;
  Homework _homework;
  Lesson _lesson;

  bool enablePeer = false, editing = false;
  DateTime _dateNow;
  BaseFireBaseStore fireBaseStore;
  List<DateTime> _ddl;
  List<String> summitTypeOptions;
  List<bool> summitTypeChecks;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
    fireBaseStore = FireBaseStore();
    _dateNow = DateTime.now();
    _ddl = [DateTime.now(), null, null, null];
    summitTypeOptions = ['文字', '图片', '语音', '文档'];
    summitTypeChecks = [false, false, false, false];
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _detailsController.dispose();
  }

  updateScopeHomework() {
    ScopedModel.of<AppModel>(context).setHwCreating(_homework);
  }

  @override
  Widget build(BuildContext context) {
    _lesson = widget.currentLesson;
    editing = widget.homework != null;
    _homework = editing
        ? widget.homework
        : ScopedModel.of<AppModel>(context).hwCreating;

    if (_homework != null) {
      setState(() {
        _titleController.text = _homework.hwTitle;
        _detailsController.text = _homework.hwDescri;
        enablePeer = _homework.enablePeer;
        _ddl = _homework.ddl;
        summitTypeChecks = _homework.summitTypeChecks;
      });
    } else {
      setState(() {
        _homework = Homework("assets/images/nezuko.png", "", _lesson.lessonID,
            _lesson.lessonName, 2, 0, "", false, summitTypeChecks, _ddl,
            hwID: new Random(DateTime.now().second)
                .nextInt(Lesson.MAX_LESSON_ID));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? '编辑作业' : '创建作业'),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () => _leaveWhileEditing(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            onPressed: () => _clickCompleteEditing(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(16.0),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                onChanged: (text) {
                  _homework.hwTitle = text;
                  updateScopeHomework();
                },
                controller: _titleController,
                decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '作业题目',
                    helperText: '设定作业的题目'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (text) {
                  _homework.hwDescri = text;
                  updateScopeHomework();
                },
                autofocus: false,
                controller: _detailsController,
                textAlign: TextAlign.start,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '作业要求',
                  alignLabelWithHint: true,
                  helperText: '详细说明作业的要求',
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AnimatedContainer(
                decoration: const BoxDecoration(
                  border: const Border(
                      top: const BorderSide(width: 1, color: Colors.grey),
                      bottom: const BorderSide(width: 1, color: Colors.grey)),
                ),
                curve: Curves.easeOutCirc,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                  vsync: this,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text('启用同伴互评'),
                          Checkbox(
                            value: enablePeer,
                            onChanged: (value) {
                              setState(() {
                                enablePeer = !enablePeer;
                                _homework.enablePeer = enablePeer;
                                updateScopeHomework();
                              });
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('一稿截至日期'),
                            GestureDetector(
                              onTap: () async {
                                var selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: _dateNow,
                                    firstDate: _dateNow,
                                    lastDate: _dateNow.add(
                                      const Duration(days: 30),
                                    ));
                                if (selectedDate != null) {
                                  setState(() {
                                    _ddl[0] = selectedDate;
                                    _homework.ddl = _ddl;
                                    updateScopeHomework();
                                  });
                                }
                              },
                              child: Text(
                                _ddl[0] == null
                                    ? '----\\--\\--'
                                    : _ddl[0].toString().split(' ')[0],
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Visibility(
                        visible: enablePeer,
                        child: Column(
                          children: _buildPeerOptions(),
                        ),
                      ),
                    ],
                  ),
                ),
                duration: const Duration(milliseconds: 500),
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _leaveWhileEditing() {
    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('是否保留填写信息？'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              ScopedModel.of<AppModel>(context).setHwCreating(null);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('否'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('是'),
          )
        ],
      ),
    );
  }

  _clickCompleteEditing() {
    if (_checkIfFilled()) {
      print(_homework.toJson());
      if (editing) {
        fireBaseStore.updateDocument(
            'homework', _homework.docID, _homework.toJson());
      } else {
        fireBaseStore.addDocument('homework', _homework.toJson());
      }
      MyFlutterToast.showToast(editing ? "修改完成" : "创建成功", context);
      Navigator.of(context).pop();
    } else {
      MyFlutterToast.showToast("请完整填写作业细节", context);
    }
  }

  _checkIfFilled() {
    if (_titleController.text.length == 0) return false;
    if (_detailsController.text.length == 0) return false;
    if (enablePeer) {
      for (int i = 0; i < _ddl.length; i++) {
        if (_ddl[i] == null) return false;
      }
    }
    return true;
  }

  List<Widget> _buildPeerOptions() {
    List<Widget> peerOptions = [];
    DateTime initial = _dateNow;
    for (int i = 1; i < _ddl.length; i++) {
      if (_ddl[i - 1] != null) initial = _ddl[i - 1];
      peerOptions.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(Homework.peerOptions[i - 1]),
              GestureDetector(
                onTap: () async {
                  var selectedDate = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: initial,
                      lastDate: initial.add(
                        const Duration(days: 30),
                      ));
                  if (selectedDate != null) {
                    setState(() {
                      _ddl[i] = selectedDate;
                      _homework.ddl = _ddl;
                      updateScopeHomework();
                    });
                  }
                },
                child: Text(
                  _ddl[i] == null
                      ? '----\\--\\--'
                      : _ddl[i].toString().split(' ')[0],
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return peerOptions;
  }
}
