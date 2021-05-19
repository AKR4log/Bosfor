import 'dart:io';

import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key key,
    @required this.imageFile,
    @required this.tag,
  }) : super(key: key);

  final Future<File> imageFile;
  final Object tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: FutureBuilder<File>(
          future: imageFile,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final file = snapshot.data;
            if (file == null) return Container();
            return Image.file(file);
          },
        ),
      ),
    );
  }
}
