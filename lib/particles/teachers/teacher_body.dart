import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:random_color/random_color.dart';
import 'package:schedule_kpi/Models/teachers.dart';
import 'package:schedule_kpi/http_response/http_parse_teachers.dart';
import 'package:schedule_kpi/particles/teachers/teacher_schedule.dart';
import 'package:schedule_kpi/save_data/db_teachers.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TeacherBody extends StatelessWidget {
  const TeacherBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String groupId = Provider.of<Notifier>(context).groupName;

    return FutureBuilder(
      future: DBTeachers.db.select(),
      builder: (BuildContext context, AsyncSnapshot<List<Teachers>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return LoadingFromInternet(groupId: groupId, data: snapshot.data!);
      },
    );
  }
}

class LoadingFromInternet extends StatelessWidget {
  const LoadingFromInternet({
    Key? key,
    required this.groupId,
    required this.data,
  }) : super(key: key);

  final String groupId;
  final List<Teachers> data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTeachers(groupId),
      initialData: data,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Teachers> dataFromInternet = snapshot.data;
        if (!snapshot.hasData && data.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData && data.isNotEmpty) {
          return BuildList(
            dataBase: data,
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            data.isEmpty &&
            dataFromInternet.isNotEmpty) {
          for (var item in dataFromInternet) {
            DBTeachers.db.insert(item);
          }
          return BuildList(
            dataBase: dataFromInternet,
          );
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text("Can't load"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            !listEquals(data, dataFromInternet) &&
            dataFromInternet.isNotEmpty) {
          for (var item in dataFromInternet) {
            DBTeachers.db.update(item);
          }
          return BuildList(
            dataBase: dataFromInternet,
          );
        }
        return BuildList(
          dataBase: data,
        );
      },
    );
  }
}

class BuildList extends StatelessWidget {
  const BuildList({
    Key? key,
    required this.dataBase,
  }) : super(key: key);

  final List<Teachers> dataBase;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: dataBase.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TeacherScheduleWidget(
                  teacherName: dataBase[index].teacherName))),
          child: ListTile(
            title: Text(dataBase[index].teacherName),
            leading: AnimateColor(
              dataBase: dataBase,
              index: index,
            ),
            subtitle: CustomLinearProgress(dataBase: dataBase, index: index),
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

class AnimateColor extends StatefulWidget {
  const AnimateColor({
    Key? key,
    required this.dataBase,
    required this.index,
  }) : super(key: key);

  final List<Teachers> dataBase;
  final int index;

  @override
  _AnimateColorState createState() => _AnimateColorState();
}

class _AnimateColorState extends State<AnimateColor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  final Rainbow _rb = Rainbow(spectrum: const [
    Colors.deepPurple,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.purple,
    Colors.deepPurpleAccent,
    Colors.deepPurple,
  ], rangeStart: 0.0, rangeEnd: 300.0);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    animation = Tween<double>(begin: 0.0, end: 300.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            _rb[animation.value],
            _rb[(50.0 + animation.value) % _rb.rangeEnd]
          ])),
      child: Center(
        child: Text(
          widget.dataBase[widget.index].teacherName[0].toUpperCase(),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomLinearProgress extends StatefulWidget {
  const CustomLinearProgress(
      {Key? key, required this.dataBase, required this.index})
      : super(key: key);

  final List<Teachers> dataBase;
  final int index;

  @override
  _CustomLinearProgressState createState() => _CustomLinearProgressState();
}

class _CustomLinearProgressState extends State<CustomLinearProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  final Rainbow _rb = Rainbow(spectrum: const [
    Colors.deepPurple,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.purple,
    Colors.deepPurpleAccent,
    Colors.deepPurple,
  ], rangeStart: 0.0, rangeEnd: 300.0);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    animation = Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animation: true,
      percent:
          (double.tryParse(widget.dataBase[widget.index].teacherRating) ?? 0) /
              5,
      linearGradient: LinearGradient(colors: [
        _rb[animation.value],
        _rb[(50.0 + animation.value) % _rb.rangeEnd]
      ]),
      lineHeight: 10,
      linearStrokeCap: LinearStrokeCap.roundAll,
      animationDuration: 700,
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Text('Rating : '),
      ),
      alignment: MainAxisAlignment.start,
    );
  }
}
