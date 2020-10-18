import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class CurrentWeek extends StatefulWidget {
  const CurrentWeek({Key key, this.currentWeek}) : super(key: key);
  final currentWeek;

  @override
  _CurrentWeekState createState() => _CurrentWeekState();
}

class _CurrentWeekState extends State<CurrentWeek> {
  String current;
  @override
  void initState() {
    super.initState();
    current = widget.currentWeek;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () {
        Provider.of<Notifier>(context, listen: false).changeWeek(current);
        setState(() {
          if (current == '1') {
            current = '2';
          } else {
            current = '1';
          }
        });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 15, 10, 15),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: current == '1' ? Colors.grey : Colors.white,
              child: Text(
                '1',
                style: style,
              ),
            ),
            Container(
                color: current == '2' ? Colors.grey : Colors.white,
                child: Text('2', style: style))
          ],
        ),
      ),
    );
  }
}
