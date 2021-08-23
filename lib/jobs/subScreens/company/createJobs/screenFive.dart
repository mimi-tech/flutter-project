import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/company/createJobs/screenSix.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class CreateJobsScreenFive extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateJobsScreenFive({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateJobsScreenFiveState createState() => _CreateJobsScreenFiveState();
}

class _CreateJobsScreenFiveState extends State<CreateJobsScreenFive> {
  var _skillsController = TextEditingController();

  String? skills;
  int _count = PostJobFormStorage.skills!.length;
  _addData(data, list) {
    setState(() {
      if (data != null) {
        list.add(data);

        _count = _count + 1;
      } else {
        Fluttertoast.showToast(
            msg: "Please fill the empty space",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
  }

  void _addSkillRow() {
    if (_skillsController.text == '') {
      Fluttertoast.showToast(
          msg: "Skill is required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(_skillsController.text, PostJobFormStorage.skills);
      skills = null;

      _skillsController.clear();
    }
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _skillsController.dispose();

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
                  details: "${PostJobFormStorage.companyName} POST JOB"),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Required Skills",
                ),
              ),

              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "SKILLS",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(20.0),
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
                          for (var item in PostJobFormStorage.skills!)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _count = _count - 1;
                                        PostJobFormStorage.skills!.remove(item);
                                      });
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item,
                                        softWrap: true,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: 15.sp,
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
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _skillsController,
                        labelText: "Enter Job Skill",
                        hintText: "JavaScript",
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
                  percent: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    if (PostJobFormStorage.skills!.isEmpty) {
      Fluttertoast.showToast(
          msg: "Job skill is required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CreateJobsScreenSix()));
    }
  }
}
