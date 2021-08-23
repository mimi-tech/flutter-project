/*

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import 'package:sparks/colors/colors.dart';
import 'package:sparks/dimens/dimen.dart';
import 'package:sparks/mycontacts/contact.dart';

import 'package:sparks/variable_live_modal.dart';
import 'package:sparks/widget/subtitles_listview.dart';
import 'package:sparks/widget/users_friends_selected_list.dart';
import 'package:sparks/send.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/tutees/tutees_friends.dart';

class ClassroomContact extends StatefulWidget {
  static String classroomContactName = kContactsroutes;

  @override
  _ClassroomContactState createState() => _ClassroomContactState();
}


Tutees _tuteesDetails = Tutees('Eggs','https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',false);
Tutees _tuteesDetails1 = Tutees('mimi','https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',false);
List<Tutees> tutees = [
  _tuteesDetails,
  _tuteesDetails1
];

@override
class _ClassroomContactState extends State<ClassroomContact> {
  static bool fontScale = true;
  bool viewVisible = true;

  Widget appBarTitle = Text(kChooseFriends,
    style: TextStyle(color: kWhitecolor),
  );
  Icon actionIcon = new Icon(Icons.search);


  void toggleSwitch(bool value) {
    if (Variables.switchControl == false) {
      setState(() {
        Variables.switchControl = true;
      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.
      setState(() {
        Variables.menteesVal = true;
        Variables.contactVal = true;
        Variables.tuteesVal = true;
        Variables.classmateVal = true;
        Variables.alumniVal = true;
      });
    }
    else {
      setState(() {
        Variables.switchControl = false;
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
      setState(() {
        Variables.menteesVal = false;
        Variables.contactVal = false;
        Variables.tuteesVal = false;
        Variables.classmateVal = false;
        Variables.alumniVal = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: kWhitecolor, size: 20.0),
          elevation: 4.0,
          backgroundColor: kListcard,
          title: Text(kChooseFriends, style: TextStyle(color: kWhitecolor),),
          actions: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: viewVisible,
                  child: Switch(
                    onChanged: toggleSwitch,
                    value: Variables.switchControl,
                    activeColor: kMaincolor,
                    activeTrackColor: kSwitchfadecolor,
                    inactiveThumbColor: kSwitchoffColor,
                    inactiveTrackColor: kSwitchoffColors,
                  ),
                ),


              ],
            ),
          ],
        ),
        floatingActionButton: Send(),
        backgroundColor: kListcard,

        body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(kCardheight),
                child: Card(
                  elevation: 5,
                  color: kListcard,
                  child: Center(
                    // padding: const EdgeInsets.only(top:28.0),
                    child: ListTile(
                      onTap: () {
                        showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {

                              return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                      opacity: a1.value,
                                      child: Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0)),
                                          backgroundColor:kMaincolor,

                                          elevation: 4,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0,top:12.0,right: 8.0),
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Icon(
                                                            Icons.cancel,
                                                            size: 28,
                                                            color: Colors.black,
                                                          ),
                                                          onTap: (){

                                                            Navigator.pop(context);
                                                          },
                                                        ),

                                                        GestureDetector(
                                                            onTap: (){
                                                              Navigator.pop(context);

                                                            },
                                                            child: Text(
                                                              kDoneText,style: Variables.textstylescard,)),

                                                      ]
                                                  ),
                                                ),

                                                Expanded(
                                                  child: SingleChildScrollView(
                                                      child:
                                                      Container(child:Cd())

                                                  ),
                                                ),
                                              ]
                                          )
                                      )
                                  )
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
// ignore: missing_return
                            pageBuilder: (context, animation1, animation2) {}
                        );

                      },

                      leading: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: kBlackcolor,
                          child: Image(
                            height: ScreenUtil().setHeight(kListviewImage),
                            width: ScreenUtil().setHeight(kListviewImage),
                            image: AssetImage('images/contacts.png'),
                          ),
                        ),
                      ),
                      title: SubTitle(),

                      trailing: CircularCheckBox(
                          inactiveColor: kBlackcolor,
                          value: Variables.contactVal,
                          onChanged: (bool value) {
                            setState(() {
                              Variables.contactVal = value;
                            });
                          }),

                    ),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(kCardheight),
                child: Card(
                  elevation: 5,
                  color: kListcard,
                  child: Center(
                    child: ListTile(
                      leading: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: kBlackcolor,
                          child: Image(
                            height: ScreenUtil().setHeight(kListviewImage),
                            width: ScreenUtil().setHeight(kListviewImage),
                            image: AssetImage('images/mentees.png'),
                          ),
                        ),
                      ),
                      title: Text(kListviewMentees,
                          style: Variables.textstyleslistViews),

                      trailing: CircularCheckBox(
                          inactiveColor: kBlackcolor,
                          value: Variables.menteesVal,
                          onChanged: (bool value) {
                            setState(() {
                              Variables.menteesVal = value;
                            });
                          }),
                    ),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(kCardheight),
                child: Card(
                  elevation: 5,
                  color: kListcard,
                  child: Center(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: TuteesList(tutees: tutees,)));
                      },
                      leading: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: kBlackcolor,
                          child: Image(
                            height: ScreenUtil().setHeight(kListviewImage),
                            width: ScreenUtil().setHeight(kListviewImage),
                            image: AssetImage('images/tutees.png'),
                          ),
                        ),
                      ),
                      title: Text(kListviewTutees,
                          style: Variables.textstyleslistViews),

                      trailing: CircularCheckBox(
                          inactiveColor: kBlackcolor,
                          value: Variables.tuteesVal,
                          onChanged: (bool value) {
                            setState(() {
                              Variables.tuteesVal = value;
                            });
                          }),
                    ),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(kCardheight),
                child: Card(
                  elevation: 5,
                  color: kListcard,
                  child: Center(
                    child: ListTile(
                      leading: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: kBlackcolor,
                          child: Image(
                            height: ScreenUtil().setHeight(kListviewImage),
                            width: ScreenUtil().setHeight(kListviewImage),
                            image: AssetImage('images/classmates.png'),
                          ),
                        ),
                      ),
                      title: Text(kListviewClassmate,
                          style: Variables.textstyleslistViews),

                      trailing: CircularCheckBox(
                          inactiveColor: kBlackcolor,
                          value: Variables.classmateVal,
                          onChanged: (bool value) {
                            setState(() {
                              Variables.classmateVal = value;
                            });
                          }),
                    ),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(kCardheight),
                child: Card(
                  elevation: 5,
                  color: kListcard,
                  child: Center(
                    child: ListTile(
                      leading: GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: kBlackcolor,
                          child: Image(
                            height: ScreenUtil().setHeight(kListviewImage),
                            width: ScreenUtil().setHeight(kListviewImage),
                            image: AssetImage('images/Alumnimain.png'),
                          ),
                        ),
                      ),
                      title: Text(kListviewAlumin,
                          style: Variables.textstyleslistViews),

                      trailing: CircularCheckBox(
                          inactiveColor: kBlackcolor,
                          value: Variables.alumniVal,
                          onChanged: (bool value) {
                            setState(() {
                              Variables.alumniVal = value;
                            });
                          }),

                    ),
                  ),


                ),
              )

            ]
        )

    );
  }
}


*/
