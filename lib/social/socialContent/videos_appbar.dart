import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

class SocialVideosAppbar extends StatefulWidget implements PreferredSizeWidget{
  SocialVideosAppbar({

    required this.text1,
  });
 final String text1;
  @override
  _SocialVideosAppbarState createState() => _SocialVideosAppbarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);


}

class _SocialVideosAppbarState extends State<SocialVideosAppbar> {
  Widget space() {
    return SizedBox(height: 10.h);
  }


  @override
  Widget build(BuildContext context) {

    return  SliverAppBar(

      automaticallyImplyLeading: false,
      backgroundColor: kWhitecolor,
      pinned: false,
      floating: true,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: kBlackcolor,),
          onPressed: () {
            Navigator.pop(context);
          }),

      title:Text(widget.text1,
        style: GoogleFonts.rajdhani(
          fontSize:kFontsize.sp,
          color: kExpertColor,
          fontWeight: FontWeight.bold,

        ),),


    );




  }
}


class SeeAllAppbar extends StatefulWidget implements PreferredSizeWidget{
  @override
  _SeeAllAppbarState createState() => _SeeAllAppbarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _SeeAllAppbarState extends State<SeeAllAppbar> {
  Icon actionIcon =  Icon(Icons.search,color: kBlackcolor,);
  Widget appBarTitle = Text('Let them mentor you',
    style: GoogleFonts.rajdhani(
      fontSize:kFontsize.sp,
      color: kExpertColor,
      fontWeight: FontWeight.bold,

    ),);
  @override
  Widget build(BuildContext context) {
    return  AppBar(

      backgroundColor: kWhitecolor,

      leading: IconButton(icon: Icon(Icons.arrow_back,color: kBlackcolor,),
          onPressed: () {
            Navigator.pop(context);
          }),

      title: appBarTitle,
      actions: <Widget>[
        Row(

          children: <Widget>[
            IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = Icon(Icons.close,color: kBlackcolor,);
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
                                color: kBlackcolor),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: kBlackcolor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kMaincolor),
                            ),
                          ));
                    } else {
                      this.actionIcon = Icon(Icons.search);
                      this.appBarTitle =  Text('Let them mentor you',
                        style: GoogleFonts.rajdhani(
                          fontSize:kFontsize.sp,
                          color: kExpertColor,
                          fontWeight: FontWeight.bold,

                        ),);
                    }
                  });
                }),
          ],
        ),
      ],
    );
  }
}


