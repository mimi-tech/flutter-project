import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/golive/classroom_contact.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ContactVisibility extends StatefulWidget {
  @override
  _ContactVisibilityState createState() => _ContactVisibilityState();
}

class _ContactVisibilityState extends State<ContactVisibility> {
  bool contactVisible = true;
  int? selectedRadio;
  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ///create playlist dropdown
        Text(
          'Choose Friends',
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
            color: kBlackcolor,
          )),
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          height: ScreenUtil().setHeight(360),
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: klistnmber,
            ),
            borderRadius: BorderRadius.circular(kPlaylistborder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ///public
              Row(
                children: <Widget>[
                  /*CircularCheckBox(inactiveColor: kBlackcolor,
                      activeColor: kbtnsecond,
                      value: UploadVariables.pVPublic, onChanged: (bool value) {
                        setState(() {
                          UploadVariables.pVPublic = value;
                          UploadVariables.pvPrivate = false;
                          UploadVariables.playlistVisibility = "public";

                        });
                      }),*/
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: kbtnsecond,
                    onChanged: (dynamic val) {
                      UploadVariables.isChecked = true;
                      setSelectedRadio(val);
                      UploadVariables.pVPublic = val;
                      UploadVariables.pvPrivate = false;
                      UploadVariables.playlistVisibility = "public";
                    },
                  ),
                  Text(
                    kPublic,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: kBlackcolor,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: kHorizontal,
                ),
                child: Text(
                  kPublichint,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kTextcolorhintcolor,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ),

              ///private

              Row(
                children: <Widget>[
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: kbtnsecond,
                    onChanged: (dynamic val) {
                      setSelectedRadio(val);
                      UploadVariables.pvPrivate = true;
                      UploadVariables.playlistVisibility = "private";
                      UploadVariables.pVPublic = false;
                    },
                  ),

                  /*CircularCheckBox(inactiveColor: kBlackcolor,
                      activeColor: kbtnsecond,
                      value: UploadVariables.pvPrivate, onChanged: (bool value) {
                        setState(() {
                          UploadVariables.pvPrivate = value;
                          UploadVariables.playlistVisibility = "private";
                          UploadVariables.pVPublic = false;
                        });
                      }),*/

                  Text(
                    kPlaylistPrivate,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: kBlackcolor,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Text(
                  kPrivatehint,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kTextcolorhintcolor,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ///select contact btn
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: kHorizontal, vertical: 10.0),
                child: RaisedButton(
                  child: Text(
                    kSelectContact,
                    style: UploadVariables.uploadbtnfontsize,
                  ),
                  onPressed: () {
                    showContactlist();
                  },
                  color: UploadVariables.pvPrivate == false
                      ? kMaincolor
                      : kPreviewcolor,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Text(
                  kcontacthintText,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kTextcolorhintcolor,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: kHorizontal, vertical: 10.0),
                child: RaisedButton(
                  child: Text(
                    kDone,
                    style: UploadVariables.uploadbtnfontsize,
                  ),
                  onPressed: () {
                    _hideContact();
                  },
                  color: kFbColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showContactContainer() {
    setState(() {
      contactVisible = true;
    });
  }

  void _hideContact() {
    setState(() {
      contactVisible = false;
      Navigator.pop(context);
    });
  }

  void showContactlist() {
    if (UploadVariables.pvPrivate == true) {
      Navigator.pop(context);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: ClassroomContact()));
    }
  }
}
