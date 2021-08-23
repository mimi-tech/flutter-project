import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/classroom/contents/edit_appbar_second.dart';

import 'package:sparks/classroom/contents/live/edit_btn.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/live/edit_btn_published.dart';
import 'package:sparks/classroom/contents/live/published.dart';
import 'package:sparks/classroom/golive/classroom_custom_listview.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/classroom/uploadvideo/widgets/agedialog.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/classroom/uploadvideo/widgets/visibility.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditPublishedPost extends StatefulWidget {
  @override
  _EditPublishedPostState createState() => _EditPublishedPostState();
}

class _EditPublishedPostState extends State<EditPublishedPost> {
  File? image;
  late UploadTask uploadTask;
  String get filePath => 'sessionThumbnails/${DateTime.now()}';

  Future getImageFromGallery() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File file = await FilePicker.getFile(
    //   type: FileType.image,
    // );

    late File file;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    String _path = file.toString();

    String fileName = _path.split('/').last;

    // send to fireBase storage
    int fileSize = file.lengthSync();
    if (fileSize <= kSFileSize) {
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      uploadTask = ref.putFile(
          image!,
          SettableMetadata(
            contentType: "image/jpeg",
          ));

      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();
      UploadVariables.cThumbnail = url;
      setState(() {
        image = image;
      });
    }
  }

  String? title;
  String? description;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool _publishModal = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ufriends.litems.clear();
    // Timer.periodic(Duration(seconds: 1), (Timer t) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: EditAppBarSecond(
            title: kSPublishedTutorialEdit,
          ),
          body: ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Column(children: <Widget>[
                        SizedBox(width: ScreenUtil().setWidth(editContent)),
                        GestureDetector(
                          onTap: () {
                            getImageFromGallery();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                klivethumbnailtitle,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: kFontsize.sp,
                                    color: kAshmainthumbnailcolor,
                                  ),
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(10)),
                              SvgPicture.asset('images/classroom/edit_add.svg'),
                            ],
                          ),
                        )
                      ])),
                  Divider(
                    color: kAshthumbnailcolor,
                    thickness: kThickness,
                  ),

                  InkWell(
                    onTap: () {
                      getImageFromGallery();
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: UploadVariables.cThumbnail!,
                    ),
                  ),
//Displaying the contacts selected
                  Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: UserFriendsSelected()),

                  PublishedEditButton(
                    ageLimit: () {
                      _showDialog();
                    },
                    contacts: () {
                      _showContact();
                    },
                  ),

                  //  display the text class
                  EditText(
                    title: kliveformtitle,
                  ),

                  // display the form

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (String? value) {
                              title = value;
                            },
                            onChanged: (String value) {
                              title = value;
                            },
                            initialValue: UploadVariables.cTitle,
                            cursorColor: kMaincolor,
                            validator: Validator.validateTitle,
                            decoration: UploadVariables.editContentDecoration,
                          ),
                          EditText(
                            title: kliveformdesc,
                          ),
                          TextFormField(
                            onSaved: (String? value) {
                              description = value;
                            },
                            onChanged: (String value) {
                              description = value;
                            },
                            cursorColor: kMaincolor,
                            initialValue: UploadVariables.cDesc,
                            validator: Validator.validateTitle,
                            decoration: UploadVariables.editContentDecoration,
                          ),
                        ],
                      ),
                    ),
                  ),
// save button
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: ScreenUtil().setHeight(45.0),
                    width: ScreenUtil().setWidth(140.0),
                    child: RaisedButton(
                      onPressed: () {
                        _updateContent();
                      },
                      color: kFbColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        kSave,
                        style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold,
                          textStyle: TextStyle(
                            fontSize: 22.sp,
                            color: kWhitecolor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  AgeDialog(
                    checkAge: () {
                      Navigator.pop(context);
                    },
                  ),
                ]));
  }

//showing contact
  void _showContact() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  ContactVisibility(),
                ]));
  }

  Future<void> _updateContent() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      setState(() {
        _publishModal = true;
      });
      User currentUser = FirebaseAuth.instance.currentUser!;

      try {
        await FirebaseFirestore.instance
            .collection('sessionContent')
            .doc(currentUser.uid)
            .collection('publishedLive')
            .doc(UploadVariables.cDocumentId)
            .update({
          'tmb': UploadVariables.cThumbnail,
          'alimit': UploadVariables.childrenAdult ?? UploadVariables.cLimit,
          'age': UploadVariables.ageRestriction ?? UploadVariables.cAge,
          'title': title ?? UploadVariables.cTitle,
          'desc': description ?? UploadVariables.cDesc,
          'visi': UploadVariables.playlistVisibility,
        });
        if (ufriends.litems.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('sessionContent')
              .doc(currentUser.uid)
              .collection('publishedLive')
              .doc(UploadVariables.cDocumentId)
              .collection('contacts')
              .doc(UploadVariables.cDocumentId)
              .update({"scont": FieldValue.arrayUnion(ufriends.litems)});
          setState(() {
            ufriends.litems.clear();
            _publishModal = false;
          });
          Fluttertoast.showToast(
              msg: 'Updated successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kSsprogresscompleted);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PublishedLive()));
        } else {
          setState(() {
            ufriends.litems.clear();
            _publishModal = false;
          });
          Fluttertoast.showToast(
              msg: 'Updated successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kSsprogresscompleted);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PublishedLive()));
        }
      } catch (e) {
        print('Error is: $e');
        setState(() {
          _publishModal = false;
        });
      }
      form.save();
    }
  }
}
