import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UploadContactList extends StatefulWidget {
  @override
  _UploadContactListState createState() => _UploadContactListState();
}

class _UploadContactListState extends State<UploadContactList> {
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
  var itemscolor = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackcolor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhitecolor, size: 10.0),
        elevation: 4.0,
        backgroundColor: kBlackcolor,
        title: Text(kChooseFriends,
            style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
              color: kWhitecolor,
            ))),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
            child: TextFormField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              cursorColor: kMaincolor,
              controller: editingController,
              decoration: InputDecoration(
                fillColor: kWhitecolor,
                filled: true,
                hintStyle: TextStyle(
                  fontSize: kFontsize.sp,
                  color: kTextcolorhintcolor,
                  fontFamily: 'Rajdhani',
                  fontWeight: FontWeight.bold,
                ),
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kMaincolor)),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
          ),
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
                          trailing: itemscolor.contains(items[index])
                              ? Icon(
                                  Icons.radio_button_checked,
                                  color: kFbColor,
                                )
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  color: kWhitecolor,
                                ),
                          leading: itemscolor.contains(items[index])
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
                                      image:
                                          ('${contactImage[index]}'.toString()),
                                      placeholder: 'images/classroom/user.png',
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
    );
  }

  _onTapItem(BuildContext context, String item) {
    setState(() {
      if (itemscolor.contains(item)) {
        itemscolor.remove(item);
        UploadUfriends.litems.remove(item);
        Uploadcontacts.lcontacts.remove(item);
      } else {
        itemscolor.add(item);
        UploadUfriends.litems.add(item);
        Uploadcontacts.lcontacts.add(item);
        UploadVariables.contactCount = UploadUfriends.litems.length;
      }
    });
  }
}
