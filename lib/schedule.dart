import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/particles/schedule_app_bar.dart';
import 'package:schedule_kpi/particles/schedule_body.dart';
import 'package:schedule_kpi/particles/teacher_app_bar.dart';
import 'package:schedule_kpi/particles/teacher_body.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key, this.currentWeek}) : super(key: key);

  final String currentWeek;

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
  String currentWeek;
  int currentDay = DateTime.now().weekday;
  @override
  void initState() {
    imgOnErrorLoad = SvgPicture.asset('assets/img/sad_smile.svg');
    _selectedValue = 0;
    currentWeek = widget.currentWeek;

    if (currentDay == 7) currentDay = 1;
    _controller = TabController(
        length: list.length, vsync: this, initialIndex: currentDay - 1);

    // _controller.addListener(() {
    //   setState(() {
    //     currentDay = _controller.index;
    //   });
    // });
    text = Provider.of<Notifier>(context, listen: false).groupName;
    _widgetOptionBody = <Widget>[
      ScheduleBody(text: text, list: listRu, controller: _controller),
      TeacherBody(),
      Text('body'),
    ];
    _widgetOptionAppBar = <Widget>[
      ScheduleAppBar(
          currentWeek: currentWeek,
          text: text,
          list: list,
          controller: _controller),
      TeacherAppBar(),
      AppBar(
        title: Text('data'),
      ),
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
