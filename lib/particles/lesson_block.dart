import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:schedule_kpi/Models/lessons.dart';

class LessonBlock extends StatelessWidget {
  const LessonBlock({Key key, this.data}) : super(key: key);

  final Lessons data;

  @override
  Widget build(BuildContext context) {
    Color _color = RandomColor().randomColor();
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
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
                Column(
                  children: [
                    Text(
                      data.timeStart.substring(0, 5),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
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
          Container(
            width: MediaQuery.of(context).size.width * 0.795,
            //alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(12, 12, 16, 12),
            child: data.lessonName != 'ВП'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.lessonName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Teacher: " + data.teacherName,
                        //style: TextStyle(fontSize: 18),
                      ),
                      Text("Type: " + data.lessonType),
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
        ],
      ),
    );
  }
}
