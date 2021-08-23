import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/profilepicture.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
class SocialTopAppBar extends StatefulWidget implements PreferredSizeWidget{
  SocialTopAppBar({required this.search});
  final Function search;

  @override
  _SocialTopAppBarState createState() => _SocialTopAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _SocialTopAppBarState extends State<SocialTopAppBar> {


  //ToDo:Appbar title
  Icon actionIcon =  Icon(Icons.search);
  Widget appBarTitle =  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 32,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: '${GlobalVariables.loggedInUserObject.pimg}',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
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
    return SliverAppBar(
        shape:  RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
            )
        ),
        automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: (){Navigator.pop(context);},
          icon: Icon(Icons.arrow_back)
      ),
      floating: true,
      snap: true,
      pinned: false,
      elevation: 10.0,
      backgroundColor: kBlackcolor,
      title: appBarTitle,
      actions: <Widget>[
        Column(
          children: [
            Flexible(
              child: Row(

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
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 32,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: '${GlobalVariables.loggedInUserObject.pimg}',
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          width: 40.0,
                                          height: 40.0,
                                        ),
                                      ),
                                    ),
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
            ),
          ],
        ),
      ],
    );
  }
}
