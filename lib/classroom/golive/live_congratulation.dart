import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class Congratulation extends StatefulWidget {
  @override
  _Congratulation createState() => _Congratulation();
}

class _Congratulation extends State<Congratulation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel,
                    size: 42,
                    color: kWhitecolor,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: kBlackcolor.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    )),
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Center(
                            child: Text(Variables.title!,
                                style: Variables.textstyles)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Divider(
                          height: 0.0,
                          color: kWhitecolor.withOpacity(0.5),
                          thickness: 2.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                            child: Text(kTagtext,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rajdhani',
                                  color: kMaincolor,
                                ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                            child: Text(kSharetext,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rajdhani',
                                  color: kWhitecolor.withOpacity(0.5),
                                ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SvgPicture.asset(
                                      'images/classroom/facebook.svg',
                                      width:
                                          ScreenUtil().setWidth(kSocialIcons),
                                      height: ScreenUtil().setHeight(40.0),
                                    )),
                              ),
                              GestureDetector(
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SvgPicture.asset(
                                      'images/classroom/messenger.svg',
                                      width:
                                          ScreenUtil().setWidth(kSocialIcons),
                                      height: ScreenUtil().setHeight(40.0),
                                    )),
                              ),
                              GestureDetector(
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SvgPicture.asset(
                                      'images/classroom/instagram.svg',
                                      width:
                                          ScreenUtil().setWidth(kSocialIcons),
                                      height: ScreenUtil().setHeight(40.0),
                                    )),
                              ),
                              GestureDetector(
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SvgPicture.asset(
                                      'images/classroom/twitter.svg',
                                      width:
                                          ScreenUtil().setWidth(kSocialIcons),
                                      height: ScreenUtil().setHeight(40.0),
                                    )),
                              ),
                              GestureDetector(
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SvgPicture.asset(
                                      'images/classroom/whatsapp.svg',
                                      width:
                                          ScreenUtil().setWidth(kSocialIcons),
                                      height: ScreenUtil().setHeight(40.0),
                                    )),
                              ),
                              GestureDetector(
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SvgPicture.asset(
                                      'images/classroom/telegram.svg',
                                      width:
                                          ScreenUtil().setWidth(kSocialIcons),
                                      height: ScreenUtil().setHeight(40.0),
                                    )),
                              ),
                            ]),
                      ),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(60),
                        margin: EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 20.0,
                        ),
                        child: RaisedButton(
                          elevation: 5.0,
                          color: kBlackcolor,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: kWhitecolor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'images/classroom/video.svg',
                              ),
                              SizedBox(
                                width: 7.0,
                              ),
                              Text(
                                kGolivetitle + " " + '!',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rajdhani',
                                  color: kFbColor,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
