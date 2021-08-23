import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class SchoolConstants extends StatelessWidget {
  SchoolConstants({required this.details});
  final String details;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kCompspace4),
      width: double.infinity,
      height: ScreenUtil().setHeight(50.0),
      color: kCdetailsbgcolor.withOpacity(0.5),
      child: Center(
        child: Text(
          details.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: kCompanydetailsdimens.sp,
            color: kCdetailstxtcolor,
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
//ToDo:TextForm field hint text

class EditHintText extends StatefulWidget {
  EditHintText({required this.hintText});
  final String hintText;
  @override
  _EditHintTextState createState() => _EditHintTextState();
}

class _EditHintTextState extends State<EditHintText>
    with TickerProviderStateMixin {
  Animation<Offset>? animation;
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
      curve: Curves.fastLinearToSlowEaseIn,
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
    return Container(
      child: Center(
        child: SlideTransition(
          position: _offsetFloat,
          child: Text(
            widget.hintText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: kCompanydetailsdimens.sp,
              color: Colors.black,
              fontFamily: 'Rajdhani',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class HintText extends StatefulWidget {
  HintText({required this.hintText});
  final String hintText;
  @override
  _HintTextState createState() => _HintTextState();
}

class _HintTextState extends State<HintText> with TickerProviderStateMixin {
  Animation<Offset>? animation;
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
      curve: Curves.fastLinearToSlowEaseIn,
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
    return Container(
      child: Center(
        child: SlideTransition(
          position: _offsetFloat,
          child: Text(
            widget.hintText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: kCompanydetailsdimens.sp,
              color: kWhitecolor,
              fontFamily: 'Rajdhani',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

//ToDo: sparks logo

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'images/company/companyback.svg',
              )),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'images/company/sparkslogo.svg',
            ),
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatefulWidget {
  Indicator({required this.nextBtn, required this.percent});
  final Function nextBtn;
  final double percent;
  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;
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
      curve: Curves.fastLinearToSlowEaseIn,
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
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: kHorizontal, vertical: kCompspace3),
        child: SlideTransition(
          position: animation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LinearPercentIndicator(
                width: ScreenUtil().setWidth(160.0),
                animation: true,
                lineHeight: 10.0,
                animationDuration: 2000,
                percent: widget.percent,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: kFbColor,
                backgroundColor: kComlinearprogressbar,
              ),
              GestureDetector(
                  onTap: widget.nextBtn as void Function()?,
                  child: CircleAvatar(
                    radius: 30.0,
                    child: Image(
                      height: ScreenUtil().setHeight(70.0),
                      width: ScreenUtil().setWidth(70.0),
                      image: AssetImage('images/company/next.png'),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: ScreenUtil().setHeight(50.0),
      color: kCdetailsbgcolor.withOpacity(0.5),
      child: Center(
        child: SvgPicture.asset(
          'images/company/address.svg',
        ),
      ),
    );
  }
}
