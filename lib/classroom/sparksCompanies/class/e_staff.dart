import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/sparksCompanies/delete_text.dart';
import 'package:sparks/classroom/sparksCompanies/yesNo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

class SeeExpertStaff extends StatefulWidget {
  SeeExpertStaff({required this.index, required this.doc});
  final List<dynamic> doc;
  final int index;
  @override
  _SeeExpertStaffState createState() => _SeeExpertStaffState();
}

class _SeeExpertStaffState extends State<SeeExpertStaff> {
  bool progress = false;
  var itemsData = [];
  var _documents = [];

  bool _loadMoreProgress = false;
  late var _lastDocument;
  DocumentSnapshot? result;
  bool moreData = false;
  String? filter;
  bool _publishModal = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStaff();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: itemsData.length == 0 && progress == false
                ? Center(child: ProgressIndicatorState())
                : itemsData.length == 0 && progress == true
                    ? NoContentCreated(
                        title: 'No expert company have been registered yet',
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              SizedBox(
                                height: kCH,
                              ),
                              Text(
                                '${widget.doc[widget.index]['name']} staff'
                                    .toUpperCase(),
                                style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                  color: kBlackcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: kFontsize.sp,
                                )),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: _documents.length,
                                  itemBuilder: (context, int index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: itemsData[index]
                                                      ['pimg'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: kImageWidth.w,
                                                    height: kImageHeight.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      itemsData[index]['fn'],
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              textStyle:
                                                                  TextStyle(
                                                        color: kBlackcolor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: kFontsize.sp,
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      itemsData[index]['ln'],
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              textStyle:
                                                                  TextStyle(
                                                        color: kBlackcolor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: kFontsize.sp,
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.copy,
                                                    ),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: itemsData[
                                                                      index]
                                                                  ['ky']));
                                                      Fluttertoast.showToast(
                                                          msg: 'Copied',
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          backgroundColor:
                                                              klistnmber,
                                                          textColor:
                                                              kWhitecolor);
                                                    }),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: kRed,
                                                    ),
                                                    onPressed: () {
                                                      _deleteStaff(index);
                                                    })
                                              ],
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
                            ]),
                          ),
                        ),
                      )));
  }

  Future<void> getStaff() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('expertAdmin')
          .orderBy('ts', descending: true)
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
        .collection('expertAdmin')
        .orderBy('ts', descending: true)
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

  void _deleteStaff(int index) {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Container(
                  child: Text(
                    'Delete staff'.toUpperCase(),
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
                    'Delete Staff'.toUpperCase(),
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
                    title:
                        '$kEC ${itemsData[index]['fn']} ${itemsData[index]['ln']}',
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
          .collection('expertKey')
          .doc(itemsData[index]['id'])
          .delete();

      setState(() {
        _publishModal = false;
        getStaff();
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
