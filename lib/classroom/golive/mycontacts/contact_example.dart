/*
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/mycontacts/contacts_const.dart';
import 'package:sparks/mycontacts/contacts_details_profile_image.dart';
import 'package:sparks/mycontacts/list_title.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/variable_live_modal.dart';
import 'package:sparks/widget/circle_online.dart';

class MyContactsappbar extends StatefulWidget {
  static String classroomContactList = kMyContactsroutes;

  @override
  _MyContactsappbarState createState() => _MyContactsappbarState();
}

class _MyContactsappbarState extends State<MyContactsappbar> {
  static bool fontScale = true;
  bool viewVisible = true;

  Widget appBarTitle = Text(kListviewContact,
      style: TextStyle(
        fontSize: 24.0,
        color: kWhitecolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ));
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
            backgroundColor: kBlackcolor,
            body: ListView.builder(
              itemCount: ContactsDetails.titles.length,
              itemBuilder: (context, index) {

                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: Card(

                    color: kListView,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            ContactProfileImages.ProfileImages[index]),
                      ),
                      title: Text(
                        ContactsDetails.titles[index],
                        style: Variables.textstyles,
                      ),

                      subtitle: Row(children: <Widget>[
                        Text('Mentor:',style: Variables.textstyles,),
                        Padding(
                          padding: const EdgeInsets.only(left:4.0),
                          child: Text(
                            ContactsDetailsContacts.contactstitles[index],
                            style: Variables.textstyles,
                          ),
                        ),
                      ]
                      ),
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
                );
              },
            )));
  }
}
*/

/*

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/mycontacts/contacts_const.dart';
import 'package:sparks/mycontacts/contacts_details_profile_image.dart';
import 'package:sparks/mycontacts/list_title.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/variable_live_modal.dart';
import 'package:sparks/widget/circle_online.dart';

class MyContactsappbar extends StatefulWidget {
  static String classroomContactList = kMyContactsroutes;

  @override
  _MyContactsappbarState createState() => _MyContactsappbarState();
}

class _MyContactsappbarState extends State<MyContactsappbar> {
  static bool fontScale = true;
  bool viewVisible = true;

  Widget appBarTitle = Text(kListviewContact,
      style: TextStyle(
        fontSize: 24.0,
        color: kWhitecolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ));
  Icon actionIcon = new Icon(Icons.search);

  var holder_1 = [];

  getItems(){

    ContactsDetails.titles.forEach((key, value) {
      if(value == true)
      {
        holder_1.add(key);
      }
    });

    // Printing all selected items on Terminal screen.
    print(holder_1);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
    holder_1.clear();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        backgroundColor: kBlackcolor,
        body: ListView(
          children: ContactsDetails.titles.keys.map((String key) {
            return Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 0),
              child: Card(
                color: kListView,
                child: CheckboxListTile(

                  title: Text(key,style: Variables.textstyles,),
                  value: ContactsDetails.titles[key],
                  activeColor: kMaincolor,
                  checkColor: Colors.white,
                  onChanged: (bool value) {

                    setState(() {
                      ContactsDetails.titles[key] = value;
                    });
                  },

                  subtitle: Text(ContactsDetailsContacts.ConDet[0],
                    style: Variables.textstyles,),
                ),

              ),
            );
          }).toList(),

        ),
      ),


    );

  }
}*/

/*


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/dimens/dimen.dart';
import 'package:sparks/variable_live_modal.dart';
import 'package:sparks/widget/circle_offline.dart';
import 'package:sparks/widget/circle_online.dart';

class SubTitle extends StatelessWidget {

  SubTitle({this.title, this.nos,this.online, this.offline });
  final String title;
  final int nos;
  final int online;
  final int offline;
  @override
  Widget build(BuildContext context) {


    return Row(
      children: <Widget>[
        Text(title ,
            style: Variables.textstyles),
        RaisedButton(
            color: kMaincolor,
            splashColor: Colors.blueAccent,
            shape: new CircleBorder(),
            child: new Text(nos.toString()),
            onPressed:(){

            }
        ),
        Container(
          child: CustomPaint(painter: DrawCircle()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( online.toString(),
              style: Variables.textstyles),
        ),
        Container(
          child: CustomPaint(painter: ShapesPainter()),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(offline.toString(),
              style: Variables.textstyles),
        ),
      ],
    );

  }
}*/

/*


import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/mycontacts/contacts_const.dart';
import 'package:sparks/send.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/variable_live_modal.dart';

class MyContactsappbar extends StatefulWidget {
  static String classroomContactList = kMyContactsroutes;
  MyContactsappbar({Key key, this.product}) :super(key: key);
  List<ContactsDetails> product;
  @override
  _MyContactsappbarState createState() => _MyContactsappbarState();
}

class _MyContactsappbarState extends State<MyContactsappbar> {
  static bool fontScale = true;
  bool viewVisible = true;
  ContactsDetails _contactsDetails = ContactsDetails(
    image: 'https://cdn.motherandbaby.co.uk/web/1/root/baby-towel-face.png',
    title: 'mimi',
    condet: 'hello',);


  Widget appBarTitle = Text(kListviewContact,
      style: TextStyle(
        fontSize: 24.0,
        color: kWhitecolor,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.bold,
      ));
  Icon actionIcon = new Icon(Icons.search);
  */
/*void ItemChange(bool val,String index){
    setState(() {
      ContactsDetails.titles[index] = val;
    });
  }*/ /*

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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

            backgroundColor: kBlackcolor,
            body: new Container(
              padding: new EdgeInsets.all(8.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Expanded(child: new ListView(
                    padding: new EdgeInsets.symmetric(vertical: 8.0),
                    children: widget.product.map((ContactsDetails product) {
                      return new ShoppingItemList(product: _contactsDetails);
                    }).toList(),
                  )),

                  SizedBox.fromSize(
                    size: Size(56, 56), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: kFloatbtn, // button color
                        child: InkWell(
                          splashColor: kMaincolor, // splash color
                          onTap: () {
                            for (ContactsDetails p in widget.product) {
                              if (p.isChecked)
                                setState(() {
                                  Variables.usercontactselection = p.title;
                                  print(Variables.usercontactselection);
                                  Navigator.of(context).pop();
                                });

                            }
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add,color:kWhitecolor), // icon
                              // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ));
  }
}

class ShoppingItemList extends StatefulWidget{
  final ContactsDetails product;

  ShoppingItemList({this.product});
  @override
  ShoppingItemState createState() {
    return new ShoppingItemState(product);
  }
}
class ShoppingItemState extends State<ShoppingItemList> {
  final ContactsDetails product;
  ShoppingItemState(this.product);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kListView,
      child: new ListTile(
        onTap:null,
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              image:(product.image),
              fit: BoxFit.cover,
              width: 80.0,
              height: 80.0,
              placeholder: 'images/user.png',
            ),
          ),
        ),
        title:  Text(product.title,
            style: Variables.textstyles),

        trailing:  CircularCheckBox(inactiveColor: kWhitecolor,
            value: product.isChecked, onChanged: (bool value) {
              setState(() {
                product.isChecked = value;

              });
            }),

        subtitle:
        Text('Mentor' + " "+':'+ " " +product.condet,style: Variables.textstyles,),


      ),
    );
  }
}


*/
