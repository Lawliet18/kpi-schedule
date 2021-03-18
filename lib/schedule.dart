import 'package:flutter/material.dart';

import 'generated/l10n.dart';
import 'particles/notes/notes_appbar.dart';
import 'particles/notes/notes_body.dart';
import 'particles/schedule/schedule_app_bar.dart';
import 'particles/schedule/schedule_body.dart';
import 'particles/teachers/teacher_app_bar.dart';
import 'particles/teachers/teacher_body.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key, this.onSavedNotes = 0}) : super(key: key);
  final int onSavedNotes;

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  late int _selectedValue = widget.onSavedNotes;
  late List<Widget> _widgetOptionBody;
  late List<Widget> _widgetOptionAppBar;
  late TabController _controller;
  int currentDay = DateTime.now().weekday;
  @override
  void initState() {
    super.initState();
    currentDay = currentDay == 7 ? 1 : currentDay;
    _controller =
        TabController(length: 6, vsync: this, initialIndex: currentDay - 1);
    _widgetOptionBody = <Widget>[
      ScheduleBody(controller: _controller),
      const TeacherBody(),
      const NotesBody(),
    ];
    _widgetOptionAppBar = <Widget>[
      ScheduleAppBar(controller: _controller),
      const TeacherAppBar(),
      const NotesAppBar(),
    ];
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
        appBar: PreferredSize(
          preferredSize: _selectedValue == 0
              ? const Size.fromHeight(90)
              : const Size.fromHeight(60),
          child: _widgetOptionAppBar.elementAt(_selectedValue),
        ),
        body: _widgetOptionBody.elementAt(_selectedValue),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 12,
          onTap: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
          currentIndex: _selectedValue,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.book,
                size: 26,
              ),
              label: S.of(context).schedule,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.people,
                size: 26,
              ),
              label: S.of(context).teacher,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.notes,
                size: 26,
              ),
              label: S.of(context).notes,
            ),
          ],
        ),
      ),
    );
  }
}
