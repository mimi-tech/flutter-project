import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
// import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/company/screens/popout.dart';

import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CompanyState extends StatefulWidget {
  @override
  _CompanyStateState createState() => _CompanyStateState();
}

class _CompanyStateState extends State<CompanyState>
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

    Future<void>.delayed(Duration(seconds: 2), () {
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
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: SlideTransition(
              position: _offsetFloat,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      Constants.selectedState == null
                          ? kCcompanystatelocated
                          : "Ellis here", // Variables.state
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: kComapnylocation,
                        fontFamily: 'Rajdhani',
                      ))),
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 4,
                children: <Widget>[
                  PopOut(
                    pop: () {
                      setState(
                        () {
                          Constants.selectedState = Variables.state;
                        },
                      );
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: StateDialog(
                        substringBackground: Colors.green,
                        substringFontSize: 18.0.sp,
                        fontStyle: FontStyle.normal,
                        textColors: Colors.black,
                        fontSize: 18.0.sp,
                        substringTextColor: Colors.blueAccent,
                        fontFamily: 'rajdhani',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: Divider(
            color: kComapnylocation,
          ),
        )
      ],
    );
  }
}
