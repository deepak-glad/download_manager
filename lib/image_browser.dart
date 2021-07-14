import 'dart:io';
import 'package:flutter/material.dart';

class ImageBrowser extends StatelessWidget {
  final File image;
  const ImageBrowser({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Image Browser'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Center(child: Image.file(image)),
    );
  }
}
