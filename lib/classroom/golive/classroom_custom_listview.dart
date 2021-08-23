import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class UserFriendsSelected extends StatefulWidget {
  @override
  _UserFriendsSelectedState createState() => _UserFriendsSelectedState();
}

class _UserFriendsSelectedState extends State<UserFriendsSelected> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          height: 40.0,
          child: new ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: ufriends.litems.length,
              itemBuilder: (BuildContext ctxt, int Index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.0,
                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                ufriends.litems.removeAt(Index);

                                //UserpickContacts.pickContacts.removeAt(Index);
                              });
                              setState(() {
                                ucontacts.lcontacts.removeAt(Index);
                                print(ucontacts.lcontacts);
                              });
                            },
                            child: Icon(
                              Icons.cancel,
                              size: 15,
                              color: kBlackcolor,
                            ),
                          ),
                        ),
                        Text(
                          ufriends.litems[Index],
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rajdhani',
                            color: kBlackcolor,
                          ),
                        ),
                      ],
                    ),
                    width: 150.0,
                    decoration: new BoxDecoration(
                        color: khorizontallistviewcolor,
                        borderRadius: BorderRadius.circular(50.0)),
                  ),
                );
              }))
    ]);
  }
}
