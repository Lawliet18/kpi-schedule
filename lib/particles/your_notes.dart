import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/particles/notes/adding_notes.dart';
import 'package:schedule_kpi/particles/notes/detail_image.dart';
import 'package:schedule_kpi/settings.dart';

class YourNotes extends StatelessWidget {
  const YourNotes({Key? key, required this.data}) : super(key: key);
  final Lessons data;

  @override
  Widget build(BuildContext context) {
    List<String> list = [];
    if (data.imagePath != null && data.imagePath! != '') {
      list = data.imagePath!.split(' ');
    }
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).noteFor + ' ' + data.lessonName),
            centerTitle: true,
          ),
          body: Stack(children: [
            ListView(
              children: [
                list.isNotEmpty
                    ? Column(
                        children: [
                          CategoryName(icon: Icons.image, name: 'Your images'),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: list.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  File file;
                                  try {
                                    file = File(list[index]);

                                    return GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailImage(
                                                        path: list[index],
                                                        index: index))),
                                        child: Hero(
                                            tag: list[index] + index.toString(),
                                            child: Image.file(file)));
                                  } catch (e) {
                                    print(e);
                                    return Container();
                                  }
                                }),
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
                              name: S.of(context).yourDescription),
                          BuildDescription(list: data.description!.split(' '))
                        ],
                      )
                    : Container()
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  //width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          return Theme.of(context)
                              .colorScheme
                              .primary; // Use the component's default.
                        },
                      ),
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AddingNotes(data: data))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        S.of(context).changeNotes,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ])),
    );
  }
}
