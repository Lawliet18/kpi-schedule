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
      builder: (context, AsyncSnapshot<List<Lessons>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return snapshot.connectionState == ConnectionState.done &&
                snapshot.data.isEmpty
            ? FutureBuilder(
                future: fetchLessons(widget.text),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<Lessons> data = snapshot.data;
                  if (data == null)
                    return buildOnWrongFuture(
                        context,
                        'Cannot load your schedule.\nPlease check your internet connection.',
                        true,
                        imgOnErrorLoad);
                  if (snapshot.connectionState == ConnectionState.done &&
                      data.isEmpty) {
                    for (var item in data) {
                      DBLessons.db.insert(item);
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      data.isEmpty)
                    return buildOnWrongFuture(context,
                        'Input Your group correct', false, imgOnErrorLoad);

                  return snapshot.connectionState == ConnectionState.done &&
                          data.isNotEmpty
                      ? BuildLessons(widget: widget, data: data)
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                })
            : BuildLessons(widget: widget, data: snapshot.data);
      },
    );
  }

  Center buildOnWrongFuture(BuildContext context, String description,
      bool isInternetFailed, SvgPicture imgOnErrorLoad) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
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
