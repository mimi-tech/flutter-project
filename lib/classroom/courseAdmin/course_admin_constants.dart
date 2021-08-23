import 'package:cloud_firestore/cloud_firestore.dart';

class CourseAdminConstants{
  static late DocumentSnapshot userData;

  static List<dynamic> adminData = <dynamic>[];

  static String emailSubject = 'Sparks Course Correction';

  static String? courseAdminDocId;

  static List<int> selectedDoc = <int>[];
  static String? courseAdminName;
  static List<dynamic> newCount = <dynamic>[];
  static List<dynamic> updatedCount = <dynamic>[];
  static List<dynamic> courseAdminLogin = <dynamic>[];
  static List<dynamic> courseAdminLogout = <dynamic>[];
  static List<DocumentSnapshot> courseDoc = <DocumentSnapshot>[];

  static String? courseAdminPix;


  static List<int> lectureSelectedIndex = <int>[];


  static List<dynamic> courseItem = <dynamic>[];


  static late DateTime loginTime;
  static var showLoginTime;

  static String? currentUser;


}