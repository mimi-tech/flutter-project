import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/save_new_admin.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';


class VerifyNewSchoolAdmin extends StatefulWidget {


  @override
  _VerifyNewSchoolAdminState createState() => _VerifyNewSchoolAdminState();
}

class _VerifyNewSchoolAdminState extends State<VerifyNewSchoolAdmin> {

  final TextEditingController _email =  TextEditingController();
  String? email;
  bool getUser = false;

  String fName = '';
  String lName = '';
  bool progress = false;
  var _documents = <DocumentSnapshot>[];
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  List<dynamic>? name;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: kWhitecolor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(kmodalborderRadius),
              topLeft: Radius.circular(kmodalborderRadius),
            )),
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 400),
          curve: Curves.decelerate,
          child: getUser == true?
          Column(
            children: <Widget>[
              spacer(),
              spacer(),
              Text('Do you want to create \n school admin pin for',
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  fontSize: 22.sp,
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                ),
              ),


              Text('$fName $lName',
                style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kFacebookcolor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              spacer(),
              spacer(),
              progress?Center(child: PlatformCircularProgressIndicator()):Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: klistnmber,
                    onPressed: (){Navigator.pop(context);},
                    child: Text('Cancel',
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kWhitecolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),


                  RaisedButton(
                    color: kFbColor,
                    onPressed: (){
                      saveNewAdmin();
                    },
                    child: Text('Proceed',
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kWhitecolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),
                ],
              ),
              spacer(),
              spacer(),
            ],
          )

              :Column(

            children: <Widget>[
              spacer(),
              spacer(),

              Text('Please enter email of the one you want to give access to your school admin'.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kMaincolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),

              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: null,
                  autocorrect: true,
                  cursorColor: (kMaincolor),
                  style: UploadVariables.uploadfontsize,
                  decoration: Constants.kTopicDecoration,
                  onChanged: (String value) {
                    email = value;
                  },

                ),
              ),


              spacer(),

              progress == true?ProgressIndicatorState():RaisedButton(
                color: kFbColor,
                onPressed: (){showPin();},
                child: Text('Confirm',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kWhitecolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),

              spacer(),
              spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showPin() async {
    print(_email.text.trim());
    if((email == null) || (email == '')){
      Fluttertoast.showToast(
          msg: 'Please put the admin email',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }else{

      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email.text.trim());
      if (emailValid == true) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {
          progress = true;
        });
        try {
          final QuerySnapshot result = await  FirebaseFirestore.instance
              .collectionGroup('Personal')
              .where('em', isEqualTo: _email.text.trim())
              .get();


          final List <DocumentSnapshot> documents = result.docs;
          if (documents.length == 0) {
            setState(() {
              progress = false;
            });
            Fluttertoast.showToast(
                msg: 'sorry user not found',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: kBlackcolor,
                textColor: kFbColor);
          } else {
            for (DocumentSnapshot doc in documents) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              setState(() {
                ExpertAdminConstants.foundUserData = doc;
                fName = data['nm']['fn'];
                lName = data['nm']['ln'];
                progress = false;
                getUser = true;
              });
            }
            setState(() {
              progress = false;
            });
          }
        } catch (e) {
          setState(() {
            progress = false;
          });

          print(e);
          Fluttertoast.showToast(
              msg: kError,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      }else{
        Fluttertoast.showToast(
            msg: 'sorry put your email address correctly',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }

    }
  }

  void saveNewAdmin() {
    final random = Random();
    var r = (random.nextInt(1000000));


    setState(() {
      progress = true;
    });
    try {

      DocumentReference documentReference = FirebaseFirestore
          .instance
          .collection("classroomAdmins").doc(SchClassConstant.schDoc['schId']).collection('classSchAdmin')
          .doc();

      documentReference.set({

        'id': ExpertAdminConstants.foundUserData['id'],
        'fn': ExpertAdminConstants.foundUserData['nm']['fn'],
        'ln': ExpertAdminConstants.foundUserData['nm']['ln'],
        'pix': ExpertAdminConstants.foundUserData['pimg'],
        'email': ExpertAdminConstants.foundUserData['em'],
         'schId':SchClassConstant.schDoc['schId'],
        'ky':r,
        'name': SchClassConstant.schDoc['name'],
        'str': SchClassConstant.schDoc['str'],
        'st': SchClassConstant.schDoc['st'],
        'cty': SchClassConstant.schDoc['cty'],
        'logo': SchClassConstant.schDoc['logo'],
        'camp':SchClassConstant.schDoc['camp'] == true?true:false,
        'did': documentReference.id,
        'ol':'',
        'off':DateTime.now().toString(),
        'onl':false,
        'ts': DateTime.now().toString(),
        'oid':GlobalVariables.loggedInUserObject.id,



      });




      setState(() {
        progress = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: kCreatedSuccessfully,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kSsprogresscompleted);
    } catch (e) {
      setState(() {
        progress = false;
      });
      print(e);
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }



}
