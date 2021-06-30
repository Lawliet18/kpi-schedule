import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/teacher_schedule_model.dart';
import '../../generated/l10n.dart';
import '../../save_data/notifier.dart';
import '../current_week.dart';

class TeacherScheduleWidget extends StatefulWidget {
  final List<TeacherSchedules> list;
  final String teacherName;

  const TeacherScheduleWidget({
    Key? key,
    required this.teacherName,
    required this.list,
  }) : super(key: key);

  @override
  _TeacherScheduleWidgetState createState() => _TeacherScheduleWidgetState();
}

class _TeacherScheduleWidgetState extends State<TeacherScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    final listUA = <String>[
      'Понеділок',
      'Вівторок',
      'Середа',
      'Четвер',
      'П’ятниця',
      'Субота'
    ];
    final list = listUA
        .map((e) =>
            widget.list.where((element) => element.dayName == e).toList())
        .toList();
    return SafeArea(
      child: Scaffold(
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
                const SizedBox(width: 10),
                const CurrentWeek(),
              ],
            ),
            centerTitle: true,
          ),
          body: BuildList(
            list: list,
          )),
    );
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
        final l = [];
        for (final item in list) {
          l.addAll(item
              .where((element) => element.lessonWeek == week.toStr())
              .toList());
        }
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
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listOfLessonWeek.length,
                            itemBuilder: (context, index) {
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
                  S.of(context).teacherFree,
                  style: const TextStyle(fontSize: 36),
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
                  if (index == 0)
                    Text(
                      data[index].dayName,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    )
                  else
                    const Divider(
                      color: Colors.black,
                    ),
                  const SizedBox(height: 10),
                  Text(
                    data[index].lessonFullName,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          '${S.of(context).groups} ',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: Text(
                            data[index].groups,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
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
                          Text('${S.of(context).type} ',
                              style: const TextStyle(fontSize: 16)),
                          Text(
                            '${data[index].lessonType} ${data[index].lessonRoom}',
                            style: const TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            data[index].timeStart.substring(0, 5),
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            data[index].timeEnd.substring(0, 5),
                            style: const TextStyle(fontSize: 18),
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
