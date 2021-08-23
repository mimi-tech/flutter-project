import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/uploadvideo/createplaylist.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/playlistappbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/uploadSelectedcontact.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:page_transition/page_transition.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EditPlayList extends StatefulWidget {
  @override
  _EditPlayListState createState() => _EditPlayListState();
}

class _EditPlayListState extends State<EditPlayList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _publishModal = false;
  String? playlistTitle;

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
                    //ToDo:show the contact and update button
                    ContactBtn(create: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: CreatePlayList()));
                    }, update: () {
                      _updatePlaylist();
                    }),
                    SizedBox(
                      height: 30.0,
                    ),

                    //ToDo:Horizontal list displaying all friends selected
                    Visibility(
                      visible: UploadUfriends.litems.isEmpty ? false : true,
                      child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: UploadUserFriendsSelected()),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('sessionplaylists')
                            .doc(UploadVariables.currentUser)
                            .collection('userplaylist')
                            .where('id', isEqualTo: UploadVariables.playlistId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Column(
                                children: snapshot.data!.docs.map((doc) {
                              //List<Map<String, String>> loadVideos = List.from(doc.data['details']);
                              List<dynamic> loadVideos = doc['details'];
                              //var loadVideos = doc.data['details'];

                              return Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: kHorizontal),
                                    child: Form(
                                      key: _formKey,
                                      autovalidate: _autoValidate,
                                      child: TextFormField(
                                        onSaved: (String? value) {
                                          playlistTitle = value;
                                        },
                                        onChanged: (String value) {
                                          playlistTitle = value;
                                        },
                                        initialValue:
                                            doc['name'], // data['name']
                                        cursorColor: klistnmber,
                                        validator: Validator.validateTitle,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            fontSize: kErrorfont.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Rajdhani',
                                            color: Colors.red,
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 18.0, 20.0, 18.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kPlaylistborder)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: ScreenUtil().setHeight(20.0)),
                                  //ToDo:displaying the video

                                  loadVideos.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: loadVideos.length,
                                          itemBuilder: (context, int index) {
                                            return Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width: ScreenUtil()
                                                          .setWidth(200),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          ShowUploadedVideo(
                                                            videoPlayerController:
                                                                VideoPlayerController
                                                                    .network(loadVideos[
                                                                            index]
                                                                        [
                                                                        'vido']),
                                                            looping: false,
                                                          ),
                                                          Center(
                                                              child:
                                                                  ButtonTheme(
                                                            shape:
                                                                CircleBorder(),
                                                            height: ScreenUtil()
                                                                .setHeight(100),
                                                            child: RaisedButton(
                                                                color: Colors
                                                                    .transparent,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                onPressed:
                                                                    () {},
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          print(loadVideos[index]
                                                                              [
                                                                              'vido']);
                                                                          UploadVariables.videoUrlSelected =
                                                                              loadVideos[index]['vido'];
                                                                          Navigator.of(context)
                                                                              .push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                        },
                                                                        child: Icon(
                                                                            Icons
                                                                                .play_arrow,
                                                                            size:
                                                                                30))),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(5.0)),

                                                    Column(
                                                      children: <Widget>[
                                                        ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        150),
                                                            minHeight:
                                                                ScreenUtil()
                                                                    .setHeight(
                                                                        10),
                                                          ),
                                                          child: AutoSizeText(
                                                              loadVideos[index]
                                                                  ['title'],
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              minFontSize:
                                                                  20.sp,
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                      textStyle:
                                                                          TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 22.sp,
                                                                color:
                                                                    kBlackcolor,
                                                              ))),
                                                        ),
                                                      ],
                                                    ),

                                                    //ToDo:edit button
                                                    GestureDetector(
                                                        onTap: () {
                                                          deletePlaylist(
                                                            document: doc,
                                                            index: index,
                                                          );
                                                        },
                                                        child: Icon(
                                                            Icons.delete,
                                                            color: kFbColor,
                                                            size: 40)),
                                                  ],
                                                ),
                                                /* Row(
                                            children: <Widget>[
                                              //ToDo:Update button
                                              RaisedButton(child:Text('update'),
                                                  onPressed:(){
                                                    updatePlaylist(
                                                        document: doc,
                                                        index: index,
                                                        newTitle: '');

                                                  }
                                              ),
                                              //ToDo:delete button
                                              Icon(Icons.delete)
                                            ],
                                          ),*/

                                                Divider(
                                                  thickness: kThickness,
                                                ),
                                              ],
                                            );
                                          })
                                      : NoPlayListCreated(),
                                ],
                              );
                            }).toList());
                          }
                        }),
                  ],
                ),
              ),
            )));
  }

  deletePlaylist({required DocumentSnapshot document, required int index}) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      _publishModal = true;
    });

    List<dynamic> details = document['details'];

    /*Map<String, String> detailToUpdate = details[index];
    String titleToUpdate = detailToUpdate['title'];*/

    details.removeAt(index);

    await FirebaseFirestore.instance
        .collection('sessionplaylists')
        .doc(currentUser.uid)
        .collection('userplaylist')
        .doc(document.id)
        .set({'details': details}, SetOptions(merge: true)).then((value) {
      setState(() {
        _publishModal = false;
      });

      Fluttertoast.showToast(
          msg: 'Removed successfully at ${index.toString()}',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kSsprogresscompleted);
    }).catchError((e) {
      setState(() {
        _publishModal = false;
      });
    });
  }

  Future<void> _updatePlaylist() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _publishModal = true;
    });
    User currentUser = FirebaseAuth.instance.currentUser!;
    playlistTitle!.trim();
    print(playlistTitle);
    await FirebaseFirestore.instance
        .collection('sessionplaylists')
        .doc(currentUser.uid)
        .collection('userplaylist')
        .doc(UploadVariables.playlistId)
        .update({'name': playlistTitle}).whenComplete(() {
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Updated successfully',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kSsprogresscompleted);
    }).catchError((e) => print('Error: ${e.toString()}'));
  }

  /*updatePlaylist({DocumentSnapshot document, int index, String newTitle}) {

    String mainTitle = document['title'];

    List<dynamic> details = document['details'];

    */ /*Map<String, String> detailToUpdate = details[index];
    String titleToUpdate = detailToUpdate['title'];*/ /*

    details[index]['title'] = newTitle;


    document.reference
        .update({
      'title': mainTitle,
      'details' : details,
    })
        .whenComplete(() {


    })
        .catchError( (e) => print('Error: ${e.toString()}'));

  }
*/
}

class ContactsDetails {
  final String? vido;

  ContactsDetails({
    this.vido,
  });
}

class ContactBtn extends StatelessWidget {
  ContactBtn({
    this.update,
    this.create,
  });

  final Function? update;

  final Function? create;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ///create playlist btn
          Container(
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setWidth(150),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                color: kWhitecolor,
                elevation: 10.0,
                onPressed: create as void Function()?,
                child: Text(
                  'create',
                  style: TextStyle(
                    fontSize: kFontsize.sp,
                    color: kbtnsecond,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),

          ///save button
          Container(
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setWidth(150),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(3.0),
                ),
                color: kbtnsecond,
                elevation: 10.0,
                onPressed: update as void Function()?,
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: kFontsize.sp,
                    color: kWhitecolor,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
