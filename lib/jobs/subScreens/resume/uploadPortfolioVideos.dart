import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class UploadPortfolioVideos extends StatefulWidget {
  @override
  _UploadPortfolioVideosState createState() => _UploadPortfolioVideosState();
}

class _UploadPortfolioVideosState extends State<UploadPortfolioVideos> {
  final TextEditingController categoryController = TextEditingController();
  String category = "Category";
  String _error = 'No Videos Added';
  List<Asset> images = [];
  bool showSpinner = false;
  bool isUploadComplete = false;

  String? _path;
  late Map<String, String> _paths;
  String? _extension;
  FileType _pickType = FileType.video;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<UploadTask> _tasks = <UploadTask>[];
  List<String> uploadedVideosUrl = [];

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        );
      }),
    );
  }

  void openFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        /// TODO: Ellis = Multi-file package has change. Refer to the documentation
        // _paths = await FilePicker.getMultiFilePath(
        //   type: FileType.video,
        // );
      } else {
        // _path = await FilePicker.getFilePath(
        //   type: FileType.video,
        // );

        FilePickerResult result = await (FilePicker.platform.pickFiles(
          type: FileType.video,
        ) as Future<FilePickerResult>);

        _path = result.files.single.path;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    setState(() {
      showSpinner = true;
    });
    if (_multiPick) {
      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
    } else {
      String fileName = _path!.split('/').last;
      String filePath = _path!;
      upload(fileName, filePath);
    }
  }

  upload(fileName, filePath) async {
    _extension = fileName.toString().split('.').last;
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    final UploadTask storageUploadTask = storageRef.putFile(
      File(filePath),
      SettableMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    final TaskSnapshot downloadUrl = (await storageUploadTask);

    final String url = (await downloadUrl.ref.getDownloadURL());

    uploadedVideosUrl.add(url);
  }

  saveVideos() {
    print('hellow');
    uploadToFirebase();
    print(uploadedVideosUrl);
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        "images/jobs/bag.svg",
                        height: ScreenUtil().setHeight(20.0),
                        width: ScreenUtil().setWidth(20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Add Video Category/Title',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: categoryController,
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                      if (category == '') {
                        setState(() {
                          category = "Category";
                        });
                      }
                    },
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kLight_orange, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Enter Videos Category/Title',
                    ),
                  ),
                )),
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        "images/jobs/bag.svg",
                        height: ScreenUtil().setHeight(20.0),
                        width: ScreenUtil().setWidth(20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Select Videos For $category',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(300.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        height: ScreenUtil().setHeight(300.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: images.isEmpty
                            ? Center(
                                child: RaisedButton(
                                    onPressed: () {},
                                    color: kLight_orange,
                                    child: Text(
                                      ' $_error',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )))
                            : buildGridView(),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        openFileExplorer();
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              height: ScreenUtil().setHeight(40.0),
                              width: ScreenUtil().setWidth(150.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 25.0,
                                      ),
                                      Text(
                                        'Add Videos',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          saveVideos();
                        },
                        color: kLight_orange,
                        child: Row(
                          children: [
                            showSpinner == false
                                ? Icon(
                                    Icons.cloud_upload,
                                    color: Colors.white,
                                    size: 25.0,
                                  )
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                            Text(
                              showSpinner == true ? 'UPLOADING' : 'UPLOAD',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
