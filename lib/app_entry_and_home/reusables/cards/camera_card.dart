import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_streams.dart';
import 'package:sparks/app_entry_and_home/custom_post_bg_widgets/bgcolor.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/bookmark.dart';
import 'package:sparks/app_entry_and_home/models/camera_post_model.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/screens/comments.dart';
import 'package:sparks/app_entry_and_home/screens/view_profile.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/services/dynamic_link_service.dart';
import 'package:sparks/app_entry_and_home/services/storageService.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/popup_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CameraCard extends StatefulWidget {
  final CameraPostModel cameraPostModel;
  final String feedAge;

  CameraCard({
    required this.cameraPostModel,
    required this.feedAge,
  });

  @override
  _CameraCardState createState() => _CameraCardState();
}

class _CameraCardState extends State<CameraCard> {
  bool? likeDislike = false;
  bool? isBookmarked = false;
  String formatLikeCounter = "";
  String formatCommentCounter = "";
  Popup? _selectedMenu;

  //TODO: Change the colour of the like button base on user interaction
  addAndDeleteLikes(bool isUidAvailable, String? loggedInUid, String? authorsId,
      String? postId) async {
    bool? likeResult = await DatabaseService(loggedInUserID: loggedInUid)
        .addDeleteUid(authorsId, postId, isUidAvailable);
    setState(() {
      likeDislike = likeResult;
    });
  }

  //TODO: Check what the user's choice was and change the colour of the like button.
  likeButtonUserChoice() {
    CustomFunctions.isPostLiked(
            widget.cameraPostModel.aID,
            GlobalVariables.loggedInUserObject.id,
            widget.cameraPostModel.postId)
        .then((userChoice) {
      if (this.mounted) {
        if (userChoice == true) {
          setState(() {
            likeDislike = userChoice;
          });
        } else {
          setState(() {
            likeDislike = userChoice;
          });
        }
      }
    });

    return likeDislike;
  }

  //TODO: Share this post with other social media apps using the help of a dynamic link
  share(BuildContext context, String? postType, String? authorID,
      String? postID) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    switch (postType) {
      case "Text":
        String shareUrl =
            await DynamicLinkService.createDynamicLink(authorID, postID);
        Share.share(
          shareUrl,
          subject: "SHARE POST",
          sharePositionOrigin:
              renderBox!.localToGlobal(Offset.zero) & renderBox.size,
        );
        break;
      case "Camera":
        break;
      case "Video":
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: kTransparent,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height * 0.49,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //TODO: Display the info of the user who made the post.
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.018,
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ListTile(
                isThreeLine: true,
                leading: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: GestureDetector(
                    //View the profile of the user who made the post
                    onTap: () async {
                      //TODO: View user profile
                      DocumentSnapshot<Map<String, dynamic>> dst =
                          await CustomFunctions.viewingThisUserProfile(
                              widget.cameraPostModel.aID, "Personal");
                      SparksUser sUser = SparksUser.fromJson(dst.data()!);
                      GlobalVariables.viewingProfileInfo = sUser;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProfile(
                            profileId: widget.cameraPostModel.aID,
                            profileStatus: "",
                          ),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: CircleAvatar(
                        maxRadius: 30.0,
                        backgroundImage: (widget.cameraPostModel.auPimg != null
                            ? CachedNetworkImageProvider(
                                "${widget.cameraPostModel.auPimg}",
                              )
                            : AssetImage(
                                "images/app_entry_and_home/profile_image.png",
                              )) as ImageProvider<Object>?,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  "${widget.cameraPostModel.nm!["ln"]} ${widget.cameraPostModel.nm!["fn"]}",
                  style: Theme.of(context).textTheme.headline6!.apply(
                        color: kBlackcolor,
                        fontSizeFactor: 0.7,
                      ),
                  textAlign: TextAlign.left,
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: "${widget.cameraPostModel.auSpec}\n",
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontSize: kSize_13.sp,
                        fontWeight: FontWeight.w600,
                        color: kHintColor,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: "${widget.feedAge}",
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontSize: kSize_13.sp,
                            fontWeight: FontWeight.w900,
                            color: kHintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //TODO: Popup starts here
                trailing: PopupMenuButton(
                  onSelected: (dynamic selected) {
                    setState(() {
                      _selectedMenu = selected;
                    });

                    //Delete this post.
                    if (_selectedMenu == Popup.DELETE) {
                      //TODO: Show the post delete dialog
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("Deleting Post"),
                            content: Text(
                              "Deleting this post will also delete all the likes, comments, photos and videos associated with it.",
                              style:
                                  Theme.of(context).textTheme.headline6!.apply(
                                        fontSizeFactor: 0.7,
                                      ),
                            ),
                            actions: [
                              //Click on this button to delete a post
                              FlatButton(
                                onPressed: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  switch (widget.cameraPostModel.postT) {
                                    case "Camera":
                                      if (widget.cameraPostModel.mediaT ==
                                          "Images") {
                                        bool isDeleted = await DatabaseService(
                                                loggedInUserID: GlobalVariables
                                                    .loggedInUserObject.id)
                                            .deletingAnAuthorPost(
                                                widget.cameraPostModel.delID);

                                        if (isDeleted) {
                                          await StorageService(
                                                  userID: GlobalVariables
                                                      .loggedInUserObject.id)
                                              .deletingMediaFile(widget
                                                  .cameraPostModel.imgVid![0]);
                                        }
                                      } else {}
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Yes, Delete Post",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                          fontSizeFactor: 0.8,
                                          fontSizeDelta: 2,
                                        ),
                                  ),
                                ),
                              ),
                              //Click on this button to cancel post deletion
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Text(
                                    "No, Don't Delete",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .apply(
                                          fontSizeFactor: 0.8,
                                          fontSizeDelta: 2,
                                          color: kLight_orange,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        barrierDismissible: false,
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return <PopupMenuEntry>[
                      GlobalVariables.loggedInUserObject.id ==
                              widget.cameraPostModel.aID
                          ? PopupMenuItem(
                              value: Popup.DELETE,
                              child: Text(
                                "Delete Post",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(
                                      fontSizeFactor: 0.8,
                                      fontSizeDelta: 2,
                                      color: kHintColor,
                                    ),
                              ),
                            )
                          : Container() as PopupMenuEntry<dynamic>,
                    ];
                  },
                ),
              ),
            ),
            //TODO: Display the content of the post.
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.02,
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomFunctions.createSlider(
                        context, widget.cameraPostModel.imgVid!),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            //TODO: Display the post title
            widget.cameraPostModel.title == null
                ? Container(
                    width: 0.0,
                    height: 0.0,
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.cameraPostModel.title!.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6!.apply(
                              fontSizeFactor: 0.8,
                              fontSizeDelta: 2,
                              color: kHintColor,
                            ),
                      ),
                    ),
                  ),

            //TODO: Display post description if any.
            widget.cameraPostModel.desc == null
                ? Container(
                    width: 0.0,
                    height: 0.0,
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: ReadMoreText(
                        "${widget.cameraPostModel.desc}",
                        trimLines: 3,
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '...Show more',
                        trimExpandedText: ' show less',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontSize: kFontSizeAnonynousUser.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            //TODO: Display the reaction users made on the post.
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SparksReactions(
                          dim: 20.0,
                          aDim: 20.0,
                          reactionUrl:
                              "images/app_entry_and_home/new_images/sparks_like.svg",
                          btnReactionColor: likeButtonUserChoice() == true
                              ? kRed
                              : kMore_icon_Colour,
                          bgImageTap: () async {
                            bool postLikedAndUnlike =
                                await CustomFunctions.isPostLiked(
                                    widget.cameraPostModel.aID,
                                    GlobalVariables.loggedInUserObject.id,
                                    widget.cameraPostModel.postId);

                            //TODO: Add the logged in user id into the liked collection if absence/update or delete logged user id if present.
                            addAndDeleteLikes(
                                postLikedAndUnlike,
                                GlobalVariables.loggedInUserObject.id,
                                widget.cameraPostModel.aID,
                                widget.cameraPostModel.postId);

                            /*setState(() {
                              dim = 28.0;
                            });*/
                          },
                          endAnimationImg: () {
                            /*setState(() {
                              dim = 27.0;
                            });*/
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        //TODO: Displays the number of likes a post has.
                        StreamBuilder<DocumentSnapshot>(
                          stream:
                              CustomStreams.currentNumberOfLikesCommentsShare(
                                  GlobalVariables.loggedInUserObject.id,
                                  widget.cameraPostModel.aID,
                                  widget.cameraPostModel.postId),
                          builder: (context, snapshot) {
                            if ((snapshot.connectionState ==
                                    ConnectionState.waiting) &&
                                (!snapshot.hasData)) {
                              return Text("0");
                            }
                            if ((snapshot.connectionState ==
                                    ConnectionState.active) &&
                                (snapshot.hasData)) {
                              try {
                                DocumentSnapshot dsp = snapshot.data!;
                                Map<String, dynamic> uDoc =
                                    dsp.data() as Map<String, dynamic>;
                                widget.cameraPostModel.nOfLikes =
                                    uDoc["nOfLikes"];

                                formatLikeCounter =
                                    CustomFunctions.numberFormatter(
                                        widget.cameraPostModel.nOfLikes);
                              } catch (e) {
                                e.toString();
                              }
                            }
                            return Text(
                              formatLikeCounter == "0" ? "" : formatLikeCounter,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: kFont_size.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kMore_icon_Colour,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                        ),
                        SparksReactions(
                          dim: 20.0,
                          aDim: 20.0,
                          reactionUrl:
                              "images/app_entry_and_home/new_images/sparks_comments.svg",
                          bgImageTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SparksComments(
                                  postToComment: widget.cameraPostModel.postId,
                                  ownerOfThePost: widget.cameraPostModel.aID,
                                ),
                              ),
                            );
                            /*setState(() {
                              dim = 28.0;
                            });*/
                          },
                          endAnimationImg: () {
                            /* setState(() {
                              dim = 27.0;
                            });*/
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        //TODO: Displays the number of comments a post has.
                        StreamBuilder<DocumentSnapshot>(
                          stream:
                              CustomStreams.currentNumberOfLikesCommentsShare(
                                  GlobalVariables.loggedInUserObject.id,
                                  widget.cameraPostModel.aID,
                                  widget.cameraPostModel.postId),
                          builder: (context, snapshot) {
                            if ((snapshot.connectionState ==
                                    ConnectionState.waiting) &&
                                (!snapshot.hasData)) {
                              return Text("0");
                            }
                            if ((snapshot.connectionState ==
                                    ConnectionState.active) &&
                                (snapshot.hasData)) {
                              try {
                                DocumentSnapshot dsp1 = snapshot.data!;
                                Map<String, dynamic> uDoc1 =
                                    dsp1.data() as Map<String, dynamic>;
                                widget.cameraPostModel.nOfCmts =
                                    uDoc1["nOfCmts"];

                                formatCommentCounter =
                                    CustomFunctions.numberFormatter(
                                        widget.cameraPostModel.nOfCmts);
                              } catch (e) {
                                e.toString();
                              }
                            }
                            return Text(
                              formatCommentCounter == "0"
                                  ? ""
                                  : formatCommentCounter,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: kFont_size.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kMore_icon_Colour,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                        ),
                        //TODO: Share
                        SparksReactions(
                          aDim: 20.0,
                          dim: 20.0,
                          reactionUrl:
                              "images/app_entry_and_home/new_images/sparks_share.svg",
                          bgImageTap: () {
                            share(
                              context,
                              widget.cameraPostModel.postT,
                              widget.cameraPostModel.aID,
                              widget.cameraPostModel.postId,
                            );
                            /*setState(() {
                              dim = 28.0;
                            });*/
                          },
                          endAnimationImg: () {},
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          "",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: kFont_size.sp,
                              fontWeight: FontWeight.w600,
                              color: kMore_icon_Colour,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                      ],
                    ),
                  ),
                  //TODO: Bookmark starts here
                  Expanded(
                    flex: 1,
                    child: FutureBuilder<bool>(
                      future: CustomFunctions.isPostBookmarked(
                          widget.cameraPostModel.aID,
                          widget.cameraPostModel.postId),
                      builder: (context, snapshot) {
                        if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                            (snapshot.hasData)) {
                          isBookmarked = snapshot.data;
                        }
                        return IconButton(
                          onPressed: () {
                            isBookmarked!
                                ? isBookmarked = false
                                : isBookmarked = true;

                            if (isBookmarked!) {
                              //TODO; Add a bookmark
                              SparksBookmark addNewBookmark = SparksBookmark(
                                  auId: widget.cameraPostModel.aID,
                                  postId: widget.cameraPostModel.postId,
                                  bkOwn: GlobalVariables.loggedInUserObject.id,
                                  bkCrt: DateTime.now());
                              CustomFunctions.addBookmark(
                                  widget.cameraPostModel.aID,
                                  widget.cameraPostModel.postId,
                                  addNewBookmark);
                            } else {
                              //TODO: Delete a bookmark
                              CustomFunctions.deleteBookmark(
                                  widget.cameraPostModel.aID,
                                  widget.cameraPostModel.postId);
                            }
                          },
                          icon: Icon(Icons.bookmark),
                          iconSize: 25.0,
                          color:
                              isBookmarked! ? kLight_orange : kMore_icon_Colour,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            //TODO: Display location of the user who made the post.
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.01,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: k18,
                        color: kLight_orange,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                          "${widget.cameraPostModel.cln!["st"]}, ${widget.cameraPostModel.cln!["cty"]}",
                          style: Theme.of(context).textTheme.headline6!.apply(
                                fontSizeFactor: 0.65,
                                color: kHintColor,
                              )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
          ],
        ),
      ),
    );
  }
}
