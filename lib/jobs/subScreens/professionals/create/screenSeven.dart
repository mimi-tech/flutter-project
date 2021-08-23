import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenEight.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class CreateProfessionalScreenSeven extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenSeven({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenSevenState createState() =>
      _CreateProfessionalScreenSevenState();
}

class _CreateProfessionalScreenSevenState
    extends State<CreateProfessionalScreenSeven> {
  String? skills;
  int _count = ProfessionalStorage.skills.length;
  final TextEditingController _skillController = TextEditingController();

  final TextEditingController _skillControllerEdit = TextEditingController();

  _addData(data, list) {
    setState(() {
      if (data != null) {
        list.add(data);

        _count = _count + 1;
      } else {
        print('what the fuck');
        return null;
      }
    });
  }

  void _addSkillRow() {
    if (_skillController.text == '') {
      Fluttertoast.showToast(
          msg: "skill required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(ReusableFunctions.capitalizeWords(_skillController.text),
          ProfessionalStorage.skills);
      skills = null;
      _skillController.clear();
    }
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _skillController.dispose();
    _skillControllerEdit.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/company/sparksbg.png'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Logo(),
              //ToDo:company details
              SchoolConstants(
                  details:
                      "You are doing great ${GlobalVariables.loggedInUserObject.nm!["fn"]}"),

              //ToDo:hint text

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "List your skills below",
                ),
              ),

              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Icon(
                                Icons.build,
                                color: kLight_orange,
                                size: 30.0,
                              ),
                            ),
                          ),
                          Text(
                            "Skills",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(25.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                      child: Column(
                        children: <Widget>[
                          for (var i = 0;
                              i < ProfessionalStorage.skills.length;
                              i++)
                            Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "${i + 1}. ${ProfessionalStorage.skills[i]} ",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _skillControllerEdit.text =
                                                  ProfessionalStorage.skills[i];
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      SimpleDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          elevation: 8,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _skillControllerEdit,
                                                                      labelText:
                                                                          "Enter your skill",
                                                                      hintText:
                                                                          "Programming",
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          ///validate for empty data.
                                                                          if (_skillControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "field is empty",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              ProfessionalStorage.skills[i] = _skillControllerEdit.text;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              15.0,
                                                                              20.0,
                                                                              20.0,
                                                                              00.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                "Ok",
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.rajdhani(
                                                                                  textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              15.0,
                                                                              20.0,
                                                                              20.0,
                                                                              00.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                "Cancel",
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.rajdhani(
                                                                                  textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ]));
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.edit,
                                                color: kLight_orange,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      SimpleDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          elevation: 8,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      'Are You Sure You Want To Delete',
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                ScreenUtil().setSp(18.0),
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.red),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      "${i + 1}.${ProfessionalStorage.skills[i]} ",
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            ProfessionalStorage.skills.remove(ProfessionalStorage.skills[i]);
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              15.0,
                                                                              20.0,
                                                                              20.0,
                                                                              00.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                "YES",
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.rajdhani(
                                                                                  textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              15.0,
                                                                              20.0,
                                                                              20.0,
                                                                              00.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                "Cancel",
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.rajdhani(
                                                                                  textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ]));
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.delete,
                                                color: kLight_orange,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _skillController,
                        labelText: "Enter your skill",
                        hintText: "Programming",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addSkillRow();
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(100.0),
                            width: ScreenUtil().setWidth(100),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/jobs/add.png"),
                                //fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //ToDo: Company btn
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
                child: Indicator(
                  nextBtn: () {
                    goToNext();
                  },
                  percent: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    if (ProfessionalStorage.skills.isEmpty) {
      Fluttertoast.showToast(
          msg: "skill is required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      print(ProfessionalStorage.skills);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateProfessionalScreenEight()));
    }
  }
}
