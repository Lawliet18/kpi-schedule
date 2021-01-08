import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/teacher_schedule_model.dart';
import 'package:schedule_kpi/http_response/parse_teacher_schedule.dart';
import 'package:schedule_kpi/particles/current_week.dart';
import 'package:schedule_kpi/save_data/db_teacher_schedule.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class TeacherScheduleWidget extends StatefulWidget {
  final String teacherName;

  const TeacherScheduleWidget({Key? key, required this.teacherName})
      : super(key: key);

  @override
  _TeacherScheduleWidgetState createState() => _TeacherScheduleWidgetState();
}

class _TeacherScheduleWidgetState extends State<TeacherScheduleWidget> {
  List<String> listUkr = [
    'Понеділок',
    'Вівторок',
    'Середа',
    'Четвер',
    "П’ятниця",
    'Субота'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.teacherName,
                maxLines: 2,
                style: TextStyle(
                    fontSize: widget.teacherName.length > 30 ? 15 : 18),
              ),
            ),
            SizedBox(width: 10),
            CurrentWeek(),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TeacherSchedules>>(
        future: DBTeacherSchedule.db.select(),
        builder: (BuildContext context,
            AsyncSnapshot<List<TeacherSchedules>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return LoadingFromInternet(
              widget: widget, listUkr: listUkr, data: snapshot.data!);

          //  else {
          //   final list = listUkr
          //       .map((e) =>
          //           data.where((element) => element.dayName == e).toList())
          //       .toList();
          //   return BuildList(list: list);
          // }
        },
      ),
    );
  }
}

class LoadingFromInternet extends StatelessWidget {
  const LoadingFromInternet({
    Key? key,
    required this.widget,
    required this.listUkr,
    required this.data,
  }) : super(key: key);

  final TeacherScheduleWidget widget;
  final List<String> listUkr;
  final List<TeacherSchedules> data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TeacherSchedules>?>(
        future: fetchTeacherSchedule(widget.teacherName),
        builder: (BuildContext context,
            AsyncSnapshot<List<TeacherSchedules>?> snapshot) {
          if (!snapshot.hasData && data.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && data.isEmpty) {
            return Center(
              child: Text(
                'Teacher are free',
                style: TextStyle(fontSize: 36),
              ),
            );
          }
          if (!snapshot.hasData && data.isNotEmpty) {
            final list = listUkr
                .map((e) =>
                    data.where((element) => element.dayName == e).toList())
                .toList();
            return BuildList(list: list);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(child: Text("Can't load"));
          }
          List<TeacherSchedules> dataFromInternet = snapshot.data!;
          if (snapshot.connectionState == ConnectionState.done &&
              data.isEmpty &&
              dataFromInternet.isNotEmpty) {
            for (var item in dataFromInternet) {
              DBTeacherSchedule.db.insert(item);
            }
            final list = listUkr
                .map((e) => dataFromInternet
                    .where((element) => element.dayName == e)
                    .toList())
                .toList();
            return BuildList(list: list);
          }
          if (snapshot.connectionState == ConnectionState.done &&
              dataFromInternet.isNotEmpty &&
              data.isNotEmpty &&
              !listEquals(data, dataFromInternet)) {
            for (var item in dataFromInternet) {
              DBTeacherSchedule.db.update(item);
            }
            final list = listUkr
                .map((e) => dataFromInternet
                    .where((element) => element.dayName == e)
                    .toList())
                .toList();
            return BuildList(list: list);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class BuildList extends StatelessWidget {
  const BuildList({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<List<TeacherSchedules>> list;

  @override
  Widget build(BuildContext context) {
    return Consumer<Notifier>(
      builder: (context, value, child) {
        final week = value.week;
        List l = [];
        list.forEach((e) {
          l.addAll(e
              .where((element) => element.lessonWeek == week.toStr())
              .toList());
        });
        return l.isNotEmpty
            ? ListView(
                children: list.map((e) {
                final listOfLessonWeek = e
                    .where((element) => element.lessonWeek == week.toStr())
                    .toList();
                return listOfLessonWeek.isEmpty
                    ? Container()
                    : Card(
                        elevation: 6,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: listOfLessonWeek.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TeacherParticles(
                                  data: listOfLessonWeek,
                                  index: index,
                                  lessonWeek: week);
                            },
                          ),
                        ));
              }).toList())
            : Center(
                child: Text(
                  'Teacher are free',
                  style: TextStyle(fontSize: 36),
                ),
              );
      },
    );
  }
}

class TeacherParticles extends StatelessWidget {
  final List<TeacherSchedules> data;
  final int index;
  final Week lessonWeek;
  const TeacherParticles(
      {Key? key,
      required this.data,
      required this.index,
      required this.lessonWeek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: data[index].lessonWeek == lessonWeek.toStr()
            ? Column(
                children: [
                  index == 0
                      ? Text(
                          data[index].dayName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2),
                        )
                      : Divider(
                          color: Colors.black,
                        ),
                  SizedBox(height: 10),
                  Text(
                    data[index].lessonFullName,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          'Groups: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [Text('group')],
                            // children: data[index]
                            //     .groups
                            //     .map((e) => Text(
                            //           e.groupFullName.toUpperCase() + " ",
                            //           style: TextStyle(
                            //               fontStyle: FontStyle.italic,
                            //               fontSize: 16),
                            //           overflow: TextOverflow.ellipsis,
                            //         ))
                            //     .toList()
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Type: ', style: TextStyle(fontSize: 16)),
                          Text(
                            data[index].lessonType +
                                ' ' +
                                data[index].lessonRoom,
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            data[index].timeStart.substring(0, 5),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            data[index].timeEnd.substring(0, 5),
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              )
            : Container());
  }
}
