import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

enum Week { first, second }

extension MyMethods on Week {
  Week invert() {
    switch (this) {
      case Week.first:
        return Week.second;
      case Week.second:
        return Week.first;
    }
  }

  String toStr() {
    switch (this) {
      case Week.first:
        return '1';
      case Week.second:
        return '2';
    }
  }
}

class CurrentWeek extends StatefulWidget {
  const CurrentWeek({Key? key}) : super(key: key);

  @override
  _CurrentWeekState createState() => _CurrentWeekState();
}

class _CurrentWeekState extends State<CurrentWeek> {
  late Week current;
  @override
  void initState() {
    current = Provider.of<Notifier>(context, listen: false).week;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () {
        Provider.of<Notifier>(context, listen: false).changeWeek(current);
        setState(() {
          current = current.invert();
        });
      },
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 20,
            height: 25,
            decoration: BoxDecoration(
              color: current == Week.first ? Colors.grey : Colors.white,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: const Text(
              '1',
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              width: 20,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: current == Week.second ? Colors.grey : Colors.white,
                border: Border.all(color: Colors.transparent),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: const Text(
                '2',
                style: style,
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}
