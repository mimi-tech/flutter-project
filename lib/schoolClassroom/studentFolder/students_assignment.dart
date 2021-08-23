import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_bottombar.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:sparks/schoolClassroom/studentFolder/view_assessments.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/e-class-secondAppbar.dart';

class StudentAssessment extends StatefulWidget {
  @override
  _StudentAssessmentState createState() => _StudentAssessmentState();
}

class _StudentAssessmentState extends State<StudentAssessment> {
  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;

bool _publishModal = false;
  String? url;
  String get fileImagePaths => 'studentsAssessment/${DateTime.now()}';
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
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
        .where('ass',isEqualTo:true)
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

         // bottomNavigationBar: StudentsBottomBar(),
          appBar: StuAppBar(),
          body:ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: CustomScrollView(slivers: <Widget>[
              ActivityAppBer(
                activitiesColor: kTextColor,
                classColor: kStabcolor1,
                newsColor: kTextColor,
              ),
              EClassSliverAppBar(
                liveBgColor: Colors.transparent,
                liveColor: klistnmber,
                missedClassBgColor: Colors.transparent,
                missedClassColor: klistnmber,
                recordsBgColor: Colors.transparent,
                recordsColor: klistnmber,
                assessmentBgColor: klistnmber,
                assessmentColor: kWhitecolor,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    SingleChildScrollView(
                  child: Column(
                      children: [
                        StreamBuilder<List<DocumentSnapshot>>(
                            stream: _streamController.stream,

                            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                              if(snapshot.data == null){
                                return Center(child: Text('Loading...',
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
                                      onTap: (){
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
                                                            maxWidth: ScreenUtil().setWidth(180),
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
                                                                fontSize:12.sp,
                                                              ),

                                                            ),
                                                          ),
                                                        ),),
                                                      Text(data['tc'],
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: kExpertColor,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        ),

                                                      ),

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

                                                    child: Text('No. of Replies ${data['rec']}',
                                                      style: GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: kExpertColor,
                                                          fontSize: kFontsize.sp,
                                                        ),
                                                      ),

                                                    ),
                                                  ),
                                                  VerticalDivider(),

                                                  RaisedButton(
                                                    onPressed: (){
                                                      postAssignment(doc);},
                                                    color: kExpertColor,

                                                    child: Text('Submit',
                                                      style: GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: kWhitecolor,
                                                          fontSize: kFontsize.sp,
                                                        ),
                                                      ),

                                                    ),
                                                  ),




                                                ],
                                              ),
                                            ),




                                            _isFinish == false ?
                                            isLoading == true ? Center(
                                                child: PlatformCircularProgressIndicator()) : Text('')

                                                : Text(''),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }})

                      ]),
                ),
              ])
        )
        ]),
          )
    )));
  }

  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await  FirebaseFirestore.instance.collection('teachersAssessment').doc(SchClassConstant.schDoc['schId']).collection('assessments')
            .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
            .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
            .where('ass',isEqualTo:true)

            .orderBy('ts',descending: true)
            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await  FirebaseFirestore.instance.collection('teachersAssessment').doc(SchClassConstant.schDoc['schId']).collection('assessments')
            .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
            .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
            .where('ass',isEqualTo:true)

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



  late File imageNote;
  Future<void> postAssignment(DocumentSnapshot doc) async {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

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
        _publishModal = true;
      });
      imageNote = file;
      SchClassConstant.displayToastCorrect(title: 'file picked');


//check if assignment have been submitted by this student
try{
        final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('checkAssignmentSubmit')
            .where('stId', isEqualTo: SchClassConstant.schDoc['id'])
            .where('id', isEqualTo: data!['id'])
            .get();

        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length == 0) {
//upload to database the assignment submitted by the students
          Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
          Constants.courseThumbnail = ref.putFile(
            imageNote,
            SettableMetadata(
              contentType: 'images.pdf',
            ),
          );

          final TaskSnapshot downloadUrl = (await Constants.courseThumbnail!);
          url = await downloadUrl.ref.getDownloadURL();

          //push to database the url
          DocumentReference docRef = FirebaseFirestore.instance.collection('submittedAssignment').doc(SchClassConstant.schDoc['schId']).collection('assignment').doc();
          docRef.set({
            'id': docRef.id,
            'url': url,
            'curs':SchClassConstant.isUniStudent?data['curs']:'',
            'lv': SchClassConstant.schDoc['lv'],
            'cl': SchClassConstant.schDoc['cl'],
            'fn': SchClassConstant.schDoc['fn'],
            'ln': SchClassConstant.schDoc['ln'],
            'schId': SchClassConstant.schDoc['schId'],
            'stId': SchClassConstant.schDoc['id'],
            'tc': data['tc'],
            'aid': data['id'],
            'ts': DateTime.now().toString(),
            'tcId':data['tcId'],
            'title':data['title'],
          });


          //push students that they have submitted this particular assignment
          DocumentReference docRefs = FirebaseFirestore.instance.collection('checkAssignment').doc(SchClassConstant.schDoc['schId']).collection('checkAssignmentSubmit').doc();
          docRefs.set({

            'stId': SchClassConstant.schDoc['id'],
            'id': data['id'],
          });


          //update the replied count

          FirebaseFirestore.instance.collection('teachersAssessment').doc(SchClassConstant.schDoc['schId']).collection('assessments').doc(data['id']).get()
              .then((resultComm) {
            dynamic totalComment = resultComm.data()!['rec'] + 1;

            resultComm.reference.set({
              'rec':totalComment,

            },SetOptions(merge: true));

            setState(() {
              _publishModal = false;
            });
          });


          studentsAnalysis(doc);





          SchClassConstant.displayToastCorrect(title: 'Submitted successfully');


        } else{
          setState(() {
            _publishModal = false;
          });

          SchClassConstant.displayToastError(title: 'You have submitted your assignment');

        }

}catch(e){
  setState(() {
    _publishModal = false;
  });
  SchClassConstant.displayToastError(title: kError);

}

    }else{
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }




  }

  Future<void> studentsAnalysis(DocumentSnapshot doc) async {
    //This collection is to get the students attendant class analysis
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


    FirebaseFirestore.instance.collection('studentActivity').doc(SchClassConstant.schDoc['schId']).collection('sActivity').doc()
        .set({
      'ts':DateTime.now().toString(),
      'ac':true,
      'stId':SchClassConstant.schDoc['id'],
      'schId':SchClassConstant.schDoc['schId'],
      'fn': SchClassConstant.schDoc['fn'],
      'ln':SchClassConstant.schDoc['ln'],
      'cl':SchClassConstant.schDoc['cl'],
      'lv':SchClassConstant.schDoc['lv'],
      'tcId':data['tcId'],
      'tsn':data['tcId'],
      'surl':url,
      'turl':data['url']

    });





  }


}
