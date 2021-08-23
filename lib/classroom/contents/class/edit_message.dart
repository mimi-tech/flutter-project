import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/class/class_content_post.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_appbar.dart';

import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditExpertMessage extends StatefulWidget {
  @override
  _EditExpertMessageState createState() => _EditExpertMessageState();
}

class _EditExpertMessageState extends State<EditExpertMessage> {
  TextEditingController _congratulationMessage = TextEditingController();
  TextEditingController _message = TextEditingController();
  String get filePaths => 'ExpertVideos/${DateTime.now()}';

  String get fileImagePaths => 'ExpertAttachment/${DateTime.now()}';
  String? promoThumb;
  String? promoVideo;
  List<String> _amount = [
    'Free',
    '10.99',
    '19.99',
    '49.99',
    '50.99'
  ]; // Option 2
  String? _selectedAmount; // Option 2
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  late UploadTask uploadTask;
  bool _publishModal = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _congratulationMessage.text = ExpertEditConstants.cong!;
    _message.text = ExpertEditConstants.welcome!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ExpertAppBar(),
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        spacer(),

                        spacer(),
                        ExpertTitle(
                          title: kClassAmt,
                        ),
                        spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlineButton(
                              onPressed: () {},
                              child: Text('USD',
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kBlackcolor,
                                      fontSize: kFontsize.sp,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(30),
                            ),
                            Container(
                              child: DropdownButton(
                                hint: Text(ExpertEditConstants.amount!,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlackcolor,
                                        fontSize: kFontsize.sp,
                                      ),
                                    )), // Not necessary for Option 1
                                value: _selectedAmount,
                                onChanged: (dynamic newValue) {
                                  setState(() {
                                    _selectedAmount = newValue;
                                  });
                                },
                                items: _amount.map((amount) {
                                  return DropdownMenuItem(
                                    child: Text(amount,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kBlackcolor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        )),
                                    value: amount,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),

                        ///welcome message

                        spacer(),

                        ExpertTitle(
                          title: kExpertWelcome,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _message,
                            maxLength: 200,
                            maxLines: null,
                            style: UploadVariables.uploadfontsize,
                            decoration: ExpertConstants.keyDecoration,
                            onChanged: (String value) {
                              ExpertConstants.welcome = value;
                            },
                          ),
                        ),
                        spacer(),

                        ///Congratulatory message

                        spacer(),

                        ExpertTitle(
                          title: kExpertCongratulatory,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _congratulationMessage,
                            maxLength: 200,
                            maxLines: null,
                            style: UploadVariables.uploadfontsize,
                            decoration: ExpertConstants.keyDecoration,
                            onChanged: (String value) {
                              ExpertConstants.cong = value;
                            },
                          ),
                        ),
                        spacer(),
                        Container(
                          height: ScreenUtil().setHeight(50),
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: RaisedButton(
                              onPressed: () {
                                nextPage();
                              },
                              color: kExpertColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                kUpdate,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kWhitecolor,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              )),
                        ),
                        spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  Future<void> nextPage() async {
    if ((_message == null) || (_message.text.length == 0)) {
      Fluttertoast.showToast(
          msg: kExpertWelcome,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((_congratulationMessage == null) ||
        (_congratulationMessage.text.length == 0)) {
      Fluttertoast.showToast(
          msg: kExpertCongratulatory,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      setState(() {
        ExpertConstants.amount = _selectedAmount;
      });

      /*update database*/

      try {
        setState(() {
          _publishModal = true;
        });

        if ((ExpertConstants.videoFile != null) &&
            (ExpertConstants.imageFile != null)) {
          /*uploading the promotional thumbnail*/
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          uploadTask = ref.putFile(
            ExpertConstants.imageFile!,
            SettableMetadata(
              contentType: 'image/jpg',
            ),
          );

          final TaskSnapshot downloadUrl = await uploadTask;
          promoThumb = await downloadUrl.ref.getDownloadURL();

          /*uploading the promotional video*/

          Reference videoRef = FirebaseStorage.instance.ref().child(filePaths);
          uploadTask = videoRef.putFile(
            ExpertConstants.videoFile!,
            SettableMetadata(
              contentType: 'video.mp4',
            ),
          );

          final TaskSnapshot downloadVideoUrl = await uploadTask;
          promoVideo = await downloadVideoUrl.ref.getDownloadURL();

          uploading();
        } else if (ExpertConstants.imageFile != null) {
          /*if user did not change the thumbnail*/
          /*uploading the promotional thumbnail*/
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          uploadTask = ref.putFile(
            ExpertConstants.imageFile!,
            SettableMetadata(
              contentType: 'image/jpg',
            ),
          );

          final TaskSnapshot downloadUrl = await uploadTask;
          promoThumb = await downloadUrl.ref.getDownloadURL();

          uploading();
        } else if (ExpertConstants.videoFile != null) {
          /*if user did not change the video*/
          /*uploading the promotional video*/
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          uploadTask = ref.putFile(
            ExpertConstants.imageFile!,
            SettableMetadata(
              contentType: 'image/jpg',
            ),
          );

          final TaskSnapshot downloadUrl = await uploadTask;
          promoThumb = await downloadUrl.ref.getDownloadURL();

          uploading();
        } else {
          uploading();
        }
      } catch (e) {
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }

  uploading() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection("sessionContent")
        .doc(currentUser.uid)
        .collection('classes')
        .doc(ExpertEditConstants.docId)
        .update({
      'pdesc': ExpertEditConstants.purpose,
      'topic': ExpertEditConstants.topic,
      'sub': ExpertEditConstants.subTopic,
      'desc': ExpertEditConstants.description,
      'name': ExpertEditConstants.name,
      'req': FieldValue.arrayUnion(ExpertConstants.requirementItems),
      'lang': FieldValue.arrayUnion(ExpertConstants.language),
      'tmb': promoThumb ?? ExpertEditConstants.tmb,
      'prom': promoVideo ?? ExpertEditConstants.promoVideo,
      'note': ExpertEditConstants.note ?? ExpertConstants.note,
      'amt': ExpertEditConstants.amount,
      'cong': ExpertEditConstants.cong,
      'wel': ExpertEditConstants.welcome,
      'age': UploadVariables.ageRestriction,
      'age2': UploadVariables.childrenAdult,
    }).whenComplete(() => {
              setState(() {
                _publishModal = false;
                ExpertConstants.requirementItems.clear();
                ExpertConstants.language.clear();
              }),
              Fluttertoast.showToast(
                  msg: kError,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: kBlackcolor,
                  textColor: kSsprogresscompleted),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ClassContentPost()))
            });
  }
}
