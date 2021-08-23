import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_bottomAppbar.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/sliverAppbarCampus.dart';

import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';


class AllSchoolFeed extends StatefulWidget {
  @override
  _AllSchoolFeedState createState() => _AllSchoolFeedState();
}

class _AllSchoolFeedState extends State<AllSchoolFeed> {


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

    FirebaseFirestore.instance.collection('lessonFeedback').doc(SchClassConstant.schDoc['schId']).collection('feedback').orderBy('ts',descending: true)        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();

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
            appBar: StuAppBar(),
            body: CustomScrollView(slivers: <Widget>[
              ProprietorActivityAppBar(
              activitiesColor: kTextColor,
              classColor: kTextColor,
              newsColor: kStabcolor1,
              studiesColor: kTextColor,
            ),
            CampusSliverAppBarNews(
              campusBgColor: Colors.transparent,
              campusColor: klistnmber,
              deptBgColor: klistnmber,
              deptColor: kWhitecolor,
              recordsBgColor: Colors.transparent,
              recordsColor: klistnmber,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(kFeeds,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhitecolor,
                        fontSize: kFontsize.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),


                StreamBuilder<List<DocumentSnapshot>>(
                        stream: _streamController.stream,

                        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if(snapshot.data == null){
                            return Center(child: PlatformCircularProgressIndicator());
                          } else {
                            return Column(
                                children: snapshot.data!.map((doc) {
                                  Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                                  return Card(
                                    elevation: 5,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${data['fn']} ${data['ln']} ',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kLightGreen,
                                                fontSize:kFontsize.sp,
                                              ),
                                            ),
                                          ),

                                          Text('${data['cl']} ${data['lv']} ',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kBlackcolor,
                                                fontSize: kFontSize14.sp,
                                              ),
                                            ),
                                          ),
                                          Text(Variables.dateFormat.format(DateTime.parse(data['ts'])),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: kFbColor,
                                                fontSize: kFontSize14.sp,
                                              ),
                                            ),
                                          ),
                                          Divider(),

                                          ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width,
                                                minHeight: ScreenUtil().setHeight(15),
                                              ),
                                              child: ReadMoreText(data['msg'],

                                                trimLines: 3,
                                                colorClickableText:kStabcolor,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: ' ...',
                                                trimExpandedText: ' show less',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: kBlackcolor,
                                                    fontSize:kFontsize.sp,
                                                  ),
                                                ),
                                              )),




                                        ],




                                      ),
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
            ]),
          ),
        ));
  }


  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await   FirebaseFirestore.instance.collection('lessonFeedback').doc(SchClassConstant.schDoc['schId']).collection('feedback').orderBy('ts',descending: true)

            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await   FirebaseFirestore.instance.collection('lessonFeedback').doc(SchClassConstant.schDoc['schId']).collection('feedback').orderBy('ts',descending: true)
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
}
