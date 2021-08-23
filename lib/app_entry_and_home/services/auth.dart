import 'package:firebase_auth/firebase_auth.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user_general.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/services/storageService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AuthService {
  //Make an instance of FireBaseAuth
  final FirebaseAuth _authService = FirebaseAuth.instance;

  //TODO: Variable declarations.
  User? firebaseUser;
  String? verificationID;

  //TODO: Create a User object based on fireBaseUser object.
  AccountGateWay _createUserObjectFromFirebaseUserObject(User? fUser) {
    if (fUser != null) {
      print("Ellis => User: ${fUser.uid}");
      print("Ellis => Email Verified: ${fUser.emailVerified}");
      return AccountGateWay(
        id: fUser.uid,
        emv: fUser.emailVerified,
      );
    } else
      return AccountGateWay(
        id: "",
        emv: false,
      );
  }

  //TODO: Checks to see if the user is signed in or not.
  Stream<AccountGateWay> get authStateChanges {
    return _authService.authStateChanges().map(
          _createUserObjectFromFirebaseUserObject,
        );
  }

  //TODO: Sign user in anonymously.
  Future signInAnonymously() async {
    try {
      firebaseUser = (await _authService.signInAnonymously()).user;
      //firebaseUser = result.user;

      /*User newSparkUser = User(
          uid: firebaseUser.uid,
          username: 'Sparks User',
          email: 'sparks_user@sparks.com',
          phoneNumber: '+234SPARKS0000');*/

      /*await DatabaseService(loggedInUserID: firebaseUser.uid)
          .storeAndUpdateUserData(newSparkUser);
      await DatabaseService(loggedInUserID: firebaseUser.uid)
          .updateUserIsPhoneNumberVerified(
        true,
      );*/

      return _createUserObjectFromFirebaseUserObject(firebaseUser);
    } catch (Exception) {
      return null;
    }
  }

  //TODO: Sign the user in using email and password.
  Future<AccountGateWay?> signInWithEmailAndPassword(
      String email, String password) async {
    AccountGateWay? user;

    try {
      UserCredential result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        user = _createUserObjectFromFirebaseUserObject(firebaseUser);
      } else
        return null;
    } catch (e) {
      return null;
    }

    return user;
  }

  //TODO: Send OTP to user's phone number.
  Future<AccountGateWay?> sendCodeToPhoneNumber(
      String incomingPhoneNumber, String optCode) async {
    User? firebaseUser;
    AccountGateWay? user;

    await _authService.verifyPhoneNumber(
      phoneNumber: incomingPhoneNumber,
      timeout: const Duration(seconds: 5),
      verificationCompleted: (AuthCredential authCredential) async {
        try {
          UserCredential authResult =
              await FirebaseAuth.instance.signInWithCredential(authCredential);

          firebaseUser = authResult.user;

          if (firebaseUser != null) {
            //TODO: Update this global variable if the user's phone number is validated.
            GlobalVariables.isPhoneNumberVerified = true;

            //TODO: Get the user's phone auth ID created by firebase authentication
            GlobalVariables.userPhoneAuthID = firebaseUser!.uid;

            user = _createUserObjectFromFirebaseUserObject(firebaseUser);

            if (user != null) {
              _authService.signOut();
            } else {
              user = null;
            }
          } else {
            user = null;
          }

          GlobalVariables.phoneAuthException = null;
        } catch (e) {
          GlobalVariables.phoneAuthException = e.toString();
        }
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(authException.message);
      },
      codeSent: (String verificationID, [int? forceResendingToken]) async {
        AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID,
          smsCode: optCode,
        );

        try {
          UserCredential authResult =
              await FirebaseAuth.instance.signInWithCredential(credential);

          firebaseUser = authResult.user;

          if (firebaseUser != null) {
            //TODO: Update this global variable if the user's phone number is validated.
            GlobalVariables.isPhoneNumberVerified = true;

            //TODO: Get the user's phone auth ID created by firebase authentication
            GlobalVariables.userPhoneAuthID = firebaseUser!.uid;

            user = _createUserObjectFromFirebaseUserObject(firebaseUser);

            if (user != null) {
              _authService.signOut();
            } else {
              user = null;
            }
          } else {
            user = null;
          }

          GlobalVariables.phoneAuthException = null;
        } catch (e) {
          GlobalVariables.phoneAuthException = e.toString();
        }
      },
      codeAutoRetrievalTimeout: (String verificationID) {},
    );

    return user;
  }

  //TODO: Register a new user using email and password. (Personal)
  Future<String> registerNewUserWithEmailAndPassword(
      String email, String password) async {
    try {
      User fireBaseUser = (await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      //TODO: Get the UID
      GlobalVariables.personalUID = fireBaseUser.uid;

      //TODO: Send an email verification to the user.
      await fireBaseUser.sendEmailVerification();

      //TODO: create a Sparks user object to hold user data and store it in cloud firestore.
      SparksUserGeneral sparksUserGeneral = SparksUserGeneral(
        acct: [GlobalVariables.accountSelected],
        phne: [
          {
            "ph": GlobalVariables.phoneNumber,
            "pnVd": GlobalVariables.userPhoneAuthID,
            "isPh": GlobalVariables.isPhoneNumberVerified,
          }
        ],
        tkn: GlobalVariables.personalTokenID[0],
        sts: GlobalVariables.accountStatus,
        ol: true,
        em: fireBaseUser.email,
        emv: fireBaseUser.emailVerified,
      );

      SparksUser sparksUser = SparksUser(
        id: GlobalVariables.personalUID,
        nm: {"fn": GlobalVariables.firstName, "ln": GlobalVariables.lastName},
        pimg: GlobalVariables.profileImageDownloadUrl,
        addr: {
          "cty": GlobalVariables.country,
          "st": GlobalVariables.state,
          "ctyR": GlobalVariables.isCountryOFResidence,
          "stR": GlobalVariables.isStateOfResidence
        },
        bdate: GlobalVariables.dob,
        sex: GlobalVariables.gender,
        marst: GlobalVariables.maritalStatus,
        lang: GlobalVariables.spokenLanguages,
        hobb: GlobalVariables.hobbies,
        aoi: GlobalVariables.areaOfInterest,
        ind: GlobalVariables.userIndustries,
        spec: GlobalVariables.specialities,
        schVt: false,
        isMen: GlobalVariables.amAMentor,
        un: GlobalVariables.username,
        em: GlobalVariables.email,
        emv: false,
        crAt: DateTime.now(),
      );

      //TODO: upload user's data to cloud firestore.
      DatabaseService(loggedInUserID: GlobalVariables.personalUID)
          .createNewUserAccount(sparksUserGeneral, sparksUser);

      //TODO: Upload the user's profile image to cloud firebase storage.
      StorageService(userID: GlobalVariables.personalUID).uploadProfileImage(
          GlobalVariables.profileImage!, GlobalVariables.userProfileImage!);
    } catch (Exception) {
      Exception.toString();
    }

    return 'Success';
  }

  //TODO: This handles password recovery.
  Future<String> passwordRecovery(String userEmail) async {
    await _authService.sendPasswordResetEmail(email: userEmail);
    return kPasswordResetMgs;
  }

  //TODO: Sign out the current user from Sparks.
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (exception) {
     exception.toString();
    }
  }
}
