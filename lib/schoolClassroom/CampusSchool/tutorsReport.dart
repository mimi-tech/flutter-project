import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/all_socialClasses.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/report_tutor.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';


class ShowTeachersReport extends StatefulWidget {
  ShowTeachersReport({required this.doc});
  final DocumentSnapshot doc;
  @override
  _ShowTeachersReportState createState() => _ShowTeachersReportState();
}

class _ShowTeachersReportState extends State<ShowTeachersReport> {

  String like = 'Liked by';
  String view = 'Viewed by';
  String videoDownload = 'Video DownLoaded by';
  String noteDownload = 'Note DownLoaded by';

  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {

        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if(isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {

    FirebaseFirestore.instance.collectionGroup('schoolLessons').where('tId',isEqualTo:  SchClassConstant.schDoc['id']).orderBy('ts',descending: true).snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
           backgroundColor: kStatusbar,
              title: Text('${widget.doc['tc']} Report(s)'.toUpperCase(),

                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kWhitecolor,
                    fontSize: kFontsize.sp,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(

                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: BtnThird(next: (){_reportTeacher();}, title: 'Send report', bgColor: Colors.amber)),
                    StreamBuilder<List<DocumentSnapshot>>(
                        stream: _streamController.stream,

                        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if(snapshot.data == null){
                            return Center(child: Text('Loading...'));
                          } else {
                            return Column(
                                children: snapshot.data!.map((doc) {
                                  Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;

                                  return  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                        elevation:5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Text('Report',

                                                style: GoogleFonts.rajdhani(
                                                  decoration: TextDecoration.underline,
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: klistnmber,
                                                    fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),

                                              Container(
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(context).size.width,
                                                    minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),),

                                                  child: ReadMoreText(data['msg'],
                                                    //doc.data['desc'],
                                                    trimLines: 2,
                                                    colorClickableText: Colors.pink,
                                                    trimMode: TrimMode.Line,
                                                    trimCollapsedText: ' .. ^',
                                                    trimExpandedText: ' ^',
                                                    style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: kFbColor,
                                                        fontSize: kFontsize.sp,
                                                      ),

                                                    ),
                                                  ),
                                                ),),
                                              Text('Date',

                                                style: GoogleFonts.rajdhani(
                                                  decoration: TextDecoration.underline,
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: klistnmber,
                                                    fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),
                                              Text(DateFormat().format(DateTime.parse(data['ts'])),

                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    color: klistnmber,
                                                    fontSize: kFontSize14.sp,
                                                  ),
                                                ),
                                              ),
                                              Text('By',

                                                style: GoogleFonts.rajdhani(
                                                  decoration: TextDecoration.underline,
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: klistnmber,
                                                    fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),

                                              Text('${data['fn']} ${data['ln']}',

                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kExpertColor,
                                                    fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                        )
                                    ),
                                  );


                                }).toList()

                            );
                          }
                        }
                    ),





                    _isFinish == false ?
                    isLoading == true ? Center(
                        child: PlatformCircularProgressIndicator()) : Text('')

                        : Text(''),
                  ],
                ),
              ),
            ),
          ),
        ));
  }



  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

         querySnapshot  = await FirebaseFirestore.instance
            .collection("tutorsReport").doc(SchClassConstant.schDoc['schId']).collection('report')
            .where('id',isEqualTo: widget.doc['id'])

            .orderBy('ts',descending: true)
            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
         querySnapshot  = await FirebaseFirestore.instance
            .collection("tutorsReport").doc(SchClassConstant.schDoc['schId']).collection('report')
            .where('id',isEqualTo: widget.doc['id']).orderBy('ts',descending: true)
            .startAfterDocument(_products[_products.length - 1])
            .limit(SchClassConstant.streamCount)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }
  void _reportTeacher() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return AdminTeachersReport(doc:widget.doc);
        });
  }
}
