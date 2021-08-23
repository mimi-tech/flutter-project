import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/createplaylist.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/contactlist.dart';

import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/uploadfirstlistview.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class uploadcontact extends StatefulWidget {
  static String classroomContactName = kContactsroutes;

  @override
  _uploadcontactState createState() => _uploadcontactState();
}

@override
class _uploadcontactState extends State<uploadcontact> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer t) => setState(() {}));
  }

  bool viewVisible = true;

  Widget appBarTitle = Text(
    kChooseFriends,
    style: TextStyle(color: kWhitecolor),
  );
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        backgroundColor: kBlackcolor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kWhitecolor, size: 10.0),
          elevation: 4.0,
          backgroundColor: kBlackcolor,
          title: Text(
            kChooseFriends,
            style: TextStyle(color: kWhitecolor, fontWeight: FontWeight.normal),
          ),
          actions: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: CreatePlayList()));
            setState(() {
              UploadVariables.isPrivate = true;
            });
          },
          child: Icon(Icons.check, color: kWhitecolor, size: 40),
          backgroundColor: kFbColor,
        ),
        body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 8),
            shrinkWrap: true,
            itemCount: UploadFirstListViewtitles.titles.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: AnimatedContainer(
                    height: ScreenUtil().setHeight(kCardheight),
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    child: GestureDetector(
                      onTap: () {
                        _movetocontacts(
                            context, UploadFirstListView.title[index]);
                      },
                      child: Card(
                        color: kListView,
                        elevation: 5.0,
                        child: Center(
                          child: ListTile(
                            title: (UploadFirstListViewtitles.titles[index]),
                            subtitle: (UploadListViewtitles.subtitles[index]),
                            leading: (UploadFirstListView.icons[index]),
                            trailing: GestureDetector(
                                child: UploadUserpickContacts.pickContacts
                                        .contains(
                                            UploadFirstListView.title[index])
                                    ? Icon(Icons.radio_button_checked,
                                        color: kMaincolor)
                                    : Icon(Icons.radio_button_unchecked,
                                        color: kWhitecolor),
                                onTap: () => _onTapItemContacts(
                                    context, UploadFirstListView.title[index])),
                          ),
                        ),
                      ),
                    ),
                  ));
            }));
  }

  _onTapItemContacts(BuildContext context, String titles) {
    setState(() {
      if (UploadUserpickContacts.pickContacts.contains(titles)) {
        UploadUserpickContacts.pickContacts.remove(titles);
        UploadUfriends.litems.remove(titles);
      } else {
        if (UploadUserpickContacts.pickContacts.contains(titles)) {
        } else {
          UploadUserpickContacts.pickContacts.add(titles);
        }
        UploadUfriends.litems.add(titles);
        print(UploadUfriends.litems);
      }
    });
  }

  void _movetocontacts(BuildContext context, String title) {
    if (title == 'All friends') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UploadContactList()));
    }
  }
}
