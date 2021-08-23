import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentsActivitiesTab.dart';
import 'package:sparks/schoolClassroom/CampusSchool/add_campus_students.dart';
import 'package:sparks/schoolClassroom/CampusSchool/edit_campus_student.dart';
import 'package:sparks/schoolClassroom/CampusSchool/search_by_deptment.dart';
import 'package:sparks/schoolClassroom/CampusSchool/studentsReport.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:sparks/schoolClassroom/SchoolAdmin/sliverAppbarCampus.dart';
import 'package:sparks/schoolClassroom/campus_searchAppbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';

class CampusStudentsScreen extends StatefulWidget {
  @override
  _CampusStudentsScreenState createState() => _CampusStudentsScreenState();
}

class _CampusStudentsScreenState extends State<CampusStudentsScreen> {
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }

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

    getDepartments();

    FirebaseFirestore.instance.collectionGroup('campusStudents').where('schId',isEqualTo:  SchClassConstant.schDoc['schId']).orderBy('ts',descending: true)

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
  List<dynamic> levelSorted = <dynamic>[];
  List<Widget> getLevel(){

    List<Widget> list =  <Widget>[];
    for(var i = 0; i < levelSorted.length; i++){
      Widget w =  Padding(padding: EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusSearchByDepartment(level:levelSorted[i])));
            Navigator.pop(context);
          },
          child: Text(levelSorted[i].toString(),
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
                fontSize: kFontSize14.sp,
              ),
            ),

          ),
        ),
      );
      list.add(w);
    }
    return list;
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

            body: CustomScrollView(
                slivers: <Widget>[
                  ProprietorActivityAppBar(
                    activitiesColor: kTextColor,
                    classColor: kStabcolor1,
                    newsColor: kTextColor,
                    studiesColor: kTextColor,
                  ),
                  CampusSliverAppBar(
                    campusBgColor: Colors.transparent,
                    campusColor: klistnmber,
                    deptBgColor: Colors.transparent,
                    deptColor: klistnmber,
                    recordsBgColor: klistnmber,
                    recordsColor: kWhitecolor,
                    adminsBgColor: Colors.transparent,
                    adminsColor: klistnmber,
                  ),

            CampusStudentSearchAppBar(
            filter:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getLevel(),
            ),
      click: (){_addNewStudent();},
            ),
            SliverList(
            delegate: SliverChildListDelegate([
             Container(
                  child: Column(
                      children: [


                        space(),
                        Text('List of your school students'.toUpperCase(),
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),

                        ),
                        space(),
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
                                      return  Card(
                                          elevation: 10,
                                          child:Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: Colors.transparent,
                                                      child: ClipOval(
                                                        child: FadeInImage.assetNetwork(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          fit: BoxFit.cover,
                                                          image: ('images/classroom/user.png'.toString()),
                                                          placeholder: 'images/classroom/user.png',),
                                                      ),

                                                    ),

                                                    Column(
                                                      children: [
                                                        Text(data['fn'].toString(),
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: kBlackcolor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),

                                                        Text(data['ln'].toString(),
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: kBlackcolor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    data['ass'] == true?RaisedButton(onPressed: (){
                                                      _removeStudent(doc);
                                                    },
                                                      color: kLightGreen,
                                                      child: Text(kDenied,
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: kWhitecolor,
                                                            fontSize: kFontsize.sp,
                                                          ),
                                                        ),

                                                      ),
                                                    ):RaisedButton(onPressed: (){
                                                      _acceptStudent(doc);
                                                    },
                                                      color: kFbColor,
                                                      child: Text('Accept',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: kWhitecolor,
                                                            fontSize: kFontsize.sp,
                                                          ),
                                                        ),

                                                      ),
                                                    )

                                                  ],
                                                ),
                                                Divider(),

                                                ///username
                                                ShowRichText(color:kSwitchoffColors,title: 'Username: ',titleText: data['un']),



                                                space(),
                                                ShowRichText(color:kSwitchoffColors,title: 'Pin: ',titleText: data['pin'].toString()),


                                                space(),

                                                ShowRichText(color:kIconColor,title: 'student Level: ',titleText: data['lv']),


                                                space(),
                                                ShowRichText(color:kIconColor,title: 'Student department: ',titleText: data['dept']),

                                                space(),
                                                ShowRichText(color:kIconColor,title: 'Student faculty: ',titleText: data['fac']),




                                                space(),
                                                ShowRichText(color:kIconColor,title: 'Added: ',titleText: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(data['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(data['ts']))}'),



                                                space(),
                                                ShowRichText(color:kIconColor,title: 'By: ',titleText: data['by']),

                                                space(),
                                                Divider(),

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [
                                                    Text(data['onl']==true?'Online':'Offline',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: data['onl']==true?kAGreen:kRed,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        )),

                                                    Text(data['onl']==true?'${timeago.format(DateTime.parse(data['ol']), locale: 'en_short')} ago':'${timeago.format(DateTime.parse(data['off']), locale: 'en_short')} ago',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: kIconColor,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        )),

                                                    Text('online count: ${data['olc'].toString()}',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: kIconColor,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        )),


                                                  ],
                                                ) ,
                                                space(),
                                                Divider(),

                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap:(){
                                                          _deleteStudent(doc);
                                                        },
                                                        child: Text('Remove',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kExpertColor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),
                                                      ),

                                                      VerticalDivider(),

                                                      GestureDetector(
                                                        onTap:(){
                                                          _reportStudent(doc);
                                                        },
                                                        child: Text('Report',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kExpertColor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),
                                                      ),

                                                      VerticalDivider(),

                                                      GestureDetector(
                                                        onTap:(){
                                                          _editStudent(doc);
                                                        },
                                                        child: Text('Edit',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kExpertColor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),
                                                      ),

                                                      VerticalDivider(),
                                                      GestureDetector(
                                                        onTap:(){
                                                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentActivitiesTab(doc:doc)));
                                                        },
                                                        child: Text('Activities',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kExpertColor,
                                                              fontSize: kFontsize.sp,
                                                            ),
                                                          ),

                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                )



                                              ],
                                            ),
                                          )
                                      );
                                    }).toList()


                                );


                              }
                            }),

                        _isFinish == false ?
                        isLoading == true ? Center(
                            child: PlatformCircularProgressIndicator()) : Text('')

                            : Text(''),
                      ])
              ),
            ]))

    ]),
          ),
        ));
  }

  void _addNewStudent() {
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AddCampusNewStudents()));

  }

  void _deleteStudent(DocumentSnapshot doc) {
    //remove Admin
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('uniStudents').doc(data['schId']).collection('campusStudents').doc(data['did'])

          .delete();

    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _removeStudent(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('uniStudents').doc(data['schId']).collection('campusStudents').doc(data['did'])
          .update({
        'ass':false,
      });
    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _acceptStudent(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('uniStudents').doc(data['schId']).collection('campusStudents').doc(data['did'])
          .update({
        'ass':true,
      });
    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _editStudent(DocumentSnapshot doc) {

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: EditCampusStudents(doc:doc)));




  }

  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await   FirebaseFirestore.instance.collectionGroup('campusStudents').where('schId',isEqualTo:  SchClassConstant.schDoc['schId']).orderBy('ts',descending: true)

            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await   FirebaseFirestore.instance.collectionGroup('campusStudents').where('schId',isEqualTo:  SchClassConstant.schDoc['schId']).orderBy('ts',descending: true)

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

  Future<void> getDepartments() async {

    try{
    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('deptList').where('schId',isEqualTo: SchClassConstant.schDoc['schId']).orderBy('ts',descending: true)
        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length != 0) {
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        setState(() {
          levelSorted.addAll(data!['dept']);

        });
        print(levelSorted);
    }}else{
    }
  }catch(e){
      print(e);
    }
  }

  void _reportStudent(DocumentSnapshot doc) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return SchoolStudentReport(doc:doc);
        });



  }
}
