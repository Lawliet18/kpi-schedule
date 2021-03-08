import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/http_response/parse_lessons.dart';
import 'package:schedule_kpi/particles/current_week.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/particles/notes/adding_notes.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';
import 'package:schedule_kpi/save_data/db_notes.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class ScheduleBody extends StatefulWidget {
  const ScheduleBody({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TabController controller;

  @override
  _ScheduleBodyState createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Lessons>>>(
        future: Future.wait([DBLessons.db.select(), DBNotes.db.select()]),
        builder: (context, AsyncSnapshot snapshotFromDataBase) {
          if (snapshotFromDataBase.hasData) {
            final List<Lessons> dataFromDataBase =
                snapshotFromDataBase.data![0] as List<Lessons>;
            final List<Lessons> notes =
                snapshotFromDataBase.data![1] as List<Lessons>;

            if (dataFromDataBase.isEmpty) {
              return LoadFromInternet(controller: widget.controller);
            } else {
              return BuildLessons(
                controller: widget.controller,
                data: dataFromDataBase,
                notes: notes,
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class LoadFromInternet extends StatefulWidget {
  const LoadFromInternet({Key? key, required this.controller})
      : super(key: key);

  final TabController controller;

  @override
  _LoadFromInternetState createState() => _LoadFromInternetState();
}

class _LoadFromInternetState extends State<LoadFromInternet> {
  final SvgPicture imgOnErrorLoad =
      SvgPicture.asset('assets/img/sad_smile.svg');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchLessons(context.read<Notifier>().groupName),
      builder: (BuildContext context, AsyncSnapshot sp) {
        //if you dont have internet connection
        if (sp.connectionState == ConnectionState.none) {
          return buildOnWrongFuture(
              context, S.of(context).scheduleInternetError, imgOnErrorLoad,
              isInternetFailed: true);
        }
        if (sp.connectionState == ConnectionState.done) {
          final dataFromInternet = sp.data as List<Lessons>;
          // incorrect input
          if (dataFromInternet.isEmpty) {
            return buildOnWrongFuture(
                context, S.of(context).correctInputGroup, imgOnErrorLoad,
                isInternetFailed: false);
          }

          for (final item in dataFromInternet) {
            DBLessons.db.insert(item);
          }

          return BuildLessons(
              controller: widget.controller, data: dataFromInternet);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Center buildOnWrongFuture(
      BuildContext context, String description, SvgPicture imgOnErrorLoad,
      {required bool isInternetFailed}) {
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
          const SizedBox(height: 10),
          Center(
            child: Text(
              description,
              //textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
          if (isInternetFailed)
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text(
                S.of(context).refresh,
              ),
              //color: Theme.of(context).primaryColor,
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                S.of(context).changeGroup,
              ),
              //color: Theme.of(context).primaryColor,
            )
        ],
      ),
    );
  }
}

class BuildLessons extends StatelessWidget {
  const BuildLessons({
    Key? key,
    required this.controller,
    required this.data,
    this.notes = const [],
  }) : super(key: key);

  final TabController controller;
  final List<Lessons> data;
  final List<Lessons> notes;

  @override
  Widget build(BuildContext context) {
    Color? _color;
    final listUa = [
      'Понеділок',
      'Вівторок',
      'Середа',
      'Четвер',
      "П’ятниця",
      'Субота'
    ];
    return Consumer<Notifier>(
        builder: (context, value, child) => TabBarView(
            controller: controller,
            children: listUa.map((e) {
              final b = data.where((element) => element.dayName == e);
              if (b.isEmpty) {
                return Center(
                    child: Text(
                  S.of(context).free,
                  style: const TextStyle(
                    fontSize: 36,
                    letterSpacing: 1.3,
                  ),
                ));
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (data[index].dateNotes != null &&
                      notes.any((element) =>
                          element.lessonId == data[index].lessonId)) {
                    _color = Colors.primaries[
                            math.Random().nextInt(Colors.primaries.length)]
                        .withOpacity(0.3);
                  } else {
                    _color = Colors.transparent;
                  }
                  if (data[index].lessonType == 'конс') {
                    data[index].lessonType =
                        data[index].lessonType.replaceFirst(RegExp('к'), 'К');
                  }
                  if (e == data[index].dayName &&
                      data[index].lessonWeek == value.week.toStr()) {
                    return GestureDetector(
                        onDoubleTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddingNotes(
                                      data: data[index],
                                    ))),
                        child: LessonBlock(data: data[index], color: _color));
                  } else {
                    return Container();
                  }
                },
              );
            }).toList()));
  }
}
