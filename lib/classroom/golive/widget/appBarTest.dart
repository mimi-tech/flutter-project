import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class SubTitles extends StatelessWidget {
  SubTitles({this.title, this.nos});
  final String? title;
  final int? nos;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(title!,
            style: TextStyle(
              fontSize: kFontsize.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Rajdhani',
              color: kWhitecolor,
            )),
        RaisedButton(
            color: kMaincolor,
            splashColor: Colors.blueAccent,
            shape: new CircleBorder(),
            child: new Text(nos.toString()),
            onPressed: () {}),
      ],
    );
  }
}

/*


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
class AnalysisCount extends StatefulWidget {
  AnalysisCount({required this.online, required this.offLine});
  final String offLine;
  final String online;
  @override
  _AnalysisCountState createState() => _AnalysisCountState();
}

class _AnalysisCountState extends State<AnalysisCount> {
  @override
  Widget build(BuildContext context) {
    return  Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: Center(
                  child: Text('A-Z'.toUpperCase(),
                    style: GoogleFonts.rajdhani(
                      fontSize: kTwentyTwo.sp,
                      color: kWhitecolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                  width: ScreenUtil().setWidth(kCount),
                  height: ScreenUtil().setHeight(kCountHeight),
                  color: kBlackcolor,
                  child: SvgPicture.asset('images/classroom/oo.svg',)),


            ],
          ),



          Column(
            children: <Widget>[
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: Center(
                  child: Text(widget.online,
                    style: GoogleFonts.rajdhani(
                      fontSize: kTwentyTwo.sp,
                      color: kExpertColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                  height: ScreenUtil().setHeight(kCountHeight),
                  width: ScreenUtil().setWidth(kCount),
                  color: kBlackcolor,
                  child: SvgPicture.asset('images/classroom/in.svg',)),


            ],
          ),



          Column(
            children: <Widget>[
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: Center(
                  child: Text(widget.offLine,
                    style: GoogleFonts.rajdhani(
                      fontSize: kTwentyTwo.sp,
                      color: kExpertColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                  height: ScreenUtil().setHeight(kCountHeight),
                  width: ScreenUtil().setWidth(kCount),
                  color: kBlackcolor,
                  child: SvgPicture.asset('images/classroom/out.svg',)),


            ],
          ),


          Column(
            children: <Widget>[
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: Center(
                  child: Text('#',
                    style: GoogleFonts.rajdhani(
                      fontSize: kTwentyTwo.sp,
                      color: kFbColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(kCountHeight),
                width: ScreenUtil().setWidth(kCount),
                color: kBlackcolor,
              )

            ],
          ),

          Column(
            children: <Widget>[
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),
                child: SvgPicture.asset('images/classroom/clock.svg',),
              ),
              Container(
                height: ScreenUtil().setHeight(kCountHeight),
                width: ScreenUtil().setWidth(kCount),
                color: kBlackcolor,
              )

            ],
          ),

          Column(
            children: <Widget>[
              Container(
                //color: kExpertColor,
                height: ScreenUtil().setHeight(kCount),
                width: ScreenUtil().setWidth(kCount),

              ),
              Container(
                height: ScreenUtil().setHeight(kCountHeight),
                width: ScreenUtil().setWidth(kCount),
                color: kBlackcolor,
              )

            ],
          )
        ],
      ),

    );
  }
}
*/

/*

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: MainScreen(),
));

class MainScreen extends StatelessWidget {
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal ListView'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: numbers.length, itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Card(
              color: Colors.blue,
              child: Container(
                child: Center(child: Text(numbers[index].toString(), style: TextStyle(color: Colors.white, fontSize: 36.0),)),
              ),
            ),
          );
        }),
      ),
    );
  }
}*/

/*



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/variable_live_modal.dart';
import 'package:sparks/widget/users_friends_selected_list.dart';

class UserFriendsSelected extends StatefulWidget {
  @override
  _UserFriendsSelectedState createState() => _UserFriendsSelectedState();
}

class _UserFriendsSelectedState extends State<UserFriendsSelected> {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
            height:45.0,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                HorizontalListView(title:Variables.usercontactselection),
                HorizontalListView(),
                HorizontalListView(),
                HorizontalListView(),
                HorizontalListView(),
                HorizontalListView(),

              ],
            )
        )
      ],
    );
  }
}

class HorizontalListView extends StatelessWidget {
  HorizontalListView({this.title });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0, ),
      child: Container(
        child:Text(title),
        width: 150.0,
        decoration: new BoxDecoration(
            color: khorizontallistviewcolor,
            borderRadius: BorderRadius.circular(50.0)
        ),),
    );
  }
*/
//}

/*



showGeneralDialog(
barrierColor: Colors.black.withOpacity(0.5),
transitionBuilder: (context, a1, a2, widget) {
return Transform.scale(
scale: a1.value,
child: Opacity(
opacity: a1.value,
child: Dialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8.0)),
child: Container(
margin: EdgeInsets.symmetric(
vertical: 0.0,
horizontal: 30.0,
),
width: ScreenUtil().setWidth(600),
height: ScreenUtil().setHeight(1050),
child: Padding(
padding: const EdgeInsets.all(12.0),
child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
children: [
Align(
alignment: Alignment.topRight,
child: IconButton(
onPressed: () {
Navigator.of(context).pop();
},
iconSize: 27.0,
icon: Icon(
Icons.cancel,
size: 38,
color: kBlackcolor,
),
),
),
Padding(
padding: const EdgeInsets.only(bottom: 30.0),
child: Center(
child: Text(kCongratulationsbtn,
style: TextStyle(
fontSize: ScreenUtil().setSp(
kFontsizeCongrats,
allowFontScalingSelf: true),
fontWeight: FontWeight.bold,
fontFamily: 'Rajdhani',
color: kBlackcolor,
))),
),
Expanded(

child: Container(

decoration: new BoxDecoration(

image: new DecorationImage(
image:
FileImage(Variables.imageURI),
fit: BoxFit.cover,
),
borderRadius: BorderRadius.only(
topLeft: Radius.circular(8.0),
topRight: Radius.circular(8.0),
),
),
child: Column(
children: <Widget>[
Flexible(
flex: 6,
child: Padding(
padding: const EdgeInsets.all(12.0),
child: Align(
alignment: Alignment.topRight,
child: Column(
children: <Widget>[
InkWell(
child: Image(
//                                                    height: 8.8,
//                                                    width: 14.5,
width: ScreenUtil()
    .setWidth(40.0),
height: ScreenUtil()
    .setHeight(40.0),
image: AssetImage(
'images/video_live.png',
),
)),
SizedBox(
height: 6.0,
),
Text(
klivetitle,
style: TextStyle(
fontSize: kFontsize.sp,
fontWeight:
FontWeight.bold,
fontFamily: 'Rajdhani',
color: kWhitecolor,
),
),
],
),
),
),
),
Flexible(
flex: 4,
child: Container(
margin: EdgeInsets.only(
top: 30.0, left: 12.0,),
child: Align(
alignment: Alignment.bottomLeft,
child: Column(
children: <Widget>[

Text(
'Miriam Onuoha',
style: TextStyle(
fontSize: ScreenUtil()
    .setSp(
35.0,
allowFontScalingSelf:
true),
fontWeight:
FontWeight.bold,
fontFamily: 'Rajdhani',
color: kWhitecolor,
),
),
],
),
),
),
),
],
))),
Container(
decoration: new BoxDecoration(
color: kBlackcolor,
borderRadius: BorderRadius.only(
bottomLeft: Radius.circular(8.0),
bottomRight: Radius.circular(8.0),)
),
child: Padding(
padding: const EdgeInsets.only(
left: 12.0, bottom: 12.0, top: 4.0),
child: Column(
children: <Widget>[
Row(children: <Widget>[
Container(
margin: EdgeInsets.symmetric(
vertical: 2.0,
horizontal: 4.0,
),

),
]),
Row(children: <Widget>[
Container(
margin: EdgeInsets.symmetric(
vertical: 0.0,
horizontal: 0.0,
),
child: Row(
children: <Widget>[
Icon(

Icons.location_on,
color: kWhitecolor,
size: 15,
),
Text('New Zealand',
style: TextStyle(
fontSize: ScreenUtil().setSp(
kModalDialogtext,
allowFontScalingSelf:
true),
fontWeight: FontWeight.w400,
fontFamily: 'Rajdhani',
color: kWhitecolor,
)),
],
),
)
]),
Row(
children: <Widget>[
Container(
margin: EdgeInsets.symmetric(
vertical: 2.0,
horizontal: 4.0,
),
child: Text(
kCoursetext +
' ' +
" " +
Variables.title,
style: TextStyle(
fontSize: ScreenUtil().setSp(
kModalDialogtext,
allowFontScalingSelf: true),
fontWeight: FontWeight.bold,
fontFamily: 'Rajdhani',
color: kWhitecolor,
)),
),
],
),
Row(
children: <Widget>[
Container(
margin: EdgeInsets.symmetric(
vertical: 2.0,
horizontal: 4.0,
),
child: Text(
kMentortext +
' ' +
" " +
Variables.desc,
style: TextStyle(
fontSize: ScreenUtil().setSp(
kModalDialogtext,
allowFontScalingSelf: true),
fontWeight: FontWeight.bold,
fontFamily: 'Rajdhani',
color: kWhitecolor,
)),
),
],
)
],
),
),
),
SizedBox(height: 10.0),
Center(
child: Text(kSessiontext,
style: TextStyle(
fontSize: ScreenUtil().setSp(30,
allowFontScalingSelf: true),
fontWeight: FontWeight.bold,
fontFamily: 'Rajdhani',
color: kBlackcolor,
))),
Center(
child: Text(kSessiontextsec,
style: TextStyle(
fontSize: ScreenUtil().setSp(30,
allowFontScalingSelf: true),
fontWeight: FontWeight.bold,
fontFamily: 'Rajdhani',
color: kBlackcolor,
))),
SizedBox(height: 10.0),
GestureDetector(
child: Image(
image: AssetImage('images/go_live_btn.png'),
))
],
),
),
),
),
),
);
},
transitionDuration: Duration(milliseconds: 200),
barrierDismissible: true,
barrierLabel: '',
context: context,
// ignore: missing_return
pageBuilder: (context, animation1, animation2) {});

*/

/*

Container(
decoration: BoxDecoration(
color: kBlackcolor.withOpacity(0.5),
borderRadius: BorderRadius.only(
topLeft: Radius.circular(8.0),
topRight: Radius.circular(8.0),)
),
child: Align(
alignment: Alignment.bottomCenter,
child: Container(
margin: EdgeInsets.symmetric(vertical:34.0),
child: Column(

children: <Widget>[

Padding(
padding:
const EdgeInsets.symmetric(horizontal: 4.0),
child: Center(
child: Text(Variables.title,
style: Variables.textstyles)),
),
Padding(
padding: const EdgeInsets.symmetric(horizontal:8.0,vertical:8.0),
child: Divider(
height: 0.0,
color: kofmaincolor,
thickness: 2.0,
),
),
Center(
child: Text(kTagtext,
style: TextStyle(
fontSize: 18.sp,
fontWeight: FontWeight.bold,
fontFamily: 'Rajdhani',
color: kofmaincolor,
))),
Padding(
padding: const EdgeInsets.symmetric(vertical: 24.0),
child: Center(
child: Text(kSharetext,
style: TextStyle(
fontSize: ScreenUtil().setSp(18,
allowFontScalingSelf: true),
fontWeight: FontWeight.bold,
fontFamily: 'Rajdhani',
color: kofmaincolor,
))),
),
Padding(
padding: const EdgeInsets.symmetric(horizontal:18.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: <Widget>[

GestureDetector(
child: CircleAvatar(
backgroundColor: kBlackcolor,
child: Image(
image: AssetImage('images/facebook.png'),

),
),
),
GestureDetector(
child: CircleAvatar(
backgroundColor: kBlackcolor,
child: Image(
image: AssetImage('images/messenger.png'),

),
),
),
GestureDetector(
child: CircleAvatar(
backgroundColor: kBlackcolor,
child: Image(
image: AssetImage('images/instagram.png'),

),
),
),
GestureDetector(
child: CircleAvatar(
backgroundColor: kBlackcolor,
child: Image(
image: AssetImage('images/twitter.png'),

),
),
),
GestureDetector(
child: CircleAvatar(
backgroundColor: kBlackcolor,
child: Image(
image: AssetImage('images/whatsapp.png'),

),
),
),
GestureDetector(
child: CircleAvatar(
backgroundColor: kBlackcolor,
child: Image(
image: AssetImage('images/telegram.png'),

),
),
),
]),
),
Container(
margin: EdgeInsets.symmetric(vertical:24.0),
child: GestureDetector(
child: Image(
image: AssetImage('images/live_button.png'),


),
),
),
]),
),
))*/

/*


import 'package:flutter/material.dart';
import 'package:sparks/BottomSheetCustom.dart';
import 'package:sparks/bottomSheet_widget_fourth.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/variable_live_modal.dart';
import 'package:sparks/widget/users_friends_selected_list.dart';
//class MyContactsappbar extends StatefulWidget {
//
//  @override
//  _MyContactsappbarState createState() {
//    return new _MyContactsappbarState();

  }
}
//class
  TextEditingController editingController = TextEditingController();

  List<String> duplicateItems = <String>[
    'Pratap Kumar','Jagadeesh','Srinivas','Narendra','Sravan '
    ,'Ranganadh','Ranganadh','miriam','Lucy','Agnes',
    'Anthony','John',
  ];
  List<String>contactImage = <String>[
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
  ];
  var items = [];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }


  Widget appBarTitle = Text(kListviewTutees,
      style: TextStyle(
        fontSize: 24.0,
        color: kWhitecolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ));
  Icon actionIcon = new Icon(Icons.search);



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhitecolor, size: 20.0),
        elevation: 4.0,
        backgroundColor: kBlackcolor,
        title: appBarTitle,
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: actionIcon,
                  onPressed: () {
                    setState(() {
                      if (this.actionIcon.icon == Icons.search) {
                        this.actionIcon = Icon(Icons.close);
                        this.appBarTitle = TextFormField(
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            controller: editingController,
                            style: TextStyle(color: kSearchTextcolor),

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,
                                  color: kSearchTextcolor),
                              hintText: "Search...",
                              hintStyle:
                              TextStyle(color: kSearchTextcolor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: kSearchTextcolor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kMaincolor),
                              ),
                            ));
                      } else {
                        this.actionIcon = Icon(Icons.search);
                        this.appBarTitle = Text(kChooseFriends,
                            style: TextStyle(color: Colors.white));
                      }
                    });
                  }),
            ],
          ),
        ],
      ),
      floatingActionButton:Visibility(
        visible:Variables.tuteesfb,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheetCustom(
                context: context,
                builder: (context) => BottomSheetWidgetFourth()
            );
          },
          child: Icon(Icons.check,
              color:kWhitecolor, size: 40),
          backgroundColor: kFloatbtn,

        ),
      ),
      backgroundColor: kBlackcolor,
      body: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 10, right: 10, top: 20),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              color: kListView,
              child: ListTile(
                  title: Text('${items[index]}',
                      style: Variables.textstyles),
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        image: ('${contactImage[index]}'.toString()),
                        fit: BoxFit.cover,
                        width: 80.0,
                        height: 80.0,
                        placeholder: 'images/user.png',
                      ),
                    ),
                  ),
                  onTap: () =>
                      _onTapItem(context, items[index])
              ),




            );

          } ),
    );

  }

  _onTapItem(BuildContext context, String item) {
    ufriends.litems.add(item);

  }
}

*/

///from firstview

/*


import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:sparks/BottomSheetCustom.dart';
import 'package:sparks/bottomSheet_widget_fourth.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/variable_live_modal.dart';

class MyContactsappbar extends StatefulWidget {

  @override
  _MyContactsappbarState createState() {
    return new _MyContactsappbarState();

  }
}
class _MyContactsappbarState extends State<MyContactsappbar> {
  bool viewVisible = true;
  List<Contact> contacts = [
    Contact(fullName: 'Pratap Kumar', email: 'pratap@example.com',image:'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Jagadeesh', email: 'Jagadeesh@example.com',image:'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Srinivas', email: 'Srinivas@example.com',image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Narendra', email: 'Narendra@example.com',image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Sravan ', email: 'Sravan@example.com',image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Ranganadh', email: 'Ranganadh@example.com',image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Karthik', email: 'Karthik@example.com',image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Saranya', email: 'Saranya@example.com',image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),
    Contact(fullName: 'Mahesh', email: 'Mahesh@example.com',image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',),

  ];

  Widget appBarTitle = Text(kListviewTutees,
      style: TextStyle(
        fontSize: 24.0,
        color: kWhitecolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ));
  Icon actionIcon = new Icon(Icons.search);



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhitecolor, size: 20.0),
        elevation: 4.0,
        backgroundColor: kBlackcolor,
        title: appBarTitle,
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: actionIcon,
                  onPressed: () {
                    setState(() {
                      if (this.actionIcon.icon == Icons.search) {
                        this.actionIcon = Icon(Icons.close);
                        this.appBarTitle = TextFormField(

                            style: TextStyle(color: kSearchTextcolor),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,
                                  color: kSearchTextcolor),
                              hintText: "Search...",
                              hintStyle:
                              TextStyle(color: kSearchTextcolor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: kSearchTextcolor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kMaincolor),
                              ),
                            ));
                      } else {
                        this.actionIcon = Icon(Icons.search);
                        this.appBarTitle = Text(kChooseFriends,
                            style: TextStyle(color: Colors.white));
                      }
                    });
                  }),
            ],
          ),
        ],
      ),
      floatingActionButton:Visibility(
        visible:Variables.tuteesfb,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheetCustom(
                context: context,
                builder: (context) => BottomSheetWidgetFourth()
            );
          },
          child: Icon(Icons.check,
              color:kWhitecolor, size: 40),
          backgroundColor: kFloatbtn,

        ),
      ),
      backgroundColor: kBlackcolor,
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 10, right: 10, top: 20),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return Card(
              color: kListView,
              child: ListTile(
                  title: Text('${contacts[index].fullName}',
                      style: Variables.textstyles),
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        image: ('${contacts[index].image}'.toString()),
                        fit: BoxFit.cover,
                        width: 80.0,
                        height: 80.0,
                        placeholder: 'images/user.png',
                      ),
                    ),
                  ),
                  onTap: () =>
                      _onTapItem(context, contacts[index])
              ),




            );

          } ),
    );



  }

  _onTapItem(BuildContext context, Contact contact) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("Tap on " + ' - ' + contact.fullName)));
  }
}
class Contact {
  final String fullName;
  final String email;
  final String image;
  const Contact({this.fullName, this.email, this.image});
}

*/

/*


import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/dimens/dimen.dart';
import 'package:sparks/mycontacts/contacts_const.dart';
import 'package:sparks/mycontacts/contactsappbar.dart';
import 'package:sparks/send.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/tutees/tutees_friends.dart';
import 'package:sparks/variable_live_modal.dart';

class ClassroomContact extends StatefulWidget {
  static String classroomContactName = kContactsroutes;

  @override
  _ClassroomContactState createState() => _ClassroomContactState();
}


Tutees _tuteesDetails = Tutees('Eggs','https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',false);
Tutees _tuteesDetails1 = Tutees('mimi','https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',false);
List<Tutees> tutees = [
  _tuteesDetails,
  _tuteesDetails1
];

@override
class _ClassroomContactState extends State<ClassroomContact> {
  static bool fontScale = true;
  bool viewVisible = true ;
  Widget appBarTitle = Text(kChooseFriends,
    style: TextStyle(color:kWhitecolor),
  );
  Icon actionIcon = new Icon(Icons.search);


  void toggleSwitch(bool value) {
    if(Variables.switchControl == false)
    {
      setState(() {
        Variables.switchControl = true;

      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.
      setState(() {
        Variables.menteesVal = true;
        Variables.contactVal = true;
        Variables.tuteesVal = true;
        Variables.classmateVal = true;
        Variables.alumniVal = true;
      });
    }
    else
    {
      setState(() {
        Variables.switchControl = false;

      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
      setState(() {
        Variables.menteesVal = false;
        Variables.contactVal = false;
        Variables.tuteesVal = false;
        Variables.classmateVal = false;
        Variables.alumniVal = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build



    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhitecolor, size: 20.0),
        elevation: 4.0,
        backgroundColor: kBlackcolor,
        title: Text(kChooseFriends,style: TextStyle(color:kWhitecolor),),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: viewVisible,
                child: Switch(
                  onChanged: toggleSwitch,
                  value: Variables.switchControl,
                  activeColor: kMaincolor,
                  activeTrackColor: kSwitchfadecolor,
                  inactiveThumbColor: kSwitchoffColor,
                  inactiveTrackColor: kSwitchoffColors,
                ),
              ),



            ],
          ),
        ],
      ),
      floatingActionButton: Send(),
      backgroundColor: kBlackcolor,

      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(kCardheight),
            child: Card(
              color: kListView,
              child: Center(
                // padding: const EdgeInsets.only(top:28.0),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, PageTransition
                      (type: PageTransitionType.rightToLeft, child: MyContactsappbar()));
                  },
                  leading: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: kBlackcolor,
                      child: Image(
                        height: ScreenUtil().setHeight(kListviewImage),
                        width: ScreenUtil().setHeight(kListviewImage),
                        image: AssetImage('images/contacts.png'),
                      ),
                    ),
                  ),
                  title: Text(kListviewContact,
                      style: Variables.textstyleslistViews),

                  trailing: CircularCheckBox(
                      inactiveColor: kWhitecolor,
                      value: Variables.contactVal,
                      onChanged: (bool value) {
                        setState(() {
                          Variables.contactVal = value;
                        });
                      }),

                ),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(kCardheight),
            child: Card(
              color: kListView,
              child: Center(
                child: ListTile(
                  leading: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: kBlackcolor,
                      child: Image(
                        height: ScreenUtil().setHeight(kListviewImage),
                        width: ScreenUtil().setHeight(kListviewImage),
                        image: AssetImage('images/mentees.png'),
                      ),
                    ),
                  ),
                  title: Text(kListviewMentees,
                      style: Variables.textstyleslistViews),

                  trailing: CircularCheckBox(
                      inactiveColor: kWhitecolor,
                      value: Variables.menteesVal,
                      onChanged: (bool value) {
                        setState(() {
                          Variables.menteesVal = value;
                        });
                      }),
                ),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(kCardheight),
            child: Card(
              color: kListView,
              child: Center(
                child: ListTile(
                  onTap:(){
                    Navigator.push(context, PageTransition(
                        type: PageTransitionType.rightToLeft, child: TuteesList(tutees:tutees,)));
                  },
                  leading: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: kBlackcolor,
                      child: Image(
                        height: ScreenUtil().setHeight(kListviewImage),
                        width: ScreenUtil().setHeight(kListviewImage),
                        image: AssetImage('images/tutees.png'),
                      ),
                    ),
                  ),
                  title: Text(kListviewTutees,
                      style: Variables.textstyleslistViews),

                  trailing: CircularCheckBox(
                      inactiveColor: kWhitecolor,
                      value: Variables.tuteesVal,
                      onChanged: (bool value) {
                        setState(() {
                          Variables.tuteesVal = value;
                        });
                      }),
                ),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(kCardheight),
            child: Card(
              color: kListView,
              child: Center(
                child: ListTile(
                  leading: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: kBlackcolor,
                      child: Image(
                        height: ScreenUtil().setHeight(kListviewImage),
                        width: ScreenUtil().setHeight(kListviewImage),
                        image: AssetImage('images/classmates.png'),
                      ),
                    ),
                  ),
                  title: Text(kListviewClassmate,
                      style: Variables.textstyleslistViews),

                  trailing: CircularCheckBox(
                      inactiveColor: kWhitecolor,
                      value: Variables.classmateVal,
                      onChanged: (bool value) {
                        setState(() {
                          Variables.classmateVal = value;
                        });
                      }),
                ),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(kCardheight),
            child: Card(
              color: kListView,
              child: Center(
                child: ListTile(
                  leading: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: kBlackcolor,
                      child: Image(
                        height: ScreenUtil().setHeight(kListviewImage),
                        width: ScreenUtil().setHeight(kListviewImage),
                        image: AssetImage('images/Alumnimain.png'),
                      ),
                    ),
                  ),
                  title: Text(kListviewAlumin,
                      style: Variables.textstyleslistViews),

                  trailing: CircularCheckBox(
                      inactiveColor: kWhitecolor,
                      value: Variables.alumniVal,
                      onChanged: (bool value) {
                        setState(() {
                          Variables.alumniVal = value;
                        });

                      }),

                ),
              ),



            ),
          ),
          */
/*Container(
            height: ScreenUtil().setHeight(kCardextrahelght),
          ),*/ /*



        ],
      ),
    );

  }

}

*/
