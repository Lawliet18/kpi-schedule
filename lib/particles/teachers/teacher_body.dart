import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../Models/teacher_schedule_model.dart';
import '../../Models/teachers.dart';
import '../../generated/l10n.dart';
import '../../http_response/http_parse_teachers.dart';
import '../../http_response/parse_teacher_schedule.dart';
import '../../save_data/db_teacher_schedule.dart';
import '../../save_data/db_teachers.dart';
import '../../save_data/notifier.dart';
import 'teacher_schedule.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherMap = <String, List<TeacherSchedules>>{};
    return FutureBuilder<List<List>>(
      future:
          Future.wait([DBTeachers.db.select(), DBTeacherSchedule.db.select()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Text(S.of(context).cannotFindTeacher);
        }
        final teacherList = snapshot.data![0] as List<Teachers>;
        final teacherSchedule = snapshot.data![1] as List<TeacherSchedules>;
        if (snapshot.connectionState == ConnectionState.done &&
            (teacherList.isEmpty || teacherSchedule.isEmpty)) {
          return const LoadingFromInternet();
        }
        for (final element in teacherList) {
          teacherMap[element.teacherName] = teacherSchedule
              .where((el) => el.teacherId == element.teacherName)
              .toList();
        }
        return BuildSeparated(
          dataBase: teacherList,
          teacherSchedule: teacherMap,
        );
      },
    );
  }
}

class LoadingFromInternet extends StatelessWidget {
  const LoadingFromInternet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupId = Provider.of<Notifier>(context, listen: false).groupName;
    return FutureBuilder(
      future: fetchTeachers(groupId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final dataFromInternet = snapshot.data! as List<Teachers>;
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text(S.of(context).loadError),
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            dataFromInternet.isNotEmpty) {
          for (final item in dataFromInternet) {
            DBTeachers.db.insert(item);
          }
          return BuildList(
            dataBase: dataFromInternet,
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            dataFromInternet.isEmpty) {
          return Center(
            child: Text(
              S.of(context).correctInputGroup,
              style: const TextStyle(fontSize: 24),
            ),
          );
        }

        return BuildList(
          dataBase: dataFromInternet,
        );
      },
    );
  }
}

class BuildList extends StatefulWidget {
  const BuildList({
    Key? key,
    required this.dataBase,
  }) : super(key: key);

  final List<Teachers> dataBase;

  @override
  _BuildListState createState() => _BuildListState();
}

class _BuildListState extends State<BuildList> {
  List<String> names = [];
  @override
  void initState() {
    super.initState();
    for (final item in widget.dataBase) {
      names.add(item.teacherName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTeacherSchedule(names),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text(S.of(context).connectionProblem),
            );
          case ConnectionState.done:
            final data = snapshot.data as Map<String, List<TeacherSchedules>>;
            data.forEach((key, value) {
              for (final element in value) {
                element.teacherId = key;
                DBTeacherSchedule.db.insert(element);
              }
            });
            return BuildSeparated(
                dataBase: widget.dataBase, teacherSchedule: data);
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            throw 'teacherSchedule';
        }
      },
    );
  }
}

class BuildSeparated extends StatelessWidget {
  const BuildSeparated({
    Key? key,
    required this.dataBase,
    required this.teacherSchedule,
  }) : super(key: key);

  final List<Teachers> dataBase;
  final Map<String, List<TeacherSchedules>> teacherSchedule;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: dataBase.length,
      itemBuilder: (context, index) {
        final _color = Colors
            .primaries[Random().nextInt(Colors.primaries.length)]
            .withOpacity(0.7);
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TeacherScheduleWidget(
                    list: teacherSchedule[dataBase[index].teacherName]!,
                    teacherName: dataBase[index].teacherName,
                  ))),
          child: Material(
            elevation: 1,
            type: MaterialType.card,
            child: ListTile(
              title: Text(dataBase[index].teacherName),
              leading: AnimateColor(
                dataBase: dataBase,
                index: index,
                color: _color,
              ),
              subtitle: CustomLinearProgress(
                dataBase: dataBase,
                index: index,
                color: _color,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                //color: Colors.black,
                size: 20,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        endIndent: 10,
        indent: 10,
        height: 1,
      ),
    );
  }
}

class AnimateColor extends StatelessWidget {
  const AnimateColor(
      {Key? key,
      required this.dataBase,
      required this.index,
      required this.color})
      : super(key: key);

  final List<Teachers> dataBase;
  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Center(
        child: Text(
          dataBase[index].teacherName[0].toUpperCase(),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomLinearProgress extends StatelessWidget {
  const CustomLinearProgress({
    Key? key,
    required this.dataBase,
    required this.index,
    required this.color,
  }) : super(key: key);

  final List<Teachers> dataBase;
  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      percent: (double.tryParse(dataBase[index].teacherRating) ?? 0) / 5,
      progressColor: color,
      lineHeight: 10,
      linearStrokeCap: LinearStrokeCap.roundAll,
      animationDuration: 700,
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Text('${S.of(context).rating} '),
      ),
    );
  }
}
