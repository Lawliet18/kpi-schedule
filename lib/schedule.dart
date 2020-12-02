import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/particles/schedule/schedule_app_bar.dart';
import 'package:schedule_kpi/particles/schedule/schedule_body.dart';
import 'package:schedule_kpi/particles/teachers/teacher_app_bar.dart';
import 'package:schedule_kpi/particles/teachers/teacher_body.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

import 'particles/notes/notes_appbar.dart';
import 'particles/notes/notes_body.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  int _selectedValue;
  List<String> list = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> listRu = [
    'Понеділок',
    'Вівторок',
    'Середа',
    'Четвер',
    "П’ятниця",
    'Субота'
  ];
  String text;
  SvgPicture imgOnErrorLoad;
  List<Widget> _widgetOptionBody;
  List<Widget> _widgetOptionAppBar;
  TabController _controller;
  int currentDay = DateTime.now().weekday;
  @override
  void initState() {
    imgOnErrorLoad = SvgPicture.asset('assets/img/sad_smile.svg');
    _selectedValue = 0;

    if (currentDay == 7) currentDay = 1;
    _controller = TabController(
        length: list.length, vsync: this, initialIndex: currentDay - 1);
    text = Provider.of<Notifier>(context, listen: false).groupName;
    _widgetOptionBody = <Widget>[
      ScheduleBody(text: text, list: listRu, controller: _controller),
      TeacherBody(),
      NotesBody(),
    ];
    _widgetOptionAppBar = <Widget>[
      ScheduleAppBar(text: text, list: list, controller: _controller),
      TeacherAppBar(),
      NotesAppBar(),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return text != null || text != ''
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: PreferredSize(
              child: _widgetOptionAppBar.elementAt(_selectedValue),
              preferredSize: _selectedValue == 0
                  ? Size.fromHeight(90)
                  : Size.fromHeight(60),
            ),
            body: _widgetOptionBody.elementAt(_selectedValue),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.grey,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
              currentIndex: _selectedValue,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.book,
                    ),
                    label: 'Schedule'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.people,
                    ),
                    label: 'Teacher'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.notes,
                    ),
                    label: 'Notes'),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
