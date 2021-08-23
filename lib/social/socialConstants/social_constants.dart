import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';

class SocialConstant{
  static int streamLength = 50;
  static int streamGridLength = 100;
  static dynamic ratingCount;
  static late String usersUid;
  static bool isSeeAll = false;

  static  showRating({@required submit})  {
    //popup a attachments toast
    BotToast.showAttachedWidget(
        attachedBuilder: (_) => Center(
          child: Container(
            height: 200,
            child: Card(
              color: kBlackcolor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: kHintColor,
                      glowColor: kAYellow,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: kMaincolor,
                      ),
                      onRatingUpdate: (rating) {
                        ratingCount = rating;



                      },
                    ),
                  ),

                  BtnSecond(next: submit, title: 'Submit', bgColor: kLightGreen)
                ],
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 7),
        target: Offset(520, 520));

  }

static String hint = '';
  ///course job title decoration
  static final kSearchDecoration = InputDecoration(



      prefixIcon: IconButton(
        color: Colors.black,
        icon: Icon(Icons.search),
        iconSize: 20.0,
        onPressed: () {
        },
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              kPlaylistborder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kMaincolor))


  );
}