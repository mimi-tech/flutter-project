import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/golive/mycontacts/contact.dart';
import 'package:sparks/classroom/golive/send.dart';

import 'package:sparks/classroom/golive/widget/firstlistview.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ClassroomContact extends StatefulWidget {
  static String classroomContactName = kContactsroutes;

  @override
  _ClassroomContactState createState() => _ClassroomContactState();
}

@override
class _ClassroomContactState extends State<ClassroomContact> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Timer.periodic(Duration(seconds: 2), (Timer t) => setState((){}));
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: kBlackcolor, size: 10.0),
          elevation: 4.0,
          backgroundColor: kListcard,
          title: Text(
            kChooseFriends,
            style: TextStyle(color: kBlackcolor, fontWeight: FontWeight.normal),
          ),
          actions: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
        floatingActionButton: Send(),
        backgroundColor: kListcard,
        body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 8),
            shrinkWrap: true,
            itemCount: FirstListViewtitles.titles.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: AnimatedContainer(
                    height: ScreenUtil().setHeight(kCardheight),
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    child: GestureDetector(
                      onTap: () {
                        _movetocontacts(context, FirstListView.title[index]);
                      },
                      child: Card(
                        color: kListcard,
                        elevation: 5.0,
                        child: Center(
                          child: ListTile(
                            title: (FirstListViewtitles.titles[index]),
                            subtitle: (ListViewtitles.subtitles[index]),
                            leading: (FirstListView.icons[index]),
                            trailing: GestureDetector(
                                child: UserpickContacts.pickContacts
                                        .contains(FirstListView.title[index])
                                    ? Icon(Icons.check_circle,
                                        color: kMaincolor)
                                    : Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2.0,
                                            color: Colors.black,
                                          ),
                                          color: kListcard,
                                        ),
                                        height: 20,
                                        width: 20,
                                      ),
                                onTap: () => _onTapItemContacts(
                                    context, FirstListView.title[index])),
                          ),
                        ),
                      ),
                    ),
                  ));
            }));
  }

  _onTapItemContacts(BuildContext context, String titles) {
    setState(() {
      if (UserpickContacts.pickContacts.contains(titles)) {
        UserpickContacts.pickContacts.remove(titles);
        ufriends.litems.remove(titles);
      } else {
        if (UserpickContacts.pickContacts.contains(titles)) {
        } else {
          UserpickContacts.pickContacts.add(titles);
        }
        ufriends.litems.add(titles);
      }
    });
  }

  void _movetocontacts(BuildContext context, String title) {
    if (title == 'All friends') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Cds()));
    }
  }
}
