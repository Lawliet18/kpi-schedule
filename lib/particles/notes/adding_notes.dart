import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

import 'custom_floating_button.dart';
import 'image_picker.dart';

class AddingNotes extends StatefulWidget {
  const AddingNotes({Key key, this.data}) : super(key: key);

  final Lessons data;

  @override
  _AddingNotesState createState() => _AddingNotesState();
}

class _AddingNotesState extends State<AddingNotes> {
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  onImageButtonPressed({BuildContext context}) async {
    await _displayPickImageDialog(context);
  }

  selectMethod(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
      Provider.of<Notifier>(context, listen: false)
          .addImagePath(File(_imageFile.path));
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

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
              Expanded(
                child: Consumer<Notifier>(builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          itemCount: value.textFieldCounter.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            print(value.textFieldCounter[index]);
                            return value.textFieldCounter[index]
                                ? Row(
                                    children: [
                                      Expanded(child: TextField()),
                                      IconButton(
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          onPressed: () =>
                                              value.deleteTextField(index))
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: FutureBuilder(
                              future: retrieveLostData(),
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
                                          return GestureDetector(
                                            child: Hero(
                                                tag: _imageFile.path +
                                                    index.toString(),
                                                child: Image.file(
                                                    value.list[index])),
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailImage(
                                                          path: _imageFile.path,
                                                          index: index,
                                                        ))),
                                          );
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
                              }),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFloatingButton(
            function: () => onImageButtonPressed(context: context)));
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  _displayPickImageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Camera",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                    onTap: () => selectMethod(ImageSource.camera),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.image,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Gallery",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                    onTap: () => selectMethod(ImageSource.gallery),
                  )
                ],
              ),
            ),
          );
        });
  }
}
