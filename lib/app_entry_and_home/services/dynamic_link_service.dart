import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/dynamic_link/home_dynamic_link.dart';

class DynamicLinkService {

  //TODO: Creating a dynamic link for any post from home
  static Future<String> createDynamicLink(String? authorID, String? postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://sparksuniverse2.page.link',
      link: Uri.parse('https://sparksuniverse2.page.link/HomePostDynamicScreen/?id=$authorID&pid=$postID'),
      androidParameters: AndroidParameters(
        packageName: 'com.sparksuniverse.sparks',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'your_ios_bundle_identifier',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl.toString();

  }

  //TODO: Retrieving dynamic link
  static Future<void> retrieveDynamicLink(BuildContext context) async {

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    Uri? deepLink = data?.link;

    try {

      if (deepLink != null) {
        if ((deepLink.queryParameters.containsKey('id')) && (deepLink.queryParameters.containsKey('pid'))) {
          String? id = deepLink.queryParameters['id'];
          String? pid = deepLink.queryParameters['pid'];
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePostDynamicScreen(authorID: id, postID: pid,)));
        }
      }

      FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        if ((deepLink!.queryParameters.containsKey('id')) && (deepLink.queryParameters.containsKey('pid'))) {
          String? id = deepLink.queryParameters['id'];
          String? pid = deepLink.queryParameters['pid'];
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePostDynamicScreen(authorID: id, postID: pid,)));
        }
      });

    } catch (e) {
      print(e.toString());
    }
  }

}