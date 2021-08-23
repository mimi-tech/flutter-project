import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/CampusSchool/edit_campus_student.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/edit_students.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';


class NonCampusStudentSearchStream extends StatefulWidget {
  @override
  _NonCampusStudentSearchStreamState createState() => _NonCampusStudentSearchStreamState();
}

class _NonCampusStudentSearchStreamState extends State<NonCampusStudentSearchStream> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  List <dynamic>? aoi;
  List <dynamic>? spec;
  List <dynamic>? hobby;
  List <dynamic>? lang;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {

      SchClassConstant().searchByNonCampusStudentsName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['fn'].startsWith(capitalizedValue)) {

          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kStatusbar,
          title: Text('Search for a student',
            style: GoogleFonts.rajdhani(
              fontSize:kFontsize.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),
        body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                backgroundColor: kWhitecolor,
                automaticallyImplyLeading: false,
                //expandedHeight: 100,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (dynamic val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by first name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([

                    tempSearchStore.length == 0?Text('empty'):
                    ListView.builder(
                        itemCount: tempSearchStore.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {


                          return  Card(
                              elevation: 10,
                              child:Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
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
                                              image: ('images/classroom/user.png'
                                                  .toString()),
                                              placeholder: 'images/classroom/user.png',),
                                          ),

                                        ),

                                        Column(
                                          children: [
                                            Text(tempSearchStore[index]['fn'].toString(),
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: kBlackcolor,
                                                  fontSize: kFontsize.sp,
                                                ),
                                              ),

                                            ),

                                            Text(tempSearchStore[index]['ln'].toString(),
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
                                        tempSearchStore[index]['ass'] == true?RaisedButton(onPressed: (){
                                          _removeStudent(tempSearchStore[index]);
                                        },
                                          color: kFbColor,
                                          child: Text('Denial',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kWhitecolor,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),

                                          ),
                                        ):RaisedButton(onPressed: (){
                                          _acceptStudent(tempSearchStore[index]);
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
                                    ShowRichText(color:kSwitchoffColors,title: 'Username: ',titleText: tempSearchStore[index]['un']),



                                    space(),
                                    ShowRichText(color:kSwitchoffColors,title: 'Pin: ',titleText: tempSearchStore[index]['pin'].toString()),


                                    space(),

                                    ShowRichText(color:kExpertColor,title: 'student Level: ',titleText: tempSearchStore[index]['lv']),


                                    space(),
                                    ShowRichText(color:kExpertColor,title: 'Student class: ',titleText: tempSearchStore[index]['cl']),





                                    space(),
                                    ShowRichText(color:kFbColor,title: 'Added: ',titleText: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(tempSearchStore[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(tempSearchStore[index]['ts']))}'),



                                    space(),
                                    ShowRichText(color:kFbColor,title: 'By: ',titleText: tempSearchStore[index]['by']),

                                    space(),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RaisedButton(onPressed: (){
                                          _deleteStudent(tempSearchStore[index]);
                                        },
                                          color: kRed,
                                          child: Text('Remove',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kWhitecolor,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),

                                          ),
                                        ),

                                        RaisedButton(onPressed: (){
                                          _editStudent(tempSearchStore[index]);
                                        },
                                          color: kWhitecolor,
                                          child: Text('Edit',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kFbColor,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),

                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                          );




                        })])
              )])
    ));
  }


  void _deleteStudent(DocumentSnapshot doc) {
    //remove Admin
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('classroomStudents').doc(data['schId']).collection('students').doc(data['did'])

          .delete();

    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _removeStudent(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('classroomStudents').doc(data['schId']).collection('students').doc(data['did'])
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

      FirebaseFirestore.instance.collection('classroomStudents').doc(data['schId']).collection('students').doc(data['did'])
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
            child: EditStudents(doc:doc)));




  }
}

