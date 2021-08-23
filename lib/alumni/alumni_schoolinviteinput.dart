import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/alumni/alumniEntry.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/alumni/strings.dart';
import 'package:sparks/global_services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'color/colors.dart';

class SchoolInviteInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SchoolInviteInputState();
  }
}

class _SchoolInviteInputState extends State<SchoolInviteInput> {
  final CallService? _service = locator<CallService>();
  TextEditingController alumniSchoolEmail = TextEditingController();

  bool showSpinner = false;

  void notifyMySchool() {
    //TODO:validate input data
    if (alumniSchoolEmail.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else {
      //TODO: send to database

      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('notifyMySchool')
          .doc(SchoolStorage.schoolId);
      documentReference.set({
        'uid': SchoolStorage.userId,
        'id': documentReference.id,
        'schId': SchoolStorage.schoolId,
        'schName': SchoolStorage.schoolName,
        'schMail': alumniSchoolEmail.text,
        'time': DateTime.now()
      });

      setState(() {
        showSpinner = false;
      });
      //TODO: display a toast and redirect to school page
      Fluttertoast.showToast(
          msg: "REQUEST SENT",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.white);
      Navigator.push(context,
          PageTransition(type: PageTransitionType.scale, child: School()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0))),
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: School()));
            },
            child: Icon(Icons.arrow_back)),
        backgroundColor: kADarkRed,
        title: Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.13,
          ),
          child: Text(
            kAppBarSparksUniverseRequest,
            style: TextStyle(
              color: kAWhite,
              fontFamily: "Rajdhani",
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
              elevation: 5.0,
              color: kAWhite,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.98,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: TextFormField(
                          controller: alumniSchoolEmail,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: kABlack,
                            )),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kABlack,
                              ),
                            ),
                            hintText: kAppBarEnterSchoolEmail,
                            hintStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            elevation: 15.0,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.34,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        kAppBarHelloAdmin_iAmAndreLyonStudent_AlumniOfHavArdUniversity_PleaseKindlyCreateAnAccountWithSparksUniverse,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Rajdhani",
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        kAppBarSparksUniverseEnablesAdministration_EngagementOfSchools_InstitutionsWithTheirStudent_Alumni,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: kAOrangeGreen,
                                          fontFamily: "Rajdhani",
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            child: SvgPicture.asset(
                                                "images/alumni/google-playbadge.svg"),
                                          ),
                                          Container(
                                            child: SvgPicture.asset(
                                                "images/alumni/app-storeapple.svg"),
                                          ),
                                          Container(
                                            child: SvgPicture.asset(
                                                "images/alumni/web-storeweb.svg"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      child: RaisedButton(
                        elevation: 15,
                        onPressed: () {
                          if (alumniSchoolEmail.text == '') {
                            Fluttertoast.showToast(
                                msg: "Email required",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                textColor: Colors.white);
                          } else {
                            //TODO: send to database
                            try {
                              _service!.sendEmail(alumniSchoolEmail.text);
                            } catch (err) {
                              print("not working");
                              print(err);
                            }
                          }
                        },
                        color: kADeepOrange,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Opn mail",
                                style: TextStyle(
                                    color: kAWhite,
                                    fontFamily: "Rajdhani",
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CallService {
  void sendEmail(String email) => launch("mailto:$email");
}
