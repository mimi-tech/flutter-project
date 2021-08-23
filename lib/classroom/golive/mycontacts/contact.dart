import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparks/classroom/golive/send.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class Cds extends StatefulWidget {
  @override
  _CdsState createState() => _CdsState();
}

class _CdsState extends State<Cds> {
  @override
  TextEditingController editingController = TextEditingController();
  bool isSelected = true;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  int? counter;

  List<String> duplicateItems = <String>[
    'Pratap Kumar',
    'Jagadeesh',
    'Srinivas',
    'Narendra',
    'Sravan ',
    'Ranganadh',
    'Vincent',
    'miriam',
    'Lucy',
    'Agnes',
    'Anthony',
    'John',
  ];
  List<String> contactImage = <String>[
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
  var itemsColor = [];

  @override
  void initState() {
    items.addAll(duplicateItems);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: kBlackcolor));
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

  Widget appBarTitle = Text(kChooseFriends,
      style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: KLightermaincolor,
      )));
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlackcolor,
        appBar: AppBar(
            iconTheme: IconThemeData(color: kWhitecolor, size: 10.0),
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
                                style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                  fontSize: kFontsize.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kWhitecolor,
                                )),
                                cursorColor: kMaincolor,
                                controller: editingController,
                                onChanged: (value) {
                                  filterSearchResults(value);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search,
                                      color: kSearchTextcolor),
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: kSearchTextcolor),
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
                                style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  color: KLightermaincolor,
                                )));
                          }
                        });
                      }),
                ],
              )
            ]),
        body: SingleChildScrollView(
          child: Container(
              child: Column(children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      // Provide an optional curve to make the animation feel smoother.

                      curve: Curves.fastOutSlowIn,
                      decoration: BoxDecoration(),
                      child: Card(
                        color: kListView,
                        elevation: 5.0,
                        child: ListTile(
                            subtitle: Text('${items[index]}',
                                style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                  fontSize: kFontsize.sp,
                                  fontWeight: FontWeight.bold,
                                  color: kWhitecolor,
                                ))),
                            title: Text('${items[index]}',
                                style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                  fontSize: kFontsize.sp,
                                  fontWeight: FontWeight.bold,
                                  color: kWhitecolor,
                                ))),
                            trailing: itemsColor.contains(items[index])
                                ? Icon(
                                    Icons.radio_button_checked,
                                    color: kFbColor,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    color: kWhitecolor,
                                  ),
                            leading: itemsColor.contains(items[index])
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        '${contactImage[index]}'.toString()),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        width: 50.0,
                                        height: 50.0,
                                        fit: BoxFit.cover,
                                        image: ('${contactImage[index]}'
                                            .toString()),
                                        placeholder:
                                            'images/classroom/user.png',
                                      ),
                                    ),
                                  ),
                            onTap: () => _onTapItem(context, items[index])),
                      ),
                    ),
                  );
                }),
          ])),
        ),
      ),
    );
  }

  _onTapItem(BuildContext context, String item) {
    setState(() {
      if (itemsColor.contains(item)) {
        itemsColor.remove(item);
        ufriends.litems.remove(item);
        ucontacts.lcontacts.remove(item);
      } else {
        itemsColor.add(item);
        ufriends.litems.add(item);
        ucontacts.lcontacts.add(item);
        Variables.contactCount = ucontacts.lcontacts.length;
      }
    });
  }
}
