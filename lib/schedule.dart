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
  const Schedule({Key? key, this.onSavedNotes = 0}) : super(key: key);
  final int onSavedNotes;

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  late int _selectedValue;
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
  late String groupName;
  SvgPicture imgOnErrorLoad = SvgPicture.asset('assets/img/sad_smile.svg');
  late List<Widget> _widgetOptionBody;
  late List<Widget> _widgetOptionAppBar;
  late TabController _controller;
  int currentDay = DateTime.now().weekday;
  @override
  void initState() {
    _selectedValue = widget.onSavedNotes;

    currentDay = currentDay == 7 ? 1 : currentDay;
    _controller = TabController(
        length: list.length, vsync: this, initialIndex: currentDay - 1);
    groupName = Provider.of<Notifier>(context, listen: false).groupName;
    _widgetOptionBody = <Widget>[
      ScheduleBody(text: groupName, list: listRu, controller: _controller),
      TeacherBody(),
      NotesBody(),
    ];
    _widgetOptionAppBar = <Widget>[
      ScheduleAppBar(text: groupName, list: list, controller: _controller),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          child: _widgetOptionAppBar.elementAt(_selectedValue),
          preferredSize:
              _selectedValue == 0 ? Size.fromHeight(90) : Size.fromHeight(60),
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
      ),
    );
  }
}
