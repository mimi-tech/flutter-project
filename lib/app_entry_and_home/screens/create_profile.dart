import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/alumni/alumniEntry.dart';
import 'package:sparks/alumni/alumni_registration.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user_general.dart';
import 'package:sparks/app_entry_and_home/reusables/home_appBar.dart';
import 'package:sparks/app_entry_and_home/reusables/modified_smaller_fab.dart';
import 'package:sparks/app_entry_and_home/reusables/smaller_fab.dart';
import 'package:sparks/app_entry_and_home/reusables/sparks_bottom_menu.dart';
import 'package:sparks/app_entry_and_home/screens/bookmark_screen.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_tour_screen.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_social.dart';
import 'package:sparks/app_entry_and_home/services/auth.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/jobs/screens/jobs.dart';
import 'package:sparks/market/screens/market_home.dart';
import 'package:sparks/classroom/golive/bottomsheet_widget_first.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/utils/entery.dart';
import 'package:sparks/social/socialContent/NewMatches/new_matches_live.dart';

class CreateSparksProfile extends StatefulWidget {
  static String id = kSparks_create_profile;
  static int tabClicked = 3;
  String? accountName;

  CreateSparksProfile({
    this.accountName,
  });

  @override
  _CreateSparksProfileState createState() => _CreateSparksProfileState();
}

class _CreateSparksProfileState extends State<CreateSparksProfile> {
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.HOME;
  FabActivity? fabCurrentState;
  bool? isPressed;
  AuthService _authService = AuthService();
  Widget customAppBarWithView = CustomScrollView();
  bool? isSparksAppBarVisible;
  Future<dynamic>? loggedInUser;
  bool drawerInfo = false;

  bool hasVisitedSchool = false;

  _getLoggedInUser() async {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return await DatabaseService(loggedInUserID: firebaseUser.uid)
        .loggedInUserProfileWithDefaultAccount("Personal");
  }

  //TODO: Check if it is the first time a user is visiting the school/alumni tab
  void checkSchoolAccount() async {
    DocumentSnapshot docSnap = await _getLoggedInUser();

    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

    //Todo: check if user has visited school account
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(data["id"])
        .collection("Personal")
        .where('schVt', isEqualTo: true)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    print(documents.length);
    if (documents.length == 1) {
      setState(() {
        hasVisitedSchool = true;
      });
      //TODO: Route the user to the desired screen if true
    } else {
      //TODO: Route the user to the desired screen if false
    }
  }

  @override
  void initState() {
    fabCurrentState = FabActivity.CLOSE;
    isPressed = false;
    isSparksAppBarVisible = false;

    loggedInUser = _getLoggedInUser();
    checkSchoolAccount();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountGateWay = Provider.of<AccountGateWay>(context, listen: false);

    /// Rebuild the section called manage account
    Widget managingUsersAccount() {
      Widget mA;

      mA = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.allMyAccountTypes, accountGateWay.id),
      );

      return mA;
    }

    /// Displays all the accounts and show the one that is active
    Widget settingActiveAcct() {
      Widget activeAcct = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.updatedAcct, accountGateWay.id),
      );

      return activeAcct;
    }

    //TODO: Stores the basic info that is associated with all the accounts
    basicProfileFile() async {
      DocumentSnapshot generalProfileInfo = await DatabaseService(
              loggedInUserID: GlobalVariables.loggedInUserObject.id)
          .profileInfoFromCollection();
      SparksUserGeneral sug = SparksUserGeneral.fromJson(
          generalProfileInfo.data() as Map<String, dynamic>);
      GlobalVariables.basicProfileInfo = sug;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          fabCurrentState = FabActivity.CLOSE;
        });
      },
      child: FutureBuilder<dynamic>(
        future: loggedInUser,
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.active) &&
              (snapshot.hasData == false)) {
            return Container(
              child: Center(
                child: SpinKitDoubleBounce(
                  color: kFormLabelColour,
                ),
              ),
            );
          } else if ((snapshot.connectionState == ConnectionState.done) &&
              (snapshot.hasData == true)) {
            //TODO: Create a SparksUser object from the snapshot.
            DocumentSnapshot personalData = snapshot.data;
            SparksUser user = SparksUser.fromJson(
                personalData.data() as Map<String, dynamic>);

            //TODO: Store the user object that is created.
            GlobalVariables.loggedInUserObject = user;
            basicProfileFile();

            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: SafeArea(
                child: Scaffold(
                  drawer: Drawer(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            color: kLight_orange,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                //TODO: Display profile image on drawer.
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.16,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Center(
                                        child: ClipOval(
                                          child: snapshot.hasData
                                              ? CachedNetworkImage(
                                                  imageUrl: "${user.pimg}",
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                )
                                              : Image.asset(
                                                  "images/app_entry_and_home/profile_image.png"),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: CircleAvatar(
                                            backgroundColor: user.id != null
                                                ? kResendColor
                                                : kHintColor,
                                            maxRadius: 7.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                //TODO: Display user status
                                Center(
                                  child: GlobalVariables.accountStatus ==
                                          "FRIEND"
                                      ? SizedBox.shrink()
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            border: Border(
                                              top: BorderSide(
                                                width: 1.0,
                                                color: kLight_red,
                                              ),
                                              right: BorderSide(
                                                width: 1.0,
                                                color: kLight_red,
                                              ),
                                              bottom: BorderSide(
                                                width: 1.0,
                                                color: kLight_red,
                                              ),
                                              left: BorderSide(
                                                width: 1.0,
                                                color: kLight_red,
                                              ),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${GlobalVariables.accountStatus}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontSize: kSize_17.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: kLight_red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                //TODO: Display user's fullName.
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                      child: Text(
                                        snapshot.hasData
                                            ? user.nm!["fn"]! +
                                                " " +
                                                user.nm!["ln"]!
                                            : "",
                                        style: TextStyle(
                                          color: kWhiteColour,
                                          fontSize: kFontSizeAnonynousUser.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Rajdhani',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //TODO: Display user's email.
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  child: Center(
                                    child: Text(
                                      GlobalVariables.loggedInUserObject.em!,
                                      style: TextStyle(
                                        color: kLight_red,
                                        fontSize: kSize_14.sp,
                                        fontFamily: 'Rajdhani',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          //TODO: Manage accounts
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02,
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          kManageAcc,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontSize: kFont_size.sp,
                                              color: kLight_orange,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return PersonalReg();
                                                },
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.add,
                                          ),
                                          iconSize: 40.0,
                                          padding: EdgeInsets.all(0.0),
                                          color: kLight_orange,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  //TODO: Display all the account a user has and show the account that is active.
                                  GlobalVariables.updatedAcct.isEmpty
                                      ? managingUsersAccount()
                                      : settingActiveAcct(),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                            color: kLight_orange,
                          ),
                          //TODO: Creating a bookmark menu
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.05,
                              color: kWhitecolor,
                              child: TextButton(
                                onPressed: () {
                                  //TODO: Route user to the bookmark screen
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(
                                      context, BookmarkScreen.id);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Icon(
                                          Icons.bookmark,
                                          color: kLight_orange,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          kBookmark,
                                          style: TextStyle(
                                            color: kLight_orange,
                                            fontSize: kFontSizeAnonynousUser.sp,
                                            fontFamily: 'Rajdhani',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          //TODO: Display the logout button.
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.08,
                              color: kLight_orange,
                              child: TextButton(
                                onPressed: () async {
                                  await _authService.signOut();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SparksLandingTourScreen();
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Icon(
                                          Icons.power_settings_new,
                                          color: kWhiteColour,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Logout",
                                          style: TextStyle(
                                            color: kWhiteColour,
                                            fontSize: kFontSizeAnonynousUser.sp,
                                            fontFamily: 'Rajdhani',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: Stack(
                    children: <Widget>[
                      //TODO: Displays a dynamic content for all bottom menus when clicked.
                      isSparksAppBarVisible == true
                          ? customAppBarWithView
                          : HomeAppBarWithCustomScrollView(
                              profileImageUrl: (snapshot.hasData
                                      ? CachedNetworkImageProvider(
                                          "${snapshot.data["pimg"]}",
                                        )
                                      : AssetImage(
                                          "images/app_entry_and_home/profile_image.png"))
                                  as ImageProvider<Object>,
                              accName: "Personal",
                            ),
                      //TODO: Display smaller FAB.
                      Align(
                        alignment: Alignment.bottomRight,
                        child: fabCurrentState == FabActivity.CLOSE
                            ? Visibility(
                                visible: false,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.01,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.06,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  color: kTransparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      ModifiedSmallerFab(
                                        heroTag: "nftFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/create_post.svg",
                                        smallFabOnPressed: () {
                                          //TODO: Do something when this fab button is pressed.

                                          print('one pressed');
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                      ModifiedSmallerFab(
                                        heroTag: "ftFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/hub_and_tv.svg",
                                        smallFabOnPressed: () {
                                          //TODO: Do something when this fab button is pressed.

                                          print('one pressed');
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                      ModifiedSmallerFab(
                                        heroTag: "sFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/cart.svg",
                                        smallFabOnPressed: () {
                                          //TODO: Do something when this fab button is pressed.
                                          print("Second button form the top");
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                      ModifiedSmallerFab(
                                        heroTag: "tFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/create_new_jobs.svg",
                                        smallFabOnPressed: () {
                                          //TODO: Do something when this fab button is pressed.
                                          print("Third button form the top");
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Visibility(
                                visible: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 5),
                                  curve: Curves.bounceIn,
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.01,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.06,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  color: kTransparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      ModifiedSmallerFab(
                                        heroTag: "nftFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/create_post.svg",
                                        smallFabOnPressed: () async {
                                          //TODO: Do something when this fab button is pressed.

                                          setState(() {
                                            isPressed == true
                                                ? isPressed = false
                                                : isPressed = true;
                                            isPressed == false
                                                ? fabCurrentState =
                                                    FabActivity.CLOSE
                                                : fabCurrentState =
                                                    FabActivity.OPEN;
                                          });

                                          /*User? currentUser = FirebaseAuth
                                              .instance.currentUser;
                                          */ /*getting the uid of the user currently logged in*/ /*
                                          setState(() {
                                            UploadVariables.currentUser =
                                                currentUser!.uid;
                                          });

                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  BottomSheetWidget());*/
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                      ModifiedSmallerFab(
                                        heroTag: "ftFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/hub_and_tv.svg",
                                        smallFabOnPressed: () async {
                                          //TODO: Do something when this fab button is pressed.

                                          setState(() {
                                            isPressed == true
                                                ? isPressed = false
                                                : isPressed = true;
                                            isPressed == false
                                                ? fabCurrentState =
                                                    FabActivity.CLOSE
                                                : fabCurrentState =
                                                    FabActivity.OPEN;
                                          });

                                          /*User? currentUser = FirebaseAuth
                                              .instance.currentUser;
                                          */ /*getting the uid of the user currently logged in*/ /*
                                          setState(() {
                                            UploadVariables.currentUser =
                                                currentUser!.uid;
                                          });

                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  BottomSheetWidget());*/
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                      ModifiedSmallerFab(
                                        heroTag: "sFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/cart.svg",
                                        smallFabOnPressed: () {
                                          print('number two');
                                          setState(() {
                                            isPressed == true
                                                ? isPressed = false
                                                : isPressed = true;
                                            isPressed == false
                                                ? fabCurrentState =
                                                    FabActivity.CLOSE
                                                : fabCurrentState =
                                                    FabActivity.OPEN;
                                          });
                                          //TODO: Do something when this fab button is pressed.
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                      ModifiedSmallerFab(
                                        heroTag: "tFAB",
                                        imageName:
                                            "images/app_entry_and_home/new_images/create_new_jobs.svg",
                                        smallFabOnPressed: () {
                                          setState(() {
                                            isPressed == true
                                                ? isPressed = false
                                                : isPressed = true;
                                            isPressed == false
                                                ? fabCurrentState =
                                                    FabActivity.CLOSE
                                                : fabCurrentState =
                                                    FabActivity.OPEN;
                                          });
                                          //TODO: Do something when this fab button is pressed.
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: BottomAppBar(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.065,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SparksButtonAppBarMenu(
                                menuIcon: "images/app_entry_and_home/home.svg",
                                menuItemColor:
                                    bottomMenuPressed == SparksBottomMenu.HOME
                                        ? kBottom_menu_items_active
                                        : kBottom_menu_items_in_active,
                                menuPressed: () {
                                  setState(() {
                                    isSparksAppBarVisible = true;
                                    bottomMenuPressed = SparksBottomMenu.HOME;
                                    customAppBarWithView =
                                        HomeAppBarWithCustomScrollView(
                                      profileImageUrl: (snapshot.hasData
                                              ? CachedNetworkImageProvider(
                                                  "${snapshot.data["pimg"]}",
                                                )
                                              : AssetImage(
                                                  "images/app_entry_and_home/profile_image.png"))
                                          as ImageProvider<Object>,
                                      accName: "Personal",
                                    );
                                  });
                                },
                              ),

                              ///Sparks social was changed to sparks tv.
                              SparksButtonAppBarMenu(
                                menuIcon:
                                    "images/app_entry_and_home/new_images/sparks_tv.svg",
                                menuItemColor: bottomMenuPressed ==
                                        SparksBottomMenu.SPARKS_TV
                                    ? kBottom_menu_items_active
                                    : kBottom_menu_items_in_active,
                                menuPressed: () {
                                  setState(() {
                                    bottomMenuPressed =
                                        SparksBottomMenu.SPARKS_TV;

                                    ///Route the user to sparks tv screen
                                  });
                                },
                              ),

                              ///Sparks alunmi has been repositioned to have mentors hub.
                              SparksButtonAppBarMenu(
                                menuIcon:
                                    "images/app_entry_and_home/new_images/mentors_hub.svg",
                                menuItemColor: bottomMenuPressed ==
                                        SparksBottomMenu.MENTORS_HUB
                                    ? kBottom_menu_items_active
                                    : kBottom_menu_items_in_active,
                                menuPressed: () {
                                  setState(() {
                                    isSparksAppBarVisible = true;
                                    bottomMenuPressed =
                                        SparksBottomMenu.MENTORS_HUB;

                                    /*hasVisitedSchool
                                        ? Navigator.pushNamed(
                                            context, School.id)
                                        : Navigator.pushNamed(
                                            context, Registration.id);*/

                                    ///Route the user to mentor's hub screen.
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SocialNewMatchesLive();
                                        },
                                      ),
                                    );
                                  });
                                },
                              ),

                              ///Sparks market has been repositioned to have sparks school.
                              SparksButtonAppBarMenu(
                                menuIcon:
                                    "images/app_entry_and_home/new_images/school.svg",
                                menuItemColor:
                                    bottomMenuPressed == SparksBottomMenu.ALUMNI
                                        ? kBottom_menu_items_active
                                        : kBottom_menu_items_in_active,
                                menuPressed: () {
                                  setState(() {
                                    bottomMenuPressed = SparksBottomMenu.ALUMNI;

                                    ///Route the user to sparks school screen.
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EntryScreen();
                                        },
                                      ),
                                    );
                                  });
                                },
                              ),

                              ///Sparks jobs has been repositioned to have sparks market.
                              SparksButtonAppBarMenu(
                                menuIcon:
                                    "images/app_entry_and_home/new_images/new_market.svg",
                                menuItemColor:
                                    bottomMenuPressed == SparksBottomMenu.MARKET
                                        ? kBottom_menu_items_active
                                        : kBottom_menu_items_in_active,
                                menuPressed: () {
                                  setState(() {
                                    print("hello go ");
                                    bottomMenuPressed = SparksBottomMenu.MARKET;

                                    ///Route the user to sparks market screen.
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    shape: CircularNotchedRectangle(),
                    color: kLight_orange,
                    elevation: 20.0,
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endDocked,
                  floatingActionButton: FloatingActionButton(
                    heroTag: "MainFAB",
                    shape: CircleBorder(
                      side: BorderSide(
                        color: kWhiteColour,
                      ),
                    ),
                    child: fabCurrentState == FabActivity.CLOSE
                        ? Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.012,
                              top: MediaQuery.of(context).size.height * 0.014,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.012,
                            ),
                            width: MediaQuery.of(context).size.width * 0.08,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                "images/app_entry_and_home/sparks_brand_svg.svg",
                                width: MediaQuery.of(context).size.width * 0.05,
                                height:
                                    MediaQuery.of(context).size.height * 0.038,
                                fit: BoxFit.cover,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.clear,
                            size: kSize_40.sp,
                          ),
                    backgroundColor: kProfile,
                    onPressed: () {
                      setState(() {
                        isPressed == true
                            ? isPressed = false
                            : isPressed = true;
                        isPressed == false
                            ? fabCurrentState = FabActivity.CLOSE
                            : fabCurrentState = FabActivity.OPEN;
                      });
                    },
                  ),
                ),
              ),
            );
          } else {
            return Container(
              color: kWhiteColour,
              child: Center(
                child: SpinKitDoubleBounce(
                  color: kFormLabelColour,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
