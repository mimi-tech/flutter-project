import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/sliverAppbarCampus.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/verify_new_admin.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:timeago/timeago.dart' as timeago;
class SchoolAddShowAdmin extends StatefulWidget {
  @override
  _SchoolAddShowAdminState createState() => _SchoolAddShowAdminState();
}

class _SchoolAddShowAdminState extends State<SchoolAddShowAdmin> {
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: StuAppBar(),

          body: CustomScrollView(slivers: <Widget>[
            ProprietorActivityAppBar(
            activitiesColor: kTextColor,
            classColor: kStabcolor1,
            newsColor: kTextColor,
            studiesColor: kTextColor,
          ),
          HighSchoolSliverAppBar(
            campusBgColor: Colors.transparent,
            campusColor: klistnmber,
            deptBgColor: Colors.transparent,
            deptColor: klistnmber,
            recordsBgColor: klistnmber,
            recordsColor: kWhitecolor,
            sectionBgColor: Colors.transparent,
            sectionColor: klistnmber,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collectionGroup('classSchAdmin').where('schId',isEqualTo:  SchClassConstant.schDoc['schId']).orderBy('ts',descending: true).

          snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: ProgressIndicatorState(),
              );
            } else if (!snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  space(),
                  Center(child: Text(kAdminAdd,
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      color: kFbColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )

                  ),

                  space(),
                  SchClassConstant.schDoc['id'] == GlobalVariables.loggedInUserObject.id? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                        border: Border.all(color: kExpertColor,width: 2.0)                ),

                      alignment:Alignment.topCenter,
                      child: IconButton(icon: Icon(Icons.add,color: kExpertColor,size: 30,), onPressed: (){_addAdmin();})):Text(''),
                  space(),

                ],
              );
            } else {
              final List<Map<String, dynamic>> workingDocuments =
              snapshot.data!.docs as List<Map<String, dynamic>>;

              //final List<DocumentSnapshot> workingDocuments = snapshot.data.documents;

              return Column(
                children: <Widget>[
                  space(),
                  SchClassConstant.schDoc['id'] == GlobalVariables.loggedInUserObject.id? Align(
                    alignment:Alignment.topRight,

                    child: Container(

                        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kExpertColor,width: 2.0)
                        ),

            child: IconButton(icon: Icon(Icons.add,color: kExpertColor,size: 30,), onPressed: (){_addAdmin();})),
                  ):Text(''),
                  space(),
                  Text('List of your school admins'.toUpperCase(),
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kBlackcolor,
                        fontSize: 20.sp,
                      ),
                    ),

                  ),
                  space(),

                  ListView.builder(
          itemCount: workingDocuments.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, int index) {
            return Card(
              elevation: 10,
              child:Column(
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
                            image: ('${workingDocuments[index]['pix']}'
                                .toString()),
                            placeholder: 'images/classroom/user.png',),
                        ),

                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(workingDocuments[index]['fn'].toString(),
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kBlackcolor,
                                fontSize: kFontsize.sp,
                              ),
                            ),

                          ),
                          Text(workingDocuments[index]['ln'].toString(),
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

                      Text(workingDocuments[index]['ky'].toString(),
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
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(workingDocuments[index]['onl']==true?'Online':'Offline',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: workingDocuments[index]['onl']==true?kAGreen:kRed,
                                    fontSize: kFontSize14.sp,
                                  ),
                                )),

                            Text(workingDocuments[index]['onl']==true?'${timeago.format(DateTime.parse(workingDocuments[index]['ol']), locale: 'en_short')} ago':

                            '${timeago.format(DateTime.parse(workingDocuments[index]['off']), locale: 'en_short')} ago',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kIconColor,
                                    fontSize: kFontSize14.sp,
                                  ),
                                )),

                            Text('online count: ${workingDocuments[index]['olc'].toString()}',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kIconColor,
                                    fontSize: kFontSize14.sp,
                                  ),
                                )),



                          ],
                        ) ,

                        VerticalDivider(),

                        SchClassConstant.schDoc['id'] == GlobalVariables.loggedInUserObject.id?
                        BtnThird(next: (){_removeAdmin(workingDocuments,index);}, title: 'Remove', bgColor: kRed):Text(''),
                      ],
                    ),
                  ),

                ],
              )
            );
          })
                ],
              );
            }
          })
          ])
          ),
        ]),
      ),
    );
  }

  void _addAdmin() {

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return VerifyNewSchoolAdmin();
        });
  }

  void _removeAdmin(List<Map<String, dynamic>> workingDocuments, int index) {
    //remove Admin
    try{

    FirebaseFirestore.instance.collection('classroomAdmins').doc(workingDocuments[index]['schId']).collection('classSchAdmin').doc(workingDocuments[index]['did'])

        .delete();

  }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }
}
