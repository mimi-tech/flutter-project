import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ShowLiveText extends StatelessWidget {
  const ShowLiveText({
    required this.title,
    required this.desc,
    required this.views,
    required this.rate,
    required this.date,
    required this.comm,
    required this.downloads,
    required this.note,
    required this.likeClick,
  });
  final String? title;
  final String? desc;
  final String views;
  final String rate;
  final String? date;
  final String comm;
  final String downloads;
  final String note;
  final Function likeClick;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //ToDo: Displaying the title
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ScreenUtil().setWidth(constrainedReadMore),
            minHeight: ScreenUtil().setHeight(10),
          ),
          child: ReadMoreText(
            title!,
            trimLines: 1,
            colorClickableText: kStabcolor,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' ...',
            trimExpandedText: ' show less',
            style: TextStyle(
              fontSize: 15.sp,
              color: kPreviewcolor,
              fontFamily: 'Rajdhani',
            ),
          ),
        ),

        //ToDo:Displaying the description
        Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ScreenUtil().setWidth(constrainedReadMore),
              minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
            ),
            child: ReadMoreText(
              desc!,
              //doc.data['desc'],
              trimLines: 1,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' .. ^',
              trimExpandedText: ' ^',
              style: TextStyle(
                fontSize: 15.sp,
                color: kBlackcolor,
                fontFamily: 'RajdhaniMedium',
              ),
            ),
          ),
        ),
        SizedBox(height: kSheightdate),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //ToDo: Number of views

            Row(
              children: <Widget>[
                GestureDetector(
                    child: SvgPicture.asset(
                      'images/classroom/viewsorange.svg',
                    )),
                SizedBox(width: kSiconspace),
                Text(
                  views,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ],
            ),
            SizedBox(
              width: kSiconheigt,
            ),

            Row(
              children: <Widget>[
                //ToDo:icons for comments

                GestureDetector(
                    child: SvgPicture.asset(
                      'images/classroom/comment.svg',
                    )),
                SizedBox(width: kSiconspace),
                Text(
                  comm,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ],
            ),
            SizedBox(
              width: kSiconheigt,
            ),
            Row(
              children: <Widget>[
                /// icons for like

                GestureDetector(
                    onTap: likeClick as void Function()?,
                    child: Icon(
                      Icons.thumb_up,
                      color: Colors.deepOrange,
                      size: 18,
                    )),
                Text(
                  rate,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ],
            ),
            SizedBox(
              width: kSiconheigt,
            ),
            Row(
              children: <Widget>[
                /// icons for download

                GestureDetector(
                    child: Icon(
                      Icons.download_rounded,
                      color: Colors.deepOrange,
                      size: 18,
                    )),
                Text(
                  downloads,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ],
            ),
            SizedBox(
              width: kSiconheigt,
            ),
            Row(
              children: <Widget>[
                /// icons for note

                GestureDetector(
                    child: Icon(
                      Icons.read_more,
                      color: Colors.deepOrange,
                      size: 18,
                    )),
                Text(
                  note,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ],
            ),
          ],
        ),

        //ToDo:Displaying the date and time published
        SizedBox(height: kSheightdate),

        Row(
          children: <Widget>[
            Text(
              kSDate,
              style: TextStyle(
                fontSize: 12.sp,
                color: klistnmber,
                fontFamily: 'Rajdhani',
              ),
            ),
            SizedBox(
              width: 2.0,
            ),
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ScreenUtil().setWidth(constrainedReadMore),
                  minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                ),
                child: ReadMoreText(
                  date!,
                  //doc.data['desc'],
                  trimLines: 1,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' .. ^',
                  trimExpandedText: ' ^',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: kBlackcolor,
                    fontFamily: 'RajdhaniMedium',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
