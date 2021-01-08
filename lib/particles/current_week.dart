import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

enum Week { First, Second }

extension MyMethods on Week {
  Week invert() {
    switch (this) {
      case Week.First:
        return Week.Second;
      case Week.Second:
        return Week.First;
    }
  }

  String toStr() {
    switch (this) {
      case Week.First:
        return '1';
      case Week.Second:
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
    TextStyle style = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () {
        Provider.of<Notifier>(context, listen: false).changeWeek(current);
        setState(() {
          current = current.invert();
        });
      },
      child: Container(
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: 20,
              height: 25,
              decoration: BoxDecoration(
                color: current == Week.First ? Colors.grey : Colors.white,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Text(
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
                  color: current == Week.Second ? Colors.grey : Colors.white,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  '2',
                  style: style,
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }
}
