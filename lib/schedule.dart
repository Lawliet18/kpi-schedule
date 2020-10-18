import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/http_response/parse_lessons.dart';
import 'package:schedule_kpi/particles/current_week.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/settings.dart';

import 'particles/lesson_block.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key key, this.currentWeek}) : super(key: key);

  final String currentWeek;

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
    String text = context.watch<Notifier>().groupName;
    return text != null || text != ''
        ? DefaultTabController(
            length: list.length,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                leading: CurrentWeek(currentWeek: currentWeek),
                title: Text('Розклад для ' + text.toUpperCase()),
                centerTitle: true,
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
              body: Consumer<Notifier>(
                builder: (context, value, child) => FutureBuilder(
                    future: fetchLessons(text),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Lessons> data = snapshot.data;
                      return snapshot.hasData
                          ? TabBarView(
                              children: list
                                  .map(
                                    (e) => ListView.builder(
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
                                    ),
                                  )
                                  .toList())
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    }),
              ),
            ))
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
