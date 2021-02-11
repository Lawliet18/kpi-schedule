import 'package:flutter/material.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/settings.dart';

class NotesAppBar extends StatelessWidget {
  const NotesAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        S.of(context).notes,
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 1.2,
          wordSpacing: 1.2,
        ),
      ),
      leading: Icon(
        Icons.notes,
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
