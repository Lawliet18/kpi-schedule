import 'package:flutter/material.dart';
import 'package:schedule_kpi/settings.dart';

class NotesAppBar extends StatelessWidget {
  const NotesAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Notes'),
      leading: Icon(
        Icons.notes,
        color: Colors.white,
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
