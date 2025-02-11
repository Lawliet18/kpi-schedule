import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../save_data/notifier.dart';

class CustomImagePicker {
  CustomImagePicker._();
  static final CustomImagePicker imagePicker = CustomImagePicker._();
  final ImagePicker _picker = ImagePicker();
  PickedFile? imageFile;

  Future<PickedFile?> retrieveLostData() async {
    final response = await _picker.getLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      imageFile = response.file;
    } else {}

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
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> onImageButtonPressed(BuildContext context) async {
    await _displayPickImageDialog(context);
  }

  Future<void> _displayPickImageDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).cameraParameters),
          content: Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  selectMethod(ImageSource.camera, context)
                      .then((value) => Navigator.pop(context));
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.camera,
                    size: 30,
                  ),
                  title: Text(
                    S.of(context).camera,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  selectMethod(ImageSource.gallery, context)
                      .then((value) => Navigator.pop(context));
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.image,
                    size: 30,
                  ),
                  title: Text(
                    S.of(context).gallery,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
