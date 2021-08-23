import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/alumni/alumniEntry.dart';
import 'package:sparks/alumni/alumni_registration.dart';
import 'package:sparks/app_entry_and_home/screens/bookmark_screen.dart';
import 'package:sparks/app_entry_and_home/screens/comments.dart';
import 'package:sparks/app_entry_and_home/screens/create_profile.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_social.dart';
import 'package:sparks/app_entry_and_home/services/dynamic_link_service.dart';
import 'package:sparks/dynamic_link/home_dynamic_link.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/market/market_services/navigation_service.dart';
import 'package:sparks/jobs/components/companyDataProvider.dart';
import 'package:sparks/market/providers/market_product_detail_state_manager.dart';
import 'package:sparks/market/providers/new_used_provider.dart';
import 'package:sparks/market/providers/shopping_cart.dart';
import 'package:sparks/market/screens/market_comments.dart';
import 'package:sparks/market/screens/market_home.dart';
import 'package:sparks/market/screens/market_notifications.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/screens/market_product_listing.dart';
import 'package:sparks/market/screens/market_profile.dart';
import 'package:sparks/market/screens/market_search.dart';
import 'package:sparks/market/screens/shopping_cart_screen.dart';
import 'package:sparks/market_registration/m_reg_email_ver.dart';
import 'package:sparks/market_registration/market_reg_phone_verification.dart';
import 'package:sparks/market_registration/market_registration.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/reusables/photo_view.dart';
import 'package:sparks/app_entry_and_home/screens/email_verified_screen.dart';
import 'package:sparks/app_entry_and_home/screens/forgot_password.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/screens/profile_reg_complete.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_tour_screen.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_login_screen.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_signup_screen.dart';
import 'package:sparks/app_entry_and_home/screens/splash_screen.dart';
import 'package:sparks/app_entry_and_home/screens/verifying_email.dart';
import 'package:sparks/app_entry_and_home/screens/view_profile.dart';
import 'package:sparks/app_entry_and_home/services/auth.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:device_preview/device_preview.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/utils/entery.dart';
import 'package:sparks/global_services/service_locator.dart';
import 'package:sparks/social/socialContent/NewMatches/new_matches_live.dart';
import 'package:sparks/utilities/colors.dart';

import 'classroom/golive/publish_live.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  /* Initializing a firebase app. This line of code is called once */
  await Firebase.initializeApp();

  /*This is the starting point of this app*/

  /*flutter download initialization*/
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true); // optional: set false to disable printing logs to console

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });

  /// Commented out this code block ->
  // var initializationSettings = InitializationSettings(
  //     initializationSettingsAndroid, initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //   }
  //   selectNotificationSubject.add(payload);
  // });

  runApp(
    /* DevicePreview(
      builder: (context) => SparksApp(),
    ),*/
    SparksApp(),
  );
}

class SparksApp extends StatefulWidget {
  @override
  _SparksAppState createState() => _SparksAppState();
}

class _SparksAppState extends State<SparksApp> with WidgetsBindingObserver {
  /*  variable declarations */
  final AuthService _authService = AuthService();
  Timer? _timerLink;

  //TODO: this function updates the user's presence. It could be online or offline.
  _isOnlineOrOffline(bool? onlineOfflineStat) async {
    try {
      User? fu = FirebaseAuth.instance.currentUser;
      if (fu != null) {
        DatabaseService(loggedInUserID: fu.uid)
            .updateUserPresence(onlineOfflineStat);
      } else {
        print("User is not logged in");
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        GlobalVariables.isUserOnline = false;
        _isOnlineOrOffline(GlobalVariables.isUserOnline);
        break;
      case AppLifecycleState.paused:
        GlobalVariables.isUserOnline = false;
        _isOnlineOrOffline(GlobalVariables.isUserOnline);
        break;
      case AppLifecycleState.resumed:
        GlobalVariables.isUserOnline = true;
        _isOnlineOrOffline(GlobalVariables.isUserOnline);

        //TODO: Retrieving dynamic link
        _timerLink = Timer(Duration(milliseconds: 1000), () {
          DynamicLinkService.retrieveDynamicLink(context);
        });
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    /* App is always in portrait mode */
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
*/
    /* Sets the statusBar colour of the app */
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        //statusBarColor: stColor,
        statusBarColor: kStatusbar,
      ),
    );
    /* Sets both the top and bottom status bar to be visible*/
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);

    return MultiProvider(
      providers: [
        StreamProvider<AccountGateWay>.value(
          initialData: AccountGateWay(
            id: "",
            emv: false,
          ),
          value: _authService.authStateChanges,
          catchError: (_, err) {
            print(err.toString());
            return AccountGateWay(
              id: "",
              emv: false,
            );
          },
        ),

        /// Ellis => Just testing the new provider implementation
        // StreamProvider<AccountGateWay?>(
        //   initialData: null,
        //   create: (context) => AuthService().authStateChanges,
        // ),
        ChangeNotifierProvider(
          create: (context) => ShoppingCart(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewUsedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MarketProductDetailStateManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => CompanyAccessTest(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 640),
        builder: () => MaterialApp(
          navigatorKey: locator<NavigationService>().navigatorKey,
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()],
          /*locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,*/

          title: kBrandName,

          //TODO: Adding localization delegations and languages supported.
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'), // English
          ],

          /* Removes the debug banner at the extreme right of the app */
          debugShowCheckedModeBanner: false,

          /* The default theme setup */
          theme: ThemeData(
            primaryColorDark: kPrimaryColorDark,
            accentColor: kPrimaryColorDark,
            appBarTheme: AppBarTheme(
              elevation: 0.0,
              color: kAppbarColor,
              iconTheme: IconThemeData(
                color: kWhiteColor,
              ),
            ),

            /*Colors for bottomsheet*/

            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
            ),

            /* Set the default font family */
            fontFamily: "Rajdhani",

            /* Text theme and it's properties. All text theme is defined here. */
            textTheme: TextTheme(
              headline6: TextStyle(
                fontSize: k20,
                fontWeight: FontWeight.w500,
              ),
              headline5: TextStyle(
                fontSize: k24,
                fontWeight: FontWeight.w500,
              ),
              subtitle1: TextStyle(
                fontSize: k14,
                fontWeight: FontWeight.w300,
                fontFamily: "RajdhaniMedium",
              ),
              subtitle2: TextStyle(
                fontSize: kSize_13.sp,
                fontWeight: FontWeight.w400,
                fontFamily: "RajdhaniMedium",
              ),
              caption: TextStyle(
                fontSize: k12,
                fontFamily: "RajdhaniMedium",
                fontWeight: FontWeight.w700,
              ),
              bodyText1: TextStyle(
                color: kWhitecolor,
              ),
            ),
          ),

          /* This the route to the splash screen */
          initialRoute: SplashScreen.id,

          /* This route dictionary points to all the screens in this app. This is
          * where all the routes is defined. */
          routes: {
            SplashScreen.id: (context) => SplashScreen(),
            SparksLoginScreen.id: (context) => SparksLoginScreen(),
            SparksSignUpScreen.id: (context) => SparksSignUpScreen(),
            SparksLandingScreen.id: (context) => SparksLandingScreen(),
            VerifyEmail.id: (context) => VerifyEmail(),
            VerifyingEmailAddress.id: (context) => VerifyingEmailAddress(),
            ResetPassword.id: (context) => ResetPassword(),
            RegistrationCompleted.id: (context) => RegistrationCompleted(),
            HomePostDynamicScreen.id: (context) => HomePostDynamicScreen(),
            SparksSocial.id: (context) => SparksSocial(),

            /// Market Routes
            MarketHome.id: (context) => MarketHome(),
            MarketComments.id: (context) => MarketComments(),
            MarketSearch.id: (context) => MarketSearch(),
            MarketProductListing.id: (context) => MarketProductListing(),
            MarketProductDetails.id: (context) => MarketProductDetails(),
            ShoppingCartScreen.id: (context) => ShoppingCartScreen(),
            MarketNotifications.id: (context) => MarketNotifications(),

            /// Market Registration Routes
            MarketRegistration.id: (context) => MarketRegistration(),
            MarketRegEmailVer.id: (context) => MarketRegEmailVer(),
            MarketRegPhoneVerification.id: (context) =>
                MarketRegPhoneVerification(),

            /// Jobs Routes
            Jobs.id: (context) => Jobs(),

            /// Alumni Routes
            School.id: (context) => School(),
            Registration.id: (context) => EntryScreen(),

            /// Mentors Hub Routes
            SocialNewMatchesLive.id: (context) => SocialNewMatchesLive(),
          },
          //TODO: Page routes that is dependent on page transition.
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case PersonalReg.id:
                return PageTransition(
                  child: PersonalReg(),
                  type: PageTransitionType.scale,
                  duration: Duration(milliseconds: 900),
                );
                break;
              case SparksLandingTourScreen.id:
                return PageTransition(
                  child: SparksLandingTourScreen(),
                  type: PageTransitionType.scale,
                  duration: Duration(milliseconds: 900),
                );
                break;
              case ViewProfile.id:
                return PageTransition(
                  child: ViewProfile(),
                  type: PageTransitionType.scale,
                  duration: Duration(milliseconds: 500),
                );
                break;
              case PhotoView.id:
                return PageTransition(
                  child: PhotoView(),
                  type: PageTransitionType.scale,
                  duration: Duration(milliseconds: 900),
                );
              case SparksComments.commentId:
                return PageTransition(
                  child: SparksComments(),
                  type: PageTransitionType.scale,
                  duration: Duration(milliseconds: 900),
                );
              case BookmarkScreen.id:
                return PageTransition(
                  child: BookmarkScreen(),
                  type: PageTransitionType.scale,
                  duration: Duration(milliseconds: 700),
                );
              default:
                return null;
            }
          },
        ),
      ),
    );
  }
}
