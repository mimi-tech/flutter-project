import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/uploadvideo/createplaylist.dart';

import 'package:sparks/classroom/uploadvideo/edit_playlist.dart';
import 'package:sparks/classroom/uploadvideo/widgets/playlistappbar.dart';
import 'package:sparks/classroom/uploadvideo/widgets/playlistbtn.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool playlistList = false;

  var playlistCheckbox = [];
  TextEditingController searchController = TextEditingController();
  String? filter;
  bool _publishModal = false;
  String? yt;
  @override
  void initState() {
    // TODO: implement initState
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  late DocumentSnapshot _currentDocument;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PlaylistAppbar(),
          backgroundColor: kWhitecolor,
          body: ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                PlayListBtn(
                  name: kCreateplaylist,
                  save: kSave,
                  create: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: CreatePlayList()));
                  },
                  saved: () {
                    sendPlayList();
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                  child: TextField(
                    onChanged: (value) {
                      //filterSearchResults(value);
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: kSearchplaylist,
                      hintStyle: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kTextcolorhintcolor,
                          fontFamily: 'Rajdhani',
                          textBaseline: TextBaseline.ideographic),
                      prefixIcon: Icon(
                        Icons.search,
                        color: kBlackcolor,
                        size: 30.0,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('sessionplaylists')
                        .doc(UploadVariables.currentUser)
                        .collection('userplaylist')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ProgressIndicatorState(),
                        );
                      } else if (!snapshot.hasData) {
                        return NoPlayListCreated();
                      } else {
                        return Column(
                            children: snapshot.data!.docs.map((doc) {
                          Map<String, dynamic> data =
                          doc.data as Map<String, dynamic>;
                          return Container(
                              child: filter == null || filter == ""
                                  ? ListTile(
                                      title: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _currentDocument = doc;
                                            playlistCheckbox.clear();
                                            playlistCheckbox.add(data[
                                                'name']); // .add(data['name']);
                                          });
                                        },
                                        child: Text(
                                            data['name']), // data['name']
                                      ),
                                      leading: playlistCheckbox
                                              .contains(data['name'])
                                          ? Icon(
                                              Icons.radio_button_checked,
                                              color: kbtnsecond,
                                            )
                                          : Icon(Icons.radio_button_unchecked),
                                      trailing: Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _currentDocument = doc;
                                              _deletePlayList();
                                            },
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                child: Icon(
                                                    Icons.delete_forever,
                                                    color: kFbColor)),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditPlayList()));
                                              User currentUser = FirebaseAuth
                                                  .instance.currentUser!;
                                              UploadVariables.currentUser =
                                                  currentUser.uid;
                                              UploadVariables.playlistId =
                                                  data['id'];
                                            },
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 30),
                                                width: 30,
                                                height: 30,
                                                child: Icon(Icons.edit,
                                                    color: klistnmber)),
                                          ),
                                        ],
                                      ))
                                  : '${data['name']}'
                                          .toLowerCase()
                                          .contains(filter!.toLowerCase())
                                      ? ListTile(
                                          title: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentDocument = doc;
                                                  playlistCheckbox.clear();
                                                  playlistCheckbox
                                                      .add(data['name']);
                                                });
                                              },
                                              child: Text(data['name'])),
                                          leading: playlistCheckbox
                                                  .contains(data['name'])
                                              ? Icon(
                                                  Icons.radio_button_checked,
                                                  color: kbtnsecond,
                                                )
                                              : Icon(
                                                  Icons.radio_button_unchecked))
                                      : Container());
                        }).toList());
                      }
                    }),
              ],
            )),
          )

          //SizedBox(height: 50.0,),

          ),
    );
  }

  void createPlaylist() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: CreatePlayList()));
  }

//Todo: sending playlist to fireBase;
  Future<void> sendPlayList() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (playlistCheckbox.isEmpty) {
      Fluttertoast.showToast(
          msg: kSscheckplaylist,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      setState(() {
        _publishModal = true;
      });

      await FirebaseFirestore.instance
          .collection('sessionplaylists')
          .doc(currentUser!.uid)
          .collection('userplaylist')
          .doc(_currentDocument.id)
          .update({
        'details': FieldValue.arrayUnion(
          [
            {
              'vido': UploadVariables.selectedVideo,
              'title': UploadVariables.title,
              'tmb': UploadVariables.playlistUrl1,
              'end': UploadVariables.playlistUrl2
            }
          ],
        )
      });
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kSsplaylistaddedsuccessfully,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kSsprogresscompleted);
    }
  }

//ToDo: delete playlist
  void _deletePlayList() {
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
                      User currentUser =
                          await FirebaseAuth.instance.currentUser!;

                      await FirebaseFirestore.instance
                          .collection('sessionplaylists')
                          .doc(currentUser.uid)
                          .collection('userplaylist')
                          .doc(_currentDocument.id)
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

class NoPlayListCreated extends StatelessWidget {
  const NoPlayListCreated({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(360),
      width: ScreenUtil().setHeight(350),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 2.0,
          color: klistnmber,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          kNoplaylist,
          style: TextStyle(
            fontSize: kFontsize.sp,
            color: klistnmber,
            fontFamily: 'Rajdhani-Medium ',
          ),
        ),
      ),
    );
  }
}
