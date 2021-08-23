import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SeeImagePost extends StatefulWidget {
  SeeImagePost({required this.doc});
  final DocumentSnapshot doc;
  @override
  _SeeImagePostState createState() => _SeeImagePostState();
}

class _SeeImagePostState extends State<SeeImagePost> {
  int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading")!;

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  List<dynamic>? images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = widget.doc['pix'];

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      /* setState(() {
        progress = message[2];
      });*/
    });

    FlutterDownloader.registerCallback(downloadingCallback);
    getLocalPath();
  }

  late String _localPath;
  Future<String> _findLocalPath() async {
    return "";
  }

  getLocalPath() async {
    _localPath = (await _findLocalPath());

    print('Download Path: $_localPath');

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: kBlackcolor,
            body: Container(
              child: ListView.builder(
                  itemCount: images!.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: images![index],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  icon: (Icon(Icons.save_alt, color: kFbColor)),
                                  onPressed: () {
                                    _saveImage(index);
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }),
            )));
  }

  Future<void> _saveImage(int index) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      // final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url: images![index],
        savedDir: _localPath, //externalDir.path,
        fileName: DateTime.now().toString(),
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print("Permission denied");
    }
  }
}
