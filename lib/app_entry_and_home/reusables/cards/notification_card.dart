import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/screens/notification_post_screen.dart';

class HomeNotificationCard extends StatefulWidget {
  final String? authorId;
  final String? postId;
  final String? ownOfPostCommentId;
  final String? authorPimg;
  final Map<String, String>? authorFN;
  final String? authorComment;
  String? notificationStatus;
  final String notificationType;
  final String? notificationID;
  final String whenCreated;

  HomeNotificationCard({
    required this.authorId,
    required this.postId,
    required this.ownOfPostCommentId,
    required this.authorPimg,
    required this.authorFN,
    required this.authorComment,
    required this.notificationStatus,
    required this.notificationType,
    required this.notificationID,
    required this.whenCreated,
  });

  @override
  _HomeNotificationCardState createState() => _HomeNotificationCardState();
}

class _HomeNotificationCardState extends State<HomeNotificationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: Route the user to source of the notification
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationPostScreen(
              postAuthorId: widget.ownOfPostCommentId,
              postId: widget.postId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
        child: ListTile(
            isThreeLine: true,
            tileColor: Colors.red.shade100,
            leading: Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: GestureDetector(
                onTap: () {
                  //TODO: Display the profile of this user who got this profile image
                  print("View user personal profile");
                },
                child: ClipOval(
                  child: CircleAvatar(
                    maxRadius: 30.0,
                    backgroundColor: Colors.red,
                    backgroundImage: (widget.authorPimg != null
                        ? CachedNetworkImageProvider(
                            "${widget.authorPimg}",
                          )
                        : AssetImage(
                            "images/app_entry_and_home/profile_image.png",
                          )) as ImageProvider<Object>?,
                  ),
                ),
              ),
            ),
            title: RichText(
              text: TextSpan(
                text: "${widget.authorFN!["fn"]} ${widget.authorFN!["ln"]} ",
                style: Theme.of(context).textTheme.headline6!.apply(
                      color: kBlackcolor,
                      fontSizeFactor: 0.7,
                    ),
                children: [
                  TextSpan(
                    text: "${widget.notificationType}",
                    style: Theme.of(context).textTheme.headline6!.apply(
                          color: kHintColor,
                          fontSizeFactor: 0.7,
                        ),
                  ),
                ],
              ),
            ),
            subtitle: RichText(
              text: TextSpan(
                  text: "${widget.authorComment}\n",
                  style: Theme.of(context).textTheme.headline6!.apply(
                        color: kHintColor,
                        fontSizeFactor: 0.7,
                      ),
                  children: [
                    TextSpan(
                      text: "${widget.whenCreated}",
                      style: Theme.of(context).textTheme.headline6!.apply(
                            color: kSvg_black,
                            fontSizeFactor: 0.7,
                          ),
                    ),
                  ]),
            ),
            trailing: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: CircleAvatar(
                maxRadius: 5.0,
                backgroundColor: widget.notificationStatus == "Unread"
                    ? kLight_orange
                    : kTransparent,
              ),
            )),
      ),
    );
  }
}
