import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/tabsTitle.dart';

class StudentAttendedClass extends StatefulWidget {
  StudentAttendedClass({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentAttendedClassState createState() => _StudentAttendedClassState();
}

class _StudentAttendedClassState extends State<StudentAttendedClass> {
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
    if(SchClassConstant.isTeacher) {
      FirebaseFirestore.instance.collectionGroup('classList')
          .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
          .where('stId',isEqualTo: widget.doc['id'])
          .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
          .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
          .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
          .orderBy('ts',descending: true)
          .snapshots()
          .listen((data) => onChangeData(data.docChanges));


      FirebaseFirestore.instance.collection('studentActivity').doc(widget.doc['schId'])
          .collection('sActivity')
          .where('stId',isEqualTo:  widget.doc['id'])
          .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
          .orderBy('ts',descending: true)
          .get().then((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          SchClassConstant.studentsActivityItems.clear();
          for (DocumentSnapshot document in documents) {

            setState(() {
              SchClassConstant.studentsActivityItems.add(document.data());

            });
          }
        }});

      requestNextPage();




    }else{
    FirebaseFirestore.instance.collectionGroup('classList')
        .where('stId',isEqualTo: widget.doc['id'])
        .where('lv',isEqualTo: widget.doc['lv'])
        .where('cl',isEqualTo: widget.doc['cl'])
        .where('schId',isEqualTo: widget.doc['schId'])
        .orderBy('ts',descending: true)
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    }
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
        child:
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          StreamBuilder<List<DocumentSnapshot>>(
                              stream: _streamController.stream,

                              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                                if(snapshot.data == null){
                                  return NoContentText(title: kNothing);
                                } else {
                                  return Column(
                                     children: snapshot.data!.map((doc) {
                                       Map<String, dynamic> data =
                                       doc.data() as Map<String, dynamic>;
                                        return Column(
                                          children: [
                                            GestureDetector(

                                               child: Card(
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
                                                              Text('${data['cn']}',
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
                                                                  child: ReadMoreText(data['tp'],

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
                                                                child:  Text('Live',
                                                                  style: GoogleFonts.rajdhani(
                                                                    textStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: kWhitecolor,
                                                                      fontSize: kFontsize.sp,
                                                                    ),
                                                                  ),
                                                                ),


                                                              ),

                                                            ],
                                                          )
                                                        ],
                                                      )),

                                                      Divider(),

                                                      Text(data['tsn'],
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            color: kBlackcolor,
                                                            fontSize: kFontsize.sp,
                                                          ),
                                                        ),
                                                      ),



                                                      Text('Class date: ${DateFormat('EE d, MMM yyyy: hh:mma').format(DateTime.parse(data['ts']))}',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: kExpertColor,
                                                            fontSize: kFontsize.sp,
                                                          ),
                                                        ),
                                                      ),




                                                      SizedBox(height: 10,),




                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        );
                                      }).toList());
                                }}),

                          _isFinish == false ?
                          isLoading == true ? Center(
                              child: PlatformCircularProgressIndicator()) : Text('')

                              : Text(''),
                        ],
                      ),
                    ));
  }

  void requestNextPage() async {
    if (SchClassConstant.isTeacher) {

      if (!_isRequesting && !_isFinish) {
        QuerySnapshot querySnapshot;
        _isRequesting = true;


        if (_products.isEmpty) {

          querySnapshot = await    FirebaseFirestore.instance.collectionGroup('classList')
              .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
              .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
              .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
              .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
              .orderBy('ts',descending: true)
              .limit(SchClassConstant.streamCount)
              .get();
        } else {
          setState(() {
            isLoading = true;
          });
          querySnapshot = await  FirebaseFirestore.instance.collectionGroup('classList')
              .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
              .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
              .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
              .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
              .orderBy('ts',descending: true)

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



    } else {
      if (!_isRequesting && !_isFinish) {
        QuerySnapshot querySnapshot;
        _isRequesting = true;


        if (_products.isEmpty) {
          querySnapshot =
          await FirebaseFirestore.instance.collectionGroup('classList')
              .where('stId', isEqualTo: widget.doc['id'])
              .where('lv', isEqualTo: widget.doc['lv'])
              .where('cl', isEqualTo: widget.doc['cl'])
              .where('schId', isEqualTo: widget.doc['schId'])
              .orderBy('ts', descending: true)
              .limit(SchClassConstant.streamCount)
              .get();
        } else {
          setState(() {
            isLoading = true;
          });
          querySnapshot =
          await FirebaseFirestore.instance.collectionGroup('classList')
              .where('stId', isEqualTo: widget.doc['id'])
              .where('lv', isEqualTo: widget.doc['lv'])
              .where('cl', isEqualTo: widget.doc['cl'])
              .where('schId', isEqualTo: widget.doc['schId'])
              .orderBy('ts', descending: true)

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







}
