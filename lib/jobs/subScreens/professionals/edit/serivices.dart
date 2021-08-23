import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class EditServices extends StatefulWidget {
  @override
  _EditServicesState createState() => _EditServicesState();
}

class _EditServicesState extends State<EditServices> {
  final TextEditingController _serviceTitleController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();

  final TextEditingController _serviceTitleControllerEdit =
      TextEditingController();
  final TextEditingController _serviceDescriptionControllerEdit =
      TextEditingController();

  String? name;
  List<dynamic>? listServices = [];

  void _addService() {
    //TODO: validate user input
    if (_serviceTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_serviceDescriptionController.text == '') {
      Fluttertoast.showToast(
          msg: "description field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var services = {
        "title":
            ReusableFunctions.capitalizeWords(_serviceTitleController.text),
        "description": _serviceDescriptionController.text,
      };

      setState(() {
        //TODO: add the object to the list
        ProfessionalStorage.services.add(services);
        listServices!.add(services);
        //TODO: clear the content of the text controllers
        services = {};
        _serviceTitleController.clear();
        _serviceDescriptionController.clear();
      });
    }
  }

  bool showSpinner = false;
  void validateAndUpdate() {
    if (listServices!.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please add at least one service",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('professionals')
          .doc(EditProfessionalStorage.id);
      documentReference.update({
        "services": listServices,
      });
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(
          msg: "Services updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listServices = EditProfessionalStorage.services;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.account_circle,
                          color: kLight_orange,
                          size: 40.0,
                        ),
                      ),
                      Text(
                        "Services",
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(18.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                for (var i = 0; i < listServices!.length; i++)
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "images/jobs/bullet.svg",
                                          color: Colors.red,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${i + 1} ${listServices!.elementAt(i)['title']}",
                                              softWrap: true,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(15.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
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
                                                                      listServices!
                                                                          .elementAt(
                                                                              i)['title'],
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
                                                                            listServices!.remove(listServices!.elementAt(i));
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
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _serviceTitleControllerEdit.text =
                                                  listServices!
                                                      .elementAt(i)['title'];
                                              _serviceDescriptionControllerEdit
                                                      .text =
                                                  listServices!.elementAt(
                                                      i)['description'];
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
                                                              child:
                                                                  ResumeInput(
                                                                controller:
                                                                    _serviceTitleControllerEdit,
                                                                labelText:
                                                                    "Enter Service Title",
                                                                hintText:
                                                                    "Programmer",
                                                              ),
                                                            ),
                                                            Container(
                                                              child:
                                                                  ResumeInput(
                                                                controller:
                                                                    _serviceDescriptionControllerEdit,
                                                                labelText:
                                                                    "write about what you do",
                                                                hintText:
                                                                    "I love writing code",
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    ///validate for empty data.
                                                                    if (EditProfessionalStorage
                                                                        .services!
                                                                        .isEmpty) {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Please add at least one service",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          textColor:
                                                                              Colors.white);
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        listServices!
                                                                            .elementAt(
                                                                                i)['title'] = _serviceTitleControllerEdit
                                                                            .text;
                                                                        listServices!
                                                                            .elementAt(
                                                                                i)['description'] = _serviceDescriptionControllerEdit
                                                                            .text;
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            15.0,
                                                                            20.0,
                                                                            20.0,
                                                                            00.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    height: ScreenUtil()
                                                                        .setHeight(
                                                                            40.0),
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          "Ok",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.rajdhani(
                                                                            textStyle: TextStyle(
                                                                                fontSize: ScreenUtil().setSp(18),
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            15.0,
                                                                            20.0,
                                                                            20.0,
                                                                            00.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    height: ScreenUtil()
                                                                        .setHeight(
                                                                            40.0),
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          "Cancel",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.rajdhani(
                                                                            textStyle: TextStyle(
                                                                                fontSize: ScreenUtil().setSp(18),
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "images/jobs/bullet.svg",
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ReadMoreText(
                                              listServices!
                                                  .elementAt(i)['description'],
                                              trimLines: 6,
                                              colorClickableText: kLight_orange,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText:
                                                  ' ...Show more',
                                              trimExpandedText: ' ...Show less',
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(14.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Add Services",
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
                  child: ResumeInput(
                    controller: _serviceTitleController,
                    labelText: "Enter Service Title",
                    hintText: "Programmer",
                  ),
                ),
                Container(
                  child: ResumeInput(
                    controller: _serviceDescriptionController,
                    labelText: "write about what you do",
                    hintText: "I love writing code",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _addService();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RaisedButton(
                        onPressed: () {
                          validateAndUpdate();
                        },
                        color: kLight_orange,
                        textColor: Colors.white,
                        child: Text("save"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
