import 'package:firebase_auth/firebase_auth.dart';

class SchoolStorage {
  static String? schoolId;
  static String? schoolName;
  static String? jobName;
  static String? userId;
  static String? logo;
  static String? cty;
  static String? email;
  static String? adr;
  static String? cpin;
  static String? date;
  static String? phn;
  static String? un;
  static String? vfy;
  static String? street;
  static String? state;
  static String? city;
  static String? chpNm;
  static bool? isItFromSchoolRequest;
  static bool? isItFromChapterRequest;
  static bool? isItFromChapterActivities;
  static String? reAcceptId;
}

class SchoolUserStorage {
  static User? currentUser;
  static final _auth = FirebaseAuth.instance;
  static late User loggedInUser;

  static void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
}

class GeneralFunction {
  static String selectedValue = "";
}



class ChapterStorage {
  static String? schoolName;
  static String? street;
  static String? adr;
  static String? chpNm;
  static String? sl;
  static String? city;
  static String? schoolId;
  static String? state;
  static String? chapLcn;
  static String? Id;

}