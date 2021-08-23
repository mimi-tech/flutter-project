import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_custom_dialog_tv/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/classroom/golive/classroom_contact.dart';
import 'package:sparks/classroom/uploadvideo/widgets/agedialog.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/uploaduserselection.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

class ContactClass extends StatefulWidget {
  @override
  _ContactsVisibilityState createState() => _ContactsVisibilityState();
}

class _ContactsVisibilityState extends State<ContactClass> {
  int? selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

// Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ///Visibility

        FadeHeading(
          title: kVisibility,
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: kbtnsecond,
                  onChanged: (dynamic val) {
                    UploadVariables.isChecked = true;
                    setSelectedRadio(val);
                    UploadVariables.isPrivate = false;
                    UploadVariables.publicPrivate = "public";
                  },
                ),

                /* CircularCheckBox(inactiveColor: kBlackcolor,
                    activeColor: kbtnsecond,
                    value: UploadVariables.isChecked, onChanged: (bool value) {
                      setState(() {
                        UploadVariables.isChecked = value;
                        UploadVariables.isPrivate = false;
                        UploadVariables.publicPrivate = "public";

                      });
                    }),*/

                Row(
                  children: <Widget>[
                    Container(
                      child: SvgPicture.asset(
                        'images/classroom/world.svg',
                        width: ScreenUtil().setHeight(klivebtn.roundToDouble()),
                        height:
                            ScreenUtil().setHeight(klivebtn.roundToDouble()),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Radio(
                  value: 2,
                  groupValue: selectedRadio,
                  activeColor: kbtnsecond,
                  onChanged: (dynamic val) {
                    UploadVariables.isPrivate = true;
                    setSelectedRadio(val);
                    UploadVariables.publicPrivate = "private";
                    UploadVariables.isChecked = false;
                  },
                ),

                /* CircularCheckBox(inactiveColor: kBlackcolor,
                    activeColor: kbtnsecond,
                    value: UploadVariables.isPrivate, onChanged: (bool value) {
                      setState(() {
                        UploadVariables.isPrivate = value;
                        UploadVariables.publicPrivate = "private";
                        UploadVariables.isChecked = false;

                      });
                    }),
*/
                Row(
                  children: <Widget>[
                    Container(
                      child: SvgPicture.asset(
                        'images/classroom/lock.svg',
                        width: ScreenUtil().setHeight(klivebtn.roundToDouble()),
                        height:
                            ScreenUtil().setHeight(klivebtn.roundToDouble()),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),

                    ///private
                    Text(
                      kPrivate,
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: kBlackcolor,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Text(
                  kPrivatehint,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: kTextcolorhintcolor,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Wrap(
          spacing: 10.0,
          children: <Widget>[
            ///Age limit
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(
                      color: UploadVariables.highlightAgeLimit == true
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2.0)),
              onPressed: () {
                ageLimit();
              },
              child: Text(
                kAge,
                style: UploadVariables.uploadbtnfontsize,
              ),
              color: kbtnsecond,
            ),

            ///contacts
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              onPressed: () {
                _selectContacts();
              },
              child: Wrap(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  Text(
                    kContacts,
                    style: UploadVariables.uploadbtnfontsize,
                  )
                ],
              ),
              color: UploadVariables.isChecked == true
                  ? kMaincolor
                  : kSelectbtncolor,
            ),

            ///view selected
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              onPressed: () {
                userSelection();
              },
              child: Text(
                kViews,
                style: UploadVariables.uploadbtnfontsize,
              ),
              color: UploadVariables.isChecked == true
                  ? kMaincolor
                  : kSelectbtncolor,
            )
          ],
        ),
        Divider(
          color: kAshthumbnailcolor,
          thickness: kThickness,
        ),
      ],
    );
  }

  ///Age limit method
  void ageLimit() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    //height: MediaQuery.of(context).size.height * 0.5,
                    child: AgeDialog(
                      checkAge: () {
                        if ((UploadVariables.ageRestriction == null) ||
                            (UploadVariables.childrenAdult == null)) {
                          Fluttertoast.showToast(
                              msg: kageLimitError,
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: kBlackcolor,
                              textColor: kFbColor);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ]));
  }

  ///user selection contact
  void _selectContacts() {
    if (UploadVariables.isPrivate == true) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ClassroomContact()));
    }
  }

  void userSelection() {
    if ((UploadVariables.isPrivate == true) && (ufriends.litems.isNotEmpty)) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UploadUserSelections()));
    }
  }
}
