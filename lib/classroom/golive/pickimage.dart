import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Picker extends StatefulWidget {
  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  Widget showImage() {
    return FutureBuilder<File>(
        future: imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.file(
              snapshot.data!,
              width: 300,
              height: 300,
            );
          } else if (snapshot.error != null) {
            return Text('Error picking image');
          } else {
            return Text('No Image selected');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        showImage(),
        Container(
          child: RaisedButton(
            onPressed: () {
              pickImageFromGallery(ImageSource.gallery);
            },
            child: Text('pick'),
          ),
        ),
      ],
    );
  }

  Future<File>? imageFile;
  pickImageFromGallery(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile image =
        await (_picker.pickImage(source: ImageSource.gallery) as Future<XFile>);
    // imageFile = ImagePicker.pickImage(source: source);

    /// Ellis to Miriam = I casted [imageFile] as Future<File>, but [imageFile]
    /// should not longer be a Future<File> but just File
    imageFile = File(image.path) as Future<File>;
    // imageFile = ImagePicker.pickImage(source: source);
  }
}
