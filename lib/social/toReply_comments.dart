import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/chat/chatConstant.dart';
import 'package:timeago/timeago.dart' as timeago;

class ToReplyComment extends StatefulWidget {
  ToReplyComment({required this.doc});
  final DocumentSnapshot doc;

  @override
  _ToReplyCommentState createState() => _ToReplyCommentState();
}

class _ToReplyCommentState extends State<ToReplyComment> {


  @override
  Widget build(BuildContext context) {
    return  Column(

                          children: [

                            Container(
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0)),

                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),

                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width,
                                      minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,

                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              radius: 32,
                                              child: ClipOval(

                                                child: CachedNetworkImage(

                                                  imageUrl: '${ widget.doc['pimg']}',
                                                  placeholder: (context, url) => CircularProgressIndicator(),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  width: 40.0,
                                                  height: 40.0,

                                                ),
                                              ),
                                            ),


                                            Text('${widget.doc['fn']} ${widget.doc['ln']}',

                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kBlackcolor,
                                                  fontSize:kFontsize.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ReadMoreText(
                                          widget.doc['msg'],

                                          trimLines: 4,
                                          colorClickableText: Colors.pink,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: ' ...',
                                          trimExpandedText: ' less',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: kFontsize.sp,
                                            color: kBlackcolor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                          children: [
                                            Row(
                                              children: [
                                                IconButton(icon: Icon(Icons.timer, color:kbtnsecond), onPressed: (){}),
                                                Text('${timeago.format(DateTime.parse(widget.doc['ts']), locale: 'en_short')}',

                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: klistnmber,
                                                      fontSize:14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(icon: Icon(Icons.thumb_up,color:kbtnsecond), onPressed: (){}),
                                                Text('${widget.doc['like']}',

                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kExpertColor,
                                                      fontSize:14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(icon: Icon(Icons.reply,color:kbtnsecond), onPressed: (){}),
                                                Text('${widget.doc['re']}',

                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kLightGreen,
                                                      fontSize:14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                )),
                            //Divider(thickness: 2,color: kMaincolor,),


                          ],
                        );

  }




}



