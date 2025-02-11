import 'dart:io';

import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  const DetailImage({Key? key, required this.path, required this.index})
      : super(key: key);
  final String path;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: InteractiveViewer(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Hero(
                  tag: path + index.toString(), child: Image.file(File(path)))),
        ),
      ),
    );
  }
}
