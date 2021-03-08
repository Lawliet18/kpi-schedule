import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/particles/current_week.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

import '../../settings.dart';

class ScheduleAppBar extends StatelessWidget {
  const ScheduleAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final list = [
      S.of(context).monday,
      S.of(context).tuesday,
      S.of(context).wednesday,
      S.of(context).thurday,
      S.of(context).friday,
      S.of(context).saturday,
    ];
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CurrentWeek(),
          const Spacer(),
          Text(
              '${S.of(context).scheduleFor} ${context.read<Notifier>().groupName}'),
          const Spacer()
        ],
      ),
      //centerTitle: true,
      actions: [
        IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Settings()))),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: SizedBox(
          height: 30,
          child: TabBar(
              controller: controller,
              physics: const ClampingScrollPhysics(),
              isScrollable: true,
              unselectedLabelColor: Colors.grey[100],
              tabs: list
                  .map((e) => Tab(
                        child: Text(
                          e,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2),
                        ),
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
