import 'package:cloud_firestore/cloud_firestore.dart';

class ExpertAdminConstants {
  static var userData = [];
  static late DateTime loginTime;
  static var showLoginTime;
  static String? currentUser;
  static late DocumentSnapshot lecturesKey;
  static late DocumentSnapshot foundUserData;
}
