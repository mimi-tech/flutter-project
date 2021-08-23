import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/companyDataProvider.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class CompanyAccessPage extends StatefulWidget {
  @override
  _CompanyAccessPageState createState() => _CompanyAccessPageState();
}

class _CompanyAccessPageState extends State<CompanyAccessPage> {
  TextEditingController companyUsername = TextEditingController();
  TextEditingController companyPin = TextEditingController();

  String? encryptedCompanyPin;

  //Todo: Verify company verification
  void verifyCompanyCredentials(CompanyAccessTest pagePin) async {
    //Todo: encrypt company pin to match the one in the database
    final encryptedCompanyPin =
        CompanyEncryption.encryptAes(companyPin.text).base64;

    final encryptedPin =
        CompanyEncryption.decryptAES("6aD1Ta5MhYWhRK4Ynogsiw==");
    print("hello pin");
    print(encryptedPin);

    //Todo: check if credentials exist and is a  match
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('company')
        .where('un', isEqualTo: companyUsername.text)
        .where('cpin', isEqualTo: encryptedCompanyPin)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    print(documents.length);

    if (documents.length == 1) {
      for (var data in documents) {
        Map<String, dynamic> data2 = data.data() as Map<String, dynamic>;
        //Todo: check if user already have access to company account already
        final QuerySnapshot hasCompanyAccount = await FirebaseFirestore.instance
            .collection('managedCompanyAccounts')
            .doc(UserStorage.loggedInUser.uid)
            .collection('companyAccounts')
            .where('un', isEqualTo: data2['un'])
            .get();
        final List<DocumentSnapshot> hasCompanyAccountDocuments =
            hasCompanyAccount.docs;

        //Todo: get expire datetime from database
        DateTime expiringDate = DateTime.parse(data2['ex']);

        //Todo: get current datetime
        final now = DateTime.now();

        final timeCheck = now.day - expiringDate.day;
        print("timeCheck");
        print(timeCheck);

        //Todo: check if pin has expired time check was 2
        if (hasCompanyAccountDocuments.length == 0) {
          if (timeCheck > 4) {
            ReusableFunctions.showToastMessage2(
                "Pin expired. Pleas contact the company for a new pin",
                Colors.white,
                Colors.red);
          } else {
            //Todo: else send all document to managedCompanyAccount Collection(loggedUid, viewStatus,companyName, Companyid)
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection('managedCompanyAccounts')
                .doc(UserStorage.loggedInUser.uid)
                .collection('companyAccounts')
                .doc();
            documentReference.set({
              'id': documentReference.id,
              'uac': UserStorage.loggedInUser.uid,
              'vs': true,
              'adr': data2['adr'],
              'city': data2['city'],
              'comp_id': data2['comp_id'],
              'cty': data2['cty'],
              'date': data2['date'],
              'em': data2['em'],
              'ex': data2['ex'],
              'logo': data2['logo'],
              'name': data2['name'],
              'ph': data2['ph'],
              'st': data2['st'],
              'str': data2['str'],
              'tk': data2['tk'],
              'un': data2['un'],
              'ugc': data2['id'],
              'ts': DateTime.now()
            });

            //Todo: also send details to companyAccountManagers ( uid of accessing company, uid of granting company, companyId, email, currentLoggeduser.
            DocumentReference companyAccountManagers = FirebaseFirestore
                .instance
                .collection('companyAccountManagers')
                .doc(data2['id'])
                .collection('companyManagers')
                .doc();
            companyAccountManagers.set({
              'id': documentReference.id,
              'uac': UserStorage.loggedInUser.uid,
              'dn_ac': UserStorage.loggedInUser.displayName,
              'lac': UserStorage.loggedInUser.photoURL,
              'ugc': data2['id'],
              'comp_id': data2['comp_id'],
              'vs': true,
              'ts': DateTime.now()
            });
            //Todo: for deleting, delete document in managedCompanyAccounts collection where uac comp_id match companyAccountManagers
            ReusableFunctions.showToastMessage2(
                "Account Added Successfully", Colors.white, Colors.black);
          }
        } else {
          ReusableFunctions.showToastMessage2(
              "Oops something went wrong", Colors.white, Colors.red);
        }
      }
    } else {
      pagePin.updateCounter1();
      ReusableFunctions.showToastMessage2(
          "Incorrect Credentials", Colors.white, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagePin = Provider.of<CompanyAccessTest>(context);
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        "images/jobs/bag.svg",
                        height: ScreenUtil().setHeight(20.0),
                        width: ScreenUtil().setWidth(20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Enter Company Credentials',
                          style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          "Enter Company Username",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: kComp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rajdhani',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 20.0),
                      child: Container(
                        child: TextFormField(
                          controller: companyUsername,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              hintText: "Enter Company Username",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: kShade,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          "Enter Company Pin",
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: kComp),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 20.0),
                      child: Container(
                        child: TextField(
                          obscureText: true,
                          controller: companyPin,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              hintText: "****",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: kShade,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (pagePin.falseCredentials > 2) {
                        pagePin.updateCounter2();
                        if (pagePin.perClick == 1) {
                          pagePin.updatePinAccess();
                          ReusableFunctions.showToastMessage2(
                              "Maximum Trial Exceeded try again in the next 20 seconds",
                              Colors.white,
                              Colors.red);
                        } else {
                          ReusableFunctions.showToastMessage2(
                              "Maximum Trial Exceeded",
                              Colors.white,
                              Colors.red);
                        }
                      } else {
                        verifyCompanyCredentials(pagePin);
                      }
                    },
                    color: kLight_orange,
                    textColor: Colors.white,
                    child: pagePin.checkPinTrial
                        ? Text("Disabled")
                        : Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
