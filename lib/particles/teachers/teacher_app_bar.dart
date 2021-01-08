import 'package:flutter/material.dart';
import 'package:schedule_kpi/settings.dart';

class TeacherAppBar extends StatelessWidget {
  const TeacherAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Teachers',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          letterSpacing: 1.2,
          wordSpacing: 1.2,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Settings(),
            ),
          ),
        )
      ],
    );
  }
}
