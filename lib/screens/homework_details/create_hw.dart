import 'package:flutter/material.dart';
import 'package:graduationapp/models/hw_home.dart';

class CreateHWPage extends StatefulWidget {
  final HwAtHome homework;

  const CreateHWPage({Key key, this.homework}) : super(key: key);

  @override
  _CreateHWPageState createState() => _CreateHWPageState();
}

class _CreateHWPageState extends State<CreateHWPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _titleController, _detailsController;
  HwAtHome homework;

  bool enablePeer = false, editable = false;
  DateTime _dateNow = DateTime.now();
  List<DateTime> _ddl = [
    DateTime.now(),
    null,
    null,
    null,
  ];
  List<String> peerOptions = [
    '一评截至日期',
    '二评截至日期',
    '回评截至日期',
  ];
  List<String> summitTypeOptions = [
    '文字',
    '图片',
    '语音',
    '文档',
  ];
  List<bool> summitTypeChecks = [
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _detailsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // homework = widget.homework == null
    //     ? ScopedModel.of<AppModel>(context).hwAtHome
    //     : widget.homework;
    if (homework != null) {
      setState(() {
        _titleController.text = homework.hwTitle;
        _detailsController.text = homework.hwDescri;
        enablePeer = homework.enablePeer;
        _ddl = homework.ddl;
        summitTypeChecks = homework.summitTypeChecks;
      });
    } else {
      homework =
          HwAtHome(0, "", "", "", 2, 5, "", false, summitTypeChecks, _ddl);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('创建作业'),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('是否保留填写信息？'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      // ScopedModel.of<AppModel>(context).setHwAtHome(null);
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
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              editable ? Icons.check : Icons.edit,
              color: editable ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              if (editable) {
                //TODO: 完成创建作业
                setState(() {
                  editable = !editable;
                });
              } else {
                setState(() {
                  editable = !editable;
                });
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            ignoring: !editable,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  enabled: editable,
                  onChanged: (text) {
                    homework.hwTitle = text;
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
                  enabled: editable,
                  onChanged: (text) {
                    homework.hwDescri = text;
                    updateScopeHomework();
                  },
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
                              tristate: true,
                              value: enablePeer,
                              onChanged: (value) {
                                setState(() {
                                  enablePeer = !enablePeer;
                                  homework.enablePeer = enablePeer;
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
                              const Text('提交截至日期'),
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
                                      homework.ddl = _ddl;
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
                          child: Container(
                            height: 110.0,
                            child: ListView(
                              children: _buildPeerOptions(),
                            ),
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
                Text('作业提交形式'),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  direction: Axis.horizontal,
                  children: _buildSummitTypeOptions(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateScopeHomework() {
    // ScopedModel.of<AppModel>(context).setHwAtHome(homework);
  }

  List<Widget> _buildSummitTypeOptions() {
    return summitTypeOptions
        .map((f) => Container(
              width: 90.0,
              child: Row(
                children: <Widget>[
                  Text(f),
                  Checkbox(
                    tristate: true,
                    value: summitTypeChecks[summitTypeOptions.indexOf(f)],
                    onChanged: (value) {
                      setState(() {
                        summitTypeChecks[summitTypeOptions.indexOf(f)] =
                            !summitTypeChecks[summitTypeOptions.indexOf(f)];
                      });
                    },
                  )
                ],
              ),
            ))
        .toList();
  }

  List<Widget> _buildPeerOptions() {
    return _ddl.map((f) {
      if (_ddl.indexOf(f) == 0) {
        return Container();
      }
      DateTime initial = f == null ? _dateNow : f;
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text((peerOptions[_ddl.indexOf(f) - 1])),
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
                      _ddl[_ddl.indexOf(f)] = selectedDate;
                      homework.ddl = _ddl;
                      updateScopeHomework();
                    });
                  }
                },
                child: Text(
                  f == null ? '----\\--\\--' : f.toString().split(' ')[0],
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ));
    }).toList();
  }
}
