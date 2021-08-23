import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenNine.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class CreateProfessionalScreenEight extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenEight({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenEightState createState() =>
      _CreateProfessionalScreenEightState();
}

class _CreateProfessionalScreenEightState
    extends State<CreateProfessionalScreenEight> {
  String? hobbies;
  int _count = ProfessionalStorage.hobbies.length;
  final TextEditingController _hobbyController = TextEditingController();

  final TextEditingController _hobbyControllerEdit = TextEditingController();

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

  void _addHobbyRow() {
    if (_hobbyController.text == '') {
      Fluttertoast.showToast(
          msg: "hobby required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(ReusableFunctions.capitalizeWords(_hobbyController.text),
          ProfessionalStorage.hobbies);
      hobbies = null;
      _hobbyController.clear();
    }
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _hobbyController.dispose();
    _hobbyControllerEdit.dispose();

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
                  hintText: "List your hobbies below",
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
                            "Hobbies",
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
                              i < ProfessionalStorage.hobbies.length;
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
                                          "${i + 1}. ${ProfessionalStorage.hobbies[i]} ",
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
                                              _hobbyControllerEdit.text =
                                                  ProfessionalStorage
                                                      .hobbies[i];
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
                                                                          _hobbyControllerEdit,
                                                                      labelText:
                                                                          "Enter your hobbies",
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
                                                                          if (_hobbyControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "field is empty",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              ProfessionalStorage.hobbies[i] = _hobbyControllerEdit.text;
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
                                                                      "${i + 1}.${ProfessionalStorage.hobbies[i]} ",
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
                                                                            ProfessionalStorage.hobbies.remove(ProfessionalStorage.hobbies[i]);
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
                        controller: _hobbyController,
                        labelText: "Enter your hobby",
                        hintText: "swimming",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addHobbyRow();
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
                  percent: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    if (ProfessionalStorage.hobbies.isEmpty) {
      Fluttertoast.showToast(
          msg: "hobby is required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      print(ProfessionalStorage.hobbies);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateProfessionalScreenNine()));
    }
  }
}
