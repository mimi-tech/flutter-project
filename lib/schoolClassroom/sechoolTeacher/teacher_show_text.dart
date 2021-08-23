import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class TeacherShowText extends StatelessWidget {
  const TeacherShowText({
    required this.title,
    required this.desc,
    required this.views,
    required this.rate,
    required this.date,
    required this.comm,
    required this.downloads,
    required this.note,
    required this.likeClick,
    required this.viewClick,
    required this.feedClick,
    required this.downloadClick,
    required this.downloadNoteClick,
  });
  final String title;
  final String desc;
  final String views;
  final String rate;
  final String date;
  final String comm;
  final String downloads;
  final String note;
  final Function likeClick;
  final Function viewClick;
  final Function feedClick;
  final Function downloadClick;
  final Function downloadNoteClick;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: <Widget>[
        //ToDo: Displaying the title
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ScreenUtil().setWidth(constrainedReadMore),
            minHeight: ScreenUtil().setHeight(10),
          ),
          child: ReadMoreText(

            title,

            trimLines: 1,
            colorClickableText:kStabcolor,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' ...',
            trimExpandedText: ' show less',
            style: TextStyle(
              fontSize:15.sp,
              color: kPreviewcolor,
              fontFamily: 'Rajdhani',
            ),
          ),
        ),

        //ToDo:Displaying the description
        Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ScreenUtil()
                  .setWidth(constrainedReadMore),
              minHeight: ScreenUtil()
                  .setHeight(constrainedReadMoreHeight),
            ),
            child: ReadMoreText(
              desc,
              //doc.data['desc'],
              trimLines: 1,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' .. ^',
              trimExpandedText: ' ^',
              style: TextStyle(
                fontSize: 15.sp,
                color: kBlackcolor,
                fontFamily:
                'RajdhaniMedium',
              ),
            ),
          ),
        ),
        SizedBox(height: kSheightdate),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //ToDo: Number of views

            GestureDetector(
              onTap: viewClick as void Function()?,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      child:
                      SvgPicture.asset(
                        'images/classroom/viewsorange.svg',
                      )),
                  SizedBox(
                      width: kSiconspace),
                  Text(views,
                    style: TextStyle(
                      fontSize: kSlivevcrfonts.sp,
                      color: klistnmber,
                      fontFamily:
                      'Rajdhani',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: kSiconheigt,
            ),

            Row(
              children: <Widget>[
                //ToDo:icons for comments

                GestureDetector(
                  onTap: feedClick as void Function()?,
                    child:
                    SvgPicture.asset(
                      'images/classroom/comment.svg',
                    )),
                SizedBox(
                    width: kSiconspace),
                Text(
                  comm,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily:
                    'Rajdhani',
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
                    child:Icon(Icons.thumb_up,color:Colors.deepOrange,size: 18,)),
                Text(rate,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily:
                    'Rajdhani',
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
                 onTap: downloadClick as void Function()?,
                    child:Icon(Icons.download_rounded,color:Colors.deepOrange,size: 18,)),
                Text(downloads,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily:
                    'Rajdhani',
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
                  onTap: downloadNoteClick as void Function()?,
                    child:Icon(Icons.read_more,color:Colors.deepOrange,size: 18,)),
                Text(note,
                  style: TextStyle(
                    fontSize: kSlivevcrfonts.sp,
                    color: klistnmber,
                    fontFamily:
                    'Rajdhani',
                  ),
                ),
              ],
            ),
          ],
        ),

        //ToDo:Displaying the date and time published
        SizedBox(height: kSheightdate),
        RichText(
          text: TextSpan(
              text:'$kSDate: ',
              style: GoogleFonts.rajdhani(
                fontSize: 12.sp,
                color: klistnmber,
                fontWeight: FontWeight.w500,
              ),

              children: <TextSpan>[
                TextSpan(text:date,
                  style: GoogleFonts.rajdhani(
                    fontSize: 12.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,
                  ),),
              ]
          ),
        ),

      ],
    );
  }
}
