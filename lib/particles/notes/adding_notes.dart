import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

import 'custom_floating_button.dart';
import 'detail_image.dart';
import 'image_picker.dart';

class AddingNotes extends StatefulWidget {
  const AddingNotes({Key key, this.data}) : super(key: key);

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
              Expanded(child: BuildListOfData())
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(left: 50, right: 50, bottom: 10),
          child: FlatButton(
              minWidth: 100,
              color: Colors.redAccent,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black45,
              hoverColor: Colors.greenAccent,
              onPressed: _saveNotes(),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
        ),
        floatingActionButton: CustomFloatingButton());
  }

  _saveNotes() {
    return null;
  }
}

class BuildListOfData extends StatelessWidget {
  const BuildListOfData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Notifier>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            ListView.builder(
              itemCount: value.textFieldCounter.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return value.textFieldCounter[index]
                    ? Row(
                        children: [
                          Expanded(child: TextField()),
                          IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () => value.deleteTextField(index))
                        ],
                      )
                    : Container();
              },
            ),
            SizedBox(height: 20),
            FutureBuilder(
                future: CustomImagePicker.imagePicker.retrieveLostData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.done:
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: value.list.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 5,
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return value.list.isNotEmpty
                                ? GestureDetector(
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
                                  )
                                : Container();
                          });
                      break;
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
                })
          ],
        ),
      );
    });
  }
}
