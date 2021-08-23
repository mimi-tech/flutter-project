import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/screens/view_profile.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class ReplyCommentCard extends StatefulWidget {
  final String? whoReplyProfileImage;
  final Map<String, dynamic>? fullname;
  final String? reply;
  final String? id;

  ReplyCommentCard({
    required this.whoReplyProfileImage,
    required this.fullname,
    required this.reply,
    required this.id,
  });

  @override
  _ReplyCommentCardState createState() => _ReplyCommentCardState();
}

class _ReplyCommentCardState extends State<ReplyCommentCard> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
                margin: EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
                padding: EdgeInsets.only(
                  left: 10.0,
                ),
                child: GestureDetector(
                  onTap: () async {
                    //TODO: View user profile
                    DocumentSnapshot<Map<String, dynamic>> dst =
                        await CustomFunctions.viewingThisUserProfile(
                            widget.id, "Personal");
                    SparksUser sUser = SparksUser.fromJson(dst.data()!);
                    GlobalVariables.viewingProfileInfo = sUser;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProfile(
                          profileId: widget.id,
                          profileStatus: "",
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: CachedNetworkImage(
                      imageUrl: "${widget.whoReplyProfileImage}",
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            //Display a textfield for replying a comment
            Expanded(
              flex: 9,
              child: Wrap(
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  //Display user full name
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      left: 5.0,
                      bottom: 2.0,
                    ),
                    child: Text(
                      "${widget.fullname!["ln"]} ${widget.fullname!["fn"]} ",
                      style: Theme.of(context).textTheme.headline6!.apply(
                            fontSizeFactor: 0.5,
                            fontSizeDelta: 2,
                            color: kBlackColour,
                          ),
                    ),
                  ),

                  //Display the reply
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      top: 5.0,
                      bottom: 5.0,
                      right: 5.0,
                    ),
                    child: Text(
                      widget.reply!,
                      style: Theme.of(context).textTheme.headline6!.apply(
                            fontSizeFactor: 0.5,
                            fontSizeDelta: 2,
                            color: kHintColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
