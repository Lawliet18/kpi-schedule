import 'package:flutter/material.dart';
import 'package:schedule_kpi/Models/lessons.dart';

class LessonBlock extends StatelessWidget {
  const LessonBlock({Key key, @required this.data, this.withNotes = false})
      : super(key: key);

  final Lessons data;
  final bool withNotes;

  @override
  Widget build(BuildContext context) {
    String dayName;
    Color _color = chooseColor(data);
    if (withNotes) {
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
        case 'П ятниця':
          dayName = 'Пт';
          break;
        case 'Субота':
          dayName = 'Сб';
          break;
      }
    }
    return Container(
      //height: MediaQuery.of(context).size.height * 0.15,
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.lessonNumber,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Column(
                  children: [
                    Text(
                      data.timeStart.substring(0, 5),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.timeEnd.substring(0, 5),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.005,
            color: _color,
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Teacher: " +
                              (data.teacherName.isEmpty
                                  ? "Don't know"
                                  : data.teacherName),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text("Type: " + data.lessonType.toString()),
                        data.lessonRoom != ''
                            ? Text("Room : " + data.lessonRoom)
                            : Container(),
                      ],
                    )
                  : Center(
                      child: Text(
                      data.lessonName,
                      style: TextStyle(fontSize: 30),
                    )),
            ),
          ),
          withNotes
              ? Container(
                  padding: const EdgeInsets.only(right: 5),
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                    child: Text(
                      dayName,
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
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
