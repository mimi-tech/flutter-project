import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/courses/course_description.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseLandingPage extends StatefulWidget {
  @override
  _CourseLandingPageState createState() => _CourseLandingPageState();
}

class _CourseLandingPageState extends State<CourseLandingPage>
    with TickerProviderStateMixin {
  int _current = 0;

  static late Animation<Offset> animation;
  late AnimationController animationController;

  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });

    //ToDo:second animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imgList = [
      SlideTransition(
        position: animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(kExample2,
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlackcolor,
                    fontSize: 30.sp,
                    letterSpacing: 2.0,
                  ),
                )),
            Text(kExample3,
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kStabcolor,
                    fontSize: 22.sp,
                  ),
                )),
          ],
        ),
      ),
      ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: kWhitecolor,
              size: 20,
            ),
            title: SlideTransition(
              position: animation,
              child: Text(kExample,
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  )),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: kWhitecolor,
              size: 20,
            ),
            title: SlideTransition(
              position: animation,
              child: Text(kExample,
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  )),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: kWhitecolor,
              size: 20,
            ),
            title: SlideTransition(
              position: animation,
              child: Text(kExample,
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  )),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: kWhitecolor,
              size: 20,
            ),
            title: SlideTransition(
              position: animation,
              child: Text(kExample,
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  )),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: kWhitecolor,
              size: 20,
            ),
            title: SlideTransition(
              position: animation,
              child: Text(kExample,
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  )),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: kWhitecolor,
              size: 20,
            ),
            title: SlideTransition(
              position: animation,
              child: Text(kExample,
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  )),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.ac_unit,
              color: kWhitecolor,
              size: 20,
            ),
            title: SlideTransition(
              position: animation,
              child: Text(kExample,
                  //textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  )),
            ),
          ),
        ],
      )
    ];
    return Scaffold(
      //appBar: AppBar(title: Text('Carousel with indicator demo')),
      body: SingleChildScrollView(
        child: Container(
          /*decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/company/sparksbg.png'),
                  fit: BoxFit.cover)),*/

          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: kHorizontal, right: kHorizontal, top: 30),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(60),
                  child: RaisedButton(
                    color: kFbColor,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: kWhitecolor)),
                    child: SlideTransition(
                      position: _offsetFloat,
                      child: Text('Sparks Curriculum Tips',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: 22.sp,
                            ),
                          )),
                    ),
                  ),
                ),
                CarouselSlider(
                  items: imgList
                      .map((item) => Container(
                            child: item,
                          ))
                      .toList(),
                  options: CarouselOptions(
                      viewportFraction: 1.0,
//enableInfiniteScroll: false,
                      height: MediaQuery.of(context).size.height * 0.75,
                      pauseAutoPlayOnTouch: true,
                      autoPlayInterval: Duration(seconds: 10),
                      autoPlayCurve: Curves.easeIn,
                      autoPlay: true,
                      //enlargeCenterPage: true,
                      // aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? kFbColor : kMaincolor,
                      ),
                    );
                  }).toList(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomCenter,
                            child: CourseDescription()));
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Material(
                      color: kFbColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      elevation: 5.0,
                      animationDuration: Duration(seconds: 5),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text('Skip',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                                fontSize: kFontsize.sp,
                              ),
                            )),
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
