import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_stack/image_stack.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MultiImageVideo extends StatefulWidget {
  @override
  _MultiImageVideoState createState() => _MultiImageVideoState();
}

class _MultiImageVideoState extends State<MultiImageVideo> {
  TextEditingController imageDescriptionController =
      TextEditingController(text: "");
  String? imageDesc;
  FocusNode? focusNode, fNode;

  String? _fileName;
  String? _path;
  Map<String, String>? _paths;
  List<String>? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickImageType = FileType.image;
  FileType _pickVideoType = FileType.video;
  TextEditingController _controller = new TextEditingController();

  //TODO: Generate video thumbnail from video file.
  Future<String?> getVideoThumbnail(String videoFile) async {
    String? vThumbnail = await VideoThumbnail.thumbnailFile(
      video: videoFile,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    return vThumbnail;
  }

  //TODO: A preview for multi image/video selected
  Widget multiMediaSelected(
      BuildContext context, List<Map<String, String>?> selectedMediaFiles) {
    Widget previewWidget;
    List<String> values = [];
    List<String> fileExtensions = [];

    for (Map<String, String>? myKey in selectedMediaFiles) {
      if (myKey == null) {
        Navigator.of(context).pop();
      } else {
        values.addAll(myKey.values.toList());
      }
    }

    for (String fileExt in values) {
      fileExtensions.add(fileExt.split(".").last);
    }

    if (values.length > 4) {
      previewWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.147,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage(
                        values[0],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.06,
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.amber,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (values.contains(
                              values[0],
                            )) {
                              selectedMediaFiles[0]!.removeWhere((key, value) =>
                                  key == values[0].split("/").last);
                              setState(() {
                                multiMediaSelected(context, selectedMediaFiles);
                                GlobalVariables.mediaFiles = selectedMediaFiles;
                              });
                            }
                          },
                          child: Text("x"),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.147,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage(
                        values[1],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.06,
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.amber,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (values.contains(
                              values[1],
                            )) {
                              selectedMediaFiles[1]!.removeWhere((key, value) =>
                                  key == values[1].split("/").last);
                              setState(() {
                                multiMediaSelected(context, selectedMediaFiles);
                                GlobalVariables.mediaFiles = selectedMediaFiles;
                              });
                            }
                          },
                          child: Text("x"),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.147,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage(
                        values[2],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.06,
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.amber,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (values.contains(
                              values[2],
                            )) {
                              selectedMediaFiles[2]!.removeWhere((key, value) =>
                                  key == values[2].split("/").last);
                              setState(() {
                                multiMediaSelected(context, selectedMediaFiles);
                                GlobalVariables.mediaFiles = selectedMediaFiles;
                              });
                            }
                          },
                          child: Text("x"),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.147,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage(
                        values[3],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.amber,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (values.contains(
                                  values[3],
                                )) {
                                  selectedMediaFiles[3]!.removeWhere(
                                      (key, value) =>
                                          key == values[3].split("/").last);
                                  setState(() {
                                    multiMediaSelected(
                                        context, selectedMediaFiles);
                                    GlobalVariables.mediaFiles =
                                        selectedMediaFiles;
                                  });
                                }
                              },
                              child: Text("x"),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            values.length > 4 ? "+${values.length - 4}" : "",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontSize: kSize_24.sp,
                                fontWeight: FontWeight.w600,
                                color: kWhiteColour,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else {
      switch (values.length) {
        case 1:
          //TODO: For a single file
          previewWidget = Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            decoration: BoxDecoration(
              color: Colors.purple,
              image: DecorationImage(
                image: AssetImage(
                  fileExtensions.contains("jpg") ||
                          fileExtensions.contains("png")
                      ? values[0]
                      : getVideoThumbnail(values[0]) as String,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.height * 0.03,
                color: Colors.amber,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (values.contains(
                        values[0],
                      )) {
                        selectedMediaFiles[0]!.removeWhere(
                            (key, value) => key == values[0].split("/").last);
                        setState(() {
                          multiMediaSelected(context, selectedMediaFiles);
                          GlobalVariables.mediaFiles = selectedMediaFiles;
                        });
                      }
                    },
                    child: Text("x"),
                  ),
                ),
              ),
            ),
          );
          break;
        case 2:
          //TODO: For two files
          previewWidget = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage(
                        values[0],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.06,
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.amber,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (values.contains(
                              values[0],
                            )) {
                              selectedMediaFiles[0]!.removeWhere((key, value) =>
                                  key == values[0].split("/").last);
                              setState(() {
                                multiMediaSelected(context, selectedMediaFiles);
                                GlobalVariables.mediaFiles = selectedMediaFiles;
                              });
                            }
                          },
                          child: Text("x"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage(
                        values[1],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.06,
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.amber,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (values.contains(
                              values[1],
                            )) {
                              selectedMediaFiles[0]!.removeWhere((key, value) =>
                                  key == values[1].split("/").last);
                              setState(() {
                                multiMediaSelected(context, selectedMediaFiles);
                                GlobalVariables.mediaFiles = selectedMediaFiles;
                              });
                            }
                          },
                          child: Text("x"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
          break;
        case 3:
          //TODO: For three files
          previewWidget = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    image: DecorationImage(
                      image: AssetImage(
                        values[0],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.06,
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.amber,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (values.contains(
                              values[0],
                            )) {
                              selectedMediaFiles[0]!.removeWhere((key, value) =>
                                  key == values[0].split("/").last);
                              setState(() {
                                multiMediaSelected(context, selectedMediaFiles);
                                GlobalVariables.mediaFiles = selectedMediaFiles;
                              });
                            }
                          },
                          child: Text("x"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.147,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        image: DecorationImage(
                          image: AssetImage(
                            values[1],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.amber,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (values.contains(
                                  values[1],
                                )) {
                                  selectedMediaFiles[1]!.removeWhere(
                                      (key, value) =>
                                          key == values[1].split("/").last);
                                  setState(() {
                                    multiMediaSelected(
                                        context, selectedMediaFiles);
                                    GlobalVariables.mediaFiles =
                                        selectedMediaFiles;
                                  });
                                }
                              },
                              child: Text("x"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.147,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        image: DecorationImage(
                          image: AssetImage(
                            values[2],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.amber,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (values.contains(
                                  values[2],
                                )) {
                                  selectedMediaFiles[2]!.removeWhere(
                                      (key, value) =>
                                          key == values[2].split("/").last);
                                  setState(() {
                                    multiMediaSelected(
                                        context, selectedMediaFiles);
                                    GlobalVariables.mediaFiles =
                                        selectedMediaFiles;
                                  });
                                }
                              },
                              child: Text("x"),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
          break;
        case 4:
          //TODO: For four files
          previewWidget = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.147,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        image: DecorationImage(
                          image: AssetImage(
                            values[0],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.amber,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (values.contains(
                                  values[0],
                                )) {
                                  selectedMediaFiles[0]!.removeWhere(
                                      (key, value) =>
                                          key == values[0].split("/").last);
                                  setState(() {
                                    multiMediaSelected(
                                        context, selectedMediaFiles);
                                    GlobalVariables.mediaFiles =
                                        selectedMediaFiles;
                                  });
                                }
                              },
                              child: Text("x"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.147,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        image: DecorationImage(
                          image: AssetImage(
                            values[1],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.amber,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (values.contains(
                                  values[1],
                                )) {
                                  selectedMediaFiles[1]!.removeWhere(
                                      (key, value) =>
                                          key == values[1].split("/").last);
                                  setState(() {
                                    multiMediaSelected(
                                        context, selectedMediaFiles);
                                    GlobalVariables.mediaFiles =
                                        selectedMediaFiles;
                                  });
                                }
                              },
                              child: Text("x"),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.147,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        image: DecorationImage(
                          image: AssetImage(
                            values[2],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.amber,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (values.contains(
                                  values[2],
                                )) {
                                  selectedMediaFiles[2]!.removeWhere(
                                      (key, value) =>
                                          key == values[2].split("/").last);
                                  setState(() {
                                    multiMediaSelected(
                                        context, selectedMediaFiles);
                                    GlobalVariables.mediaFiles =
                                        selectedMediaFiles;
                                  });
                                }
                              },
                              child: Text("x"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.147,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        image: DecorationImage(
                          image: AssetImage(
                            values[3],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              width: MediaQuery.of(context).size.width * 0.06,
                              height: MediaQuery.of(context).size.height * 0.03,
                              color: Colors.amber,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (values.contains(
                                      values[3],
                                    )) {
                                      selectedMediaFiles[3]!.removeWhere(
                                          (key, value) =>
                                              key == values[3].split("/").last);
                                      setState(() {
                                        multiMediaSelected(
                                            context, selectedMediaFiles);
                                        GlobalVariables.mediaFiles =
                                            selectedMediaFiles;
                                      });
                                    }
                                  },
                                  child: Text("x"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
          break;
        default:
          previewWidget = Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: kHintColor,
              ),
            ),
          );
      }
    }

    return previewWidget;
  }

  //TODO: Picking multiple images
  _openFileExplorerForImages() async {
    if (_pickImageType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        /// Ellis added this snippet
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: _pickImageType,
          allowedExtensions: _extension,
        );

        /// TODO: Ellis = Multi-file package has change. Refer to the documentation
        // _paths = await FilePicker.getMultiFilePath(
        //     type: _pickImageType, allowedExtensions: _extension);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path!.split('/').last
            : _paths != null
                ? _paths!.keys.toString()
                : "";
      });
    }

    setState(() {
      GlobalVariables.mediaFiles = [_paths];
    });
  }

  //TODO: Picking multiple videos
  _openFileExplorerForVideo() async {
    if (_pickVideoType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        /// TODO: Ellis = Multi-file package has change. Refer to the documentation
        // _paths = await FilePicker.getMultiFilePath(
        //     type: _pickVideoType, allowedExtensions: _extension);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path!.split('/').last
            : _paths != null
                ? _paths!.keys.toString()
                : "";
      });
    }

    setState(() {
      GlobalVariables.mediaFiles = [_paths];
    });
  }

  //TODO: Launch a bottomSheet for photo and video post creation
  _openShowBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return Container(
            color: Colors.transparent,
            margin: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      kChoose,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontSize: kSize_24.sp,
                          fontWeight: FontWeight.w700,
                          color: kBlackColour,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: IconButton(
                          onPressed: () {
                            _openFileExplorerForImages();
                            Navigator.of(context).pop();
                          },
                          iconSize: 50.0,
                          color: kProfile,
                          icon: Icon(
                            Icons.photo_album,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _openFileExplorerForVideo();
                          },
                          iconSize: 50.0,
                          color: kProfile,
                          icon: Icon(Icons.video_library),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Text(
                            kPhotoAlbum,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontSize: kSize_17.sp,
                                fontWeight: FontWeight.w600,
                                color: kBlackColour,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Text(
                            kVideoAlbum,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontSize: kSize_17.sp,
                                fontWeight: FontWeight.w600,
                                color: kBlackColour,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    imageDescriptionController.addListener(() {
      imageDesc = imageDescriptionController.text;
    });

    focusNode = FocusNode();
    fNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    imageDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(
//      context,
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height,
//      allowFontScaling: true,
//    );

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //TODO: Select who gets to see this post
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      maxRadius: 30.0,
                      backgroundColor: kLight_red,
                      child: ClipOval(
                        child: Icon(
                          Icons.person_add,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.56,
                  ),
                  //TODO: Display profile image of your friends whom you are sending this post to
                  Container(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: ImageStack(
                        imageList: [
                          GlobalVariables.loggedInUserObject.pimg!,
                          GlobalVariables.loggedInUserObject.pimg!,
                          GlobalVariables.loggedInUserObject.pimg!,
                          GlobalVariables.loggedInUserObject.pimg!,
                          GlobalVariables.loggedInUserObject.pimg!,
                          GlobalVariables.loggedInUserObject.pimg!,
                          GlobalVariables.loggedInUserObject.pimg!,
                        ],
                        imageRadius: 55,
                        imageCount: 7,
                        imageBorderWidth: 2,
                        totalCount: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          //TODO: Display the image/video from the album
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                  right: MediaQuery.of(context).size.width * 0.02,
                ),
                child: GlobalVariables.mediaFiles.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: kHintColor,
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            multiMediaSelected(
                                context, GlobalVariables.mediaFiles),
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.005,
              ),
              //TODO: Give the image a description
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                  right: MediaQuery.of(context).size.width * 0.02,
                ),
                child: TextFormField(
                  cursorColor: kHintColor,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      color: kBlackColour,
                      fontSize: kSize_16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  controller: imageDescriptionController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 100,
                  decoration: InputDecoration(
                    hintText: kCameraImgDesc,
                    hintStyle: TextStyle(
                      color: kHintColor,
                      fontSize: kSize_16.sp,
                      fontFamily: "Rajdhani",
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.8,
                        color: kHintColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.8,
                        color: kHintColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.8,
                        color: kHintColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  onChanged: (imageDesc) {
                    setState(() {
                      GlobalVariables.cameraImageDescription = imageDesc.trim();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              color: kTransparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          //TODO: Activate bottom sheet for photo and video post.
                          _openShowBottomSheet();
                        },
                        mini: false,
                        backgroundColor: kProfile,
                        child: Icon(
                          Icons.album,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
