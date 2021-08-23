import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/chat/chat_screen.dart';
import 'package:sparks/schoolClassroom/studentFolder/full_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/stdent_announcement.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_assignment.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_social.dart';



class StudentsBottomBar extends StatefulWidget {
  @override
  _StudentsBottomBarState createState() => _StudentsBottomBarState();
}

class _StudentsBottomBarState extends State<StudentsBottomBar> {


  int _selectedIndex = 0;
  static  List<Widget> _pages = <Widget>[
    StudentAnnouncement(),
    StudentAssessment(),

  ];


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type:  BottomNavigationBarType.fixed,
        backgroundColor: kStatusbar,
        elevation: 0,
        mouseCursor: SystemMouseCursors.grab,
        iconSize: 20,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: kAYellow, size: 20),
        selectedItemColor: kAYellow,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,
          color: klistnmber,
          fontSize:kFontsize.sp,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
        ),
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[


          BottomNavigationBarItem(
            icon: Icon(Icons.speaker),
            label: 'Announcement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Assessment',
          ),

        ],
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );

  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}



class EClassBottomBar extends StatefulWidget {
  @override
  _EClassBottomBarState createState() => _EClassBottomBarState();
}

class _EClassBottomBarState extends State<EClassBottomBar> {


  int _selectedIndex = 0;
  static  List<Widget> _pages = <Widget>[
    StudentSocial(),
    ChatScreen(),

  ];


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type:  BottomNavigationBarType.fixed,
        backgroundColor: kStatusbar,
        elevation: 0,
        mouseCursor: SystemMouseCursors.grab,
        iconSize: 20,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: kAYellow, size: 20),
        selectedItemColor: kAYellow,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,
          color: klistnmber,
          fontSize:kFontsize.sp,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
        ),
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[


          BottomNavigationBarItem(
            icon: Icon(Icons.change_history_sharp),
            label: 'Extra Morals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat forum',
          ),

        ],
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );

  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
