import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/http_response/parse_lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/particles/notes/adding_notes.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class ScheduleBody extends StatefulWidget {
  const ScheduleBody({
    Key key,
    @required this.text,
    @required this.list,
    @required this.controller,
  }) : super(key: key);

  final String text;
  final List<String> list;
  final TabController controller;

  @override
  _ScheduleBodyState createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> {
  SvgPicture imgOnErrorLoad;

  @override
  void initState() {
    imgOnErrorLoad = SvgPicture.asset('assets/img/sad_smile.svg');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lessons>>(
      future: DBLessons.db.select(),
      builder: (context, AsyncSnapshot<List<Lessons>> snapshotFromDataBase) {
        if (!snapshotFromDataBase.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return FutureBuilder<List<List<Lessons>>>(
          future:
              Future.wait([fetchLessons(widget.text), DBLessons.db.select()]),
          initialData: [snapshotFromDataBase.data, snapshotFromDataBase.data],
          builder: (BuildContext context, AsyncSnapshot sp) {
            if (snapshotFromDataBase.data.isEmpty && !sp.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!sp.hasData && snapshotFromDataBase.data.isNotEmpty) {
              print('database');
              return BuildLessons(
                  widget: widget, data: snapshotFromDataBase.data);
            }
            List<Lessons> dataFromInternet = sp.data[0];
            List<Lessons> dataFromDataBase = sp.data[1];
            //if you dont have internet connection
            if (dataFromDataBase == null)
              return buildOnWrongFuture(
                  context,
                  'Cannot load your schedule.\nPlease check your internet connection.',
                  true,
                  imgOnErrorLoad);
            if (sp.connectionState == ConnectionState.done &&
                dataFromDataBase.isEmpty) {
              for (var item in dataFromInternet) {
                DBLessons.db.insert(item);
              }
              dataFromDataBase.addAll(dataFromInternet);
            }
            // incorrect input
            if (sp.connectionState == ConnectionState.done &&
                dataFromDataBase.isEmpty)
              return buildOnWrongFuture(
                  context, 'Input Your group correct', false, imgOnErrorLoad);
            //if something change in schedule(update)
            print(dataFromDataBase.length);
            print(dataFromInternet.length);
            if (sp.connectionState == ConnectionState.done &&
                listEquals(dataFromInternet, dataFromDataBase) &&
                dataFromDataBase.isNotEmpty) {
              print(1);
              return BuildLessons(widget: widget, data: dataFromDataBase);
            } else if (dataFromInternet.isNotEmpty) {
              print(2);
              return BuildLessons(widget: widget, data: dataFromInternet);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }

  Center buildOnWrongFuture(BuildContext context, String description,
      bool isInternetFailed, SvgPicture imgOnErrorLoad) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(0.0),
            child: imgOnErrorLoad,
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          isInternetFailed
              ? FlatButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text(
                    'Refresh',
                    style:
                        TextStyle(color: Theme.of(context).textSelectionColor),
                  ),
                  color: Theme.of(context).primaryColor,
                )
              : FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Change group',
                    style:
                        TextStyle(color: Theme.of(context).textSelectionColor),
                  ),
                  color: Theme.of(context).primaryColor,
                )
        ],
      ),
    );
  }
}

class BuildLessons extends StatelessWidget {
  const BuildLessons({
    Key key,
    @required this.widget,
    @required this.data,
  }) : super(key: key);

  final ScheduleBody widget;
  final List<Lessons> data;

  @override
  Widget build(BuildContext context) {
    return Consumer<Notifier>(
        builder: (context, value, child) => TabBarView(
            controller: widget.controller,
            children: widget.list.map((e) {
              final b = data.where((element) => element.dayName == e);
              if (b.isEmpty)
                return Center(
                    child: Text(
                  'You are free',
                  style: TextStyle(
                    fontSize: 36,
                    letterSpacing: 1.3,
                  ),
                ));
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (data[index].lessonType == 'конс')
                    data[index].lessonType =
                        data[index].lessonType.replaceFirst(RegExp('к'), 'К');
                  if (e == data[index].dayName &&
                      data[index].lessonWeek == value.week) {
                    return GestureDetector(
                        onDoubleTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddingNotes(
                                      data: data[index],
                                    ))),
                        child: LessonBlock(data: data[index]));
                  } else {
                    return Container();
                  }
                },
              );
            }).toList()));
  }
}
