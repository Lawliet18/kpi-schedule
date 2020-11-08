import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/http_response/parse_lessons.dart';
import 'package:schedule_kpi/particles/current_week.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/settings.dart';

import 'particles/lesson_block.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key, this.currentWeek}) : super(key: key);

  final String currentWeek;

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  SvgPicture imgOnErrorLoad;
  @override
  void initState() {
    imgOnErrorLoad = SvgPicture.asset('assets/img/sad_smile.svg');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = [
      'Понеділок',
      'Вівторок',
      'Середа',
      'Четвер',
      'П’ятниця',
      'Субота'
    ];
    String text = Provider.of<Notifier>(context).groupName;
    print(text);
    return text != null || text != ''
        ? DefaultTabController(
            length: list.length,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CurrentWeek(currentWeek: widget.currentWeek),
                    Spacer(),
                    Text('Розклад для ' + text.toUpperCase()),
                    Spacer()
                  ],
                ),
                //centerTitle: true,
                actions: [
                  IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Settings()))),
                ],
                bottom: PreferredSize(
                  child: Container(
                    height: 30,
                    child: TabBar(
                        physics: ClampingScrollPhysics(),
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey[100],
                        tabs: list
                            .map((e) => Tab(
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2),
                                  ),
                                ))
                            .toList()),
                  ),
                  preferredSize: Size.fromHeight(30),
                ),
              ),
              body: FutureBuilder(
                  future: fetchLessons(text),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Lessons> data = snapshot.data;
                    //if(snapshot.connectionState == ConnectionState.)
                    if (snapshot.connectionState == ConnectionState.none ||
                        snapshot.hasError) {
                      return buildOnWrongFuture(
                          context,
                          'Cannot load your schedule.\nPlease check your internet connection.',
                          true);
                    }
                    if (snapshot.connectionState == ConnectionState.done &&
                        data.isEmpty) {
                      return buildOnWrongFuture(
                          context, 'Input Your group correct', false);
                    }
                    return snapshot.connectionState == ConnectionState.done
                        ? Consumer<Notifier>(
                            builder: (context, value, child) => TabBarView(
                                    children: list.map((e) {
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (e == data[index].dayName &&
                                          data[index].lessonWeek ==
                                              value.week) {
                                        return LessonBlock(data: data[index]);
                                      } else {
                                        return Container();
                                      }
                                    },
                                  );
                                }).toList()))
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Center buildOnWrongFuture(
      BuildContext context, String description, bool isInternetFailed) {
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
