import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Models/lessons.dart';
import '../../generated/l10n.dart';
import '../../save_data/db_lessons.dart';
import '../../save_data/db_notes.dart';
import '../../save_data/language_notifier.dart';
import '../../save_data/notifier.dart';
import '../lesson_block.dart';

class NotesBody extends StatefulWidget {
  const NotesBody({Key? key}) : super(key: key);

  @override
  _NotesBodyState createState() => _NotesBodyState();
}

class _NotesBodyState extends State<NotesBody> {
  List<String> list = [];

//Add Alert dialog to dis
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Notifier>(
        builder: (context, value, child) => FutureBuilder(
          future: DBNotes.db.select(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data as List<Lessons>;
            if (snapshot.connectionState == ConnectionState.done &&
                data.isNotEmpty) {
              final notesList =
                  data.where((element) => element.dateNotes != null).toList();
              for (final item in notesList) {
                list.add(item.dateNotes!);
              }
              final ls = list.toSet().toList();
              return ListView(
                children: ls
                    .map((dayName) => Column(
                          children: [
                            DayName(
                              item: dayName,
                            ),
                            MyAnimatedList(
                              animatedListKey: GlobalKey<AnimatedListState>(
                                  debugLabel: 'debug $dayName'),
                              notesList: notesList,
                              item: dayName,
                            )
                          ],
                        ))
                    .toList(),
              );
            }

            return Center(
              child: Text(
                S.of(context).notesMessage,
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}

class DayName extends StatelessWidget {
  const DayName({
    Key? key,
    required this.item,
  }) : super(key: key);
  final String item;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.fromLTRB(15.0, 8.0, 3.0, 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.date_range,
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              converToMonthName(context),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String converToMonthName(BuildContext context) {
    final list = item.split(' ');
    final month = DateTime(DateTime.now().year, int.tryParse(list[1])!);
    list[1] = DateFormat.MMMM(context.read<LanguageNotifier>().language)
        .format(month)
        .inCaps;
    return list.join(' ');
  }
}

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget(
      {Key? key, required this.alignment, this.padding = 20.0})
      : super(key: key);
  final AlignmentDirectional alignment;
  final double padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).buttonColor,
      padding: EdgeInsets.symmetric(horizontal: padding),
      alignment: alignment,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}

class MyAnimatedList extends StatefulWidget {
  const MyAnimatedList(
      {Key? key,
      required this.animatedListKey,
      required this.notesList,
      required this.item})
      : super(key: key);
  final GlobalKey<AnimatedListState> animatedListKey;
  final List<Lessons> notesList;
  final String item;
  @override
  _MyAnimatedListState createState() => _MyAnimatedListState();
}

class _MyAnimatedListState extends State<MyAnimatedList> {
  final _offSetTween = Tween(begin: const Offset(1, 0), end: Offset.zero);
  late int? _index;
  Lessons? note;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      key: widget.animatedListKey,
      initialItemCount: widget.notesList.length,
      itemBuilder: (context, index, animation) {
        if (widget.notesList[index].dateNotes == widget.item) {
          return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                  position: _offSetTween.animate(animation),
                  child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      showAlertDialog(context, index);
                    },
                    background: const BackgroundWidget(
                      alignment: AlignmentDirectional.centerStart,
                    ),
                    secondaryBackground: const BackgroundWidget(
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                    child: LessonBlock(
                      data: widget.notesList[index],
                      withNotes: true,
                    ),
                  )));
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> showAlertDialog(BuildContext context, int index) async {
    // set up the buttons
    final Widget cancelButton = TextButton(
      onPressed: () {
        try {
          widget.animatedListKey.currentState!.insertItem(_index!);
        } on Exception catch (_) {
          rethrow;
        }
        Navigator.pop(context);
      },
      child: Text(S.of(context).no),
    );
    final continueButton = TextButton(
      onPressed: () {
        DBNotes.db.deleteNote(widget.notesList[index]);
        DBLessons.db.updateNotes(widget.notesList[index], null, null, null);
        setState(() {
          widget.notesList.removeAt(index);
          widget.animatedListKey.currentState!
              .removeItem(index, (_, __) => Container());
        });
        Provider.of<Notifier>(context, listen: false).notifier();
        Navigator.pop(context);
      },
      child: Text(S.of(context).yes),
    );

    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(S.of(context).alertTitle),
      content: Text(S.of(context).alertBody),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
}
