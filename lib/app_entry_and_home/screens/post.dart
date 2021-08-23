import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/custom_post_bg_widgets/bgcolor.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/models/spark_up.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/camera_post.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/custom_camera.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/multi_image_video.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/post_bg_enums.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/post_type_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/sending_post_request.dart';

class MakePost extends StatefulWidget {
  static String id = kMake_Post;

  final String pImageUrl;
  final String userFullName;

  MakePost({
    required this.pImageUrl,
    required this.userFullName,
  });

  @override
  _MakePostState createState() => _MakePostState();
}

class _MakePostState extends State<MakePost> {
/*  static FocusNode _postNode = FocusNode();
  final LayerLink _layerLink = LayerLink();*/
  List<Map<String, dynamic>>? mySparkUpList = [];
  List<Widget> groupWidget = [];

  SparkUp? sparkUpModel;
  Future<SparkUp>? mySparkUPGroup;

  String? _fileName;
  String? _path;
  Map<String, String>? _paths;
  List<String>? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickImageType = FileType.image;
  FileType _pickVideoType = FileType.video;
  String? getAbsoluteFilePathFromCamera;
  File? getMainFileFromCamera;

  //TODO: Set post type
  PostType typeofPost = PostType.TEXT_POST;

  double? animatedContainerDefaultWidth;
  bool? isCustomBgClicked;
  double dim = 25;
  double dim1 = 25;
  double dim2 = 25;
  double dim3 = 25;
  double dim4 = 25;
  double dim5 = 25;
  double dim6 = 25;
  PostCustomBg defaultPostBg = PostCustomBg.POSTBGIMAGE8;

  //TODO: Picking multiple images
  void openFileExplorerForImages() async {
    if (_pickImageType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
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

    //print("media file......................." + "$_paths");
    setState(() {
      GlobalVariables.mediaFiles = [_paths];
    });
  }

  //TODO: Picking multiple videos
  void openFileExplorerForVideo() async {
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

    //print("media file......................." + "$_paths");
    setState(() {
      GlobalVariables.mediaFiles = [_paths];
    });
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

  //TODO: Renders the post view based on the post button the user clicked
  Widget getPostView(PostType postType) {
    Widget postView;

    switch (postType) {
      case PostType.CAMERA_POST:
        postView = CameraPost(
          getFileAbsolutePath: getAbsoluteFilePathFromCamera,
          mainFile: getMainFileFromCamera,
        );
        break;
      case PostType.PHOTO_AND_VIDEO_POST:
        postView = MultiImageVideo();
        break;
      default:
        postView = Container();
    }

    return postView;
  }

  //TODO: Launch a bottomSheet for photo and video post creation
  openShowBottomSheet() {
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
                            openFileExplorerForImages();
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
                            openFileExplorerForVideo();
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

  //TODO: Get all the size of each group the user is subscribed to
  Future<SparkUp> _getAllGroupSizes() async {
    SparkUp sparkUp = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .getGroup();

    return sparkUp;
  }

  @override
  void initState() {
    animatedContainerDefaultWidth = 0.0;
    isCustomBgClicked = false;

    mySparkUPGroup = _getAllGroupSizes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountGateway = Provider.of<AccountGateWay>(context, listen: false);

    Widget? customPostScreen =
        CustomFunctions.getPostType(typeofPost, defaultPostBg);

    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kLight_orange,
            title: Text(
              kCreate_post,
              style: TextStyle(
                fontSize: kFont_size_22.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rajdhani',
              ),
            ),
            actions: <Widget>[
              CircleAvatar(
                backgroundColor: kWhiteColour,
                child: ClipOval(
                  child: widget.pImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: widget.pImageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                        )
                      : Image.asset(
                          "images/app_entry_and_home/profile_image.png"),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              //TODO: Create the post/submit post button.
              IconButton(
                onPressed: () async {
                  //TODO: Check the type of post the user is making
                  if (typeofPost == PostType.TEXT_POST) {
                    SendingPostRequest()
                        .sendTextPostRequest(context, defaultPostBg);
                  } else if (typeofPost == PostType.CAMERA_POST) {
                    SendingPostRequest().sendingCameraPostRequest(
                      context,
                      getMainFileFromCamera,
                      getAbsoluteFilePathFromCamera,
                    );
                  }
                },
                icon: Image.asset(
                  "images/app_entry_and_home/post_btn.png",
                ),
                padding: EdgeInsets.only(right: 15.0),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //TODO: Displaying a frame where post is being created
              Expanded(
                flex: 8,
                child: typeofPost == PostType.TEXT_POST
                    ? ListView(
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
                                              .whoSeePostWidget(
                                                  context, mySparkUPGroup),
                                        ),
                                      );

                                      print("$mySparkUpList + groups");

                                      if ((mySparkUpList!.isNotEmpty) ||
                                          (mySparkUpList != null)) {
                                        if ((groupWidget.isEmpty) ||
                                            (groupWidget == null)) {
                                          groupWidget =
                                              _groupToChip(mySparkUpList);
                                        } else {
                                          groupWidget.clear();
                                          groupWidget =
                                              _groupToChip(mySparkUpList);
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
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: groupWidget.isEmpty
                                        ? [
                                            Text(
                                              "Select who sees this post",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .apply(
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
                          customPostScreen!,
                        ],
                      )
                    : getPostView(typeofPost),
              ),
              //TODO: This section below holds the tools needed for creating a post.
              typeofPost == PostType.TEXT_POST
                  ? Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //TODO: Select the background for the post.
                          typeofPost == PostType.TEXT_POST
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height *
                                      0.027,
                                  margin: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: ListView(
                                          reverse: true,
                                          scrollDirection: Axis.horizontal,
                                          controller: AutoScrollController(),
                                          children: [
                                            BgImage(
                                              dim: dim3,
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/bg3.jpg",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE1;
                                                });
                                              },
                                              endAnimationImg: () {},
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            BgImage(
                                              dim: dim4,
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/bgr.jpg",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE2;
                                                });
                                              },
                                              endAnimationImg: () {},
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            BgImage(
                                              dim: dim5,
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/bgr2.jpg",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE3;
                                                });
                                              },
                                              endAnimationImg: () {},
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            BgImage(
                                              dim: dim6,
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/bgr1.png",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE4;
                                                });
                                              },
                                              endAnimationImg: () {},
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            BgImage(
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/orange_bg.png",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE5;
                                                });
                                              },
                                              dim: dim,
                                              endAnimationImg: () {},
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            BgImage(
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/dark_red_bg.png",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE6;
                                                });
                                              },
                                              dim: dim1,
                                              endAnimationImg: () {},
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            BgImage(
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/leaf_green_bg.png",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE7;
                                                });
                                              },
                                              dim: dim2,
                                              endAnimationImg: () {},
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025,
                                            ),
                                            BgImage(
                                              bgImageUrl:
                                                  "images/app_entry_and_home/post_bg/white_bg.png",
                                              bgImageTap: () {
                                                setState(() {
                                                  defaultPostBg =
                                                      PostCustomBg.POSTBGIMAGE8;
                                                });
                                              },
                                              dim: dim2,
                                              endAnimationImg: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "images/app_entry_and_home/bg_picker.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                          //TODO: Select a particular type of post to make.
                          typeofPost == PostType.TEXT_POST
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: kButton_disabled,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        iconSize: 30.0,
                                        color: kSvg_black,
                                        icon: Icon(
                                          Icons.camera_alt,
                                        ),
                                        onPressed: () async {
                                          //TODO: Activate the camera.
                                          Map<String, dynamic>? fileFromCamera =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomCamera()),
                                          );

                                          if (fileFromCamera == null) {
                                            Navigator.of(context).pop();
                                          } else {
                                            setState(() {
                                              getMainFileFromCamera =
                                                  fileFromCamera["MainFile"];
                                              getAbsoluteFilePathFromCamera =
                                                  fileFromCamera[
                                                      "AbsoluteFilePath"];

                                              typeofPost = PostType.CAMERA_POST;
                                            });
                                            print(fileFromCamera);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          "images/app_entry_and_home/photo_video.svg",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            typeofPost =
                                                PostType.PHOTO_AND_VIDEO_POST;
                                          });
                                          //TODO: Make a photo/video post.
                                          /*Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiPicker()),
                                              );*/
                                          openShowBottomSheet();
                                        },
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          "images/app_entry_and_home/go_live.svg",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          "images/app_entry_and_home/event.svg",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        color: kSvg_black,
                                        iconSize: 28.0,
                                        icon: Icon(
                                          Icons.location_on,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                        ],
                      ),
                    )
                  : Container(
                      width: 0.0,
                      height: 0.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
