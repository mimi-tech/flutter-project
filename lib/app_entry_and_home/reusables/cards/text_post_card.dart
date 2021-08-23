import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_streams.dart';
import 'package:sparks/app_entry_and_home/custom_post_bg_widgets/bgcolor.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/bookmark.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/reusables/home_appBar.dart';
import 'package:sparks/app_entry_and_home/screens/comments.dart';
import 'package:sparks/app_entry_and_home/screens/view_profile.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/services/dynamic_link_service.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/popup_enum.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class TextPostCard extends StatefulWidget {
  final String? authorId;
  final String? postId;
  final String? authorProfileImage;
  final String? firstname;
  final String? lastname;
  final String? authorMainSpeciality;
  final String howOldIstheFeed;
  final String? textBgImage;
  final String? mainText;
  final int? fontSize;
  final int? textColor;
  final String? postType;
  bool? likePost;
  int? likeCount;
  int? commentCount;
  int? shareCount;
  final String? fontFamily;
  final String? deletePostID;
  final Map<String, String?>? cLocation;

  TextPostCard({
    required this.authorId,
    required this.postId,
    required this.authorProfileImage,
    required this.firstname,
    required this.lastname,
    required this.authorMainSpeciality,
    required this.howOldIstheFeed,
    required this.textBgImage,
    required this.mainText,
    required this.fontSize,
    required this.textColor,
    required this.postType,
    required this.likePost,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.fontFamily,
    required this.deletePostID,
    required this.cLocation,
  });

  @override
  _TextPostCardState createState() => _TextPostCardState();
}

class _TextPostCardState extends State<TextPostCard> {
  double dim = 25.0;
  bool? likeDislike = false;
  bool isBookmarked = false;
  String formatLikeCounter = "";
  String formatCommentCounter = "";
  Popup? _selectedMenu;

  //TODO: Change the colour of the like button base on user interaction
  addAndDeleteLikes(bool isUidAvailable, String loggedInUid, String authorsId,
      String postId) async {
    bool? likeResult = await DatabaseService(loggedInUserID: loggedInUid)
        .addDeleteUid(authorsId, postId, isUidAvailable);
    setState(() {
      likeDislike = likeResult;
    });
  }

  //TODO: Check what the user's choice was and change the colour of the like button.
  likeButtonUserChoice() {
    CustomFunctions.isPostLiked(widget.authorId,
            GlobalVariables.loggedInUserObject.id, widget.postId)
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
  share(BuildContext context, String postType, String authorID,
      String postID) async {
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
    return Text('');
    /* Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: kTransparent,
        ),
        borderRadius: BorderRadius.circular(10.0),
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
                      DocumentSnapshot dst =
                        await CustomFunctions.viewingThisUserProfile(widget.authorId, "Personal");
                        SparksUser sUser = SparksUser.fromJson(dst.data());
                        GlobalVariables.viewingProfileInfo = sUser;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewProfile(
                              profileId: widget.authorId,
                              profileStatus: "",
                            ),
                          ),
                        );
                    },
                    child: ClipOval(
                      child: CircleAvatar(
                        maxRadius: 30.0,
                        backgroundImage: widget.authorProfileImage != null
                            ? CachedNetworkImageProvider(
                          "${widget.authorProfileImage}",
                        )
                            : AssetImage(
                          "images/app_entry_and_home/profile_image.png",
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  "${widget.lastname} ${widget.firstname}",
                  style: Theme.of(context).textTheme.headline6.apply(
                        color: kBlackcolor,
                        fontSizeFactor: 0.7,
                      ),
                  textAlign: TextAlign.left,
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: "${widget.authorMainSpeciality}\n",
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontSize: kSize_13.sp,
                        fontWeight: FontWeight.w600,
                        color: kHintColor,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: "${widget.howOldIstheFeed}",
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
                  onSelected: (selected) {
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
                              style: Theme.of(context).textTheme.headline6.apply(
                                fontSizeFactor: 0.7,
                              ),
                            ),
                            actions: [
                              //Click on this button to delete a post
                              FlatButton(
                                onPressed: () async {
                                  //Delete the post base on post type
                                  switch(widget.postType) {
                                    case "Text":
                                    await DatabaseService(loggedInUserID: GlobalVariables.loggedInUserObject.id)
                                                          .deletingAnAuthorPost(widget.deletePostID);
                                      break;
                                    case "Camera":
                                      break;
                                    case "Video":
                                      break;
                                  }
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Text(
                                    "Yes, Delete Post",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
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
                                        .headline6
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
                      GlobalVariables.loggedInUserObject.id == widget.authorId
                          ? PopupMenuItem(
                              value: Popup.DELETE,
                              child: Text(
                                "Delete Post",
                                style:
                                    Theme.of(context).textTheme.headline6.apply(
                                          fontSizeFactor: 0.8,
                                          fontSizeDelta: 2,
                                          color: kHintColor,
                                        ),
                              ),
                            )
                          : Container(),
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
                    minHeight: MediaQuery.of(context).size.height * 0.262,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      image: DecorationImage(
                        image: AssetImage(
                          "${widget.textBgImage}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Text(
                          "${widget.mainText}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              widget.fontSize,
                              allowFontScalingSelf: true,
                            ),
                            color: Color(widget.textColor),
                            fontFamily: widget.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
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
                                    widget.authorId,
                                    GlobalVariables.loggedInUserObject.id,
                                    widget.postId);

                            //TODO: Add the logged in user id into the liked collection if absence/update or delete logged user id if present.
                            addAndDeleteLikes(
                                postLikedAndUnlike,
                                GlobalVariables.loggedInUserObject.id,
                                widget.authorId,
                                widget.postId);

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
                                  widget.authorId,
                                  widget.postId),
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
                                DocumentSnapshot dsp = snapshot.data;
                                Map<String, dynamic> uDoc = dsp.data();
                                widget.likeCount = uDoc["nOfLikes"];

                                formatLikeCounter =
                                    CustomFunctions.numberFormatter(
                                        widget.likeCount);
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
                                  postToComment: widget.postId,
                                  ownerOfThePost: widget.authorId,
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
                                  widget.authorId,
                                  widget.postId),
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
                                DocumentSnapshot dsp1 = snapshot.data;
                                Map<String, dynamic> uDoc1 = dsp1.data();
                                widget.commentCount = uDoc1["nOfCmts"];

                                formatCommentCounter =
                                    CustomFunctions.numberFormatter(
                                        widget.commentCount);
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
                              widget.postType,
                              widget.authorId,
                              widget.postId,
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
                          widget.authorId, widget.postId),
                      builder: (context, snapshot) {
                        if ((snapshot.connectionState ==
                                ConnectionState.done) &&
                            (snapshot.hasData)) {
                          isBookmarked = snapshot.data;
                        }
                        return IconButton(
                          onPressed: () {
                            isBookmarked
                                ? isBookmarked = false
                                : isBookmarked = true;

                            if (isBookmarked) {
                              //TODO; Add a bookmark
                              SparksBookmark addNewBookmark = SparksBookmark(
                                  auId: widget.authorId,
                                  postId: widget.postId,
                                  bkOwn: GlobalVariables.loggedInUserObject.id,
                                  bkCrt: DateTime.now());
                              CustomFunctions.addBookmark(widget.authorId,
                                  widget.postId, addNewBookmark);
                            } else {
                              //TODO: Delete a bookmark
                              CustomFunctions.deleteBookmark(
                                  widget.authorId, widget.postId);
                            }
                          },
                          icon: Icon(Icons.bookmark),
                          iconSize: 25.0,
                          color:
                              isBookmarked ? kLight_orange : kMore_icon_Colour,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
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
                          "${widget.cLocation["st"]}, ${widget.cLocation["cty"]}",
                          style: Theme.of(context).textTheme.headline6.apply(
                                fontSizeFactor: 0.65,
                                color: kHintColor,
                              )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
          ],
        ),
      ),
    );*/
  }
}
