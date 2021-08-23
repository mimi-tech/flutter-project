import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/noText.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';

class ScheduledLiveActivity extends StatefulWidget {
  ScheduledLiveActivity({required this.doc});
  final DocumentSnapshot doc;
  @override
  _ScheduledLiveActivityState createState() => _ScheduledLiveActivityState();
}

class _ScheduledLiveActivityState extends State<ScheduledLiveActivity> {
  List<dynamic> workingDocuments = <dynamic>[];
  bool progress = false;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  var _documents = <DocumentSnapshot>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScheduledLive();
  }
  @override
  Widget build(BuildContext context) {

    return workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
    workingDocuments.length == 0 && progress == true ? NoTextComment(title: kNothing,):SingleChildScrollView(
        child:Column(
      children: [

    ListView.builder(
    itemCount: workingDocuments.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, int index) {
      return Column(
        children: [
          Card(
            elevation: 10,
            color: kCardFillColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Row(
                    children: [
                      Container(
                        height:50,
                        width: 50,
                        child: Icon(Icons.tv_off),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(6.0),
                            color: klistnmber
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize:MainAxisSize.min,
                        children: [
                          Text('${workingDocuments[index]['cn']}',
                            overflow:TextOverflow.ellipsis,
                            softWrap:true,
                            maxLines:1,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
                                fontSize: kFontSize14.sp,
                              ),
                            ),

                          ),
                          Container(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().setWidth(150),
                                minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                              ),
                              child: ReadMoreText(workingDocuments[index]['tp'],

                                trimLines: 1,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: ' ...',
                                trimExpandedText: 'show less',
                                style:GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: kBlackcolor,
                                    fontSize:14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),



                        ],
                      ),

                      Spacer(),
                      Column(
                        children: [
                          Material(
                            color: kRed,
                            child:   Text('Live',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kWhitecolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),


                          ),


                          Text(workingDocuments[index]['close'] == true?workingDocuments[index]['tm']:'00:00:00',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: klistnmber,
                                fontSize: kFontsize.sp,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),

                  Divider(),

                  Text(workingDocuments[index]['tsn'],
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: kBlackcolor,
                        fontSize: kFontsize.sp,
                      ),
                    ),
                  ),

                  Text('Posted on ${DateFormat('EE d, MMM yyyy: hh:mma').format(DateTime.parse(workingDocuments[index]['ts']))}',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kMaincolor,
                        fontSize: kFontsize.sp,
                      ),
                    ),
                  ),

                  Text('Class date ${DateFormat('EE d, MMM yyyy: hh:mma').format(DateTime.parse(workingDocuments[index]['dd']))}',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kAGreen,
                        fontSize: kFontsize.sp,
                      ),
                    ),
                  ),


                  Divider(),
                  Text(workingDocuments[index]['items'] == ""?'Note: No Item required to attend this class.':'Note: ${workingDocuments[index]['items']}',
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: kBlackcolor,
                        fontSize: kFontsize.sp,
                      ),
                    ),

                  ),
                  Divider(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [



                     Row(
                       mainAxisAlignment:MainAxisAlignment.spaceBetween,
                       children: [

                         GestureDetector(

                           child: Text(workingDocuments[index]['ass'] == true?'Access':'Denied',
                             style: GoogleFonts.rajdhani(
                               textStyle: TextStyle(
                                 fontWeight: FontWeight.w400,
                                 color: workingDocuments[index]['ass'] == true? kExpertColor:kRed,
                                 fontSize: kFontsize.sp,
                               ),
                             ),
                           ),
                         ),

                       ],
                     )


                    ],
                  ),


                ],
              ),
            ),
          ),

        ],
      );
      
        }),
        prog == true || _loadMoreProgress == true
            || _documents.length < SocialConstant.streamLength
            ?Text(''):
        moreData == true? PlatformCircularProgressIndicator():GestureDetector(
            onTap: (){loadMore();},
            child: SvgPicture.asset('assets/classroom/load_more.svg',))

      ],
    ));
  }

  void getScheduledLive() {


    try{
      FirebaseFirestore.instance.collection('savedClasses')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('savedOnlineClasses')
          .where('tcId',isEqualTo: widget.doc['id'])
          .where('close',isEqualTo: false)
          .orderBy('ts', descending: true)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {

            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);

            });
          }
        }else{

          setState(() {
            progress = true;
          });
        }
      });


    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }


  Future<void> loadMore() async {
    FirebaseFirestore.instance.collection('savedClasses')
        .doc(SchClassConstant.schDoc['schId'])
        .collection('savedOnlineClasses')
        .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('close',isEqualTo: false)
        .orderBy('ts', descending: true)
    .startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
      if (documents.length == 0) {
        setState(() {
          _loadMoreProgress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          _lastDocument = documents.last;

          setState(() {
            moreData = true;
            _documents.add(document);
            workingDocuments.add(document.data());

            moreData = false;
          });
        }
      }
    });
  }


  }








