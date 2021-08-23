import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/classroom/contents/profilepicture.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
class TopAppBar extends StatefulWidget implements PreferredSizeWidget{
  TopAppBar({this.search});
  final Function? search;
  @override
  _TopAppBarState createState() => _TopAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}
class _TopAppBarState extends State<TopAppBar> {

  //ToDo:Appbar title
  Icon actionIcon =  Icon(Icons.search);
  Widget appBarTitle = Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
  GestureDetector(
  child: ProfilePicture(),
  ),
  GestureDetector(
  child: SvgPicture.asset(
    "images/friends_notification.svg",
  )
  ),
  //ToDo:notifications

  GestureDetector(child: Icon(Icons.notifications,color:kWhitecolor,size:30.0)),

  //TODO: messenger notification
  GestureDetector(
  child: SvgPicture.asset(
  "images/classroom/messenger_icon.svg",
  )
  ),
      ]
  );


  @override
  Widget build(BuildContext context) {
    return  AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('images/classroom/hamburger.svg'),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      elevation: 10.0,
      backgroundColor: kplaylistappbar,
      title: appBarTitle,
      actions: <Widget>[
        Row(

          children: <Widget>[
            IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = Icon(Icons.close);
                      this.appBarTitle = TextFormField(
                          onChanged: (String value){
                            UploadVariables.searchText = value;
                          },
                          controller: UploadVariables.searchController,
                        cursorColor: kMaincolor,
                          autofocus: true,
                          style: TextStyle(color: kSearchTextcolor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search,
                                color: kWhitecolor),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: kWhitecolor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kMaincolor),
                            ),
                          ));
                    } else {
                      this.actionIcon = Icon(Icons.search);
                      this.appBarTitle =  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: ProfilePicture(),
                            ),
                            GestureDetector(
                                child: SvgPicture.asset(
                                  "images/friends_notification.svg",
                                )
                            ),
                            //ToDo:notifications

                            GestureDetector(child: Icon(Icons.notifications,color:kWhitecolor,size:30.0)),

                            //TODO: messenger notification
                            GestureDetector(
                                child: SvgPicture.asset(
                                  "images/classroom/messenger_icon.svg",
                                )
                            ),
                          ]
                      );
                    }
                  });
                }),
          ],
        ),
      ],
    );
  }
}
