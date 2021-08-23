import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/appbar.dart';
import 'package:sparks/classroom/contents/appbar2.dart';
import 'package:sparks/classroom/contents/drawer.dart';
import 'package:sparks/classroom/contents/edit_publish.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';

import 'package:sparks/classroom/contents/live/publishIcons.dart';
import 'package:sparks/classroom/contents/live/text.dart';
import 'package:sparks/classroom/contents/live/text2.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';

import 'package:sparks/classroom/contents/top_app.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PublishedLive extends StatefulWidget {
  @override
  _PublishedLiveState createState() => _PublishedLiveState();
}

class _PublishedLiveState extends State<PublishedLive> {
  bool _publishModal = false;
  String uid = "";
  var items = [];
  static late DateTime liveDate;
  static final now = DateTime.now();
  bool? checkDate;

  Widget goingLive() {
    if (checkDate == true) {
      return SvgPicture.asset('images/classroom/video.svg');
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //UploadVariables.searchController = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: TopAppBar(),
            drawer: DrawerBar(),
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: CustomScrollView(slivers: <Widget>[
                SilverAppBar(
                  matches: kSappbarcolor,
                  friends: kSappbarcolor,
                  classroom: kSappbarcolor,
                  content: kStabcolor1,
                ),
                SilverAppBarSecond(
                  tutorialColor: kBlackcolor,
                  coursesColor: kBlackcolor,
                  expertColor: kBlackcolor,
                  eventsColor: kBlackcolor,
                  publishColor: kStabcolor,
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("sessionContent")
                          .doc(UploadVariables.currentUser)
                          .collection('publishedLive')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: ProgressIndicatorState(),
                          );
                        } else {
                          if (!snapshot.hasData) {
                            return NoPlayListCreated();
                          } else {
                            final List<DocumentSnapshot> documents =
                                snapshot.data!.docs;

                            return documents.length == 0
                                ? NoContentCreated(
                                    title: kNoContentTitle,
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: documents.length,
                                    itemBuilder: (context, int index) {
                                      liveDate = DateTime.parse(
                                          snapshot.data!.docs[index]['dt']);
                                      checkDate = liveDate.isBefore(now);
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 20.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 18.0,
                                              top: 10.0,
                                              left: 8.0,
                                              right: 8.0),
                                          //ToDo:displaying the icons
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: goingLive()),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  PublishedShowIcons(
                                                    //ToDo:Edit content
                                                    edit: () {
                                                      //editPublishedPost(context, documents[index], index);
                                                      UploadVariables
                                                          .cThumbnail = snapshot
                                                              .data!.docs[index]
                                                          ['tmb'];

                                                      UploadVariables.cTitle =
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['title'];
                                                      UploadVariables.cDesc =
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['desc'];
                                                      UploadVariables.cLimit =
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['alimit'];
                                                      UploadVariables.cAge =
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['age'];
                                                      UploadVariables
                                                              .cDocumentId =
                                                          documents[index].id;
                                                      UploadVariables
                                                              .cVisibility =
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['visi'];

                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditPublishedPost()));
                                                    },

                                                    //ToDo:deleting of document
                                                    delete: () {
                                                      Navigator.pop(context);
                                                      _onTapItem(context,
                                                          documents[index]);
                                                    },

                                                    //ToDo:Copying link

                                                    copyLink: () {
                                                      Clipboard.setData(ClipboardData(
                                                          text: 'https://sparksuniverse.com/' +
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['vi_id']));
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
                                                      Navigator.pop(context);
                                                    },
                                                  ),

                                                  SizedBox(width: 5.0),
                                                  //ToDo:Display the live videos

                                                  CachedNetworkImage(
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    imageUrl: snapshot.data!
                                                        .docs[index]['tmb']
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    width: ScreenUtil()
                                                        .setWidth(100),
                                                    height: ScreenUtil()
                                                        .setHeight(100),
                                                  ),

                                                  SizedBox(
                                                    height: 10.0,
                                                  ),

                                                  //ToDo:live text display
                                                  LiveText(
                                                    title: snapshot.data!
                                                        .docs[index]['title'],
                                                    desc: snapshot.data!
                                                        .docs[index]['desc'],
                                                    rate: snapshot.data!
                                                        .docs[index]['rate']
                                                        .toString(),
                                                    date: snapshot.data!
                                                        .docs[index]['date'],
                                                    views: snapshot.data!
                                                        .docs[index]['views']
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),

                                              //ToDo:displaying the linear progress bar

                                              Divider(
                                                color: kAshthumbnailcolor,
                                                thickness: kThickness,
                                              ),

                                              //ToDo:Displaying the live text second
                                              LiveTextSecond(
                                                visibility: snapshot
                                                    .data!.docs[index]['visi'],
                                                aLimit: snapshot.data!
                                                    .docs[index]['alimit'],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                          }
                        }
                      })
                ]))
              ]),
            )));
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  DeleteDialog(oneDelete: () async {
                    if (UploadVariables.monVal == true) {
                      Navigator.pop(context);
                      _publishModal = true;
                      User currentUser = FirebaseAuth.instance.currentUser!;
                      await FirebaseFirestore.instance
                          .collection('sessionContent')
                          .doc(currentUser.uid)
                          .collection('publishedLive')
                          .doc(document.id)
                          .delete();
                      _publishModal = false;
                      Fluttertoast.showToast(
                          msg: kSdeletedsuuccessfully,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kSsprogresscompleted);
                    } else {
                      Fluttertoast.showToast(
                          msg: kuncheckwarning,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kFbColor);
                    }
                  })
                ]));
  }
}
