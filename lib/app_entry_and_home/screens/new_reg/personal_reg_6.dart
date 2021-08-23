import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg6 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg6({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg6State createState() => _PersonalReg6State();
}

class _PersonalReg6State extends State<PersonalReg6>
    with TickerProviderStateMixin {
  String userDob = "";
  late FocusNode focus;
  late AnimationController _controller;
  late Animation<Offset> offset;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    focus = FocusNode();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    offset = Tween<Offset>(
      begin: Offset(7.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //TODO: Sparks main background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/app_entry_and_home/sparksbg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //TODO: A second faded background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/app_entry_and_home/new_images/faded_spark_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //TODO: Content of this screen starts here.
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: SizedBox(
                        child: Image(
                          width: 200.0,
                          height: 80.0,
                          image: AssetImage(
                            'images/app_entry_and_home/new_images/sparks_new_logo.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "images/app_entry_and_home/new_images/title_bg.png",
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        kTell_us,
                        style: TextStyle(
                          fontSize: kFont_size_18.sp,
                          color: kReg_title_colour,
                          fontFamily: 'Rajdhani',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //TODO: Display the label: What's your brith date?.
                          SlideTransition(
                            position: offset,
                            child: Center(
                              child: Text(
                                kEnter_dob,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    color: kWhiteColour,
                                    fontSize: kFont_size_22.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          //TODO: Displays user's DOB.
                          SlideTransition(
                            position: offset,
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  focus.unfocus();
                                  //TODO: Render the date picker.
                                  DateTime myDOB = await (showRoundedDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate:
                                        DateTime(DateTime.now().year - 100),
                                    lastDate:
                                        DateTime(DateTime.now().year + 10),
                                    initialDatePickerMode: DatePickerMode.day,
                                    theme: ThemeData(
                                        primarySwatch: Colors.deepOrange),
                                    borderRadius: 16,
                                  ) as Future<DateTime>);
                                  String dob = myDOB.day.toString() +
                                      "-" +
                                      myDOB.month.toString() +
                                      "-" +
                                      myDOB.year.toString();
                                  setState(() {
                                    userDob = dob;
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                      color: kWhiteColour,
                                    )),
                                  ),
                                  child: Center(
                                    child: Text(
                                      userDob,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          color: kWhiteColour,
                                          fontSize: kFont_size_18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //TODO: Display progress indicator.
                          PersonalReg().createState().createProgressIndicator(
                              widget.currentPage, context),
                          //TODO: Display a circular next button.
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () async {
                                //TODO: Check if the dob field is empty.
                                if ((userDob == null) || (userDob == "")) {
                                  //TODO; Display a toast.
                                  Fluttertoast.showToast(
                                      msg: dob_error_mgs,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kSize_16.sp);
                                } else {
                                  setState(() {
                                    //TODO: Store user's DOB.
                                    GlobalVariables.dob = userDob;

                                    //TODO: Go to the seventh page (Personal Account)
                                    widget.pageController.animateToPage(
                                      widget.currentPage.floor(),
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kProfile,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 42.0,
                                    color: kWhiteColour,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
