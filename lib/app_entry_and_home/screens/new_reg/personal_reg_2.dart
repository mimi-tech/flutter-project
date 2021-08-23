import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/custom_radio/personal_text_info.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg2 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg2({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg2State createState() => _PersonalReg2State();
}

class _PersonalReg2State extends State<PersonalReg2>
    with TickerProviderStateMixin {
  late AnimationController _controller,
      _controller1,
      _controller2,
      _controller3,
      _controller4,
      _controller5,
      _controller6;
  Animation<Offset>? offset;
  Animation<double>? _fadeAnimation,
      _personalFadeAnimation,
      _pInfo_1FadeAnimation,
      _pInfo_2FadeAnimation,
      _pInfo_3FadeAnimation,
      _pInfo_4FadeAnimation,
      _getStartedAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _controller1 = AnimationController(
        duration: const Duration(milliseconds: 2300), vsync: this);
    _controller2 = AnimationController(
        duration: const Duration(milliseconds: 2600), vsync: this);
    _controller3 = AnimationController(
        duration: const Duration(milliseconds: 2900), vsync: this);
    _controller4 = AnimationController(
        duration: const Duration(milliseconds: 3200), vsync: this);
    _controller5 = AnimationController(
        duration: const Duration(milliseconds: 3500), vsync: this);
    _controller6 = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);

    offset = Tween<Offset>(
      begin: Offset(0.0, 7.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _personalFadeAnimation =
        CurvedAnimation(parent: _controller1, curve: Curves.easeIn);
    _pInfo_1FadeAnimation =
        CurvedAnimation(parent: _controller2, curve: Curves.easeIn);
    _pInfo_2FadeAnimation =
        CurvedAnimation(parent: _controller3, curve: Curves.easeIn);
    _pInfo_3FadeAnimation =
        CurvedAnimation(parent: _controller4, curve: Curves.easeIn);
    _pInfo_4FadeAnimation =
        CurvedAnimation(parent: _controller5, curve: Curves.easeIn);
    _getStartedAnimation =
        CurvedAnimation(parent: _controller6, curve: Curves.bounceInOut);

    _controller.forward();
    _controller1.forward();
    _controller2.forward();
    _controller3.forward();
    _controller4.forward();
    _controller5.forward();
    _controller6.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.17,
            ),
            Center(
              child: SlideTransition(
                position: offset!,
                child: FadeTransition(
                  opacity: _fadeAnimation!,
                  child: SvgPicture.asset(
                    "images/app_entry_and_home/new_images/smile.svg",
                    width: MediaQuery.of(context).size.width * 0.10,
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                ),
              ),
            ),
            //TODO: Displays special info you need to know about personal account.
            Center(
              child: SlideTransition(
                position: offset!,
                child: FadeTransition(
                  opacity: _personalFadeAnimation!,
                  child: Text(
                    kAcct_type_1,
                    style: TextStyle(
                      color: kRadio_color,
                      fontFamily: 'Rajdhani',
                      fontSize: kFont_size_30.sp,
                    ),
                  ),
                ),
              ),
            ),
            //TODO: First information.
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
              ),
              child: PersonalTextInfo(
                offset: offset,
                fadeAnimation: _pInfo_1FadeAnimation,
                info: kInfo_1,
              ),
            ),
            //TODO: Second information.
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
              ),
              child: PersonalTextInfo(
                offset: offset,
                fadeAnimation: _pInfo_2FadeAnimation,
                info: kInfo_2,
              ),
            ),
            //TODO: Third information.
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
              ),
              child: PersonalTextInfo(
                offset: offset,
                fadeAnimation: _pInfo_3FadeAnimation,
                info: kInfo_3,
              ),
            ),
            //TODO: Fourth information.
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08,
                right: MediaQuery.of(context).size.width * 0.08,
              ),
              child: PersonalTextInfo(
                offset: offset,
                fadeAnimation: _pInfo_4FadeAnimation,
                info: kInfo_4,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            //TODO: This is the get started button.
            ScaleTransition(
              scale: _getStartedAnimation!,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    //TODO: Go to the third page (Personal Account)
                    widget.pageController.animateToPage(
                      widget.currentPage.floor(),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                },
                color: kProfile,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: Center(
                    child: Text(
                      kGet_started,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        color: kWhiteColour,
                        fontSize: kFont_size_30.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
