import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_streams.dart';
import 'package:sparks/app_entry_and_home/custom_post_bg_widgets/bgcolor.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/models/comment_reply.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/reply_card.dart';
import 'package:sparks/app_entry_and_home/screens/view_profile.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CommentCard extends StatefulWidget {
  final String? authorId;
  final String? commentId;
  final Map<String, String?>? authorFullname;
  final String? authorPimg;
  final String? authorSpec;
  String? comment;
  int? numOfLikes;
  int? numOfReplies;
  final String? howOldIsTheComment;
  final String? postId; //Source of the comment

  CommentCard({
    required this.authorId,
    required this.commentId,
    required this.authorFullname,
    required this.authorPimg,
    required this.authorSpec,
    this.comment,
    this.numOfLikes,
    this.numOfReplies,
    this.howOldIsTheComment,
    this.postId,
  });

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  TextEditingController replyTextFormController = TextEditingController();
  bool showReplyTextField = false;
  late Widget replyWidget;
  bool? likeDislike = false;
  String formatLikeCounter = "";
  String formatReplyCounter = "";

  //TODO: Change the colour of the like button base on user interaction
  addAndDeleteCommentLikes(bool isUidAvailable, String? loggedInUid,
      String? authorsId, String? postId, String? commentId) async {
    bool? likeResult = await DatabaseService(loggedInUserID: loggedInUid)
        .addDeleteUidComment(authorsId, postId, isUidAvailable, commentId);
    setState(() {
      likeDislike = likeResult;
    });
  }

  //TODO: Check what the user's choice was and change the colour of the like button.
  likeButtonUserChoice() {
    CustomFunctions.isCommentLiked(
            widget.authorId,
            GlobalVariables.loggedInUserObject.id,
            widget.postId,
            widget.commentId)
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

  //TODO: Get the common id associated with a post, comment and replies.
  Future<String?> _getCommonID(String? commentId, String? postId) async {
    return await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .postCommentCommonID(commentId, postId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AccountGateWay>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(
        left: commentCardMargin,
        right: commentCardMargin,
        top: commentCardMarginTop,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //TODO: Displays the info of the person who made the post.
          ListTile(
            contentPadding: EdgeInsets.all(
              0.0,
            ),
            leading: GestureDetector(
              onTap: () async {
                //TODO: View user profile
                DocumentSnapshot<Map<String, dynamic>> dst =
                    await CustomFunctions.viewingThisUserProfile(
                        widget.authorId, "Personal");
                SparksUser sUser = SparksUser.fromJson(dst.data()!);
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: CachedNetworkImage(
                  imageUrl: "${widget.authorPimg}",
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              "${widget.authorFullname!["ln"]}  ${widget.authorFullname!["fn"]}",
              style: Theme.of(context).textTheme.headline6!.apply(
                    color: kBlackcolor,
                    fontSizeFactor: 0.5,
                    fontSizeDelta: 4,
                  ),
            ),
            subtitle: Text(
              widget.authorSpec!,
              style: Theme.of(context).textTheme.subtitle1!.apply(
                    color: kHintColor,
                    fontSizeFactor: 0.65,
                    fontSizeDelta: 4,
                  ),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width *
                  0.1, //initial width is MediaQuery.of(context).size.width * 0.2
              child: Row(
                children: [
                  /*IconButton(
                    iconSize: editDelIconSize,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.edit,
                    ),
                    onPressed: () {},
                  ),*/
                  currentUser.id == GlobalVariables.loggedInUserObject.id
                      ? IconButton(
                          iconSize: editDelIconSize,
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.delete,
                          ),
                          onPressed: () async {
                            //Get the common Id assoicated with the main comment
                            String? ccID = await _getCommonID(
                                widget.commentId, widget.postId);

                            await DatabaseService(
                                    loggedInUserID:
                                        GlobalVariables.loggedInUserObject.id)
                                .deleteCommentsLikesAndReplies(
                                    ccID, widget.commentId, widget.postId);
                          },
                        )
                      : Container(
                          width: 0.0,
                          height: 0.0,
                        ),
                ],
              ),
            ),
          ),
          //TODO: Displays the comment made by the user.
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "${widget.comment}",
                style: Theme.of(context).textTheme.bodyText1!.apply(
                      color: kHintColor,
                      fontSizeFactor: 0.7,
                      fontSizeDelta: 4,
                    ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.001,
          ),
          //TODO: Display the most current reply associated with this comment.
          StreamBuilder<QuerySnapshot>(
              stream: DatabaseService(
                      loggedInUserID: GlobalVariables.loggedInUserObject.id)
                  .getTheMostRecentReplies(widget.commentId),
              builder: (context, snapshot) {
                if ((snapshot.connectionState == ConnectionState.waiting) &&
                    (snapshot.hasData == false)) {
                  replyWidget = Container(
                    width: 0.0,
                    height: 0.0,
                  );
                } else {
                  // List<DocumentSnapshot> docSt = snapshot.data.docs;

                  List<Map<String, dynamic>?> docSt =
                      snapshot.data!.docs.map((DocumentSnapshot doc) {
                    return doc.data as Map<String, dynamic>?;
                  }).toList();
                  if (docSt.isNotEmpty) {
                    replyWidget = ReplyCommentCard(
                      whoReplyProfileImage: docSt[0]!["rPimg"],
                      fullname: docSt[0]!["fn"],
                      reply: docSt[0]!["replyText"],
                      id: docSt[0]!["id"],
                    );
                  }
                }

                return replyWidget;
              }),
          //TODO: Display a reply container that renders a reply textfield and the reply itself.
          showReplyTextField == true
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.001,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: kGreyLightShade,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Display the image of the person replying the comment
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            padding: EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: CachedNetworkImage(
                                imageUrl: "${widget.authorPimg}",
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        //Display a textfield for replying a comment
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            controller: replyTextFormController,
                            keyboardType: TextInputType.multiline,
                            cursorColor: kHintColor,
                            minLines: 1,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.headline6!.apply(
                                  color: kHintColor,
                                  fontSizeFactor: 0.45,
                                  fontSizeDelta: 2,
                                ),
                            decoration: InputDecoration(
                              hintText: kReply_post,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: kTransparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: kTransparent,
                                ),
                              ),
                              hintStyle:
                                  Theme.of(context).textTheme.headline6!.apply(
                                        color: kHintColor,
                                        fontSizeFactor: 0.55,
                                        fontSizeDelta: 2,
                                      ),
                            ),
                          ),
                        ),
                        //Displaying send reply button
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 5.0,
                              right: 10.0,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  showReplyTextField = false;
                                });
                                //Create a new reply
                                String userReply = replyTextFormController.text;
                                replyTextFormController.clear();

                                //Get the common id associated with post, likes and comments
                                String? cid = await _getCommonID(
                                    widget.commentId, widget.postId);

                                //Get the author's id from the parent post.
                                String? authorID = await DatabaseService(
                                        loggedInUserID: GlobalVariables
                                            .loggedInUserObject.id)
                                    .authorID(widget.postId, cid);

                                //Create a timestamp for the every reply generated.
                                String replyTimeStamp =
                                    DateTime.now().toString();

                                //Create a reply comment model object
                                if ((userReply != null) && (userReply != "")) {
                                  ReplyComments replyComments = ReplyComments(
                                    rPimg:
                                        GlobalVariables.loggedInUserObject.pimg,
                                    fn: GlobalVariables.loggedInUserObject.nm,
                                    replyText: userReply,
                                    delRId: cid,
                                    comID: widget.commentId,
                                    tRep: replyTimeStamp,
                                    id: GlobalVariables.loggedInUserObject.id,
                                  );

                                  //Store the reply comment object into the database
                                  await DatabaseService(
                                          loggedInUserID: GlobalVariables
                                              .loggedInUserObject.id)
                                      .newReplyObject(replyComments, authorID,
                                          widget.postId, widget.commentId);
                                }
                              },
                              child: Image.asset(
                                "images/app_entry_and_home/post_btn.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          //TODO: Display the like comment button, like counter, reply and date when the comment was made.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    SparksReactions(
                      dim: 18.0,
                      aDim: 18.0,
                      reactionUrl:
                          "images/app_entry_and_home/new_images/sparks_like.svg",
                      btnReactionColor: likeButtonUserChoice() == true
                          ? kRed
                          : kMore_icon_Colour,
                      bgImageTap: () async {
                        bool commentLikedAndUnlike =
                            await CustomFunctions.isCommentLiked(
                                widget.authorId,
                                GlobalVariables.loggedInUserObject.id,
                                widget.postId,
                                widget.commentId);

                        //TODO: Add the logged in user id into the liked collection if absence/update or delete logged user id if present.
                        addAndDeleteCommentLikes(
                            commentLikedAndUnlike,
                            GlobalVariables.loggedInUserObject.id,
                            widget.authorId,
                            widget.postId,
                            widget.commentId);

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
                    StreamBuilder<DocumentSnapshot>(
                      stream:
                          CustomStreams.currentNumberOfLikedCommentAndReplies(
                              GlobalVariables.loggedInUserObject.id,
                              widget.authorId,
                              widget.postId,
                              widget.commentId),
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
                            widget.numOfLikes = uDoc["nOfLikes"];

                            formatLikeCounter = CustomFunctions.numberFormatter(
                                widget.numOfLikes);
                          } catch (e) {
                            e.toString();
                          }
                        }
                        return Text(
                          formatLikeCounter == "0" ? "" : formatLikeCounter,
                          style: Theme.of(context).textTheme.headline6!.apply(
                                color: kHintColor,
                                fontSizeFactor: 0.6,
                                fontSizeDelta: 4,
                              ),
                        );
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showReplyTextField = true;
                        });
                      },
                      child: Text(
                        kReply,
                        style: Theme.of(context).textTheme.headline6!.apply(
                              color: kLight_orange,
                              fontSizeFactor: 0.5,
                              fontSizeDelta: 4,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream:
                          CustomStreams.currentNumberOfLikedCommentAndReplies(
                              GlobalVariables.loggedInUserObject.id,
                              widget.authorId,
                              widget.postId,
                              widget.commentId),
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
                            widget.numOfReplies = uDoc["nOfRpy"];

                            formatReplyCounter =
                                CustomFunctions.numberFormatter(
                                    widget.numOfReplies);
                          } catch (e) {
                            e.toString();
                          }
                        }
                        return Text(
                          formatReplyCounter == "0" ? "" : formatReplyCounter,
                          style: Theme.of(context).textTheme.headline6!.apply(
                                color: kHintColor,
                                fontSizeFactor: 0.6,
                                fontSizeDelta: 4,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${widget.howOldIsTheComment}",
                    style: Theme.of(context).textTheme.headline6!.apply(
                          color: kHintColor,
                          fontSizeFactor: 0.5,
                          fontSizeDelta: 4,
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          //TODO: Display a horizontal line.
          Divider(
            color: kHintColor,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
