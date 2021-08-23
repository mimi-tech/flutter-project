import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class FadeHeading extends StatelessWidget {
  FadeHeading({this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 20.0,
        ),
        child: Text(
          title!,
          style: TextStyle(
            fontSize: kFontsize.sp,
            color: kMaincolor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rajdhani',
          ),
        ),
      ),
    );
  }
}

class TargetItemsList extends StatefulWidget {
  @override
  _TargetItemsListState createState() => _TargetItemsListState();
}

class _TargetItemsListState extends State<TargetItemsList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Visibility(
            visible: TargetedStudents.items.isEmpty ? false : true,
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: TargetedStudents.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Text('.'),
                      title: Text(
                        TargetedStudents.items[index]!,
                        style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kFontsize.sp,
                        )),
                      ),
                      trailing: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              deleteText(context, TargetedStudents.items[index],
                                  index);
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 30),
                                child: Icon(Icons.delete_forever,
                                    color: kFbColor)),
                          ),
                          GestureDetector(
                            onTap: () async {
                              editText(context, TargetedStudents.items[index],
                                  index);
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 30),
                                width: 30,
                                height: 30,
                                child: Icon(Icons.edit, color: klistnmber)),
                          ),
                        ],
                      ));
                }),
          ),
        ),
      ],
    );
  }

  void deleteText(BuildContext context, String? item, int index) {
    setState(() {
      TargetedStudents.items.removeAt(index);
    });
  }

  void editText(BuildContext context, String? item, int index) {
    setState(() {
      Constants.courseEdit = item;
    });

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  Text(
                    'Edit Text',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kFbColor,
                      fontSize: kFontsize.sp,
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: TextFormField(
                        //controller: _target,
                        maxLength: 100,
                        maxLines: null,
                        autocorrect: true,
                        autofocus: true,
                        initialValue: Constants.courseEdit,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kCourseTargetDecoration,
                        onSaved: (String? value) {
                          Constants.courseTarget = value;
                        },
                        onChanged: (String value) {
                          Constants.courseTarget = value;
                        },
                        validator: Validator.validateDesc,
                      ),
                    ),
                  ),

                  //TODO:Edit icon
                  Center(
                    child: RaisedButton(
                        color: kPreviewcolor,
                        onPressed: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            setState(() {
                              TargetedStudents.items.removeAt(index);
                              TargetedStudents.items
                                  .insert(index, Constants.courseTarget);

                              Navigator.pop(context);
                            });
                          } else {
                            print('No not validated');
                          }
                        },
                        child: Text('Edit',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                                fontSize: kFontsize.sp,
                              ),
                            ))),
                  )
                ]));
  }
}

//students learning objectives
class ObjectiveList extends StatefulWidget {
  @override
  _ObjectiveListState createState() => _ObjectiveListState();
}

class _ObjectiveListState extends State<ObjectiveList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Visibility(
            visible: Objective.items.isEmpty ? false : true,
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: Objective.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Text('.'),
                      title: Text(
                        Objective.items[index]!,
                        style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kFontsize.sp,
                        )),
                      ),
                      trailing: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              deleteText(
                                  context, Objective.items[index], index);
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 30),
                                child: Icon(Icons.delete_forever,
                                    color: kFbColor)),
                          ),
                          GestureDetector(
                            onTap: () async {
                              editText(context, Objective.items[index], index);
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 30),
                                width: 30,
                                height: 30,
                                child: Icon(Icons.edit, color: klistnmber)),
                          ),
                        ],
                      ));
                }),
          ),
        ),
      ],
    );
  }

  void deleteText(BuildContext context, String? item, int index) {
    setState(() {
      Objective.items.removeAt(index);
    });
  }

  void editText(BuildContext context, String? item, int index) {
    setState(() {
      Constants.courseEdit = item;
    });

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  Text(
                    'Edit Text',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kFbColor,
                      fontSize: kFontsize.sp,
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: TextFormField(
                        //controller: _target,
                        maxLength: 100,
                        maxLines: null,
                        autocorrect: true,
                        autofocus: true,
                        initialValue: Constants.courseEdit,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kCourseTargetDecoration,
                        onSaved: (String? value) {
                          Constants.courseTarget = value;
                        },
                        onChanged: (String value) {
                          Constants.courseTarget = value;
                        },
                        validator: Validator.validateDesc,
                      ),
                    ),
                  ),

                  //TODO:Edit icon
                  Center(
                    child: RaisedButton(
                        color: kPreviewcolor,
                        onPressed: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            setState(() {
                              Objective.items.removeAt(index);
                              Objective.items
                                  .insert(index, Constants.courseTarget);

                              Navigator.pop(context);
                            });
                          } else {
                            print('No not validated');
                          }
                        },
                        child: Text('Edit',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                                fontSize: kFontsize.sp,
                              ),
                            ))),
                  )
                ]));
  }
}
