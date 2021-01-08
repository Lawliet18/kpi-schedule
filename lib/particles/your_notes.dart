import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/particles/notes/adding_notes.dart';
import 'package:schedule_kpi/particles/notes/detail_image.dart';
import 'package:schedule_kpi/settings.dart';

class YourNotes extends StatelessWidget {
  const YourNotes({Key? key, required this.data}) : super(key: key);
  final Lessons data;

  @override
  Widget build(BuildContext context) {
    List<String> list = data.imagePath!.split(' ');
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Note for ' + data.lessonName),
            centerTitle: true,
          ),
          body: Stack(children: [
            Column(
              children: [
                list.isNotEmpty
                    ? Column(
                        children: [
                          CategoryName(icon: Icons.image, name: 'Your images'),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) => GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => DetailImage(
                                              path: list[index],
                                              index: index))),
                                  child: Hero(
                                      tag: list[index] + index.toString(),
                                      child: Image.file(File(list[index])))),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                data.description!.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryName(
                              icon: Icons.text_fields,
                              name: "Your description"),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SelectableText(
                              data.description!,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
            Positioned(
              bottom: 0,
              child: RaisedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddingNotes(data: data))),
                child: Text("Change notes"),
              ),
            )
          ])),
    );
  }
}
