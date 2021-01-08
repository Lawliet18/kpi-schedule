import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/schedule.dart';
import 'package:schedule_kpi/settings.dart';

import 'custom_floating_button.dart';
import 'detail_image.dart';
import 'image_picker.dart';

class AddingNotes extends StatefulWidget {
  const AddingNotes({Key? key, required this.data}) : super(key: key);

  final Lessons data;

  @override
  _AddingNotesState createState() => _AddingNotesState();
}

class _AddingNotesState extends State<AddingNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Notes'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              LessonBlock(
                data: widget.data,
              ),
              Expanded(child: BuildListOfData(data: widget.data))
            ],
          ),
        ),
        bottomNavigationBar: Consumer<Notifier>(
          builder: (context, value, child) => Container(
            margin: EdgeInsets.only(left: 50, right: 50, bottom: 10),
            child: FlatButton(
                minWidth: 100,
                color: Colors.redAccent,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black45,
                hoverColor: Colors.greenAccent,
                onPressed: value.list.isNotEmpty || value.textFieldValue
                    ? () => _saveNotes(widget.data, value.textData)
                    : null,
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ),
        ),
        floatingActionButton: CustomFloatingButton());
  }

  _saveNotes(Lessons data, String text) {
    final list = Provider.of<Notifier>(context, listen: false).list;
    final images = list.join(' ');
    final date = DateTime.now();
    String time = "${date.day} ${DateFormat().add_MMM().format(date)}";
    DBLessons.db.updateNotes(data, text, images, time);
    Provider.of<Notifier>(context, listen: false).addTextField();
    Provider.of<Notifier>(context, listen: false).clearimagePath();
    Provider.of<Notifier>(context, listen: false).changeEditingType();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Schedule(
              onSavedNotes: 2,
            )));
  }
}

class BuildListOfData extends StatefulWidget {
  final Lessons data;

  const BuildListOfData({Key? key, required this.data}) : super(key: key);
  @override
  _BuildListOfDataState createState() => _BuildListOfDataState();
}

class _BuildListOfDataState extends State<BuildListOfData> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data.description != null &&
        widget.data.description!.isNotEmpty) {
      Provider.of<Notifier>(context, listen: false).changeEditingType();
      _controller.text = widget.data.description!;
    }
    if (widget.data.imagePath != null && widget.data.imagePath!.isNotEmpty) {
      final list = widget.data.imagePath!.split(' ');
      for (var path in list) {
        Provider.of<Notifier>(context, listen: false).addImagePath(path);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Notifier>(builder: (context, value, child) {
      return ListView(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryName(name: "Text", icon: Icons.text_fields),
              !value.editingType
                  ? TextFormField(
                      minLines: 1,
                      maxLines: 6,
                      autofocus: false,
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        value.changeEditingType();
                        value.addTextData(_controller.text);
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 28.0),
                      child: SelectableText(
                        _controller.text,
                        onTap: () => value.changeEditingType(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
        AnimatedCrossFade(
          crossFadeState: value.list.isNotEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 500),
          firstChild: FutureBuilder(
              future: CustomImagePicker.imagePicker.retrieveLostData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.done:
                    return Column(
                      children: [
                        CategoryName(name: "Images", icon: Icons.image),
                        GridView.builder(
                            padding: EdgeInsets.all(5.0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: value.list.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 5,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      child: Hero(
                                          tag: value.list[index] +
                                              index.toString(),
                                          child: Image.file(
                                              File(value.list[index]))),
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => DetailImage(
                                                    path: value.list[index],
                                                    index: index,
                                                  ))),
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () =>
                                        value.deleteImagePath(index),
                                    child: Text("remove"),
                                  )
                                ],
                              );
                            }),
                      ],
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text(
                        'Pick image/video error: ${snapshot.error}}',
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Container();
                    }
                }
              }),
          secondChild: Container(),
        )
      ]);
    });
  }
}
