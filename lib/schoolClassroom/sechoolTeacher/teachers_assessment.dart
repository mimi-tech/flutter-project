import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/post_assignment.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/replied_assignments.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/studentFolder/view_assessments.dart';

class TeachersAssessment extends StatefulWidget {
  @override
  _TeachersAssessmentState createState() => _TeachersAssessmentState();
}

class _TeachersAssessmentState extends State<TeachersAssessment> {
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

    FirebaseFirestore.instance.collection('teachersAssessment').doc(SchClassConstant.schDoc['schId']).collection('assessments')
        .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
        .orderBy('ts',descending: true)
        .snapshots()
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
    child:SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhitecolor,
          title: Align(
            alignment: Alignment.topRight,
            child: RaisedButton(onPressed: (){
              postAssignment();
            },
              color: kExpertColor,
              child:  Text('Post'.toUpperCase(),
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kWhitecolor,
                    fontSize: kFontSize14.sp,
                  ),
                ),

              ),
            ),
          )
        ),

        body: SingleChildScrollView(
          child: Column(
          children: [
          StreamBuilder<List<DocumentSnapshot>>(
          stream: _streamController.stream,

          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if(snapshot.data == null){
          return Center(child: Text(kNothing,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: klistnmber,
                fontSize: kFontsize.sp,
              ),
            ),

          ));
          } else {
            return Column(
              children: snapshot.data!.map((doc) {
                Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewAssessment(note:data['url'],doc:doc)));

                  },
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              GestureDetector(

                                child: PDF.network(data['url'],
                                  placeHolder: Center(child: CircularProgressIndicator()),
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  width:MediaQuery.of(context).size.width * 0.3,

                                ),
                              ),

                              SizedBox(width: 5,),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: ScreenUtil().setWidth(200),
                                        minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                      ),
                                      child: ReadMoreText(data['title'],
                                        //doc.data['desc'],
                                        trimLines: 1,
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

                                  SchClassConstant.isUniStudent?Container(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: ScreenUtil().setWidth(200),
                                        minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                      ),
                                      child: ReadMoreText(data['curs'],
                                        //doc.data['desc'],
                                        trimLines: 1,
                                        colorClickableText: Colors.pink,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: ' .. ^',
                                        trimExpandedText: ' ^',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kLightGreen,
                                            fontSize: kFontsize.sp,
                                          ),

                                        ),
                                      ),
                                    ),):Text(''),

                                  Text(Variables.dateFormat.format(DateTime.parse(data['ts'])),
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: klistnmber,
                                        fontSize: kFontSize14.sp,
                                      ),
                                    ),

                                  ),
                                ],
                              ),


                            ],
                          ),
                        ),
                        Divider(),

                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if(data['ass'] == true){
                                  _blockAssignment(doc);
                                  }else{
                                    _unBlockAssignment(doc);

                                  }

                                  },
                                child: Text(data['ass'] == true?"Block":'Unblock',
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: (data['ass'] == true?kExpertColor:kRed),
                                      fontSize: kFontsize.sp,
                                    ),
                                  ),

                                ),
                              ),
                    VerticalDivider(),

                    GestureDetector(
                    onTap: (){
                    _repliedAssignment(doc);},
                    child: Text('Replied ${data['rec']}',
                    style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kExpertColor,
                    fontSize: kFontsize.sp,
                    ),
                    ),

                    ),
                    ),





                    ],
                          ),
                        ),





                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }}),
            _isFinish == false ?
            isLoading == true ? Center(
                child: PlatformCircularProgressIndicator()) : Text('')

                : Text(''),
          ]),
        )
    )
    )
    );
  }

    void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
    QuerySnapshot querySnapshot;
    _isRequesting = true;


    if (_products.isEmpty) {

    querySnapshot = await  FirebaseFirestore.instance
        .collection('teachersAssessment')
        .doc(SchClassConstant.schDoc['schId'])
        .collection('assessments')
        .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
        .orderBy('ts',descending: true)
        .limit(SchClassConstant.streamCount)
        .get();
    } else {
    setState(() {
    isLoading = true;
    });
    querySnapshot = await  FirebaseFirestore.instance.collection('teachersAssessment').doc(SchClassConstant.schDoc['schId']).collection('assessments')
        .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
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
    }

  void _blockAssignment(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //block students from seeing this assessment

    FirebaseFirestore.instance.collection('teachersAssessment').doc(data['schId']).collection('assessments').doc(data['id'])
        .set({
      'ass':false,
    },SetOptions(merge: true));


  }

  void _unBlockAssignment(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //unblock students from seeing this assessment

    FirebaseFirestore.instance.collection('teachersAssessment').doc(data['schId']).collection('assessments').doc(data['id'])
        .set({
      'ass':true,
    },SetOptions(merge: true));

  }

  late File imageNote;
  Future<void> postAssignment() async {
    //open gallery to select the pdf

    File file;

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    ) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

    int fileSize = file.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        imageNote = file;

        showModalBottomSheet(
            isDismissible: false,
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            builder: (context) {
              return PostAssignment(assignment: imageNote);
            });
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  void _repliedAssignment(DocumentSnapshot doc) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsRepliedAssessment(doc: doc);
        });
  }





    }
