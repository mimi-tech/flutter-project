import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ResumeInput extends StatelessWidget {
  ResumeInput(
      {required this.controller,
      required this.labelText,
      required this.hintText,
      this.action});

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: TextField(
              onChanged: action as void Function(String)?,
              maxLines: null,
              controller: controller,
              autocorrect: true,
              cursorColor: (Colors.black),
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  suffixIcon: IconButton(
                    onPressed: () => controller.clear(),
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kShade,
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

class PasswordInput extends StatelessWidget {
  PasswordInput(
      {required this.controller,
      required this.labelText,
      required this.hintText,
      this.action,
      required this.passwordView});

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function? action;
  final bool passwordView;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: TextField(
              obscureText: passwordView,
              onChanged: action as void Function(String)?,
              controller: controller,
              autocorrect: true,
              cursorColor: (Colors.black),
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  suffixIcon: IconButton(
                    onPressed: () => controller.clear(),
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kShade,
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

class VariableStorage {
  static int? tabNumber;
  static bool changeStreamOfData = false;
  static bool changeProfessionalStreamOfData = false;
}

class InterviewFormStorage {
  static String? companyName;
  static String? jobLocation;
  static String? interviewVenue;
  static File? companyLogo;
  static String? logoUrl;
  static String? interviewMessage;
  static String? jobTitle;
  static String? description;
  static String? salaryRangeMin;
  static String? salaryRangeMax;
  static DateTime? jobTime = DateTime.now();
  static String? logoName;
  static String? jobId;
  static String? companyId;
  static String? mainCompanyId;
  static String? interviewId;
  static List<dynamic>? jobRequirement = [];
  static List<dynamic>? jobBenefit = [];
  static List<dynamic>? contactPerson = [];
}

class AppointmentStorage {
  static int? tabController;
  static String? companyId;
  static String? mainCompanyId;
  static String? appointmentId;
  static File? companyLogo;
  static String? logoUrl;
  static String? logoName;
  static String? companyName;
  static String? companyAddress;
  static String? companyCity;
  static String? companyState;
  static String? companyZipCode;
  static String? recipientName;
  static String? recipientAddress;
  static String? recipientCity;
  static String? recipientState;
  static String? recipientZipCode;

  static String? appointmentMessage;
  static String? commencementMessage;
  static String? reportingMessage;
  static String? allocationMessage;
  static String? rolesMessage;
  static String? salaryMessage;

  static String? workingHoursMessage;
  static String? vacationMessage;
  static String? sickMessage;
  static String? paternityMessage;
  static String? terminationMessage;

  static String? copyrightsMessage;
  static String? amendmentMessage;
  static String? humanResourceName;
  static String? confirmationMessage;
}

class JobOfferFormStorage {
  static String? companyName;
  static String? jobLocation;
  static String? jobOfferMessage;
  static String? interviewVenue;
  static File? companyLogo;
  static String? logoUrl;
  static String? interviewMessage;
  static String? jobTitle;
  static String? description;
  static String? salaryRangeMin;
  static String? salaryRangeMax;
  static DateTime jobTime = DateTime.now();
  static String? logoName;
  static String? jobId;
  static String? companyId;
  static String? mainCompanyId;
  static String? interviewId;
  static var jobRequirement = [];
  static var jobBenefit = [];
  static var contactPerson = [];
}

class PostJobFormStorage {
  // ignore: close_sinks
  static StreamController<List<DocumentSnapshot>>? jobsStreamController;
  static String? companyName;
  static String? jobSummary;
  static String? jobLocation;
  static File? companyLogo;
  static String? logoUrl;
  static String? jobCategory;
  static String? jobTitle;
  static String? jobType;
  static String? salaryRangeMin;
  static String? salaryRangeMax;
  static DateTime jobTime = DateTime.now();
  static String? jobId;
  static String? companyId;
  static String? mainCompanyId;
  static List<dynamic>? jobBenefit = [];
  static List<dynamic>? jobQualification = [];
  static List<dynamic>? responsibility = [];
  static List<dynamic>? skills = [];
}

class EditJobFormStorage {
  static String? companyName;
  static String? jobSummary;
  static String? jobLocation;
  static File? companyLogo;
  static String? logoUrl;
  static String? jobCategory;
  static String? jobTitle;
  static String? jobType;
  static String? status;
  static String? salaryRangeMin;
  static String? salaryRangeMax;
  static DateTime jobTime = DateTime.now();
  static String? jobId;
  static String? companyId;
  static String? mainCompanyId;
  static List<dynamic>? jobBenefit = [];
  static List<dynamic>? jobQualification = [];
  static List<dynamic>? responsibility = [];
  static List<dynamic>? skills = [];
}

class ProfessionalStorage {
  static String? professionalTitle;
  static String? location;
  static String? phoneNumber;
  static String? aboutMe;
  static String? hasDoneProject;
  static String? hasReceivedAward;
  static var award = [];
  static var projects = [];
  static String? jobCategory;
  static String? jobType;
  static String? salaryRangeMin;
  static String? salaryRangeMax;
  static String? status;
  static String? hasExperience;
  static var experience = [];
  static String? hasEducation;
  static var education = [];
  static var skills = [];
  static var hobbies = [];
  static String? hasService;
  static String? hasReferral;
  static var services = [];
  static var referee = [];
  static Stream? resume;
  static File? referralImage;
  static String? referralImageUrl;
  static String? referralImageName;
  static File? cv;
  static String? hasCv;
  static String? cvUrl;
  static String? id;

  static String? minSalary;
  static String? maxSalary;
  static String? availableJobCategory;
  static String? availableJobType;
  static File? profileLogo;
  static String? logoUrl;

// for portfolio
  static String? email;
  static String? description;
  static int? portfolioImageIndex;
  static int? portfolioImageLike;
  static String? portfolioImageClickedId;
  static String? portfolioImageSingleCategory;

  static List<dynamic>? portfolioImageUrls = [];

  static bool isLoggedInUser(loggedInId, notLoggedInId) {
    if (loggedInId == notLoggedInId) {
      return true;
    } else {
      return false;
    }
  }
}

class CompanyStorage {
  static String? companyName;
  static String? companyLocation;
  static File? companyLogo;
  static String? companyPin;
  static String? companyLogoName;
  static DateTime dateCreated = DateTime.now();
  static String? companyId;
  static String? pageId;
  static int? numberOfJobsListed;
  static int? numberOfInterviewRequestCreated;
  static int? numberOfInterviewRequestSent;
  static List<DocumentSnapshot>? jobsListed;
  static List<DocumentSnapshot>? interviewRequestSent;
  static List<DocumentSnapshot>? interviewRequestAccepted;
  static String? companyTitle;
  static int? numberOfAppliedJobs;
  static List<DocumentSnapshot>? jobsApplied;
  static String? individualJobId;
  static String? individualMainJobId;
}

class UserStorage {
  static final _auth = FirebaseAuth.instance;
  static late User loggedInUser;
  static bool isCompanyAccount = false;
  static bool profState = false;
  static bool fromResume = false;
  static bool isFromCompanyPage = false;

  static void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //TODO: checking if user has created a resume already
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('professionals')
            .where('userId', isEqualTo: loggedInUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;

        if (documents.length >= 1) {
          profState = true;
        }

        print(GlobalVariables.accountType);
        if (GlobalVariables.accountType.contains("Company")) {
          isCompanyAccount = true;
          print(GlobalVariables.accountType);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static String? jobOfferRequestID;
  static String? appointmentID;
  static String? sentInterviewRequestID;
  static String? companyID;
  static String? mainCompanyID;
  static List<DocumentSnapshot>? interviewRequestSent;
//  static Stream<QuerySnapshot> interviewRequestSent;
}

class EditProfessionalStorage {
  static String? id;
  static String? professionalTitle;
  static String? profileName;
  static String? location;
  static String? phoneNumber;
  static String? aboutMe;
  static String? hasDoneProject;
  static String? logoUrl;
  static String? hasReceivedAward;
  static List<dynamic>? award = [];
  static List<dynamic>? projects = [];
  static String? jobCategory;
  static String? jobType;
  static String? salaryRangeMin;
  static String? salaryRangeMax;
  static String? status;
  static String? hasExperience;
  static List<dynamic>? experience = [];
  static String? hasEducation;
  static List<dynamic>? education = [];
  static List<dynamic>? skills = [];
  static List<dynamic>? hobbies = [];
  static String? hasService;
  static String? hasReferral;
  static List<dynamic>? services = [];
  static List<dynamic>? referee = [];
  static Stream? resume;
  static File? referralImage;
  static File? profileLogo;
  static String? referralImageUrl;
  static String? referralImageName;
  static File? cv;
  static String? hasCv;
  static String? cvUrl;

  static bool isLoggedInUser(loggedInId, notLoggedInId) {
    if (loggedInId == notLoggedInId) {
      return true;
    } else {
      return false;
    }
  }
}

class ProfileStorage {
  static String? profileId;
  static Map? insightContent;
  static String? insightId;
}

class Validation {
  static String? validateCompanyName(String value) {
    if (value.isEmpty) {
      return "Company cannot be empty";
    }
    return null;
  }

  static String? validateJobLocation(String value) {
    if (value.isEmpty) {
      return "Job Location cannot be empty";
    }
    return null;
  }

  static String? validateJobCategory(String value) {
    if (value.isEmpty) {
      return "JobCategory cannot be empty";
    }
    return null;
  }

  static String? validateJobTitle(String value) {
    if (value.isEmpty) {
      return "JobTitle cannot be empty";
    }
    return null;
  }

  static String? validateDescription(String value) {
    if (value.isEmpty) {
      return "JobDescription cannot be empty";
    }
    return null;
  }

  static String? validateJobType(String value) {
    if (value.isEmpty) {
      return "Job Type cannot be empty";
    }
    return null;
  }

  static String? validateSalaryRange(String value) {
    if (value.isEmpty) {
      return "Salary range cannot be empty";
    }
    if (value == '') {
      return "Salary range must be a number";
    }
    return null;
  }

  static String? jobRequirement(String value) {
    if (value.isEmpty) {
      return "Job Requirement cannot be empty";
    }
    return null;
  }

  static String? jobBenefit(String value) {
    if (value.isEmpty) {
      return "Job Benefit cannot be empty";
    }
    return null;
  }
}

class NoResult extends StatelessWidget {
  NoResult({required this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      margin: EdgeInsets.only(top: 200),
      child: Text(
        message,
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
              fontSize: ScreenUtil().setSp(18.0),
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
    ));
  }
}

class ReusableFunctions {
  static bool checkPinTrial = false;
  static int falseCredentials = 0;
  static int perClick = 0;

  static ValueNotifier<bool> companyTest = ValueNotifier(false);

  static resetPinTrial2() {
    //print("hello");
    Future.delayed(Duration(seconds: 10), () {
      companyTest.value = true;
      if (companyTest.value) {
        falseCredentials = 0;
        perClick = 0;
      }
      print(companyTest.value);
    });
  }

  static resetPinTrial() {
    //print("hello");
    Future.delayed(Duration(seconds: 10), () {
      checkPinTrial = false;
      print(checkPinTrial);
    });
  }

  /// Method for showing toast messages to the user
  static void showToastMessage(String toastMessage) {
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      textColor: Colors.black,
      backgroundColor: Colors.white70,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showToastMessage2(
      String toastMessage, Color colorText, Color colorBg) {
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      textColor: colorText,
      backgroundColor: colorBg,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static String? capitalizeWords(text) {
    String? result = text
        .toLowerCase()
        .split(' ')
        .map((s) => s[0].toUpperCase() + s.substring(1))
        .join(' ');

    return result;
  }

  static String trimSentence(text) {
    text = text
        .trim()
        .toLowerCase()
        .split(' ')
        .map((s) => s[0].toUpperCase() + s.substring(1))
        .join(' ');

    return text;
  }

  /// Logic to format large numbers (e.g. 1000 to 1k, 1000000 to 1M)
  static String numberFormatter(int num) {
    String formattedNum;

    /// Logic to convert 1 Billion to '1B'
    if (num >= 1000000000) {
      formattedNum = (num / 1000000000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 Billion and then add 'B' at the end
      double remainder = num.remainder(1000000000);
      if (remainder >= 100000000) {
        remainder = remainder / 100000000;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'B';
      } else {
        formattedNum += 'B';
      }
    } else if (num >= 1000000) {
      /// Logic to convert 1 Million to '1M'
      formattedNum = (num / 1000000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 million and then add 'M' at the end
      double remainder = num.remainder(1000000);
      if (remainder >= 100000) {
        remainder = remainder / 100000;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'M';
      } else {
        formattedNum += 'M';
      }
    } else if (num >= 1000) {
      /// Logic to convert 1 thousand to '1k'
      formattedNum = (num / 1000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 thousand and then add 'k' at the end
      double remainder = num.remainder(1000);
      if (remainder >= 100) {
        remainder = remainder / 100;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'k';
      } else {
        formattedNum += 'k';
      }
    } else {
      return num.toString();
    }
    return formattedNum;
  }

  static String? displayProfessionalName(name) {
    List<String> temp2 = name.split(' ');
    String nameDisplay;

    if (temp2.length == 0) {
      nameDisplay = "no name";
    } else if (temp2.length == 1) {
      nameDisplay = smallSentence(19, 19, temp2[0]);
    } else if (temp2.length == 2) {
      nameDisplay = smallSentence(19, 19, temp2[0] + " " + temp2[1]);
    } else if (temp2.length == 3) {
      nameDisplay =
          smallSentence(19, 19, temp2[0] + " " + temp2[1] + " " + temp2[2]);
    } else {
      nameDisplay = smallSentence(19, 19, temp2[0] + " " + temp2[1]);
    }

    return capitalizeWords(nameDisplay);
  }

  static String? displayProfessionalName2(name) {
    List<String> temp2 = name.split(' ');
    String nameDisplay;

    if (temp2.length == 0) {
      nameDisplay = "no name";
    } else if (temp2.length == 1) {
      nameDisplay = smallSentence(35, 35, temp2[0]);
    } else if (temp2.length == 2) {
      nameDisplay = smallSentence(35, 35, temp2[0] + " " + temp2[1]);
    } else if (temp2.length == 3) {
      nameDisplay =
          smallSentence(35, 35, temp2[0] + " " + temp2[1] + " " + temp2[2]);
    } else {
      nameDisplay = smallSentence(35, 35, temp2[0] + " " + temp2[1]);
    }

    return capitalizeWords(nameDisplay);
  }

  static String smallSentence(int num, int num2, String bigSentence) {
    if (bigSentence.length > num) {
      return bigSentence.substring(0, num2) + '...';
    } else {
      return bigSentence;
    }
  }

  //TODO: Not useful anyways
  static String randomString(int strLen, String chars) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strLen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

//TODO: Not useful anyways
  static String capitalize(String? word) {
    if (word == null) {
      throw ArgumentError("string: $word");
    }

    if (word.isEmpty) {
      return word;
    }

    return word[0].toUpperCase() + word.substring(1);
  }

  static String encrypt(String data) {
    var encryptionKey = 'abcdefghijklmnopqrstuvwxyz.@#.,1234567890';
    var charCount = data.length;
    var encrypted = [];
    var kp = 0;
    var kl = encryptionKey.length - 1;

    for (var i = 0; i < charCount; i++) {
      var other = data[i].codeUnits[0] ^ encryptionKey[kp].codeUnits[0];
      encrypted.insert(i, other);
      kp = (kp < kl) ? (++kp) : (0);
    }
    return dataToString(encrypted);
  }

  static String decrypt(data) {
    return encrypt(data);
  }

  static String dataToString(data) {
    var s = "";
    for (var i = 0; i < data.length; i++) {
      s += String.fromCharCode(data[i]);
    }
    return s;
  }
}

class CompanyEncryption {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));
  static encryptAes(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);

    return encrypted;
  }

  static decryptAES(text) {
    return encrypter.decrypt64(text, iv: iv);
  }

  static final keySalsa20 = encrypt.Key.fromLength(32);
  static final ivSalsa20 = encrypt.IV.fromLength(8);
  static final encrypterSalsa20 =
      encrypt.Encrypter(encrypt.Salsa20(keySalsa20));

  static encryptSalsa20(text) {
    return encrypterSalsa20.encrypt(text, iv: ivSalsa20);
  }

  static decryptSalsa20(text) {
    return encrypterSalsa20.decrypt(text, iv: ivSalsa20);
//return decrypted;
  }
}
