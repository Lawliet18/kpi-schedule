import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';
import 'package:schedule_kpi/particles/notes/notes_body.dart';
import 'package:schedule_kpi/save_data/db_lessons.dart';
import 'package:schedule_kpi/save_data/db_notes.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/schedule.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:schedule_kpi/settings.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).createNotes),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_rounded),
              onPressed: () {},
              tooltip: S.of(context).notesTooltip,
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              LessonBlock(
                data: widget.data,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: BuildListOfData(data: widget.data))
            ],
          ),
        ),
        bottomNavigationBar: Consumer<Notifier>(
          builder: (context, value, child) => Container(
            margin: const EdgeInsets.only(left: 50, right: 50, bottom: 10),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary),
                    elevation: MaterialStateProperty.all<double>(4),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    )),
                onPressed: value.list.isNotEmpty ||
                        (widget.data.description != null &&
                            widget.data.description!.isNotEmpty) ||
                        Provider.of<Notifier>(context, listen: false)
                            .textData
                            .isNotEmpty
                    ? () => _saveNotes(widget.data, value.textData)
                    : null,
                child: Text(
                  S.of(context).save,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 6,
          onPressed: () =>
              CustomImagePicker.imagePicker.onImageButtonPressed(context),
          tooltip: 'Image',
          child: const Icon(Icons.image),
        ),
      ),
    );
  }

  void _saveNotes(Lessons data, String text) {
    final list = Provider.of<Notifier>(context, listen: false).list;
    final images = list.join(' ');
    final date = DateTime.now();
    final time = "${date.day} ${date.month}";
    DBLessons.db.updateNotes(data, text, images, time);
    if (widget.data.dateNotes != null) {
      DBNotes.db.updateNotes(data, text, images, time);
    } else {
      DBNotes.db.insert(data, text, images, time);
    }

    Provider.of<Notifier>(context, listen: false).clearimagePath();
    Provider.of<Notifier>(context, listen: false).changeEditingType();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Schedule(
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
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data.description != null &&
        widget.data.description!.isNotEmpty) {
      _controller.text = widget.data.description!;
    }
    try {
      final provider = Provider.of<Notifier>(context, listen: false);
      if (widget.data.imagePath != null && widget.data.imagePath!.isNotEmpty) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          provider.addImagePath(widget.data.imagePath!);
        });
      }
    } catch (e) {
      rethrow;
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryName(name: S.of(context).text, icon: Icons.text_fields),
            if (value.editingType)
              TextFormField(
                style: const TextStyle(fontSize: 22),
                minLines: 1,
                maxLines: 10,
                autofocus: true,
                controller: _controller,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  value.changeEditingType();
                  value.addTextData(_controller.text);
                },
                decoration: const InputDecoration(
                    hintText: 'Print something',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
              )
            else
              Builder(builder: (context) {
                final List<String> list = _controller.text.split(' ');
                return GestureDetector(
                    onTap: () => value.changeEditingType(),
                    child: BuildDescription(list: list));
              }),
          ],
        ),
        AnimatedCrossFade(
          crossFadeState: value.list.isNotEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 500),
          firstChild: FutureBuilder(
              future: CustomImagePicker.imagePicker.retrieveLostData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.done:
                    return Column(
                      children: [
                        CategoryName(
                            name: S.of(context).images, icon: Icons.image),
                        GridView.builder(
                            padding: const EdgeInsets.all(5.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.list.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => DetailImage(
                                              path: value.list[index],
                                              index: index,
                                            ))),
                                child: Hero(
                                  tag: value.list[index] + index.toString(),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).size.width * 4.5,
                                    margin: const EdgeInsets.all(1.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        background: const BackgroundWidget(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          padding: 10,
                                        ),
                                        secondaryBackground:
                                            const BackgroundWidget(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          padding: 10,
                                        ),
                                        onDismissed: (direction) =>
                                            Provider.of<Notifier>(context)
                                                .deleteImagePath(index),
                                        child: Image.file(
                                          File(value.list[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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

class BuildDescription extends StatelessWidget {
  const BuildDescription({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: list[0] == '' && list.length == 1
          ? const Text(
              'Type on me to print something',
              style: TextStyle(fontSize: 24),
            )
          : Text.rich(
              TextSpan(
                  children: list.map((e) {
                return !e.startsWith('#')
                    ? TextSpan(
                        text: '$e ',
                        style: const TextStyle(
                            fontSize: 22,
                            //color: Colors.black,
                            fontFamily: 'DniproCity'),
                      )
                    : TextSpan(
                        text: '${e.substring(1)} ',
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).accentColor,
                            fontFamily: 'DniproCity'),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchURL(e.substring(1)));
              }).toList()),
            ),
    );
  }

  _launchURL(String value) async {
    if (await canLaunch(value)) {
      await launch(value);
    } else {
      throw 'Could not launch $value';
    }
  }
}
