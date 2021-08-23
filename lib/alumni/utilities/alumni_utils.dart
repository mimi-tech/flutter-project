import 'package:flutter/material.dart';
import 'package:sparks/alumni/components/alumni_text_photo_card.dart';
import 'package:sparks/alumni/models/alumni_post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sparks/alumni/utilities/strings.dart';

/// This class contains custom methods that performs specific tasks
class AlumniUtils {
  /// This method receives an int which is representative of the number of
  /// letters contained in a given word or sentence and then returns the font
  /// size (as a double) to be used in displaying the text
  double? wordCountFontChanger(int numberOfLetters) {
    double? fontSize;

    if (numberOfLetters >= 1 && numberOfLetters <= 10) {
      fontSize = 32.0;
    } else if (numberOfLetters > 10 && numberOfLetters <= 20) {
      fontSize = 28.0;
    } else if (numberOfLetters > 20 && numberOfLetters <= 30) {
      fontSize = 20.0;
    } else if (numberOfLetters > 30) {
      fontSize = 18.0;
    }

    return fontSize;
  }

  static Widget? postRenderEngine(AlumniPost alumniPost) {
    Widget? widgetToRender;

    String? postType = alumniPost.type;

    print("postRenderEngine: Post Type = $postType");

    switch (postType) {
      case kTextPost:
        widgetToRender = AlumniTextPhotoCard(
          alumniPost: alumniPost,
        );
        break;
    }

    return widgetToRender;
  }

  /// This method takes in a DateTime in milliSecondsSinceEpoch (in an int value)
  /// and utilizes the [timeago] package to convert the date time to a String
  /// time elapsed value
  static String timeStampIntToElapsedString(int dateTime) {
    DateTime fromReview =
        DateTime.fromMillisecondsSinceEpoch(dateTime).subtract(
      new Duration(minutes: 1),
    );

    return timeago.format(fromReview);
  }
}
