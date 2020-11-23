import 'package:flutter/material.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';

class NotesBody extends StatelessWidget {
  const NotesBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: DBLessons.db.select(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container();
        },
      ),
    );
  }
}
