import 'package:flutter/material.dart';
import 'package:schedule_kpi/particles/current_week.dart';

import '../../settings.dart';

class ScheduleAppBar extends StatelessWidget {
  const ScheduleAppBar({
    Key key,
    @required this.currentWeek,
    @required this.text,
    @required this.list,
    @required this.controller,
  }) : super(key: key);

  final String currentWeek;
  final String text;
  final List<String> list;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CurrentWeek(currentWeek: currentWeek),
          Spacer(),
          Text('Schedule for ' + text.toUpperCase()),
          Spacer()
        ],
      ),
      //centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Settings()))),
      ],
      bottom: PreferredSize(
        child: Container(
          height: 30,
          child: TabBar(
              controller: controller,
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
    );
  }
}
