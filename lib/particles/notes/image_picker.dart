import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class CustomImagePicker {
  CustomImagePicker._();
  static final CustomImagePicker imagePicker = CustomImagePicker._();
  final ImagePicker _picker = ImagePicker();
  PickedFile? imageFile;
  String? _retrieveDataError;

  Future<PickedFile?> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      imageFile = response.file;
    } else {
      _retrieveDataError = response.exception.code;
      print(_retrieveDataError);
    }

    return imageFile;
  }

  Future selectMethod(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      imageFile = pickedFile;
      Provider.of<Notifier>(context, listen: false)
          .addImagePath(imageFile!.path);
    } catch (e) {
      print(e);
    }
  }

  onImageButtonPressed(BuildContext context) async {
    await _displayPickImageDialog(context);
  }

  _displayPickImageDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).cameraParameters),
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
                        Text(S.of(context).camera,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                    onTap: () {
                      selectMethod(ImageSource.camera, context)
                          .then((value) => Navigator.pop(context));
                    },
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
                        Text(S.of(context).gallery,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                    onTap: () {
                      selectMethod(ImageSource.gallery, context)
                          .then((value) => Navigator.pop(context));
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
