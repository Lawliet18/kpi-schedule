import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';

class NotesBody extends StatefulWidget {
  const NotesBody({Key key}) : super(key: key);

  @override
  _NotesBodyState createState() => _NotesBodyState();
}

class _NotesBodyState extends State<NotesBody> {
  final _animatedListKey = GlobalKey<AnimatedListState>();
  Lessons note;
  int _index;
  List<String> list = [];

  Tween<Offset> _offSetTween = Tween(begin: Offset(1, 0), end: Offset.zero);
//Add Alert dialog to dis
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: DBLessons.db.select(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Lessons> data = snapshot.data;
            var notesList =
                data.where((item) => item.dateNotes != null).toList();
            for (var item in notesList) {
              list.add(item.dateNotes);
            }
            var ls = list.toSet().toList();
            print(ls);
            return notesList.isNotEmpty
                ? ListView(
                    children: ls
                        .map((item) => Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 8.0, 3.0, 8.0),
                                  //height: MediaQuery.of(context).size.height * 0.05,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedList(
                                  shrinkWrap: true,
                                  key: _animatedListKey,
                                  initialItemCount: notesList.length,
                                  itemBuilder: (BuildContext context, int index,
                                      animation) {
                                    if (notesList[index].dateNotes == item) {
                                      return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                              position: _offSetTween
                                                  .animate(animation),
                                              child: Dismissible(
                                                key: ValueKey(
                                                    notesList[index].lessonId),
                                                onDismissed: (direction) {
                                                  DBLessons.db.updateNotes(
                                                      notesList[index],
                                                      null,
                                                      null,
                                                      null);
                                                  setState(() {
                                                    _index = index;
                                                    note = notesList[index];
                                                    notesList.removeAt(index);
                                                    _animatedListKey
                                                        .currentState
                                                        .removeItem(
                                                            index,
                                                            (_, __) =>
                                                                Container());
                                                  });

                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text('delete'),
                                                    action: SnackBarAction(
                                                      label: 'Undo',
                                                      textColor: Colors.red,
                                                      onPressed: () {
                                                        DBLessons.db.updateNotes(
                                                            note,
                                                            note.description,
                                                            note.imagePath,
                                                            note.dateNotes);
                                                        setState(() {
                                                          notesList.insert(
                                                              _index, note);
                                                        });
                                                        try {
                                                          _animatedListKey
                                                              .currentState
                                                              .insertItem(
                                                                  _index);
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      },
                                                    ),
                                                  ));
                                                },
                                                child: LessonBlock(
                                                  data: notesList[index],
                                                  withNotes: true,
                                                ),
                                                background: Container(
                                                  color: Colors.red,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                secondaryBackground: Container(
                                                  color: Colors.red,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerEnd,
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )));
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ))
                        .toList(),
                  )
                : Center(
                    child: Text(
                      'Double tap on a lesson\n to create a note',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
