import 'dart:io';

import 'package:flutter/material.dart';

import '../Models/lessons.dart';
import '../generated/l10n.dart';
import '../settings.dart';
import 'notes/adding_notes.dart';
import 'notes/detail_image.dart';

class YourNotes extends StatelessWidget {
  const YourNotes({Key? key, required this.data}) : super(key: key);
  final Lessons data;

  @override
  Widget build(BuildContext context) {
    var list = <String>[];
    if (data.imagePath != null && data.imagePath! != '') {
      list = data.imagePath!.split(' ');
    }
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('${S.of(context).noteFor} ${data.lessonName}'),
            centerTitle: true,
          ),
          body: Stack(children: [
            ListView(
              children: [
                if (list.isNotEmpty)
                  Column(
                    children: [
                      const CategoryName(
                          icon: Icons.image, name: 'Your images'),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            builder: (context) => DetailImage(
                                                path: list[index],
                                                index: index))),
                                    child: Hero(
                                        tag: list[index] + index.toString(),
                                        child: Image.file(file)));
                              } on Exception catch (_) {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  )
                else
                  Container(),
                if (data.description!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryName(
                          icon: Icons.text_fields,
                          name: S.of(context).yourDescription),
                      BuildDescription(list: data.description!.split(' '))
                    ],
                  )
                else
                  Container()
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          }
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
                        style: const TextStyle(fontSize: 20),
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
