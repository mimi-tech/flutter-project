import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/sparksCompanies/class/e_expert.dart';
import 'package:sparks/classroom/sparksCompanies/class/e_staff.dart';
import 'package:sparks/classroom/sparksCompanies/delete_text.dart';
import 'package:sparks/classroom/sparksCompanies/yesNo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

class ECompanies extends StatefulWidget {
  @override
  _ECompaniesState createState() => _ECompaniesState();
}

class _ECompaniesState extends State<ECompanies> {
  bool progress = false;
  var itemsData = [];
  var _documents = [];
  bool _publishModal = false;
  bool _loadMoreProgress = false;
  late var _lastDocument;
  DocumentSnapshot? result;
  bool moreData = false;
  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: itemsData.length == 0 && progress == false
                ? Center(child: ProgressIndicatorState())
                : itemsData.length == 0 && progress == true
                    ? NoContentCreated(
                        title: 'No expert company have been registered yet',
                      )
                    : Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: _documents.length,
                              itemBuilder: (context, int index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _seeStaff(index);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: itemsData[index]
                                                        ['pix'],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: kImageWidth.w,
                                                      height: kImageHeight.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        itemsData[index]['fn'],
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                                textStyle:
                                                                    TextStyle(
                                                          color: kBlackcolor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              kFontsize.sp,
                                                        )),
                                                      ),
                                                      Text(
                                                        itemsData[index]['ln'],
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                                textStyle:
                                                                    TextStyle(
                                                          color: kBlackcolor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              kFontsize.sp,
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.view_agenda,
                                                        color: kLightGrey,
                                                      ),
                                                      onPressed: () {
                                                        _seeExpert(index);
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: kRed,
                                                      ),
                                                      onPressed: () {
                                                        _deleteCompany(index);
                                                      })
                                                ],
                                              ),
                                              Divider(),
                                              RichText(
                                                text: TextSpan(
                                                    text: 'Company Name: ',
                                                    style: GoogleFonts.oxanium(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: kFontsize.sp,
                                                      color: kMaincolor,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: itemsData[index]
                                                            ['name'],
                                                        style:
                                                            GoogleFonts.oxanium(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              kFontsize.sp,
                                                          color: kBlackcolor,
                                                        ),
                                                      )
                                                    ]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                          progress == true ||
                                  _loadMoreProgress == true ||
                                  _documents.length < UploadVariables.limit
                              ? Text('')
                              : moreData == true
                                  ? PlatformCircularProgressIndicator()
                                  : GestureDetector(
                                      onTap: () {
                                        loadMore();
                                      },
                                      child: SvgPicture.asset(
                                        'images/classroom/load_more.svg',
                                      ))
                        ],
                      )));
  }

  Future<void> getCompanies() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('expertCompany')
          .orderBy('date', descending: true)
          .limit(UploadVariables.limit)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        setState(() {
          progress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          setState(() {
            _documents.add(document);
            itemsData.add(document.data());

            // PageConstants.getCompanies.clear();
          });
        }
      }
    } catch (e) {
      // return CircularProgressIndicator();
    }
  }

  Future<void> loadMore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('expertCompany')
        .orderBy('date', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(UploadVariables.limit)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
      for (DocumentSnapshot result in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(result);
          itemsData.add(result.data);

          moreData = false;
        });
      }
    }
  }

  void _seeStaff(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SeeExpertStaff(index: index, doc: itemsData));
  }

  void _seeExpert(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SeeExpert(index: index, doc: itemsData));
  }

  void _deleteCompany(int index) {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Container(
                  child: Text(
                    'Delete ${itemsData[index]['name']} company'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                      color: kMaincolor,
                      fontWeight: FontWeight.bold,
                      fontSize: kFontsize.sp,
                    )),
                  ),
                ),
                content: DeleteText(
                  title: '$kDC ',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Yes'),
                    onPressed: () {
                      _deleteCom(index);
                    },
                  ),
                ],
              )
            : SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                title: Container(
                  child: Text(
                    'Delete ${itemsData[index]['name']} company'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                      color: kMaincolor,
                      fontWeight: FontWeight.bold,
                      fontSize: kFontsize.sp,
                    )),
                  ),
                ),
                children: <Widget>[
                  DeleteText(
                    title: '$kDC ',
                  ),
                  _publishModal
                      ? PlatformCircularProgressIndicator()
                      : YesNoBtn(
                          no: () {
                            Navigator.pop(context);
                          },
                          yes: () {
                            _deleteCom(index);
                          },
                        )
                ],
              ));
  }

  void _deleteCom(int index) {
    try {
      setState(() {
        _publishModal = true;
      });
      FirebaseFirestore.instance
          .collection('expertCompany')
          .doc(itemsData[index]['did'])
          .delete();

      setState(() {
        _publishModal = false;
        _documents.remove(index);
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'deleted successfully',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: kAGreen,
          textColor: kWhitecolor);
    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      Navigator.pop(context);
    }
  }
}
