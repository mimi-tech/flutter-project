import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/contents/class/edit_class_thumbnail.dart';

import 'package:sparks/classroom/contents/class/edit_expert_appbar.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';
import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_age.dart';
import 'package:sparks/classroom/courses/dialog_btn.dart';
import 'package:sparks/classroom/expert_class/expert_constants/class_language_list.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_btn.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';
import 'package:sparks/classroom/expert_class/expert_constants/requirement_list.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditClassDetails extends StatefulWidget {
  @override
  _EditClassDetailsState createState() => _EditClassDetailsState();
}

class _EditClassDetailsState extends State<EditClassDetails> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  TextEditingController _job = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _requirement = TextEditingController();
  TextEditingController _topic = TextEditingController();
  TextEditingController _subTopic = TextEditingController();
  TextEditingController _description = TextEditingController();
  String? classReq;
  var itemsData = [];
  var _documents = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() {
    try {
      FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(UploadVariables.currentUser)
          .collection('classes')
          .where('id', isEqualTo: ExpertEditConstants.docId)
          .get()
          .then((value) {
        value.docs.forEach((result) {
          setState(() {
            _documents.add(result);
            itemsData.add(result.data());

            ///Next Screen

            List<String> lang = List.from(result.data()['lang']);
            ExpertConstants.language.addAll(lang);

            List<String> req = List.from(result.data()['req']);
            ExpertConstants.requirementItems.addAll(req);

            ExpertEditConstants.purpose = (result.data()['pdesc']);
            ExpertEditConstants.note = (result.data()['note']);
            ExpertEditConstants.topic = (result.data()['topic']);
            ExpertEditConstants.subTopic = (result.data()['sub']);
            ExpertEditConstants.description = (result.data()['desc']);
            ExpertEditConstants.name = (result.data()['name']);
            ExpertEditConstants.tmb = (result.data()['tmb']);
            ExpertEditConstants.promoVideo = (result.data()['prom']);

            ExpertEditConstants.amount = (result.data()['amt']);
            ExpertEditConstants.cong = (result.data()['cong']);
            ExpertEditConstants.welcome = (result.data()['wel']);

            /*setting it into text controller*/

            _job.text = ExpertEditConstants.purpose!;
            _name.text = ExpertEditConstants.name!;
            _topic.text = ExpertEditConstants.topic!;
            _subTopic.text = ExpertEditConstants.subTopic!;
            _description.text = ExpertEditConstants.description!;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ExpertConstants.requirementItems.clear();
    ExpertConstants.language.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: EditExpertAppBar(
              detailsColor: kFbColor,
              videoColor: kBlackcolor,
            ),
            body: _documents.isEmpty
                ? ProgressIndicatorState()
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        spacer(),
                        ExpertTitle(
                          title: kSJobProfileDesc,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _job,
                            maxLines: null,
                            style: UploadVariables.uploadfontsize,
                            decoration: ExpertConstants.keyDecoration,
                            onChanged: (String value) {
                              ExpertConstants.job = value;
                            },
                          ),
                        ),

                        spacer(),

                        ExpertTitle(
                          title: kClassName,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _name,
                            maxLines: null,
                            style: UploadVariables.uploadfontsize,
                            decoration: ExpertConstants.keyDecoration,
                            onChanged: (String value) {
                              ExpertConstants.name = value;
                            },
                          ),
                        ),

                        ///class topic

                        spacer(),

                        ExpertTitle(
                          title: kClassTopic,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _topic,
                            maxLines: null,
                            style: UploadVariables.uploadfontsize,
                            decoration: ExpertConstants.keyDecoration,
                            onChanged: (String value) {
                              ExpertConstants.topic = value;
                            },
                          ),
                        ),
                        spacer(),

                        ///class sub topic

                        spacer(),

                        ExpertTitle(
                          title: kClassSubTopic,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _subTopic,
                            maxLines: null,
                            style: UploadVariables.uploadfontsize,
                            decoration: ExpertConstants.keyDecoration,
                            onChanged: (String value) {
                              ExpertConstants.subTopic = value;
                            },
                          ),
                        ),
                        spacer(),

                        ///class Description

                        spacer(),

                        ExpertTitle(
                          title: kClassDesc,
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _description,
                            maxLines: null,
                            style: UploadVariables.uploadfontsize,
                            decoration: ExpertConstants.keyDecoration,
                            onChanged: (String value) {
                              ExpertConstants.description = value;
                            },
                          ),
                        ),
                        spacer(),

                        ///Course Requirements
                        SizedBox(
                            height: ScreenUtil().setHeight(kSCourseHeight)),

                        ExpertTitle(
                          title: kSCourseRequirement,
                        ),
                        ClassRequirementList(),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: TextField(
                            controller: _requirement,
                            maxLines: null,
                            autocorrect: true,
                            cursorColor: (kMaincolor),
                            style: UploadVariables.uploadfontsize,
                            decoration: InputDecoration(
                                hintText: 'Add class requirement',
                                suffixIcon: AddIcon(
                                  iconFunction: () {
                                    _addRequirement();
                                  },
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kAshthumbnailcolor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kAshthumbnailcolor))),
                            onChanged: (String value) {
                              classReq = value;
                            },
                          ),
                        ),

                        ///class language
                        SizedBox(
                            height: ScreenUtil().setHeight(kSCourseHeight)),

                        ExpertTitle(
                          title: kClassLanguage,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: Container(
                            width: double.infinity,
                            //height: ScreenUtil().setHeight(100),
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              onPressed: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                _showLang();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(kSCourseLang2,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kTextcolorhintcolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          )),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(10)),
                                      SvgPicture.asset(
                                        'images/classroom/edit_add.svg',
                                        color: kMaincolor,
                                      ),
                                    ],
                                  ),
                                  ExpertConstants.language.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                              ExpertConstants.language.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(ExpertConstants
                                                  .language[index]),
                                              trailing: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      ExpertConstants.language
                                                          .removeAt(index);
                                                    });
                                                  },
                                                  child: Icon(Icons.cancel)),
                                            );
                                          })
                                      : Text(''),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: ScreenUtil().setHeight(kSCourseHeight)),

                        CourseAge(),

                        ///Add icon and done button
                        SizedBox(
                            height: ScreenUtil().setHeight(kSCourseHeight)),

                        ExpertBtn(
                          next: () {
                            nextPage();
                          },
                          bgColor: kExpertColor,
                        ),

                        SizedBox(
                            height: ScreenUtil().setHeight(kSCourseHeight)),
                      ],
                    ),
                  )));
  }

  void _addRequirement() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if ((classReq != '') && (classReq != null)) {
      setState(() {
        ExpertConstants.requirementItems.add(classReq);
        _requirement.clear();
        classReq = null;
      });
    }
  }

  void nextPage() {
    if ((_job == null) || (_job.text.length == 0)) {
      Fluttertoast.showToast(
          msg: kJobText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((_name == null) || (_name.text.length == 0)) {
      Fluttertoast.showToast(
          msg: kNameText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((_topic == null) || (_topic.text.length == 0)) {
      Fluttertoast.showToast(
          msg: kTopicText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((_subTopic == null) || (_subTopic.text.length == 0)) {
      Fluttertoast.showToast(
          msg: kSubTopicText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((_description == null) || (_description.text.length == 0)) {
      Fluttertoast.showToast(
          msg: kSubDescText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (ExpertConstants.requirementItems.isEmpty) {
      Fluttertoast.showToast(
          msg: kClassReqText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (ExpertConstants.language.isEmpty) {
      Fluttertoast.showToast(
          msg: kClassLanguage,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((UploadVariables.ageRestriction == null) &&
        (UploadVariables.childrenAdult == null)) {
      Fluttertoast.showToast(
          msg: kAgeError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.topToBottom,
              child: EditExpertThumbnail()));
    }
  }

  void _showLang() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        content: Column(
          children: <Widget>[
            DialogBtn(
              context: context,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
              child: TextField(
                  onChanged: (String value) {
                    Constants.searchText = value;
                  },
                  cursorColor: kMaincolor,
                  controller: Constants.searchController,
                  decoration: Constants.searchDecoration),
            ),
            Expanded(child: ClassLanguageList()),
          ],
        ),
      ),
    );
  }
}
