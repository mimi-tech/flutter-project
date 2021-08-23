import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/custom_radio/custom_checkbox.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg3 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg3({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg3State createState() => _PersonalReg3State();
}

class _PersonalReg3State extends State<PersonalReg3>
    with TickerProviderStateMixin {
  File? _selectedFile;
  late AnimationController _controller;
 late Animation<Offset> offset;
  String country = "Select Country";
  String state = "Select State";
  String countrySelected = "";
  late bool sameWithCountry;
  late bool sameWithState;

  //TODO: Create an image uploader dialog.
  Widget imageUploaderDialog(BuildContext context) {
    Dialog imageUploaderDialog = Dialog(
      insetAnimationCurve: Curves.easeInOut,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.28,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    kUpload_image,
                    style: TextStyle(
                      fontSize: kFont_size_18.sp,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            Expanded(
              flex: 8,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getImageUploader(
                            Icons.camera, kCamera, ImageSource.camera),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getImageUploader(
                            Icons.image, kPhoto, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return imageUploaderDialog;
  }

  //TODO: create a reusable widget for camera and gallery.
  Widget getImageUploader(IconData icon, String iconLabel, ImageSource source) {
    return GestureDetector(
      onTap: () async {
        await getImageSource(source);
        Navigator.of(context).pop();
      },
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                icon,
                color: kProfile,
                size: kFont_size_70.sp,
              ),
              Center(
                child: Text(
                  iconLabel,
                  style: TextStyle(
                    fontSize: kFontSizeAnonynousUser.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rajdhani',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Get the source of the image.
  getImageSource(ImageSource source) async {
    XFile? imageSelected = await ImagePicker().pickImage(source: source);
    if (imageSelected != null) {
      File? croppedImage = await ImageCropper.cropImage(
        sourcePath: imageSelected.path,
        aspectRatio: CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        compressQuality: 100,
        maxWidth: (MediaQuery.of(context).size.width * 0.4).floor(),
        maxHeight: (MediaQuery.of(context).size.height * 0.4).floor(),
        compressFormat: ImageCompressFormat.jpg,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: kProfile,
          toolbarTitle: "Sparks Image Cropper",
          statusBarColor: kProfile,
          backgroundColor: kWhiteColour,
        ),
      );

      setState(() {
        _selectedFile = croppedImage;
      });
    }
  }

  @override
  void initState() {
    _selectedFile = null;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    offset = Tween<Offset>(
      begin: Offset(7.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _controller.forward();

    sameWithCountry = false;
    sameWithState = false;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //TODO: Sparks main background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/app_entry_and_home/sparksbg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //TODO: A second faded background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/app_entry_and_home/new_images/faded_spark_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: SizedBox(
                    child: Image(
                      width: 200.0,
                      height: 80.0,
                      image: AssetImage(
                        'images/app_entry_and_home/new_images/sparks_new_logo.png',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "images/app_entry_and_home/new_images/title_bg.png",
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    kProfile_pic_and_location,
                    style: TextStyle(
                      fontSize: kFont_size_18.sp,
                      color: kReg_title_colour,
                      fontFamily: 'Rajdhani',
                    ),
                  ),
                ),
              ),
              //TODO: Page subTitle.
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: kFriends_Fans,
                        style: TextStyle(
                          color: kWhiteColour,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                          fontSize: kFont_size_18.sp,
                        ),
                      ),
                      TextSpan(
                        text: kBrandName,
                        style: TextStyle(
                          color: kProfile,
                          fontFamily: 'Berkshire Swash',
                          fontWeight: FontWeight.w200,
                          fontSize: kFont_size_22.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //TODO: Upload a profile image.
              SlideTransition(
                position: offset,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Card(
                        color: kTransparent,
                        shape: CircleBorder(
                          side: BorderSide(color: kTransparent, width: 0),
                        ),
                        elevation: 8.0,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: kFont_size_66.sp,
                                child: ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: (_selectedFile != null
                                                ? FileImage(_selectedFile!)
                                                : AssetImage(
                                                    "images/app_entry_and_home/profile_image.png"))
                                            as ImageProvider<Object>,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.01,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.022,
                                ),
                                child: GestureDetector(
                                  //TODO: Click to upload an image.
                                  onTap: () async {
                                    await showDialog(
                                      context: this.context,
                                      builder: (context) =>
                                          imageUploaderDialog(context),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: kProfile,
                                    child: Icon(
                                      Icons.camera,
                                      color: kWhiteColour,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SlideTransition(
                      position: offset,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: CustomCheckbox(
                          backgroundColor: sameWithCountry == false
                              ? kTransparent
                              : kProfile,
                          borderColor: sameWithCountry == false
                              ? kWhiteColour
                              : kProfile,
                          checkedWidget: sameWithCountry == false
                              ? Center()
                              : Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: kWhiteColour,
                                  ),
                                ),
                          check: () {
                            setState(() {
                              sameWithCountry == true
                                  ? sameWithCountry = false
                                  : sameWithCountry = true;
                            });
                          },
                          checkboxLabel: kCountry_res_info,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    SlideTransition(
                      position: offset,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            countrySelected = await showDialog(
                              context: context,
                              builder: (context) => WillPopScope(
                                onWillPop: () => Future.value(false),
                                child: Dialog(
                                  insetAnimationCurve: Curves.easeInOut,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 9,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            child: ShowMyDialog(
                                              searchHint: 'Search country',
                                              substringBackground: Colors.green,
                                              substringFontSize: 18.0.sp,
                                              fontStyle: FontStyle.normal,
                                              textColors: Colors.black,
                                              fontSize: 18.0.sp,
                                              substringTextColor: Colors.blueAccent,
                                              fontFamily: 'rajdhani',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context, Variables.country);
                                            },
                                            style: TextButton.styleFrom(
                                              primary: kProfile,
                                              backgroundColor: kProfile,
                                            ),
                                            child: Text(
                                              kClose,
                                              style: TextStyle(
                                                color: kWhiteColour,
                                                fontFamily: 'Rajdhani',
                                                fontWeight: FontWeight.bold,
                                                fontSize: kFont_size_18.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            setState(() {
                              country = countrySelected;
                              if ((country == null) || (country == "")) {
                                country = "Select Country";
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: kWhiteColour,
                                ),
                              ),
                            ),
                            //TODO: Country
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                country,
                                style: GoogleFonts.rajdhani(
                                  fontSize: ScreenUtil().setSp(
                                    kFont_size_18,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  color: kWhiteColour,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SlideTransition(
                      position: offset,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: CustomCheckbox(
                          backgroundColor:
                              sameWithState == false ? kTransparent : kProfile,
                          borderColor:
                              sameWithState == false ? kWhiteColour : kProfile,
                          checkedWidget: sameWithState == false
                              ? Center()
                              : Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: kWhiteColour,
                                  ),
                                ),
                          check: () {
                            setState(() {
                              sameWithState == true
                                  ? sameWithState = false
                                  : sameWithState = true;
                            });
                          },
                          checkboxLabel: kState_res_info,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    SlideTransition(
                      position: offset,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: kWhiteColour,
                              ),
                            ),
                          ),
                          //TODO: State
                          child: GestureDetector(
                            onTap: () async {
                              if ((countrySelected == "") ||
                                  (country == "Select Country")) {
                                //TODO; Display a toast.
                                Fluttertoast.showToast(
                                  msg: kCountry_err,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: kLight_orange,
                                  textColor: kWhiteColour,
                                  fontSize: kSize_16.sp,
                                );
                              } else {
                                String stateSelected = await showDialog(
                                  context: context,
                                  builder: (context) => WillPopScope(
                                    onWillPop: () => Future.value(false),
                                    child: Dialog(
                                      insetAnimationCurve: Curves.easeInOut,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 9,
                                            child: SingleChildScrollView(
                                              child: Container(
                                                child: StateDialog(
                                                  substringBackground: Colors.green,
                                                  substringFontSize: 18.0.sp,
                                                  fontStyle: FontStyle.normal,
                                                  textColors: Colors.black,
                                                  fontSize: 18.0.sp,
                                                  substringTextColor: Colors.blueAccent,
                                                  fontFamily: 'rajdhani',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, Variables.state);
                                                },
                                                style: TextButton.styleFrom(
                                                  primary: kProfile,
                                                  backgroundColor: kProfile,
                                                ),
                                                child: Text(
                                                  kClose,
                                                  style: TextStyle(
                                                    color: kWhiteColour,
                                                    fontFamily: 'Rajdhani',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: kFont_size_18.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                setState(() {
                                  state = stateSelected;
                                  if ((state == null) || (state == "")) {
                                    state = "Select State";
                                  }
                                });
                              }
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state,
                                style: GoogleFonts.rajdhani(
                                  fontSize: ScreenUtil().setSp(
                                    kFont_size_18,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  color: kWhiteColour,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    //TODO: Displays both progressbar and next button.
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.06,
                        right: MediaQuery.of(context).size.width * 0.06,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //TODO: Display progress indicator.
                          PersonalReg().createState().createProgressIndicator(
                              widget.currentPage, context),
                          //TODO: Display a circular next button.
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () async {
                                if ((_selectedFile == null) ||
                                    (country == "") ||
                                    (country == "Select Country") ||
                                    (state == "") ||
                                    (state == "Select State")) {
                                  //TODO; Display a toast.
                                  Fluttertoast.showToast(
                                    msg: kCountry_State_err,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: kLight_orange,
                                    textColor: kWhiteColour,
                                    fontSize: kSize_16.sp,
                                  );
                                } else {
                                  //TODO: Store user input into a global variables
                                  GlobalVariables.userProfileImage =
                                      _selectedFile;
                                  GlobalVariables.profileImage =
                                      _selectedFile!.path.split('/').last;
                                  GlobalVariables.country = country;
                                  GlobalVariables.state = state;
                                  GlobalVariables.isCountryOFResidence =
                                      sameWithCountry;
                                  GlobalVariables.isStateOfResidence =
                                      sameWithState;

                                  setState(() {
                                    //TODO: Go to the fourth page (Personal Account)
                                    widget.pageController.animateToPage(
                                      widget.currentPage.floor(),
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kProfile,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 42.0,
                                    color: kWhiteColour,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
