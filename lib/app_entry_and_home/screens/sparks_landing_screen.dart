import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sparks/alumni/alumniEntry.dart';
import 'package:sparks/alumni/alumni_registration.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/screens/create_profile.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_tour_screen.dart';
import 'package:sparks/app_entry_and_home/screens/verifying_email.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/services/home_messeaging_service.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/market/market_services/market_messaging.dart';
import 'package:sparks/market/screens/market_home.dart';

class SparksLandingScreen extends StatefulWidget {
  static String id = kSparks_landing_screen;

  @override
  _SparksLandingScreenState createState() => _SparksLandingScreenState();
}

//TODO: This is a top-level class that handles background notifications
Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) async {
  return _SparksLandingScreenState()._showNotification(message);
}

class _SparksLandingScreenState extends State<SparksLandingScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool? profileCreated;
  String? defaultAccount;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Ellis => Testing duplication
  int timeFunctionIsCalled = 0;

  //TODO: This functions returns the notificationDetails if we are just rendering a user avatar in the notification
  Future<NotificationDetails> userAvatar(Map<String, dynamic> message) async {
    Image userAvatar = Image.network(message["data"]["pimg"]);

    // final userAvatarPath = await CustomFunctions.saveUserAvatarPath(userAvatar);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // icon: userAvatarPath,
    );

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  //TODO: Show notification
  Future<void> _showNotification(Map<String, dynamic> message) async {
    //TODO: Check for account type
    String? notificationAccountType = message["data"]["acct"];

    switch (notificationAccountType) {
      case "Personal":
        await HomeMessagingService.renderBackgroundNotifications(
            message, flutterLocalNotificationsPlugin);
        break;
      case "Market":
        break;
      case "Company":
        break;
      case "School":
        break;
    }
  }

  //TODO: Cancelling notifications removes the notifications from notification system tray
  Future selectNotification(String? payload) async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  //TODO: Get the current device ID/token ID the user is currently logged in with.
  getDeviceID() async {
    await _firebaseMessaging.getToken().then((tokenID) {
      setState(() {
        GlobalVariables.personalTokenID.add(tokenID);
      });
    });
  }

  /// This method is called in the [onMessage] function of FCM config. It is the
  /// method called when the app is running on the foreground (actively in use)
  Future<dynamic> _firebaseMessagingForegroundHandler(
      Map<String, dynamic> message) async {
    /// NOTE: Add a field "acct" to "data" payload to identify which account the
    /// notification belongs to
    String? account = message["data"]["acct"];

    /// TODO: Add a check to ensure [account] is not "null"

    switch (account) {
      case "market":
        MarketMessaging.marketForegroundHandler(message: message);
        break;

      /// Add your different cases here to handle cloud messaging data
    }
  }

  /// This method is called in the [onResume, & onLaunch] functions of FCM config.
  /// This is the method called when the app is running on the background
  Future<dynamic> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // String account = message["data"]["acct"];
    //
    // switch (account) {
    //   case "market":
    //     MarketMessaging.marketBackgroundHandler(message: message);
    //     break;
    //   case "Personal":
    //     HomeMessagingService.homeBackgroundHandler(message);
    //
    //   /// Add your different cases here to handle cloud messaging data
    // }
  }

  //TODO: Display the corresponding screen based on the default account of the user.
  Future<Widget> getDefaultAccount(AccountGateWay accountGateWay) async {
    timeFunctionIsCalled++;

    print("Ellis => Time function called = $timeFunctionIsCalled");
    late Widget? screen;
    SharedPreferences accPrefs = await SharedPreferences.getInstance();

    //User user = await FirebaseAuth.instance.currentUser();

    /// TODO: Change snapshot datatype to DocumentSnapshot
    dynamic snapshot = await DatabaseService(loggedInUserID: accountGateWay.id)
        .getAllAccountTypes();
    // List<dynamic> uAcc = snapshot.data()["acct"];

    DocumentSnapshot testingOne =
        await DatabaseService(loggedInUserID: accountGateWay.id)
            .getAllAccountTypes();

    Map<String, dynamic> testingTwo = testingOne.data() as Map<String, dynamic>;

    print("Ellis => ${testingTwo["acct"]}");

    final uAcc = testingTwo["acct"];

    print("Ellis => UACC = $uAcc");

    // List<Map<String, dynamic>> uAcc =
    //     snapshot.data()["acct"] as List<Map<String, dynamic>>;

    print("Ellis => uAcc = $uAcc}");

    //TODO: Get the user account status
    GlobalVariables.accountStatus = snapshot.data()["sts"];

    //TODO: Store user account types.
    // for (dynamic acc in uAcc) {
    //   GlobalVariables.allMyAccountTypes.add(acc);
    // }

    /// Ellis => Implementation
    for (Map<String, dynamic> acc in uAcc) {
      GlobalVariables.allMyAccountTypes.add(acc);
    }

    //TODO: Fetch all the account the user has for the purpose of adding a new account type.
    if (GlobalVariables.accountType.isNotEmpty) {
      GlobalVariables.accountType.clear();
      for (Map<String, dynamic> myAccounts in uAcc) {
        GlobalVariables.accountType.add(myAccounts["act"]);
      }
    } else {
      for (Map<String, dynamic> myAccounts in uAcc) {
        GlobalVariables.accountType.add(myAccounts["act"]);
      }
    }

    //TODO: Fetch the default account of the user
    for (int i = 0; i < uAcc.length; i++) {
      if ((uAcc[i]["act"] == "Personal") && (uAcc[i]["dp"] == true)) {
        accPrefs.setString("def", uAcc[i]["act"]);
      } else if ((uAcc[i]["act"] == "School") && (uAcc[i]["dp"] == true)) {
        accPrefs.setString("def", uAcc[i]["act"]);
      } else if ((uAcc[i]["act"] == "Company") && (uAcc[i]["dp"] == true)) {
        accPrefs.setString("def", uAcc[i]["act"]);
      } else if ((uAcc[i]["act"] == "Market") && (uAcc[i]["dp"] == true)) {
        accPrefs.setString("def", uAcc[i]["act"]);
      }
    }

    //TODO: Update user tokenID to the latest tokenID.
    DatabaseService(loggedInUserID: accountGateWay.id)
        .updateTokenID(GlobalVariables.personalTokenID[0]);

    //TODO: Get the number of device(s) the user has used in logging in so far. (max device allowed is 10)
    /*List<dynamic> uDeviceToken = snapshot.data()["tkn"];
    int numberOfDevice = uDeviceToken.length;

    //TODO: Add/remove device id from database.
    numberOfDeviceUsedSoFar(int numberOfDevice) {
      if (numberOfDevice > 10) {
        for (int i = 0; i < (numberOfDevice - 1); i++) {
          DatabaseService(loggedInUserID: accountGateWay.id)
              .removeOldDeviceID(uDeviceToken[i]);
        }
      } else {
        if (uDeviceToken.contains(GlobalVariables.personalTokenID.first) ==
            false) {
          DatabaseService(loggedInUserID: accountGateWay.id)
              .addNewDeviceID(GlobalVariables.personalTokenID.first);
        }
      }
    }*/

    /// Displaying the corresponding screen based on the default account type of the user.
    // if ((accountGateWay != null) && (accountGateWay.emv == true)) {
    //   switch (accPrefs.getString("def")) {
    //     case "Personal":
    //       //numberOfDeviceUsedSoFar(numberOfDevice);
    //       screen = CreateSparksProfile(
    //         accountName: "Personal",
    //       );
    //       break;
    //     case "School":
    //       //numberOfDeviceUsedSoFar(numberOfDevice);
    //       //TODO: Initialize screen widget with the right widget
    //       screen = School();
    //       break;
    //     case "Company":
    //       //numberOfDeviceUsedSoFar(numberOfDevice);
    //       //TODO: Initialize screen widget with the right widget
    //       //screen = CreateSparksProfile(accountName: "Personal",);
    //       break;
    //     case "Market":
    //       //numberOfDeviceUsedSoFar(numberOfDevice);
    //       //TODO: Initialize screen widget with the right widget
    //       screen = MarketHome();
    //   }
    // } else {
    //   print("Screen without email verification");
    //   screen =
    //       VerifyingEmailAddress(); // User is logged in but email is not verified
    // }

    print("Ellis => Before accountGateWay ${accountGateWay.emv}");

    /// Ellis => Implementation
    if (accountGateWay.emv) {
      print("Ellis => Email is verified");
      switch (accPrefs.getString("def")) {
        case "Personal":
          //numberOfDeviceUsedSoFar(numberOfDevice);
          print("Ellis => Account = Personal");
          screen = CreateSparksProfile(
            accountName: "Personal",
          );
          // screen = MarketHome();
          break;
        case "School":
          //numberOfDeviceUsedSoFar(numberOfDevice);
          print("Ellis => Account = School");
          screen = School();
          break;
        case "Company":
          //numberOfDeviceUsedSoFar(numberOfDevice);
          //TODO: Initialize screen widget with the right widget
          //screen = CreateSparksProfile(accountName: "Personal",);
          print("Ellis => Account = Company");
          break;
        case "Market":
          //numberOfDeviceUsedSoFar(numberOfDevice);
          print("Ellis => Account = Market");
          screen = MarketHome();
          break;
      }
    } else {
      print("Screen without email verification");
      print("Ellis => Account = Verify Email Address");
      screen =
          VerifyingEmailAddress(); // User is logged in but email is not verified
    }

    return screen!;
  }

  @override
  void initState() {
    super.initState();

    getDeviceID();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // _firebaseMessaging.configure(
    //   onBackgroundMessage: myBackgroundHandler,
    //   onMessage: _firebaseMessagingForegroundHandler,
    //   onResume: _firebaseMessagingBackgroundHandler,
    //   onLaunch: _firebaseMessagingBackgroundHandler,
    // );

    //TODO: Initializing and setting up flutter local notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('sparks_notification_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  @override
  Widget build(BuildContext context) {
    final AccountGateWay accountGateWay =
        Provider.of<AccountGateWay>(context, listen: false);

    // final accountGateWay = context.read<AccountGateWay?>();

    /// Initialization of the [ScreenUtil] package

    return FutureBuilder<Widget>(
      future: getDefaultAccount(accountGateWay),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
        // if (accountGateWay.id == null) {
        //   return SparksLandingTourScreen();
        //   //return VerifyingEmailAddress();
        // } else if ((accountGateWay != null) &&
        //     (snapshot.connectionState == ConnectionState.done) &&
        //     (snapshot.hasData == false)) {
        //   return Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     color: kWhiteColour,
        //     child: Center(
        //       child: SpinKitDoubleBounce(
        //         color: kFormLabelColour,
        //       ),
        //     ),
        //   );
        // } else if ((accountGateWay != null) &&
        //     (snapshot.connectionState == ConnectionState.done) &&
        //     (snapshot.hasData)) {
        //   return snapshot.data!;
        // } else {
        //   return Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     color: kWhiteColour,
        //     child: Center(
        //       child: SpinKitDoubleBounce(
        //         color: kFormLabelColour,
        //       ),
        //     ),
        //   );
        // }

        /// Ellis => Implementation
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          print("Connection done => No data");
          return SparksLandingTourScreen();
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          print("Connection done => Data present");
          return snapshot.data!;
        } else {
          print("Loading...");
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: kWhiteColour,
            child: Center(
              child: SpinKitDoubleBounce(
                color: kFormLabelColour,
              ),
            ),
          );
        }
      },
    );
  }
}
