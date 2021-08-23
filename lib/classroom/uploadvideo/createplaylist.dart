import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/contactscreen.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/playlistappbar.dart';
import 'package:sparks/classroom/uploadvideo/widgets/playlistbtn.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/uploadSelectedcontact.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CreatePlayList extends StatefulWidget {
  @override
  _CreatePlayListState createState() => _CreatePlayListState();
}

class _CreatePlayListState extends State<CreatePlayList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool contactVisible = true;
  bool _publishModal = false;
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
    return SafeArea(
      child: Scaffold(
          appBar: PlaylistAppbar(),
          backgroundColor: kWhitecolor,
          body: ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              PlayListBtn(
                  name: kCancel,
                  save: kCreate,
                  create: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PlaylistScreen()));
                  },
                  saved: () {
                    createPlaylist();
                  }),
              SizedBox(
                height: 30.0,
              ),

              //ToDo:Horizontal list displaying all friends selected
              Visibility(
                visible: UploadUfriends.litems.isEmpty ? false : true,
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: UploadUserFriendsSelected()),
              ),
              SizedBox(
                height: 10.0,
              ),

              ///textField for  new playlist name

              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: TextFormField(
                    onSaved: (String? value) {
                      UploadVariables.playlistTitle = value;
                    },
                    onChanged: (String value) {
                      UploadVariables.playlistTitle = value;
                    },
                    cursorColor: klistnmber,
                    validator: Validator.validateTitle,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: kErrorfont.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rajdhani',
                        color: Colors.red,
                      ),
                      hintText: kAddtitle,
                      hintStyle: TextStyle(
                        fontSize: kFontsize.sp,
                        color: kTextcolorhintcolor,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kPlaylistborder)),
                    ),
                  ),
                ),
              ),

              ///create playlist dropdown
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: ScreenUtil().setHeight(60),
                    child: FlatButton(
                      onPressed: () {
                        _showContactContainer();
                      },
                      focusColor: kFbColor,
                      child: Row(
                        children: <Widget>[
                          Text(
                            kVisibilityplist,
                            style: TextStyle(
                              fontSize: kFontsize.sp,
                              color: kTextcolorhintcolor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                            ),
                          ),
                          SizedBox(width: 20.0),

                          ///selected item visibility

                          Text(
                            UploadVariables.playlistVisibility,
                            style: TextStyle(
                              fontSize: kFontsize.sp,
                              color: kBlackcolor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: kBlackcolor,
                            size: 30.0,
                          )
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0),
                          side: BorderSide(color: klistnmber)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
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
                        Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          activeColor: kbtnsecond,
                          onChanged: (dynamic val) {
                            UploadVariables.isChecked = true;
                            setSelectedRadio(val);
                            UploadVariables.pvPrivate = false;
                            UploadVariables.playlistVisibility = "public";
                          },
                        ),

                        /*  CircularCheckBox(inactiveColor: kBlackcolor,
                               activeColor: kbtnsecond,
                               value: UploadVariables.pVPublic, onChanged: (bool value) {
                                 setState(() {
                                   UploadVariables.pVPublic = value;
                                   UploadVariables.pvPrivate = false;
                                   UploadVariables.playlistVisibility = "public";

                                 });
                               }),*/

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
                            UploadVariables.isChecked = true;
                            setSelectedRadio(val);
                            UploadVariables.pvPrivate = false;
                            UploadVariables.playlistVisibility = "public";
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
            ])),
          )),
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
    });
  }

  createPlaylist() async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();

      setState(() {
        _publishModal = true;
      });
      var now = new DateTime.now();
      var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
      User currentUser = FirebaseAuth.instance.currentUser!;

      //Todo: adding file to database

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('sessionplaylists')
          .where('uid', isEqualTo: currentUser.uid)
          .where('name', isEqualTo: UploadVariables.playlistTitle)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 1) {
        Fluttertoast.showToast(
            msg: kSsplaylistnameerror,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
        setState(() {
          _publishModal = false;
        });
      } else {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('sessionplaylists')
            .doc(currentUser.uid)
            .collection('userplaylist')
            .doc();
        documentReference.set({
          'date': date,
          'name': UploadVariables.playlistTitle,
          'visi': UploadVariables.playlistVisibility,
          'uid': currentUser.uid,
          'email': currentUser.email,
          'id': documentReference.id,
          'vido': FieldValue.arrayUnion([]),
          /* playlist contact*/ 'pcont':
              FieldValue.arrayUnion(UploadUfriends.litems)
        });

        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kSsplaylistsuccessful,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);
        setState(() {
          UploadUfriends.litems.clear();
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PlaylistScreen()));
      }
    }
  }

  void showContactlist() {
    if (UploadVariables.pvPrivate == true) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: uploadcontact()));
    }
  }
}
