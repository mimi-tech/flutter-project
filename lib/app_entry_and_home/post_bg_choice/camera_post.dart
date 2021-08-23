import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_stack/image_stack.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/sending_post_request.dart';
import 'package:sparks/app_entry_and_home/models/spark_up.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/custom_camera.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/video_slider.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/who_see_post_card.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:video_player/video_player.dart';

class CameraPost extends StatefulWidget {
  final String? getFileAbsolutePath;
  final File? mainFile;

  CameraPost({
    this.getFileAbsolutePath,
    this.mainFile,
  });

  @override
  _CameraPostState createState() => _CameraPostState();
}

class _CameraPostState extends State<CameraPost> {
  List<Widget> groupWidget = [];

  TextEditingController cameraDescriptionController =
      TextEditingController(text: "");
  TextEditingController cameraTitleController = TextEditingController(text: "");

  FocusNode? focusNode, fNode;
  File? getMainFileFromCamera;
  String? getAbsoluteFilePathFromCamera;
  List<Map<String, dynamic>>? mySparkUpList = [];
  Future<SparkUp>? mySparkUPGroup;

  //Set the title of the camera post
  setTitle(String title) {
    setState(() {
      GlobalVariables.cameraPostTitle = title;
    });
  }

  //Set the camera post description
  setDescription(String description) {
    setState(() {
      GlobalVariables.cameraImageDescription = description;
    });
  }

  //TODO: Retrieve the the extension name of the file. Eg .jpg or .mp4
  bool _getExtensionName(String fileExtensionName) {
    return fileExtensionName.endsWith(".jpg");
  }

  //TODO: Get all the size of each group the user is subscribed to
  Future<SparkUp> _getAllGroupSizes() async {
    SparkUp sparkUp = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .getGroup();

    return sparkUp;
  }

  //TODO: Create a list of chip(s) based on the selected groups. Eg Friends groups
  List<Widget> _groupToChip(List<Map<String, dynamic>>? selectedGroups) {
    List<Widget> s_Chips = [];

    setState(() {
      for (Map<String, dynamic> chips in selectedGroups!) {
        s_Chips.add(
          Chip(
            backgroundColor: kP_Chip_Colour,
            label: Text(
              chips["GroupName"],
              style: Theme.of(context).textTheme.headline6!.apply(
                    fontSizeFactor: 0.6,
                    color: kWhiteColour,
                  ),
            ),
            deleteIconColor: kWhiteColour,
            onDeleted: () {
              setState(() {
                try {
                  selectedGroups.remove(chips);
                  groupWidget.clear(); // Clear the existing maps in the list

                  //Rebuild 'groupWidget' with the new maps
                  groupWidget = _groupToChip(selectedGroups);
                } catch (e) {
                  e.toString();
                }
              });
            },
          ),
        );
      }
    });

    return s_Chips;
  }

  @override
  void initState() {
    cameraDescriptionController.addListener(() {
      setDescription(cameraDescriptionController.text);
    });
    cameraTitleController.addListener(() {
      setTitle(cameraTitleController.text);
    });

    mySparkUPGroup = _getAllGroupSizes();

    focusNode = FocusNode();
    fNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    cameraDescriptionController.dispose();
    cameraTitleController.dispose();
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

    return ListView(
      controller: AutoScrollController(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        //TODO: Select group/groups this post is meant for
        Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01,
          ),
          //width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.08,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: AutoScrollController(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //TODO: Select who gets to see this post
                GestureDetector(
                  onTap: () async {
                    mySparkUpList = await showDialog(
                      context: this.context,
                      builder: (context) => WillPopScope(
                        onWillPop: () => Future.value(false),
                        child: SendingPostRequest()
                            .whoSeePostWidget(context, mySparkUPGroup),
                      ),
                    );

                    print("$mySparkUpList + groups");

                    if ((mySparkUpList!.isNotEmpty) ||
                        (mySparkUpList != null)) {
                      if ((groupWidget.isEmpty) || (groupWidget == null)) {
                        groupWidget = _groupToChip(mySparkUpList);
                      } else {
                        groupWidget.clear();
                        groupWidget = _groupToChip(mySparkUpList);
                      }
                    }
                  },
                  child: CircleAvatar(
                    maxRadius: 25.0,
                    backgroundColor: kLight_red,
                    child: ClipOval(
                      child: Icon(
                        Icons.person_add,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: groupWidget.isEmpty
                      ? [
                          Text(
                            "Select who sees this post",
                            style: Theme.of(context).textTheme.headline6!.apply(
                                  color: kHintColor,
                                  fontSizeFactor: 0.7,
                                ),
                          ),
                        ]
                      : groupWidget,
                ),
              ],
            ),
          ),
        ),
        //TODO: Display either the image or the video taken from the camera
        AspectRatio(
          aspectRatio:
              _getExtensionName(widget.getFileAbsolutePath!) ? 4 / 3 : 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              //Display either an image or a video file
              _getExtensionName(widget.getFileAbsolutePath!)
                  ? Image.asset(
                      widget.getFileAbsolutePath!,
                      fit: BoxFit.cover,
                    )
                  : VideoSlider(videoURL: widget.getFileAbsolutePath),

              //Display a camera icon that can call up the camera
              Container(
                width: 20.0,
                height: 20.0,
                margin: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      //TODO: Activate the camera.
                      Map<String, dynamic>? fileFromCamera =
                          await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomCamera()),
                      );

                      if (fileFromCamera == null) {
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          getMainFileFromCamera = fileFromCamera["MainFile"];
                          getAbsoluteFilePathFromCamera =
                              fileFromCamera["AbsoluteFilePath"];
                        });
                      }
                    },
                    child: Icon(
                      Icons.camera,
                      size: 40.0,
                      color: kWhitecolor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //Display a text field for post title
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 8.0,
          ),
          decoration: BoxDecoration(
            color: kGreyLightShade,
          ),
          child: TextFormField(
            controller: cameraTitleController,
            cursorColor: kHintColor,
            style: Theme.of(context).textTheme.headline6!.apply(
                  fontSizeFactor: 0.8,
                  fontSizeDelta: 2,
                  color: kHintColor,
                ),
            decoration: InputDecoration(
              hintText: kCreateCameraPostTitle,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.0,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ),

        //Display a post description text field
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 8.0,
          ),
          decoration: BoxDecoration(
            color: kGreyLightShade,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height * 0.25),
            child: TextFormField(
              controller: cameraDescriptionController,
              cursorColor: kHintColor,
              style: Theme.of(context).textTheme.headline6!.apply(
                    fontSizeFactor: 0.8,
                    fontSizeDelta: 2,
                    color: kHintColor,
                  ),
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: kCreateCameraPostDescription,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
