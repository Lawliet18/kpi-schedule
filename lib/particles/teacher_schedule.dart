import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/teacher_schedule_model.dart';
import 'package:schedule_kpi/http_response/parse_teacher_schedule.dart';
import 'package:schedule_kpi/particles/current_week.dart';
import 'package:schedule_kpi/save_data/db_teacher_schedule.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class TeacherScheduleWidget extends StatelessWidget {
  final String teacherName;

  const TeacherScheduleWidget({Key key, this.teacherName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentWeek = Provider.of<Notifier>(context).week ?? '1';
    List<String> listUkr = [
      'Понеділок',
      'Вівторок',
      'Середа',
      'Четвер',
      "П’ятниця",
      'Субота'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CurrentWeek(
              currentWeek: currentWeek,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                teacherName,
                maxLines: 2,
                style: TextStyle(fontSize: teacherName.length > 22 ? 15 : 18),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: Future.wait([
            fetchTeacherSchedule(teacherName),
            DBTeacherSchedule.db.select()
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<TeacherSchedules> data = snapshot.data[0];
            List<TeacherSchedules> dataBase = snapshot.data[1];
            if (snapshot.connectionState == ConnectionState.none) {
              return Text('Error');
            }
            if (snapshot.connectionState == ConnectionState.done &&
                dataBase.isEmpty) {
              for (var item in data) {
                DBTeacherSchedule.db.insert(item);
              }
              dataBase = data;
            }
            if (snapshot.connectionState == ConnectionState.done &&
                dataBase.isNotEmpty) {
              final l = listUkr.map(
                  (e) => dataBase.where((element) => element.dayName == e));
              return Consumer<Notifier>(
                builder: (context, value, child) {
                  final week = value.week ?? '1';
                  print(week);
                  return ListView(
                      children: l.map((e) {
                    final listOfLessonWeek = e
                        .where((element) => element.lessonWeek == week)
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
                  }).toList());
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class TeacherParticles extends StatelessWidget {
  final List<TeacherSchedules> data;
  final index;
  final lessonWeek;
  const TeacherParticles({Key key, this.data, this.index, this.lessonWeek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: data[index].lessonWeek == lessonWeek
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
