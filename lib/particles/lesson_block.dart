import 'package:flutter/material.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/particles/your_notes.dart';

class LessonBlock extends StatelessWidget {
  const LessonBlock(
      {Key? key,
      required this.data,
      this.withNotes = false,
      this.color = Colors.transparent})
      : super(key: key);

  final Lessons data;
  final bool withNotes;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return withNotes
        ? GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => YourNotes(data: data))),
            child: BuildBlock(
              data: data,
              withNotes: withNotes,
              color: color,
            ),
          )
        : BuildBlock(
            data: data,
            withNotes: withNotes,
            color: color,
          );
  }
}

class BuildBlock extends StatelessWidget {
  const BuildBlock(
      {Key? key,
      required this.data,
      this.withNotes = false,
      this.color = Colors.transparent})
      : super(key: key);
  final Lessons data;
  final bool withNotes;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color _randomColor = chooseColor(data);
    return Material(
        type: MaterialType.card,
        elevation: 1,
        child: Container(
          color: color,
          margin: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.lessonNumber,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        Text(
                          data.timeStart.substring(0, 5),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data.timeEnd.substring(0, 5),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.005,
                color: _randomColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
                  child: data.lessonName != 'ВП'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.lessonName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${S.of(context).teacherBlock} ${data.teacherName.isEmpty ? S.of(context).dontKnow : data.teacherName}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text("${S.of(context).type} ${data.lessonType}"),
                            if (data.lessonRoom != '')
                              Text("${S.of(context).room} ${data.lessonRoom}")
                            else
                              Container(),
                          ],
                        )
                      : Center(
                          child: Text(
                          data.lessonName,
                          style: const TextStyle(fontSize: 30),
                        )),
                ),
              ),
              if (withNotes)
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                    child: Text(
                      shortDayName(data),
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                )
              else
                Container()
            ],
          ),
        ));
  }
}

Color chooseColor(Lessons data) {
  if (data.lessonType == 'Лек') {
    return Colors.red;
  } else if (data.lessonType == 'Лаб') {
    return Colors.green;
  } else if (data.lessonType == 'Прак') {
    return Colors.blue;
  } else {
    return Colors.black;
  }
}

String shortDayName(Lessons data) {
  String dayName = '';
  switch (data.dayName) {
    case 'Понеділок':
      dayName = 'Пн';
      break;
    case 'Вівторок':
      dayName = 'Вт';
      break;
    case 'Середа':
      dayName = 'Ср';
      break;
    case 'Четвер':
      dayName = 'Чт';
      break;
    case 'П’ятниця':
      dayName = 'Пт';
      break;
    case 'Субота':
      dayName = 'Сб';
      break;
    default:
      throw "Unreachable";
  }
  return dayName;
}
