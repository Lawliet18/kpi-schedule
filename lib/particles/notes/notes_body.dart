import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';

class NotesBody extends StatelessWidget {
  const NotesBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> list = [];
    return Container(
      child: FutureBuilder(
        future: DBLessons.db.select(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Lessons> data = snapshot.data;
          final notesList =
              data.where((item) => item.dateNotes != null).toList();
          for (var item in notesList) {
            list.add(item.dateNotes);
          }
          final ls = list.toSet().toList();
          print(ls);
          return ListView(
            children: ls
                .map((item) => Column(
                      children: [
                        Container(
                          child: Text(item),
                        ),
                        ...notesList
                            .map((note) => note.dateNotes == item
                                ? LessonBlock(
                                    data: note,
                                  )
                                : Container())
                            .toList()
                      ],
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
