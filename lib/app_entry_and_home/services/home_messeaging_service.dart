/*
* This class manages the display of notifications using flutterLocalNotificationPlugin and also routes the user
* to the desired screen depending on the type of notification being clicked.
* Types of notifications:
*   - Like post/comment notification
*   - Comment on post/reply a comment notification
*   - Accepting/declining sparks request(friend, tutor or mentor request) notification
* */

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/screens/notification_post_screen.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/market/market_services/navigation_service.dart';
import 'package:sparks/global_services/service_locator.dart';

class HomeMessagingService {
  /*
  * This function handles the notification display using flutterLocalNotificationPlugin.
  * */
  static Future renderBackgroundNotifications(
      Map<String, dynamic> messages,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    //TODO: Get the exact notification type and the appropriate notification display
    String? notificationType = messages["data"]["notificationType"];

    switch (notificationType) {
      case "LikePost":
        return await flutterLocalNotificationsPlugin.show(
            0, 'plain title', 'plain body', await SparksLandingScreen().createState().userAvatar(messages["data"]["pimg"]),
            payload: 'Default sound');
        break;

      case "CommentOnPost":
        //TODO: Knowing exactly the type of post where this notification is coming from
        String? postType = messages["data"]["postType"];

        if (postType == "Text") {
          return await flutterLocalNotificationsPlugin.show(
              0,
              messages["notification"]["notificationTitle"],
              messages["notification"]["notificationMessage"],
              await SparksLandingScreen().createState().userAvatar(messages["data"]["pimg"]),
              payload: 'Default sound');
        } else if (postType == "Camera") {
          /*return await flutterLocalNotificationsPlugin.show(
              0, 'plain title', 'plain body', platformChannelSpecifics,
              payload: 'Default sound');*/
        } else if (postType == "Video") {
          /*return await flutterLocalNotificationsPlugin.show(
              0, 'plain title', 'plain body', platformChannelSpecifics,
              payload: 'Default sound');*/
        }

        break;

      case "CreatePost":
        break;

      case "LikeComment":
        break;

      case "ReplyAComment":
        break;

      case "SparkUpRequest":
        break;
    }
  }

  /*
  * Route the user to a specific screen when the user taps on the notification from the notification tray
  * */
  static homeBackgroundHandler(Map<String, dynamic> message) {
    locator<NavigationService>().navigateToWidget(
      NotificationPostScreen(
        postAuthorId: message["data"]["ptOwn"],
        postId: message["data"]["postId"],
      ),
    );
  }

  /*
  * Route the user to a specific screen when the user taps on the notification when app is on foreground
  * */
  static homeForegroundHandler(Map<String, dynamic> message) {
    //TODO: Check the type of notification that is coming in
    String? notType = message["data"]["notificationType"];

    switch (notType) {
      case "Text":
        BotToast.showNotification(
          backgroundColor: kWhitecolor,
          borderRadius: 5.0,
          onTap: () {
            locator<NavigationService>().navigateToWidget(
              NotificationPostScreen(
                postAuthorId: message["data"]["ptOwn"],
                postId: message["data"]["postId"],
              ),
            );
          },
          leading: (_) => ClipOval(
            child: CircleAvatar(
              maxRadius: 30.0,
              backgroundImage: NetworkImage(message["data"]["pimg"]),
              backgroundColor: kWhitecolor,
            ),
          ),
          title: (_) => RichText(
            text: TextSpan(
              text:
                  "${message["data"]["nm"]["ln"]} ${message["data"]["nm"]["fn"]}",
              style: TextStyle(
                color: kBlackcolor,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text:
                      " commented on your post.",
                  style: TextStyle(
                    color: kHintColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          subtitle: (_) => Text(
            message["data"]["comm"],
            style: TextStyle(
              color: kHintColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
    }
  }
}
