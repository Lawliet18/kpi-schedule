import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:schedule_kpi/Models/teachers.dart';
import 'package:schedule_kpi/http_response/http_parse_teachers.dart';
import 'package:schedule_kpi/particles/teacher_schedule.dart';
import 'package:schedule_kpi/save_data/db_teachers.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String groupId = Provider.of<Notifier>(context).groupName;
    return Container(
      child: FutureBuilder(
        future: Future.wait([fetchTeachers(groupId), DBTeachers.db.select()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Teachers> data = snapshot.data[0];
          List<Teachers> dataBase = snapshot.data[1];
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              dataBase.isEmpty) {
            for (var item in data) {
              DBTeachers.db.insert(item);
            }
            dataBase = data;
          }
          if (snapshot.connectionState == ConnectionState.done &&
              dataBase.isNotEmpty) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TeacherScheduleWidget(
                            teacherName: dataBase[index].teacherName))),
                    child: ListTile(
                      title: Text(dataBase[index].teacherName),
                      leading: CircleAvatar(
                        child: Text(
                          dataBase[index].teacherName[0].toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        backgroundColor: RandomColor().randomColor(
                            colorBrightness: ColorBrightness.dark,
                            colorSaturation: ColorSaturation.mediumSaturation),
                      ),
                      subtitle: Text(dataBase[index].teacherRating + '/5'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
