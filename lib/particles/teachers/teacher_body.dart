import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:schedule_kpi/Models/teachers.dart';
import 'package:schedule_kpi/http_response/http_parse_teachers.dart';
import 'package:schedule_kpi/particles/teachers/teacher_schedule.dart';
import 'package:schedule_kpi/save_data/db_teachers.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String groupId = Provider.of<Notifier>(context).groupName;

    return FutureBuilder(
      future: DBTeachers.db.select(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return snapshot.connectionState == ConnectionState.done &&
                snapshot.data.isEmpty
            ? LoadingFromInternet(groupId: groupId)
            : BuildList(dataBase: snapshot.data);
      },
    );
  }
}

class LoadingFromInternet extends StatelessWidget {
  const LoadingFromInternet({
    Key key,
    @required this.groupId,
  }) : super(key: key);

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTeachers(groupId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text("Can't load"),
          );
        }
        List<Teachers> data = snapshot.data;
        for (var item in data) {
          DBTeachers.db.insert(item);
        }
        return BuildList(dataBase: data);
      },
    );
  }
}

class BuildList extends StatelessWidget {
  const BuildList({
    Key key,
    @required this.dataBase,
  }) : super(key: key);

  final List<Teachers> dataBase;

  @override
  Widget build(BuildContext context) {
    Color color;
    return ListView.separated(
      itemCount: dataBase.length,
      itemBuilder: (context, index) {
        color = RandomColor().randomColor(
            colorBrightness: ColorBrightness.dark,
            colorSaturation: ColorSaturation.mediumSaturation);
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
            subtitle: CustomLinearProgress(
                dataBase: dataBase, color: color, index: index),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
        endIndent: 10,
        indent: 10,
        height: 1,
      ),
    );
  }
}

class CustomLinearProgress extends StatelessWidget {
  const CustomLinearProgress(
      {Key key,
      @required this.dataBase,
      @required Color color,
      @required this.index})
      : _color = color,
        super(key: key);

  final List<Teachers> dataBase;
  final Color _color;
  final int index;

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animation: true,
      percent: (double.tryParse(dataBase[index].teacherRating) ?? 0) / 5,
      progressColor: _color,
      lineHeight: 10,
      linearStrokeCap: LinearStrokeCap.roundAll,
      animationDuration: 500,
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Text('Rating : '),
      ),
      alignment: MainAxisAlignment.start,
    );
  }
}
