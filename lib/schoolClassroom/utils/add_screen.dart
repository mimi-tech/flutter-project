import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_tab.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_interface.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_screen.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/techers-tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/access_denied.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';

class AddSchoolScreen extends StatefulWidget {
  @override
  _AddSchoolScreenState createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: progress,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BtnWhiteTextColor(next: (){}, title:kNotify, bgColor: kWhitecolor),

                  BtnBorder(next: (){_addSchool();}, title:kAddSchool, bgColor: kWhitecolor),


                ],
              ),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('schoolIdentity').where('uid',isEqualTo: GlobalVariables.loggedInUserObject.id).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return PlatformCircularProgressIndicator();
                  }else {

                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;

                    return data.length == 0 ?

                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 5,
                        child: Center(
                          child: Text('No school added, please add your school',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: kBlackcolor,
                              fontSize:kFontsize.sp,
                            ),
                          ),
                        ),
                      ),
                    )
                        :Column(
                      children: [
                        ListView.builder(
                         itemCount: data.length,
                           shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                  //height: MediaQuery.of(context).size.height * 0.3,
                                  width: MediaQuery.of(context).size.width,
                                  child: GestureDetector(
                                    onTap:(){_getUserIdentity(data, index);},
                                    child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(

                                        children: [
                                          Align(
                                            alignment:Alignment.topRight,
                                              child:IconButton(icon: Icon(Icons.cancel,color: kRed,size: 30,), onPressed: (){_deleteMe(data, index);})
                                          ),


                                          Center(
                                        child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 32,
                                        child: ClipOval(
                                        child: CachedNetworkImage(

                                        imageUrl: data[index]['logo'],
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        width: 40.0,
                                        height: 40.0,

                                        ),
                                        ),
                                        ),
                                      ),

                                          Text(data[index]['name'],
                                          style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: kBlackcolor,
                                          fontSize:kFontsize.sp,
                                          ),
                                          ),

                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.center,
                                            children: [

                                              Icon(Icons.location_on,color: kBlackcolor,),
                                              Flexible(child: Text(data[index]['str'],
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: kBlackcolor,
                                                    fontSize:kFontsize.sp,
                                                  ),
                                                )
                                              ))
                                            ],
                                          ),

                                          Text('${data[index]['st']}, ${data[index]['cty']}',
                                               style: GoogleFonts.rajdhani(
                                               textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: kBlackcolor,
                                              fontSize:kFontsize.sp,
                                            ),
                                          ),),

                                          Text(data[index]['cl'],
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: kExpertColor,
                                                fontSize:kFontsize.sp,
                                              ),
                                            ),),

                                          Text(data[index]['lv'],
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: kExpertColor,
                                                fontSize:kFontsize.sp,
                                              ),
                                            ),)

                                        ],
                                      ),
                                    ),
                                    ),
                                  ),
                                  ),
                                )
                                  ],
                                );
                              }),

                        Btn(next: (){},title: 'Access',bgColor: kSelectbtncolor,)
                      ],
                    );
                  }
                }
              ),


            ],
          ),
        ),
      ),
    );
  }

  void _addSchool() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return SchoolAdminInterface();
        });


  }

  Future<void> _getUserIdentity(List<QueryDocumentSnapshot> data, int index) async {
///check if user is the school owner


  if(data[index]['isP']){

    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').doc(GlobalVariables.loggedInUserObject.id).collection('schoolUsers')
          .where('id', isEqualTo: data[index]['uid'])
          .where('schId', isEqualTo: data[index]['schId'])
          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 1) {
        for( DocumentSnapshot doc in documents){
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          setState(() {
            progress = false;
            SchClassConstant.schDoc = doc;
            SchClassConstant.isProprietor = true;
          });
          Navigator.pop(context);
          //check if user school is campus or not
          if(data['camp'] == true){
            //it is  a campus
            setState(() {
              SchClassConstant.isCampusProprietor = true;

            });
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));
          }else {
            setState(() {
              SchClassConstant.isHighSchProprietor = true;
            });
            //move the proprietor to high school page
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));
          }
        }

      }else{
        setState(() {
          progress = false;
        });

        SchClassConstant.displayToastError(title: kSchoolUnDenied);
      }

    }catch(e){
      setState(() {
        progress = false;
      });
      SchClassConstant.displayToastError(title: kSchoolUnDenied);

    }





    ///check if user is a teacher

  }else if(data[index]['isT']){


    setState(() {
      progress = true;
    });
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('schoolTeachers')
          .where('pin', isEqualTo: data[index]['pin'])
          .orderBy('ts')
          .get();

      final List < DocumentSnapshot > documents = result.docs;
//check if teacher has access


      if (documents.length == 1) {
        for( DocumentSnapshot doc in documents){
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          setState(() {
            progress = false;
            SchClassConstant.schDoc = doc;
            SchClassConstant.isTeacher = true;
            SchClassConstant.teachersListItems.add(data);
          });
          if(data['ass'] == true){
            Navigator.pop(context);
            //change the isTeacher bool
            isTeacher = true;
            //move the teacher to school teachers page

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));

            //get login time and set online true for this teacher
            getOnlineTeacherHighSchool(doc);

          }else{
            setState(() {
              progress = false;
            });
//teacher does not have an access
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccessDenied()));

            SchClassConstant.displayToastError(title: kSchoolUnDenied);
          }
        }
      }else {
        //check if tutor is from campus
        getTutor(data,index);
      }


    }catch(e){
      setState(() {
        progress = false;
      });
      //Navigator.pop(context);
      print(e);
      SchClassConstant.displayToastError(title: kError);

    }


    ///check if its an admin

  }else if(data[index]['isAd']){

    setState(() {
      progress = true;
    });
    //check if proprietor  username and uid matches
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('classSchAdmin') .orderBy('ts')
          .where('ky', isEqualTo: data[index]['ky'])
          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 1) {
        for( DocumentSnapshot doc in documents){
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          setState(() {
            progress = false;
            SchClassConstant.schDoc = doc;
            SchClassConstant.isProprietor = true;
            SchClassConstant.isAdmin = true;
          });
          Navigator.pop(context);

          //check if user school is campus or not
          if(data['camp'] == true){
            //it is  a campus
            setState(() {
              SchClassConstant.isCampusProprietor = true;

            });

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));
            getOnlineTeacherCampusAdmin(doc);
          }else {
            setState(() {
              SchClassConstant.isHighSchProprietor = true;
            });
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));
            getOnlineTeacherCampusAdmin(doc);
          }
        }

      }else{
        setState(() {
          progress = false;
        });

        SchClassConstant.displayToastError(title: kSchoolUnDenied);
      }

    }catch(e){
      print(e);
      setState(() {
        progress = false;
      });

      SchClassConstant.displayToastError(title: kSchoolUnDenied);

    }



    ///check if user is a student

  }else if(data[index]['isSt']){

    setState(() {
      progress = true;
    });

    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('students')
          .where('un', isEqualTo: data[index]['un'])
          .where('pin', isEqualTo: data[index]['pin'])

      //.orderBy('ts')
          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 1) {
        //check if student has access

        for( DocumentSnapshot doc in documents) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data['ass'] == true) {
            setState(() {
              progress = false;
              SchClassConstant.schDoc = doc;
              SchClassConstant.isStudent = true;
            });
            Navigator.pop(context);
            //move the student to student tab (high school)
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CampusPostScreen()));
            //get login time and set online true for this student
            getOnlineHighStudentCampus(doc);
          } else {
            Navigator.pop(context);
            setState(() {
              progress = false;
            });
            //student does not have an access
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AccessDenied()));
          }
        }
      }else{
        //its a university students
        getUniversityStudent(data, index);
      }


    }catch(e){
      setState(() {
        progress = false;
      });
      //Navigator.pop(context);
      print(e);
      SchClassConstant.displayToastError(title: kError);

    }


  }else{
    SchClassConstant.displayToastError(title: 'Sorry please add your school');
  }
  }

  Future<void> getTutor(List<QueryDocumentSnapshot> data, int index) async {

    try {
        final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('tutors')
            .where('pin', isEqualTo: data[index]['pin'])
            .orderBy('ts')
            .get();

        final List <DocumentSnapshot> documents = result.docs;
//check if teacher has access


        if (documents.length == 1) {
          for (DocumentSnapshot doc in documents) {
            setState(() {
              progress = false;
              SchClassConstant.schDoc = doc;
              SchClassConstant.isTeacher = true;
              SchClassConstant.isLecturer = true;
              SchClassConstant.teachersListItems.add(data);

            });

            //check if tutor has access
            if(documents[0]['ass'] == true){
              isTeacher = true;
              Navigator.pop(context);
              //move the teacher to school admin page
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));
              //get login time and set online true for this teacher
              getOnlineTeacherCampus(doc);
            }else{
              setState(() {
                progress = false;
              });
              //teacher does not have an access
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccessDenied()));

              SchClassConstant.displayToastError(title: kSchoolUnDenied);
            }

          }
        }else{

          setState(() {
            progress = false;
          });
          //No tutor found
          SchClassConstant.displayToastError(title: 'incorrect pin');

        }

      }catch(e){
        setState(() {
          progress = false;
        });
        SchClassConstant.displayToastError(title: kError);

      }
    }

  Future<void> getUniversityStudent(List<QueryDocumentSnapshot> data, int index) async {

      try{
        final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('campusStudents')
            .where('un', isEqualTo: data[index]['un'])
            .where('pin', isEqualTo: data[index]['pin'])
            .get();

        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length == 1) {
          //check if student has access

          for( DocumentSnapshot doc in documents) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            if (data['ass'] == true) {


              setState(() {
                progress = false;
                SchClassConstant.schDoc = doc;
                SchClassConstant.isStudent = true;
                SchClassConstant.isUniStudent = true;
              });
              Navigator.pop(context);
              //move the proprietor to school admin page
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CampusPostScreen()));

              //get login time and set online true for this student
              getOnlineStudentCampus(doc);
            } else {
              Navigator.pop(context);
              setState(() {
                progress = false;
              });
              //student does not have an access
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AccessDenied()));
            }
          }
        }else{
          setState(() {
            progress = false;
          });
          SchClassConstant.displayToastError(title: 'Access Denied');
        }


      }catch(e){
        setState(() {
          progress = false;
        });
        SchClassConstant.displayToastError(title: kError);

      }
    }

  void _deleteMe(List<QueryDocumentSnapshot> data, int index) {
    FirebaseFirestore.instance.collection('schoolIdentity').doc(data[index]['id']).delete();
  }

  void getOnlineTeacherCampus(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('schoolTutors')
        .doc(doc['schId']).collection('tutors')
        .doc(doc['id'])
        .get().then((value) {
      value.reference.set({
      'ol':DateTime.now().toString(),
      //'off':'',
      'onl':true,
      'olc':value.data()!['olc'] == null?1:value.data()!['olc'] + 1

    },SetOptions(merge: true));
  });}


  void getOnlineTeacherHighSchool(DocumentSnapshot doc) {


    //get teacher frequent login count

    FirebaseFirestore.instance.collection('teachers').doc(doc['schId'])
        .collection('schoolTeachers').doc(doc['id'])
        .get().then((value) {
      value.reference.set({
      'ol':DateTime.now().toString(),
      //'off':'',
      'onl':true,
        'olc':value.data()!['olc'] == null?1:value.data()!['olc'] + 1

      },SetOptions(merge: true));
    });

  }





  void getOnlineHighStudentCampus(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('classroomStudents')
        .doc(doc['schId']).collection('students').doc(doc['id'])
        .get().then((value) {
      value.reference.set({
        'ol': DateTime.now().toString(),
        //'off': '',
        'onl': true,
        'olc':value.data()!['olc'] == null?1:value.data()!['olc'] + 1
      }, SetOptions(merge: true));
    });
  }

  void getOnlineStudentCampus(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('uniStudents')
        .doc(doc['schId']).collection('campusStudents').doc(doc['id'])
        .get().then((value) {
      value.reference.set({
      'ol':DateTime.now().toString(),
     // 'off':'',
      'onl':true,
        'olc':value.data()!['olc'] == null?1:value.data()!['olc'] + 1
    },SetOptions(merge: true));
  });



  }

  void getOnlineTeacherCampusAdmin(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('classroomAdmins')
        .doc(doc['schId']).collection('classSchAdmin').doc(doc['id'])
        .get().then((value) {
      value.reference.set({
        'ol':DateTime.now().toString(),
       // 'off':'',
        'onl':true,
        'olc':value.data()!['olc'] == null?1:value.data()!['olc'] + 1

      },SetOptions(merge: true));
    });

  }}


