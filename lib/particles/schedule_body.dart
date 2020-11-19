import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/http_response/parse_lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class ScheduleBody extends StatefulWidget {
  const ScheduleBody({
    Key key,
    @required this.text,
    @required this.list,
    @required this.controller,
  }) : super(key: key);

  final String text;
  final List<String> list;
  final TabController controller;

  @override
  _ScheduleBodyState createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> {
  SvgPicture imgOnErrorLoad;

  @override
  void initState() {
    imgOnErrorLoad = SvgPicture.asset('assets/img/sad_smile.svg');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadMethod(widget.text),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Lessons> data = snapshot.data[0];
          List<Lessons> dataBase = snapshot.data[1];
          if (data == null || dataBase == null) {
            return buildOnWrongFuture(
                context,
                'Cannot load your schedule.\nPlease check your internet connection.',
                true,
                imgOnErrorLoad);
          }
          if (snapshot.connectionState == ConnectionState.done &&
              dataBase.isEmpty) {
            print('set');
            for (var item in data) {
              DBLessons.db.insert(item);
            }
            dataBase = data;
          }
          if (snapshot.connectionState == ConnectionState.done &&
              dataBase.isEmpty) {
            return buildOnWrongFuture(
                context, 'Input Your group correct', false, imgOnErrorLoad);
          }
          return snapshot.connectionState == ConnectionState.done &&
                  dataBase.isNotEmpty
              ? Consumer<Notifier>(
                  builder: (context, value, child) => TabBarView(
                      controller: widget.controller,
                      children: widget.list.map((e) {
                        return ListView.builder(
                          itemCount: dataBase.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (e == dataBase[index].dayName &&
                                dataBase[index].lessonWeek == value.week) {
                              return LessonBlock(data: dataBase[index]);
                            } else {
                              return Container();
                            }
                          },
                        );
                      }).toList()))
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Center buildOnWrongFuture(BuildContext context, String description,
      bool isInternetFailed, SvgPicture imgOnErrorLoad) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(0.0),
            child: imgOnErrorLoad,
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          isInternetFailed
              ? FlatButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text(
                    'Refresh',
                    style:
                        TextStyle(color: Theme.of(context).textSelectionColor),
                  ),
                  color: Theme.of(context).primaryColor,
                )
              : FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Change group',
                    style:
                        TextStyle(color: Theme.of(context).textSelectionColor),
                  ),
                  color: Theme.of(context).primaryColor,
                )
        ],
      ),
    );
  }
}

loadMethod(String text) {
  return Future.wait([fetchLessons(text), DBLessons.db.select()]);
}
