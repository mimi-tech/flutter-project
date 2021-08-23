
import 'package:flutter/material.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadingstate.dart';

class TestUpload extends StatefulWidget {
  @override
  _TestUploadState createState() => _TestUploadState();
}

class _TestUploadState extends State<TestUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Text('this is a new widget'),
            Container(child: UploadMultipleImageDemo(),),
          ],
        )
    );
  }
}
