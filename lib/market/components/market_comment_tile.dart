import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sparks/market/utilities/market_const.dart';

class MarketCommentTile extends StatelessWidget {
  final Map<String, dynamic> review;
  final Color? color;
  final VoidCallback onLongPress;

  MarketCommentTile(
      {Key? key,
      required this.review,
      required this.color,
      required this.onLongPress})
      : super(key: key);

  String extractFirstLetterOfUsername(String userName) {
    return userName[0].toUpperCase();
  }

  Color getContrastingColor(Color color) {
    Color generatedColor;

    if (color.computeLuminance() > 0.5) {
      generatedColor = Colors.black;
    } else if (color.computeLuminance() < 0.5) {
      generatedColor = Colors.white;
    } else {
      generatedColor = Colors.blueGrey;
    }

    // TODO: Uncomment this if generatedColor clashes with the background color
    // generatedColor.withAlpha(0);

    return generatedColor;
  }

  String reviewTimeToString(int reviewDate) {
    String timeAgoResult;

    DateTime fromReview =
        DateTime.fromMillisecondsSinceEpoch(reviewDate).subtract(
      new Duration(minutes: 1),
    );

    timeAgoResult = timeago.format(fromReview);

    return timeAgoResult;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0, left: 16.0, right: 16.0, bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          review["pimg"] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kMarketPrimaryColor,
                        value: progress.progress,
                      ),
                    ),
                    imageUrl: review["pimg"],
                    width: ScreenUtil().setWidth(64),
                    height: ScreenUtil().setHeight(64),
                    fit: BoxFit.cover,
                  ),
                )
              : CircleAvatar(
                  radius: 32.0,
                  backgroundColor: getContrastingColor(color!),
                  child: CircleAvatar(
                    backgroundColor: color ?? kMarketPrimaryColor,
                    radius: getContrastingColor(color!) == Colors.white
                        ? 32.0
                        : 30.0,
                    child: Text(
                      extractFirstLetterOfUsername(review["un"]),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.w600,
                        fontSize: 32.0,
                        color: getContrastingColor(color!),
                      ),
                    ),
                  ),
                ),
          SizedBox(
            width: ScreenUtil().setWidth(8),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review["un"] ?? "...",
                      style: kMarketNameTextStyle,
                    ),
                    Text(
                      reviewTimeToString(review["ts"]),
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(14),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(8),
                ),
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Text(
                    review["cmt"] ?? "...",
                    style: kMarketComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
