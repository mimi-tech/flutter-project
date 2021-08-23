import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/validation.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/school_reg/screens/address_screen.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/school_reg/screens/username_screen.dart';

class CheckCampus extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CheckCampus({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);

  @override
  _CheckCampusState createState() => _CheckCampusState();
}

class _CheckCampusState extends State<CheckCampus> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool userNameVisible = false;
  int? selectedRadio;
  Color radioColor1 = kBlackcolor;
  Color radioColor2 = klistnmber;

  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 1;
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
        child: Column(
          children: <Widget>[
            //ToDo: The arrow for going back
            Logo(),
            //ToDo:company details
            SchoolConstants(
              details: kSchDetails.toUpperCase(),
            ),
            //ToDo:hint text
            HintText(
              hintText: kSchCampus,
            ),

            ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: kFbColor,
                    onChanged: (dynamic val) {
                      setSelectedRadio(val);

                      setState(() {
                        radioColor1 = kWhitecolor;
                        radioColor2 = kHintColor;
                      });
                    },
                  ),
                  Text(
                    'Yes, school is a campus',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: radioColor1,
                        fontSize: kFontsize.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Radio(
                  value: 2,
                  groupValue: selectedRadio,
                  activeColor: kFbColor,
                  onChanged: (dynamic val) {
                    setSelectedRadio(val);

                    setState(() {
                      radioColor2 = kWhitecolor;
                      radioColor1 = kHintColor;
                    });
                  },
                ),
                Text(
                  "No,school isn't a campus",
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: radioColor2,
                      fontSize: kFontsize.sp,
                    ),
                  ),
                ),
              ])
            ]),

            //ToDo:Enter Company username

            //ToDo:Next Button
            Indicator(
              nextBtn: () {
                goToNext();
              },
              percent: 0.2,
            ),
          ],
        ),
      ),
    )));
  }

  void goToNext() {
    if (selectedRadio == 1) {
      Constants.isCampus = true;
    } else {
      Constants.isCampus = false;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SchoolUserName()));
  }
}
