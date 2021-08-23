import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class ClassRequirementList extends StatefulWidget {
  @override
  _ClassRequirementListState createState() => _ClassRequirementListState();
}

class _ClassRequirementListState extends State<ClassRequirementList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? classReq;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Visibility(
            visible: ExpertConstants.requirementItems.isEmpty ? false : true,
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: ExpertConstants.requirementItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Text('.'),
                      title: Text(
                        ExpertConstants.requirementItems[index]!,
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
                                  context,
                                  ExpertConstants.requirementItems[index],
                                  index);
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 30),
                                child: Icon(Icons.delete_forever,
                                    color: kFbColor)),
                          ),
                          GestureDetector(
                            onTap: () async {
                              editText(
                                  context,
                                  ExpertConstants.requirementItems[index],
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
      ExpertConstants.requirementItems.removeAt(index);
    });
  }

  void editText(BuildContext context, String? item, int index) {
    setState(() {
      classReq = item;
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        //controller: _target,
                        maxLength: 100,
                        maxLines: null,
                        autocorrect: true,
                        autofocus: true,
                        initialValue: classReq,
                        cursorColor: (kMaincolor),
                        style: UploadVariables.uploadfontsize,
                        decoration: ExpertConstants.kClassReqDecoration,
                        onSaved: (String? value) {
                          classReq = value;
                        },
                        onChanged: (String value) {
                          classReq = value;
                        },
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
                              ExpertConstants.requirementItems.removeAt(index);
                              ExpertConstants.requirementItems
                                  .insert(index, classReq);

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
