import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

class CustomImagePicker {
  CustomImagePicker._();
  static final CustomImagePicker imagePicker = CustomImagePicker._();
  final ImagePicker _picker = ImagePicker();
  static PickedFile imageFile;
  String _retrieveDataError;

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      imageFile = response.file;
    } else {
      _retrieveDataError = response.exception.code;
      print(_retrieveDataError);
    }
    return imageFile;
  }

  selectMethod(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      imageFile = pickedFile;
      Provider.of<Notifier>(context, listen: false)
          .addImagePath(imageFile.path);
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
                    onTap: () => selectMethod(ImageSource.camera, context),
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
                    onTap: () => selectMethod(ImageSource.gallery, context),
                  )
                ],
              ),
            ),
          );
        });
  }
}
