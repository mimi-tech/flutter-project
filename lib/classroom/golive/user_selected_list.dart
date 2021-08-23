import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UserSelections extends StatefulWidget {
  @override
  _UserSelectionsState createState() => _UserSelectionsState();
}

class _UserSelectionsState extends State<UserSelections> {
  var items = [];
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    items.addAll(ufriends.litems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(ufriends.litems);
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
        items.addAll(ufriends.litems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            color: kListcard,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.cancel,
                          size: 28,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            kDoneText,
                            style: TextStyle(
                              fontSize: kFontsize.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                              color: kBlackcolor,
                            ),
                          )),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                child: TextFormField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
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
                      padding: const EdgeInsets.only(left: 6.0, right: 6),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(80.0),
                            bottomRight: Radius.circular(80.0),
                          )),
                          child: Card(
                            elevation: 5,
                            color: kListcard,
                            child: ListTile(
                              title: Text(items[index],
                                  style: TextStyle(
                                    fontSize: kFontsize.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Rajdhani',
                                    color: kBlackcolor,
                                  )),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    items.removeAt(index);
                                    ufriends.litems.removeAt(index);

                                    //ucontacts.lcontacts.removeAt(index);
                                    //UserpickContacts.pickContacts.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                  color: kBlackcolor,
                                ),
                              ),
                            ),
                          )),
                    );
                  }),
            ])),
      ),
    );
  }
}
