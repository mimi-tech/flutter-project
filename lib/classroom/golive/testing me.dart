/*




 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';
import 'package:sparks/classroom/expert_class/intro_screen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
class ExpertLandingPage extends StatefulWidget {
  @override
  _ExpertLandingPageState createState() => _ExpertLandingPageState();
}

class _ExpertLandingPageState extends State<ExpertLandingPage>  with TickerProviderStateMixin{
  static Animation<Offset> animation;
  AnimationController animationController;
  TextEditingController _key =  TextEditingController();
  late AnimationController _controller;
  Animation<Offset> _offsetFloat;
  String myKey;
bool progress = false;


  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }


  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });


    //ToDo:second animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();

  }
  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
appBar: AppBar(
  iconTheme: IconThemeData(color: kBlackcolor, size: 20.0),
  backgroundColor: kWhitecolor,
 elevation: 0,
 title: Row(
   mainAxisAlignment: MainAxisAlignment.end,
   children: <Widget>[
     RaisedButton(
       color: kFbColor,
       onPressed: (){},
       child:Text('Apply',
           style: GoogleFonts.rajdhani(
             textStyle: TextStyle(
               fontWeight: FontWeight.bold,
               color: kWhitecolor,
               fontSize: kFontsize.sp,
             ),
           )

       )
     )
   ],
 ),
),
        body: SingleChildScrollView(
          child: Column(
     children: <Widget>[
              spacer(),
  Center(child: SvgPicture.asset('images/classroom/unlock.svg',)),
          spacer(),
          SlideTransition(
            position: _offsetFloat,
            child: Center(child: Text(kExpertPin,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kExpertColor,
                    fontSize: 22.sp,
                  ),
                )

            )),
          ),
       spacer(),

       Container(
         margin: EdgeInsets.symmetric(horizontal: kHorizontal),
         child: TextField(
           controller: _key,
             autofocus: true,

           style: UploadVariables.uploadfontsize,
           decoration: ExpertConstants.keyDecoration,
           onChanged: (String value) {
             myKey = value;
           },

         ),
       ),
       spacer(),

            RichText(

              text: TextSpan(text:kApply,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold
                  ),

                  children: <TextSpan>[
                    TextSpan(
                      text: 'apply',
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kExpertColor.withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ]
              ),


            ),

       spacer(),

            progress == true?PlatformCircularProgressIndicator(): RaisedButton(
           color: kExpertColor,
           onPressed: (){verifyUser();},
           child:Text('Verify',
               style: GoogleFonts.rajdhani(
                 textStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: kWhitecolor,
                   fontSize: kFontsize.sp,
                 ),
               )

           )
       )

    ],

          ),
        )));
  }

  Future<void> verifyUser() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    User currentUser =
    await FirebaseAuth.instance
        .currentUser();
    String uid;
    String key;
    if ((myKey == null) || (myKey == '')) {
      Fluttertoast.showToast(
          msg: 'Please enter your key',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }  else {
      setState(() {
        progress = true;
      });

      try {


        final snapShot = await FirebaseFirestore.instance
            .collection("expertAdmin")
            .doc(currentUser.uid)

            .get();

        if (snapShot == null || !snapShot.exists) {
          // Document with id == docId doesn't exist.
          print('no it does not exist');

        }else{
          print('yes does  exist');


          await FirebaseFirestore.instance.collection('expertAdmin')
              .where('ky', isEqualTo:myKey )


              .get().then((value) {
            value.docs.forEach((result) {
              setState(() {
                key = result.data['ky'];
                uid = result.data['uid'];
                print(key);
                print(uid);
              });
            });
          }).whenComplete(() {
            if ((uid == currentUser.uid)  && (key == myKey))  {
              setState(() {
                progress = false;
              });
              Navigator.of(context).pushReplacement
                (MaterialPageRoute(builder: (context) => IntroductoryScreen()));
            }else{
              setState(() {
                progress = false;
              });


              /*check if the account or key did not match*/

              if((uid != currentUser.uid)){
                Fluttertoast.showToast(
                    msg: 'Inproper account',
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: kBlackcolor,
                    textColor: kFbColor);
              }else if(key != myKey){
                Fluttertoast.showToast(
                    msg: 'Incorrect key',
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: kBlackcolor,
                    textColor: kFbColor);
              }


            }
          });

        }


      }catch (e){
        setState(() {
          progress = false;
        });
        print('this is the problem' + e.toString());
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom_custom_listview.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/variable_live_modal.dart';
import 'package:sparks/widget/appBarSwich_component.dart';

class ClassroomContact extends StatefulWidget {
  static String classroomContactName = kContactsroutes;

  @override
  _ClassroomContactState createState() => _ClassroomContactState();
}

class _ClassroomContactState extends State<ClassroomContact> {
  static bool fontScale = true;
  bool viewVisible = true ;
  Widget appBarTitle = Text(kChooseFriends,
      style: Variables.textstyles);
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


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
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: viewVisible,
                    child: AppbarSwitchComponent() ,
                  ),


                  IconButton(
                      icon: actionIcon,
                      onPressed: () {
                        setState(() {
                          if (this.actionIcon.icon == Icons.search) {
                            viewVisible = false ;
                            this.actionIcon = Icon(Icons.close);
                            this.appBarTitle  = TextFormField(
                                style: TextStyle(color: kSearchTextcolor),
                                decoration: InputDecoration(

                                  prefixIcon: Icon(Icons.search,
                                      color: kSearchTextcolor),
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: kSearchTextcolor),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kSearchTextcolor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kMaincolor),
                                  ),
                                ));



                                     /*padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
              child: TextFormField(
                style:GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontSize: kFontsize.sp,
                      fontWeight: FontWeight.w600,
                      color: kWhitecolor,
                    )),
                onChanged: (value) {
                  filterSearchResults(value);
                },
                cursorColor: kMaincolor,
                controller: editingController,
                decoration: InputDecoration(

                  hintStyle: TextStyle(fontSize: kFontsize.sp,
                    color: kSearchTextcolor,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search,color: kMaincolor,),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kSearchTextcolor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kMaincolor),
                  ),
                ),
              )
          )*/


                          } else {
                            viewVisible = true ;
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

          body: ClassroomCustomListview(),

        )
    );

  }
}


*/

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







import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/classroom/contents/profilepicture.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
class TopAppBar extends StatefulWidget implements PreferredSizeWidget{
  TopAppBar({this.search});
  final Function search;
  @override
  _TopAppBarState createState() => _TopAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}
class _TopAppBarState extends State<TopAppBar> {
  Icon actionIcon =  Icon(Icons.search);
  Widget appBarTitle = GestureDetector(
        child: ProfilePicture(),
      );


  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('images/classroom/hamburger.svg'),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      elevation: 10.0,
      backgroundColor: kplaylistappbar,

      title: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          IconButton(
            icon: actionIcon,
              color:kWhitecolor,
              onPressed:(){
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
                    this.appBarTitle =  GestureDetector(
                      child: ProfilePicture(),
                    );
                   //ToDo:friends request notifications
                  GestureDetector(
                  child: SvgPicture.asset(
                  "images/friends_notification.svg",
                  )
                  );
                  //ToDo:notifications

                  GestureDetector(child: Icon(Icons.notifications,color:kWhitecolor,size:30.0));

                  //TODO: messenger notification
                  GestureDetector(
                  child: SvgPicture.asset(
                  "images/classroom/messenger_icon.svg",
                  )
                  );
                  }
                });
              }
          ),





        ],
      ),


    );
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



import 'package:flutter/material.dart';

import 'package:sparks/bottomSheet_widget_fourth.dart';
import 'package:sparks/colors/colors.dart';
import 'package:sparks/widget/users_friends_selected_list.dart';
import 'package:sparks/variable_live_modal.dart';

class Send extends StatefulWidget {
  @override
  _SendState createState() =>
      _SendState();
}

@override
class _SendState extends State<Send> {

  @override
  Widget build(BuildContext context) {
    if((Variables.contactVal == false) && (Variables.menteesVal == false)
    && (Variables.tuteesVal == false) && (Variables.classmateVal == false)
        && (Variables.alumniVal == false)){
      setState(() {
        Variables.fb = false;
      });
    }else{
      setState(() {
        Variables.fb = true;
      });
    }

    if(Variables.switchControl == true){
      print("sdfs");
    setState((){
    Variables.contactVal = true;
    });
    }

    if(Variables.contactVal == true){
      Variables.contact =  'Contacts';
      if(ufriends.litems.contains( Variables.contact)){
        print('i m here');

      }else{
        ufriends.litems.add( Variables.contact);
      }
    }else if(ufriends.litems.contains( Variables.contact)){
      ufriends.litems.remove( Variables.contact);

    }else{
      Variables.contact = '';
    }
    if(Variables.menteesVal == true){
      Variables.mentees =  'Mentees';
      if(ufriends.litems.contains( Variables.mentees)){

      }else{
        ufriends.litems.add( Variables.mentees);
      }
    }else if(ufriends.litems.contains( Variables.mentees)) {
      ufriends.litems.remove(Variables.mentees);
    } else{
      Variables.mentees =  '';
    }
    if(Variables.tuteesVal == true){
      Variables.tutees =  'Tutees';
      if(ufriends.litems.contains( Variables.tutees)){

      }else{
        ufriends.litems.add( Variables.tutees);
      }
    }else if(ufriends.litems.contains( Variables.tutees)) {
      ufriends.litems.remove(Variables.tutees);
    }
    else{
      Variables.tutees =  '';
    }

    if(Variables.classmateVal == true){
      Variables.classmate =  'Classmate';
      if(ufriends.litems.contains( Variables.classmate)){

      }else{
        ufriends.litems.add( Variables.classmate);
      }

    }else if(ufriends.litems.contains( Variables.classmate)) {
      ufriends.litems.remove(Variables.classmate);
    } else{
      Variables.classmate =  '';
    }

    if((Variables.alumniVal == true)){
      Variables.Alumni =  'Alumni';
      if(ufriends.litems.contains( Variables.Alumni)){
        //print('i m here');
      }else{
        ufriends.litems.add( Variables.Alumni);
      }

    }else if(ufriends.litems.contains( Variables.Alumni)) {
      ufriends.litems.remove(Variables.Alumni);
    } else{
      Variables.Alumni =  '';

    }



    return Visibility(
      //visible: Variables.fb,
      visible: true,
      child: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => BottomSheetWidgetFourth()
          );

        },
        child: Icon(Icons.check,
            color:kWhitecolor, size: 40),
        backgroundColor: kFbColor,
      ),
    );

  }


}







import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UploadMultipleImageDemo extends StatefulWidget {
  UploadMultipleImageDemo() : super();

  final String title = 'Firebase Storage';

  @override
  UploadMultipleImageDemoState createState() => UploadMultipleImageDemoState();
}

class UploadMultipleImageDemoState extends State<UploadMultipleImageDemo> {
  //
  String _path;
  Map<String, String> _paths;
  String _extension;
  FileType _pickType;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<UploadTask> _tasks = <UploadTask>[];

  void openFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickType, );
      } else {
        _path = await FilePicker.getFilePath(
            type: _pickType, );
      }
      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    if (_multiPick) {
      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
    } else {
      String fileName = _path.split('/').last;
      String filePath = _path;
      upload(fileName, filePath);
    }
  }

  upload(fileName, filePath) {
    _extension = fileName.toString().split('.').last;
    Reference storageRef =
    FirebaseStorage.instance.ref().child(fileName);
    final UploadTask uploadTask = storageRef.putFile(
      File(filePath),
      SettableMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  dropDown() {
    return DropdownButton(
      hint: new Text('Select'),
      value: _pickType,
      items: <DropdownMenuItem>[

        new DropdownMenuItem(
          child: new Text('Video'),
          value: FileType.video,
        ),

      ],
      onChanged: (value) => setState(() {
        _pickType = value;
      }),
    );
  }

  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    _tasks.forEach((UploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        onDownload: () => downloadFile(task.lastSnapshot.ref),
      );
      children.add(tile);
    });

    return new MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(widget.title),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              dropDown(),
              SwitchListTile.adaptive(
                title: Text('Pick multiple files', textAlign: TextAlign.left),
                onChanged: (bool value) => setState(() => _multiPick = value),
                value: _multiPick,
              ),
              OutlineButton(
                onPressed: () => openFileExplorer(),
                child: new Text("Open file picker"),
              ),
              SizedBox(
                height: 20.0,
              ),
              Flexible(
                child: ListView(
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(Reference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
          '\npath: $path \nBytes Count :: $byteCount',
    );
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Image.memory(
          bodyBytes,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final UploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        Widget subtitle;
        Widget prog;
        Widget progtext;
        if (asyncSnapshot.hasData) {
          final TaskSnapshot event = asyncSnapshot.data;
          final TaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)}');
         double _progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
         prog = LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.red,
                  );
                  progtext = Text('${(_progress * 100).toStringAsFixed(2)} %');



        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: subtitle,
               // Text('Upload Task #${task.hashCode}'),

            subtitle: prog,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),

              ],


            ),
          ),
        );
      },
    );
  }
}







import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/createplaylist.dart';
import 'package:sparks/classroom/uploadvideo/widgets/playlistappbar.dart';
import 'package:sparks/classroom/uploadvideo/widgets/playlistbtn.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/uploadSelectedcontact.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PlaylistScreen extends StatefulWidget {

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool playlistList = false;
      List<bool> _data = new List<bool>();
  var playlistCheckbox = [];
  TextEditingController searchController = TextEditingController();
  String? filter;
  bool _publishModal = false;

  @override
  void initState() {
    // TODO: implement initState
   searchController.addListener(() {
     setState(() {
       filter = searchController.text;
     });
   });
    super.initState();
  }
  @override  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onChange(bool value, int index) {
    setState((){
      _data[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        allowFontScaling: Variables.scaleFontSize);
    return SafeArea(
      child: Scaffold(
        appBar: PlaylistAppbar(),
        backgroundColor:kWhitecolor,
        body: ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                 PlayListBtn(name:kCreateplaylist,save: kSave, create: (){
                   Navigator.push(context, PageTransition
                     (type: PageTransitionType.rightToLeft, child: CreatePlayList()));

                 },saved: (){
                     sendPlayList();
                   },),
//ToDo:Horizontal list displaying all friends selected
                Visibility(
                  visible: UploadUfriends.litems.isEmpty ? false : true,
                  child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child:UploadUserFriendsSelected()),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                  child: TextField(
                    onChanged: (value) {
                      //filterSearchResults(value);
                    },
                    controller: searchController,
                    decoration: InputDecoration(

                      hintText: kSearchplaylist,
                      hintStyle: TextStyle(fontSize: ScreenUtil()
                          .setSp(kFontsize, allowFontScalingSelf: Variables.scaleFontSize),
                        color: kTextcolorhintcolor,
                        fontFamily: 'Rajdhani',
                       textBaseline: TextBaseline.ideographic
                      ),
                      prefixIcon: Icon(Icons.search,color: kBlackcolor,size: 30.0,),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0)),),
                  ),
                ),




                SizedBox(height: 50.0,),
                StreamBuilder(
    stream: FirebaseFirestore.instance
          .collection('sessionplaylists')
          .where('uid',
    isEqualTo:  UploadVariables.playlistCurrentUser)
          .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
          return NoPlayListCreated();
      } else {
          final userplaylist = snapshot.data.docs;
          List<String> playlistWidget = [];
          for (var playlist in userplaylist) {
            final playlistText = playlist.data['name'];
            playlistWidget.add(playlistText);
          }
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: playlistWidget.length,
                itemBuilder: (BuildContext context, int index) {
                  return filter == null || filter == "" ? ListTile(
                      leading: playlistCheckbox.contains(playlistWidget[index])
                          ? Checkbox(
                        value: true,
                        onChanged: (bool value) {
                          _onChange(value, index);
                          print(index);
                        },
                      )
                          : Checkbox(
                        value: false,
                        onChanged: (bool value) {
                          _onChange(value, index);
                        },
                      ),
                      title: Text(playlistWidget[index],
                        style: TextStyle(fontSize: ScreenUtil()
                            .setSp(kFontsize,
                            allowFontScalingSelf: Variables.scaleFontSize),
                          color: kBlackcolor,
                          fontFamily: 'Rajdhani-Medium ',
                        ),),
                      onTap: () =>
                          _onTapPlaylist(context, playlistWidget[index])

                  ): '${playlistWidget[index]}'.toLowerCase()
                      .contains(filter.toLowerCase())

                      ? ListTile(
                  leading:  playlistCheckbox.contains(playlistWidget[index]) ? Checkbox(
                      value: true,
                      onChanged: (bool value) {
                        _onChange(value, index);
                        print(index);
                      },
                    )
                        : Checkbox(
                    value: false,
                    onChanged: (bool value) {
                      _onChange(value, index);
                    },
                  ),
                  title: Text(playlistWidget[index],
                  style: TextStyle(fontSize: ScreenUtil()
                      .setSp(kFontsize,
                  allowFontScalingSelf: Variables.scaleFontSize),
                  color: kBlackcolor,
                  fontFamily: 'Rajdhani-Medium ',
                  ),),
                  onTap: () =>
                  _onTapPlaylist(context, playlistWidget[index])

                  ): Container();
                }
            ),
          );
      }
    }      ),



              ],
            ),
          ),
        )


            //SizedBox(height: 50.0,),









      ),
    );
  }

  void createPlaylist() {
    Navigator.push(context, PageTransition
      (type: PageTransitionType.rightToLeft, child: CreatePlayList()));
  }

  _onTapPlaylist(BuildContext context, String text) {
   setState(() {
     if (playlistCheckbox.contains(text)) {
       playlistCheckbox.remove(text);
     }else{
       playlistCheckbox.clear();
       playlistCheckbox.add(text);
       print(playlistCheckbox);
     }
   }
     );
  }
//Todo: sending playlist to fireBase;
  Future<void> sendPlayList() async {
    var now = new DateTime.now();
    var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
    User currentUser =
        await FirebaseAuth.instance
        .currentUser();
   if( playlistCheckbox.isEmpty){
     Fluttertoast.showToast(
         msg: kSscheckplaylist,
         toastLength: Toast.LENGTH_LONG,
         backgroundColor: kBlackcolor,
         textColor: kFbColor);
   }

   setState(() {
     _publishModal = true;
   });
    /*FirebaseFirestore.instance.collection("sessionplaylists").add({
      'date': date,
      'name': UploadVariables.playlistTitle,
      'uid': currentUser.uid,
      'email': currentUser.email,
      *//* playlist contact*//* 'vido': FieldValue.arrayUnion(UploadVideo.selectedVideo)
    });*/
    /*FirebaseFirestore.instance
        .collection('users')
        .doc('dhiMcPIs8MMzT7CDOEN0')
        .update({'vido': });*/

    setState(() {
      _publishModal = false;
    });
    Fluttertoast.showToast(
        msg: kSsplaylistsuccessful,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: kBlackcolor,
        textColor: kSsprogresscompleted);
    setState(() {
      UploadUfriends.litems.clear();
    });
    Fluttertoast.showToast(
        msg: kSsplaylistaddedsuccessfully,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: kBlackcolor,
        textColor: kSsprogresscompleted);

  }



}

class NoPlayListCreated extends StatelessWidget {
  const NoPlayListCreated({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      height: ScreenUtil().setHeight(360),

      width: ScreenUtil().setHeight(350),

      decoration: BoxDecoration(

        shape: BoxShape.rectangle,

        border: Border.all(

          width: 2.0,

          color: klistnmber,

        ),

        borderRadius: BorderRadius.circular(10.0),

      ),

      child: Center(

        child:   Text(kNoplaylist,



          style: TextStyle(fontSize: kFontsize.sp,



            color: klistnmber,



            fontFamily: 'Rajdhani-Medium ',







          ),),

      ),

    );
  }
}




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/appbar.dart';
import 'package:sparks/classroom/contents/appbar2.dart';
import 'package:sparks/classroom/contents/drawer.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/contents/live/icons.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:video_player/video_player.dart';
import 'package:sparks/classroom/contents/live/text.dart';
import 'package:sparks/classroom/contents/live/text2.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/contents/top_app.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  bool _publishModal = false;

  DocumentSnapshot _currentDocument;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: TopAppBar(),
      drawer: DrawerBar(),
      body: ModalProgressHUD(
        inAsyncCall: _publishModal,
        child: CustomScrollView(slivers: <Widget>[
          SilverAppBar(),
          SilverAppBarSecond(),
          SliverList(
            delegate: SliverChildListDelegate([
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('sessioncontent')
                      .doc(UploadVariables.currentUser)
                      .collection('usersessionuploads')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      // Here u will get list of document snapshots
                      final List<DocumentSnapshot> documents =
                          snapshot.data.docs;

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (context, int index) => Column(
                                  children: snapshot.data.docs.map((doc) {
                                return Column(
                                  children: <Widget>[
                                    SizedBox(height: 10.0),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        color: GetSelectedCard.selectedCard
                                                .contains(documents[index]
                                                    .data['vi_id']
                                                    .toString())
                                            ? Colors.grey[300]
                                            : kWhitecolor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 20.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 18.0,
                                              top: 10.0,
                                              left: 8.0,
                                              right: 8.0),
//ToDo:displaying the icons
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  ShowIcons(
                                                    playlist: () {
                                                      UploadVideo.selectedVideo
                                                          .clear();
                                                      UploadVideo.selectedVideo
                                                          .add(documents[index]
                                                              .data['vido']);
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PlaylistScreen()));
                                                    },
                                                    delete: () {
//_currentDocument = doc;
                                                      Navigator.pop(context);
                                                      showDeleteDialog();
                                                    },
//ToDo:Downloading a video
                                                    download: () {},
                                                  ),

                                                  SizedBox(width: 5.0),
//ToDo:Display the live videos
                                                  if (documents[index]
                                                          .data['vido'] ==
                                                      '')
                                                    FadeInImage.assetNetwork(
                                                      width: ScreenUtil()
                                                          .setWidth(100),
                                                      height: ScreenUtil()
                                                          .setHeight(100),
                                                      fit: BoxFit.cover,
                                                      image: (documents[index]
                                                          .data['tmb']
                                                          .toString()),
                                                      placeholder:
                                                          'images/classroom/placeholder.jpg',
                                                    )
                                                  else
                                                    Container(
                                                      width: ScreenUtil()
                                                          .setWidth(100),
                                                      child: Stack(
                                                          children: <Widget>[
                                                            Center(
                                                              child:
                                                                  ShowUploadedVideo(
                                                                videoPlayerController:
                                                                    VideoPlayerController.network(
                                                                        documents[index]
                                                                            .data['vido']),
                                                                looping: false,
                                                              ),
                                                            ),
                                                            Center(
                                                                child: ButtonTheme(
                                                                    height: ScreenUtil().setHeight(100),
                                                                    minWidth: ScreenUtil().setWidth(100),
                                                                    child: RaisedButton(
                                                                        color: Colors.transparent,
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              UploadVariables.videoUrlSelected = documents[index].data['vido'];

                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                            },
                                                                            child: Icon(Icons.play_arrow, size: 40)))))
                                                          ]),
                                                    ),

                                                  SizedBox(
                                                    height: 10.0,
                                                  ),

//ToDo:live text display
                                                  LiveText(
                                                    title: documents[index]
                                                        .data['title'],
                                                    desc: documents[index]
                                                        .data['desc'],
                                                    rate: documents[index]
                                                        .data['rate']
                                                        .toString(),
                                                    date: documents[index]
                                                        .data['date'],
                                                    views: documents[index]
                                                        .data['views']
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Divider(
                                                color: kAshthumbnailcolor,
                                                thickness: kThickness,
                                              ),

//ToDo:Displaying the live text second
                                              LiveTextSecond(
                                                visibility: documents[index]
                                                    .data['visi'],
                                                aLimit: documents[index]
                                                    .data['alimit'],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList()));
                    }
                  }),
            ]),
          )
        ]),
      ),
    );
  }

  void showDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            children: <Widget>[
              DeleteDialog(
                oneDelete: () {
                  actualDelete();
                },
              )
            ]));
  }

  //ToDo: actually deleting from firebase
  Future<void> actualDelete() async {
    _publishModal = true;
    User currentUser = await FirebaseAuth.instance.currentUser();
    await FirebaseFirestore.instance
        .collection('sessioncontent')
        .doc(currentUser.uid)
        .collection('usersessionuploads')
        .doc(_currentDocument.documentID)
        .delete();
    _publishModal = false;
    Fluttertoast.showToast(
        msg: kSdeletedsuuccessfully,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: kBlackcolor,
        textColor: kSsprogresscompleted);
  }
}


import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class MyViewModel extends ChangeNotifier {

  double _progress = 0;
  get downloadProgress => _progress;

  void startDownloading() async {
    _progress = null;
    notifyListeners();
    final url = 'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_5MG.mp3';
    final request = Request('GET', Uri.parse(url));
    final StreamedResponse response = await Client().send(request);
    final contentLength = response.contentLength;

    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);
    _progress = 0;
    notifyListeners();
    List<int> bytes = [];
    final file = await _getFile('song.mp3');
    response.stream.listen(
          (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / contentLength;
        notifyListeners();

      },
      onDone: () async {
        _progress = 0;
        notifyListeners();
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        print(e);
      },
      cancelOnError: true,
    );
  }

  Future<File> _getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$filename");
  }
}


/*

var response = await Dio().get((doc.data['tmb']),
options: Options(
responseType: ResponseType.bytes));
final result = await ImageGallerySaver
    .saveImage(
Uint8List.fromList(
response.data));
print(result);
}else{
final appDocDir = await Directory.systemTemp.createTemp();
String savePath = appDocDir.path + "/temp.mp4";
await Dio().download(doc.data['vido'], savePath);
final result = await ImageGallerySaver.saveFile(savePath);
print(result);





 Dio dio = Dio();

                                                  try {
                                                    var dir = await getApplicationDocumentsDirectory();
                                                    await dio.download(imageUrl, "${dir.path}/myimage/jpg", onReceiveProgress: (rec, total) {
                                                      setState(() {
                                                        _progress =
                                                            (rec / total);
                                                      });
                                                    });
                                                  } catch (e) {
                                                    print(e);
                                                  }






}*/




import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparks/classroom/contents/appbar3.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/contents/live/icons.dart';
import 'package:sparks/classroom/contents/live/text.dart';
import 'package:sparks/classroom/contents/live/text2.dart';
import 'package:sparks/classroom/contents/live_posts/download.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:video_player/video_player.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/appbar.dart';
import 'package:sparks/classroom/contents/appbar2.dart';
import 'package:sparks/classroom/contents/drawer.dart';
import 'package:sparks/classroom/contents/top_app.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LiveContent extends StatefulWidget {

  final TargetPlatform platform;

  LiveContent({Key key, this.platform}) : super(key: key);


  @override
  _LiveContentState createState() => _LiveContentState();
}

class _LiveContentState extends State<LiveContent> {
  var items = [];
  bool _publishModal = false;
  String? filter;
  var searchItems = [];
  //await new Future.delayed(const Duration(seconds : 15));
  List<String> selectedDocument = <String>[];
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    //ToDo:search filtering
    searchItems.addAll( ContentTitle.title);
    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    //UploadVariables.searchController.dispose();
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  List<_TaskInfo>   myTasks = [];
  List<_ItemHolder> myItems = [];

  List<_TaskInfo>   downloadTasks = [];

  @override
  Widget build(BuildContext context) {

    /*ContentDocuments.docs.forEach((doc) {

      myTasks.add(_TaskInfo(name: doc['title'], link: doc['vido']));
      myItems.add(_ItemHolder(doc));

    });*/

    for (int i = 0; i < ContentDocuments.docs.length; i++) {

      myTasks.add(_TaskInfo(
          name: ContentDocuments.docs[i]['title'],
          link: ContentDocuments.docs[i]['vido'])
      );

      myItems.add(_ItemHolder(
          name: ContentDocuments.docs[i]['title'],
          task: myTasks[i])
      );

    }


    final platform = Theme.of(context).platform;

    return SafeArea(
      child: Scaffold(
          appBar: TopAppBar(),
          drawer: DrawerBar(),
          body: ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: CustomScrollView(slivers: <Widget>[
              SilverAppBar(
                matches: kSappbarcolor,
                friends: kSappbarcolor,
                classroom: kSappbarcolor,
                content: kStabcolor1,
              ),
              GetSelectedCard.selectedCard.isEmpty?SilverAppBarSecond(
                tutorialColor: kStabcolor,
                coursesColor: kBlackcolor,
                expertColor: kBlackcolor,
                eventsColor: kBlackcolor,
              ):SilverAppBarThird(listPlaylist: (){_addListPlaylist();},
                listDownload: (){_addListDownload();},
                listDelete: (){_addListDelete();},),
              //SilverAppBarThird(),
              SliverList(
                  delegate: SliverChildListDelegate([
                    UploadVariables.checkUserContent==false?  Container(
                              child: Column(
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics:  BouncingScrollPhysics(),
                                  itemCount: ContentDocuments.docs.length,
                                  itemBuilder: (context, int index) {

                                    return filter == null || filter == "" ?

                                    GestureDetector(

                                      onLongPress:(){

                                        _selectDoc(context, ContentDocuments.docs[index], index);

                                        downloadTasks.add(myTasks[index]);

                                        },

                                      onTap: (){
                                        _tapDoc(context, ContentDocuments.docs[index], index);
                                      },

                                      child:  Card(
                                          color: GetSelectedCard.selectedCard.contains(index)?Colors.yellow:kWhitecolor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0),
                                          ),
                                          elevation: 20.0,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: kScontentPadding1,
                                                top: kScontentPadding2,
                                                left: kScontentPadding3,
                                                right: kScontentPadding4),
                                            //ToDo:displaying the icons
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    ShowIcons(

                                                        playlist: () {
                                                          UploadVideo.selectedVideo.clear();
                                                          UploadVideo.selectedVideo.add(ContentVideos.videos[index]);
                                                          Navigator.of(context).pushReplacement(
                                                              MaterialPageRoute(builder: (context) => PlaylistScreen()));
                                                        },

                                                        //ToDo:deleting of document
                                                        delete: () {
                                                          Navigator.pop(context);
                                                        _onTapItem(context, ContentDocuments.docs[index]);

                                                        },
                                                        //ToDo:Downloading a video
                                                        download: () async {
                                                          Navigator.pop(context);
                                                         UploadVariables.downloadVideoUrl = ContentVideos.videos[index];
                                                          _onSelected(index);


                                                          String _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
                                                          final savedDir = Directory(_localPath);
                                                          bool hasExisted = await savedDir.exists();
                                                          if (!hasExisted) {
                                                            savedDir.create();
                                                          }
                                                          final taskId = await FlutterDownloader.enqueue(
                                                            url:  ContentVideos.videos[index],
                                                            savedDir: _localPath,
                                                            showNotification: true,
                                                            openFileFromNotification: true,
                                                          );

                                                        },
                                                        //ToDo:Copying link

                                              copyLink: () {
                                                Clipboard.setData( ClipboardData(
                                                    text: 'https://sparksuniverse.com/'+ContentVideoId.videosId[index]));
    Fluttertoast.showToast(
    msg: 'Copied',
        gravity: ToastGravity.CENTER,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: klistnmber,
    textColor: kWhitecolor);
    Navigator.pop(context);

                                                         },


                                                    ),

                                                    SizedBox(width: 5.0),
                                                    //ToDo:Display the live videos

                                                      Container(
                                                        width: ScreenUtil().setWidth(100),
                                                        child: Stack(
                                                            children: <Widget>[
                                                              Center(
                                                                child: ShowUploadedVideo(
                                                                  videoPlayerController:
                                                                  VideoPlayerController.network(ContentVideos.videos[index]),
                                                                  looping: false,
                                                                ),
                                                              ),
                                                              Center(
                                                                  child: ButtonTheme(
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                          100),
                                                                      minWidth: ScreenUtil()
                                                                          .setWidth(
                                                                          100),
                                                                      child: RaisedButton(
                                                                          color: Colors
                                                                              .transparent,
                                                                          textColor: Colors
                                                                              .white,
                                                                          onPressed: () {},
                                                                          child: GestureDetector(
                                                                              onTap: () {
                                                                                UploadVariables.videoUrlSelected = ContentVideos.videos[index];
                                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                              },
                                                                              child: Icon(
                                                                                  Icons.play_arrow,
                                                                                  size: 40)))))
                                                            ])
                                                      ),

                                                    SizedBox(
                                                      height: 10.0,
                                                    ),

                                                    //ToDo:live text display
                                                    LiveText(
                                                      title:  ContentTitle.title[index],
                                                       desc:  ContentDescription.description[index],
                                                       rate:  ContentRating.rating[index],
                                                       date:  ContentDate.date[index],
                                                      views:  ContentViews.views[index]
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),

                                                //ToDo:displaying the linear progress bar

                                                items.contains(index) ? DownloadVideo(): Divider(
                                                  color: kAshthumbnailcolor,
                                                  thickness: kThickness,
                                                ),

                                                //ToDo:Displaying the live text second
                                                LiveTextSecond(
                                                  visibility: ContentVisibility.visibility[index],
                                                  aLimit: ContentLimit.ageLimit[index],
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),


                                         //ToDo: This displays the items user has filtered




                                    ):'${searchItems[index]}'.toLowerCase()
                                        .contains(filter.toLowerCase())
                                        ? Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0),
                                      ),
                                      elevation: 20.0,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: kScontentPadding1,
                                            top: kScontentPadding2,
                                            left: kScontentPadding3,
                                            right: kScontentPadding4),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                ShowIcons(

                                                  playlist: () {
                                                    UploadVideo.selectedVideo.clear();
                                                    UploadVideo.selectedVideo.add(ContentVideos.videos[index]);
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(builder: (context) => PlaylistScreen()));
                                                  },

                                                  //ToDo:deleting of document
                                                  delete: () {
                                                    Navigator.pop(context);
                                                    _onTapItem(context, ContentDocuments.docs[index]);

                                                  },
                                                  //ToDo:Downloading a video
                                                  download: () async {
                                                    Navigator.pop(context);
                                                    UploadVariables.downloadVideoUrl = ContentVideos.videos[index];
                                                    _onSelected(index);


                                                    String _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
                                                    final savedDir = Directory(_localPath);
                                                    bool hasExisted = await savedDir.exists();
                                                    if (!hasExisted) {
                                                      savedDir.create();
                                                    }
                                                    final taskId = await FlutterDownloader.enqueue(
                                                      url:  ContentVideos.videos[index],
                                                      savedDir: _localPath,
                                                      showNotification: true,
                                                      openFileFromNotification: true,
                                                    );

                                                  },
                                                  //ToDo:Copying link

                                                  copyLink: () {
                                                    Clipboard.setData( ClipboardData(
                                                        text: 'https://sparksuniverse.com/'+ContentVideoId.videosId[index]));
                                                    Fluttertoast.showToast(
                                                        msg: 'Copied',
                                                        gravity: ToastGravity.CENTER,
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        backgroundColor: klistnmber,
                                                        textColor: kWhitecolor);
                                                    Navigator.pop(context);

                                                  },


                                                ),

                                                SizedBox(width: 5.0),
                                                //ToDo:Display the live videos

                                                Container(
                                                    width: ScreenUtil().setWidth(100),
                                                    child: Stack(
                                                        children: <Widget>[
                                                          Center(
                                                            child: ShowUploadedVideo(
                                                              videoPlayerController:
                                                              VideoPlayerController.network(ContentVideos.videos[index]),
                                                              looping: false,
                                                            ),
                                                          ),
                                                          Center(
                                                              child: ButtonTheme(
                                                                  height: ScreenUtil()
                                                                      .setHeight(100), minWidth: ScreenUtil()
                                                                      .setWidth(
                                                                      100),
                                                                  child: RaisedButton(
                                                                      color: Colors.transparent,
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            UploadVariables.videoUrlSelected = ContentVideos.videos[index];
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                          },
                                                                          child: Icon(
                                                                              Icons.play_arrow,
                                                                              size: 40)))))
                                                        ])
                                                ),

                                                SizedBox(
                                                  height: 10.0,
                                                ),

                                                //ToDo:live text display
                                                LiveText(
                                                    title:  searchItems[index],
                                                    desc:  ContentDescription.description[index],
                                                    rate:  ContentRating.rating[index],
                                                    date:  ContentDate.date[index],
                                                    views:  ContentViews.views[index]
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),

                                            //ToDo:displaying the linear progress bar

                                            items.contains(index) ? DownloadVideo(): Divider(
                                              color: kAshthumbnailcolor,
                                              thickness: kThickness,
                                            ),

                                            //ToDo:Displaying the live text second
                                            LiveTextSecond(
                                              visibility: ContentVisibility.visibility[index],
                                              aLimit: ContentLimit.ageLimit[index],
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                    :Container();

                                  }
                              ),

                            ],
                              )
                    ):NoContentCreated(title: kNocontentcreated,)
              ]))
            ]),
          )),
    );
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            children: <Widget>[
              DeleteDialog(
                oneDelete: () async {
                  if (UploadVariables.monVal == true) {
                    Navigator.pop(context);
                    _publishModal = true;
                    User currentUser = await FirebaseAuth.instance.currentUser();
                    await FirebaseFirestore.instance
                        .collection('sessioncontent')
                        .doc(currentUser.uid)
                        .collection('usersessionuploads')
                        .doc(document.documentID)
                        .delete();
                    _publishModal = false;
                    Fluttertoast.showToast(
                        msg: kSdeletedsuuccessfully,
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: kBlackcolor,
                        textColor: kSsprogresscompleted);
                  }else{
                    Fluttertoast.showToast(
                        msg: kuncheckwarning,
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: kBlackcolor,
                        textColor: kFbColor);
                  }

                }
              )
            ]));
  }

  void _onSelected(int index){
    UploadVariables.downloadIndex = index;

    setState(() {
      if (items.contains(index)) {

      } else {
        items.add(index);
      }
    });
  }

  void _selectDoc(BuildContext context, DocumentSnapshot document, int index) {

    SelectedDocuments.items .add(document.documentID);

    setState(() {
     if(GetSelectedCard.selectedCard .contains(index)){
       GetSelectedCard.selectedCard .remove(index);
       selectedDocument.remove(document.documentID);
     }else{
       HapticFeedback.vibrate();
       UploadVariables.showSilverAppbar = false;
       GetSelectedCard.selectedCard .add(index);
       /*Add documents id*/
       selectedDocument.add(document.documentID);
       /*Add the videos selected*/
       UploadVideo.selectedVideo.add(ContentVideos.videos[index]);

     }

    });
  }

  void _tapDoc(BuildContext context, DocumentSnapshot document, int index) {
    setState(() {
      if( GetSelectedCard.selectedCard.isEmpty){
        UploadVariables.showSilverAppbar = true;
        /*clear the video list selected*/
        UploadVideo.selectedVideo.clear();
      }else if(GetSelectedCard.selectedCard .contains(index)){
        GetSelectedCard.selectedCard.remove(index);
        selectedDocument.remove(document.documentID);
        /*remove the video selected*/
        UploadVideo.selectedVideo.remove(ContentVideos.videos[index]);

      }else{
        GetSelectedCard.selectedCard .add(index);
        /*Add documents id*/
        selectedDocument.add(document.documentID);
        /*Add the videos selected*/
        UploadVideo.selectedVideo.add(ContentVideos.videos[index]);
        /*Adding videos with the name of the video for downloading*/

      }
    });
  }
//Adding to playlist
  void _addListPlaylist() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistScreen()));
  }
//ToDo:Downloading videos in a list
  Future<void> _addListDownload() async {

   String _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    final taskId = await FlutterDownloader.enqueue(
      url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
    );


  }

  Future<String> _findLocalPath() async {
    final directory = TargetPlatform.android == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

   _addListDelete() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            children: <Widget>[
              DeleteDialog(
                  oneDelete: () async {
                    if (UploadVariables.monVal == true) {
                      Navigator.pop(context);
                      setState(() {
                        _publishModal = true;
                      });


                      try {

                        User currentUser = await FirebaseAuth.instance.currentUser();

                        for(int i = 0; i < selectedDocument.length; i++) {

                               FirebaseFirestore.instance
                              .collection('sessioncontent')
                              .doc(currentUser.uid)
                              .collection('usersessionuploads')
                              .doc(selectedDocument[i])
                              .delete().then( (onValue) {

                              });
                        }

                        setState(() {
                          _publishModal = false;
                        });
                        Timer.periodic(Duration(seconds: 2), (Timer t) => setState((){}));
                        Fluttertoast.showToast(
                            msg: kSdeletedsuuccessfully,
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: kBlackcolor,
                            textColor: kSsprogresscompleted);
                      }catch (e){
                        setState(() {
                          _publishModal = false;
                        });
                       print(e) ;
                      }
                    }
                  }

              )
            ]));
  }


}



class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}






*/

/* Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              kAddfriendstext,
                              style: TextStyle(
                                fontSize: kFontsize.sp,
                                color: KLightermaincolor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rajdhani',
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 0.0,
                            ),
                            child: Center(
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                            value: monVal,
                                            onChanged: (bool value) {
                                              setState(() {
                                                monVal = value;
                                              });
                                            }),

                                        Text(
                                          kListviewContact,
                                          style: new TextStyle(
                                            fontSize: kFontsize.sp,
                                            color: kBlackcolor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Rajdhani',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                    visible: monVal==true? false:true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: FlatButton(
                                        onPressed: _classroomValidation,
                                        color: kSelectbtncolor,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(
                                              4.0),
                                        ),
                                        child: Wrap( // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 20.0,
                                            ),

                                            Text(kAddselectstext,
                                                style: TextStyle(
                                                    fontSize: kFontsize.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Rajdhani')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (ufriends.litems.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(context, PageTransition
                                            (type: PageTransitionType.rightToLeft,
                                              child: UserSelections()));
                                        },
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(
                                              4.0),
                                        ),
                                        color: kSelectbtncolor,
                                        child: Row( // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              Icons.view_list,
                                              color: Colors.white,
                                              size: 20.0,
                                            ),

                                            Text(kviewSelectedText,
                                                style: TextStyle(
                                                    fontSize: kFontsize.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Rajdhani')),
                                          ],
                                        ),
                                      ),
                                    ) else
                                    Container(child: Text('')),


                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0.0,
                          ),
                          height: 1.5,
                          color: KTextfieldunderlinedarkcolor.withOpacity(0.5),
                        ),






                        import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/classroom/contents/appbar3.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/contents/live/icons.dart';
import 'package:sparks/classroom/contents/live/text.dart';
import 'package:sparks/classroom/contents/live/text2.dart';
import 'package:sparks/classroom/contents/live_posts/download.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:video_player/video_player.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/appbar.dart';
import 'package:sparks/classroom/contents/appbar2.dart';
import 'package:sparks/classroom/contents/drawer.dart';
import 'package:sparks/classroom/contents/top_app.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  var items = [];
  bool _publishModal = false;

  //await new Future.delayed(const Duration(seconds : 15));
  int viDi;
  bool longPressFlag = false;
  List<String> indexList = new [];
  var cardColor = Colors.white;
  List<String> selectedDocument = <String>[];
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
          appBar: TopAppBar(),
          drawer: DrawerBar(),
          body: ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: CustomScrollView(slivers: <Widget>[
              SilverAppBar(
                matches: kSappbarcolor,
                friends: kSappbarcolor,
                classroom: kSappbarcolor,
                content: kStabcolor1,
              ),
              GetSelectedCard.selectedCard.isEmpty?SilverAppBarSecond(
                tutorialColor: kStabcolor,
                coursesColor: kBlackcolor,
                expertColor: kBlackcolor,
                eventsColor: kBlackcolor,
              ):SilverAppBarThird(),
              //SilverAppBarThird(),
              SliverList(
                  delegate: SliverChildListDelegate([
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('sessioncontent')
                            .doc(UploadVariables.currentUser)
                            .collection('usersessionuploads').where('vido',isGreaterThan: '')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData) {
                            return Text('Sorry you have not created any session');
                          } else {
                            final List<DocumentSnapshot> documents = snapshot.data.docs;

                            //ToDo:getting the video url
                            return Container(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10.0),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:  BouncingScrollPhysics(),
                                        itemCount: documents.length,
                                        itemBuilder: (context, int index) {

                                          return GestureDetector(
                                            onLongPress:(){
                                              _selectDoc(context, documents[index], index);
                                            },
                                            onTap: (){
                                              _tapDoc(context, documents[index], index);
                                            },
                                            child:  Card(
                                              color: GetSelectedCard.selectedCard.contains(index)?Colors.yellow:kWhitecolor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0),
                                              ),
                                              elevation: 20.0,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 18.0,
                                                    top: 10.0,
                                                    left: 8.0,
                                                    right: 8.0),
                                                //ToDo:displaying the icons
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                      children: <Widget>[
                                                        ShowIcons(

                                                          playlist: () {
                                                            UploadVideo.selectedVideo.clear();
                                                            UploadVideo.selectedVideo.add(snapshot.data.docs[index]['vido']);
                                                            Navigator.of(context)
                                                                .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        PlaylistScreen()));
                                                          },

                                                          //ToDo:deleting of document
                                                          delete: () {
                                                            Navigator.pop(context);
                                                            _onTapItem(context, documents[index]);

                                                          },
                                                          //ToDo:Downloading a video
                                                          download: () async {
                                                            Navigator.pop(context);
                                                            UploadVariables.downloadVideoUrl = snapshot.data.docs[index]['vido'];
                                                            _onSelected(index);

                                                          },
                                                          //ToDo:Copying link

                                                          copyLink: () {
                                                            Clipboard.setData( ClipboardData(
                                                                text: 'https://sparksuniverse.com/'+snapshot.data.docs[index]['vi_id']));
                                                            Fluttertoast.showToast(
                                                                msg: 'Copied',
                                                                gravity: ToastGravity.CENTER,
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                backgroundColor: klistnmber,
                                                                textColor: kWhitecolor);
                                                            Navigator.pop(context);

                                                          },


                                                        ),

                                                        SizedBox(width: 5.0),
                                                        //ToDo:Display the live videos
                                                        if (snapshot.data.docs[index]['vido'] == '')
                                                          FadeInImage.assetNetwork(
                                                            width: ScreenUtil()
                                                                .setWidth(100),
                                                            height: ScreenUtil()
                                                                .setHeight(100),
                                                            fit: BoxFit.cover,
                                                            image: (snapshot.data.docs[index]['tmb']
                                                                .toString()),
                                                            placeholder:
                                                            'images/classroom/placeholder.jpg',
                                                          )
                                                        else
                                                          Container(
                                                            width:
                                                            ScreenUtil().setWidth(100),
                                                            child: Stack(
                                                                children: <Widget>[
                                                                  Center(
                                                                    child: ShowUploadedVideo(
                                                                      videoPlayerController:
                                                                      VideoPlayerController.network(snapshot.data.docs[index]['vido']),
                                                                      looping: false,
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                      child: ButtonTheme(
                                                                          height: ScreenUtil()
                                                                              .setHeight(
                                                                              100),
                                                                          minWidth: ScreenUtil()
                                                                              .setWidth(
                                                                              100),
                                                                          child: RaisedButton(
                                                                              color: Colors
                                                                                  .transparent,
                                                                              textColor: Colors
                                                                                  .white,
                                                                              onPressed: () {},
                                                                              child: GestureDetector(
                                                                                  onTap: () {
                                                                                    UploadVariables.videoUrlSelected = snapshot.data.docs[index]['vido'];
                                                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                                  },
                                                                                  child: Icon(
                                                                                      Icons.play_arrow,
                                                                                      size: 40)))))
                                                                ]),
                                                          ),

                                                        SizedBox(
                                                          height: 10.0,
                                                        ),

                                                        //ToDo:live text display
                                                        LiveText(
                                                          title: snapshot.data.docs[index]['title'],
                                                          desc: snapshot.data.docs[index]['desc'],
                                                          rate: snapshot.data.docs[index]['rate'].toString(),
                                                          date: snapshot.data.docs[index]['date'],
                                                          views: snapshot.data.docs[index]['views'].toString(),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),

                                                    //ToDo:displaying the linear progress bar

                                                    items.contains(index) ? DownloadVideo(): Divider(
                                                      color: kAshthumbnailcolor,
                                                      thickness: kThickness,
                                                    ),

                                                    //ToDo:Displaying the live text second
                                                    LiveTextSecond(
                                                      visibility: snapshot.data.docs[index]['visi'],
                                                      aLimit: snapshot.data.docs[index]['alimit'],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),

                                          );

                                        }
                                    ),

                                  ],
                                ));

                          }
                        }),
                  ]))
            ]),
          )),
    );
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            children: <Widget>[
              DeleteDialog(
                  oneDelete: () async {
                    if (UploadVariables.monVal == true) {
                      Navigator.pop(context);
                      _publishModal = true;
                      User currentUser = await FirebaseAuth.instance.currentUser();
                      await FirebaseFirestore.instance
                          .collection('sessioncontent')
                          .doc(currentUser.uid)
                          .collection('usersessionuploads')
                          .doc(document.documentID)
                          .delete();
                      _publishModal = false;
                      Fluttertoast.showToast(
                          msg: kSdeletedsuuccessfully,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kSsprogresscompleted);
                    }else{
                      Fluttertoast.showToast(
                          msg: kuncheckwarning,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kFbColor);
                    }

                  }
              )
            ]));
  }

  void _onSelected(int index){
    UploadVariables.downloadIndex = index;

    setState(() {
      if (items.contains(index)) {

      } else {
        items.add(index);
      }
    });
  }

  void _selectDoc(BuildContext context, DocumentSnapshot document, int index) {

    SelectedDocuments.items .add(document.documentID);

    setState(() {
      if(GetSelectedCard.selectedCard .contains(index)){
        GetSelectedCard.selectedCard .remove(index);
        selectedDocument.remove(document.documentID);
      }else{
        HapticFeedback.vibrate();
        UploadVariables.showSilverAppbar = false;
        GetSelectedCard.selectedCard .add(index);
        selectedDocument.add(document.documentID);

      }

    });
  }

  void _tapDoc(BuildContext context, DocumentSnapshot document, int index) {
    setState(() {
      if( GetSelectedCard.selectedCard.isEmpty){
        UploadVariables.showSilverAppbar = true;
      }else if(GetSelectedCard.selectedCard .contains(index)){
        GetSelectedCard.selectedCard .remove(index);
        selectedDocument.remove(document.documentID);
      }else{
        GetSelectedCard.selectedCard .add(index);
        selectedDocument.add(document.documentID);
      }
    });
  }


}




import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:path_provider/path_provider.dart';

import 'package:sparks/classroom/contents/appbar3.dart';
import 'package:sparks/classroom/contents/edit_content.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/contents/live/icons.dart';
import 'package:sparks/classroom/contents/live/text.dart';
import 'package:sparks/classroom/contents/live/text2.dart';

import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:video_player/video_player.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/appbar.dart';
import 'package:sparks/classroom/contents/appbar2.dart';
import 'package:sparks/classroom/contents/drawer.dart';
import 'package:sparks/classroom/contents/top_app.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LiveContent extends StatefulWidget {

  final TargetPlatform platform;

  LiveContent({Key key, this.platform}) : super(key: key);


  @override
  _LiveContentState createState() => _LiveContentState();
}

class _LiveContentState extends State<LiveContent> {


  var items = [];
  bool _publishModal = false;
  String? filter;
  var searchItems = [];

  List<String> selectedDocument = <String>[];
  ReceivePort _port = ReceivePort();

  getLocalPath() async {

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

  }

  @override
  void initState() {
    super.initState();

    getLocalPath();
    //ToDo:search filtering
    searchItems.addAll( ContentTitle.title);
    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');

    //UploadVariables.searchController.dispose();

    GetSelectedCard.selectedCard.clear();
    ContentDocuments.documents.clear();
    ContentTitle.title.clear();
    ContentDescription.description.clear();
    ContentViews.views.clear();
    ContentRating.rating.clear();
    ContentThumbnail.thumbnails.clear();
    ContentDate.date.clear();
    ContentVisibility.visibility.clear();
    ContentLimit.ageLimit.clear();
    ContentVideos.videos.clear();
    ContentVideoId.videosId.clear();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      /*if (debug) {
        print('UI Isolate Callback: $data');
      }*/
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = downloadTasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
    print(progress);
  }


  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

 /* Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    //await _prepare();
    setState(() {});
  }
*/
  Widget _buildActionForTask(_TaskInfo task) {

    if (task.status == DownloadTaskStatus.undefined) {

      return Container();
      /*return new RawMaterialButton(
        onPressed: () {
          //_requestDownload(task);
        },
        child: new Icon(Icons.file_download),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );*/
    }

    if (task.status == DownloadTaskStatus.running) {

      return Row(

        mainAxisAlignment: MainAxisAlignment.end,

        children: <Widget>[

          GestureDetector(
            onTap: () {
              _pauseDownload(task);
            },
            child: new Icon(
              Icons.pause,
              color: kFbColor,
            ),

          ),

          SizedBox(width: 10.0),

          GestureDetector(
            onTap: () {
              _cancelDownload(task);
            },
            child: Icon(
              Icons.cancel,
              color: kFbColor,
            ),

          ),

        ],
      );
    } else if (task.status == DownloadTaskStatus.paused) {

      return Row(

        mainAxisAlignment: MainAxisAlignment.end,

        children: <Widget>[

          GestureDetector(
            onTap: () {
              _resumeDownload(task);
            },
            child: new Icon(
              Icons.play_arrow,
              color: kSsprogresscompleted,
            ),

          ),

          SizedBox(width: 10.0),

          GestureDetector(
            onTap: () {
              _cancelDownload(task);
            },
            child: Icon(
              Icons.cancel,
              color: kFbColor,
            ),

          ),


        ],
      );
    }
    else if (task.status == DownloadTaskStatus.complete) {

      downloadTasks.removeWhere( (checkTask) => checkTask.link == task.link);

      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: Icon(
            Icons.check_circle,
            color: kSsprogresscompleted,
          ),

        ),
      );
    }
    else if (task.status == DownloadTaskStatus.canceled) {

      return Align(
        alignment: Alignment.centerRight,

        child: GestureDetector(
          onTap: () {
            _cancelDownload(task);
          },
          child: Icon(
            Icons.cancel,
            color: kFbColor,
          ),

        ),

      );

    }
    else if (task.status == DownloadTaskStatus.failed) {

      return Row(

        mainAxisAlignment: MainAxisAlignment.end,

        children: <Widget>[

          GestureDetector(
            onTap: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.orangeAccent,
            ),

          ),

          SizedBox(width: 10.0),

          GestureDetector(
            onTap: () {
              _cancelDownload(task);
            },
            child: Icon(
              Icons.cancel,
              color: kFbColor,
            ),

          ),

        ],
      );

    }
    else {

      return null;

    }
  }

  void _requestDownloadMultiple(List<_TaskInfo> tasks) async {

    tasks.forEach((task) async {

      print('task.link: ${task.link}');
      task.taskId = await FlutterDownloader.enqueue(
          url: task.link,
          headers: {"auth": "test_for_sql_encoding"},
          fileName: task.name.trim() + '.mp4',
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: true);

      //downloadTasks.removeWhere( (checkTask) => checkTask.link == task.link);

    });

  }

  List<_TaskInfo>   myTasks = [];
  List<_ItemHolder> myItems = [];

  List<_TaskInfo>   downloadTasks = [];

  String _localPath;

  bool longPressTapped = false;

  @override
  Widget build(BuildContext context) {

    for (int i = 0; i < ContentDocuments.documents.length; i++) {

      myTasks.add(_TaskInfo(
          name: ContentDocuments.documents[i]['title'],
          link: ContentDocuments.documents[i]['vido'])
      );

      myItems.add(_ItemHolder(
          name: ContentDocuments.documents[i]['title'],
          task: myTasks[i])
      );

    }




    return SafeArea(
      child: Scaffold(
          appBar: TopAppBar(),
          drawer: DrawerBar(),
          body:  ModalProgressHUD(
                inAsyncCall: _publishModal,
                child: CustomScrollView(slivers: <Widget>[
                  SilverAppBar(
                    matches: kSappbarcolor,
                    friends: kSappbarcolor,
                    classroom: kSappbarcolor,
                    content: kStabcolor1,
                  ),
                  GetSelectedCard.selectedCard.isEmpty?SilverAppBarSecond(
                    tutorialColor: kStabcolor,
                    coursesColor: kBlackcolor,
                    expertColor: kBlackcolor,
                    eventsColor: kBlackcolor,
                    publishColor: kBlackcolor,
                  ):SilverAppBarThird(listPlaylist: (){_addListPlaylist();},
                    listDownload: (){_addListDownload();},
                    listDelete: (){_addListDelete();},),
                  //SilverAppBarThird(),
                  SliverList(
                      delegate: SliverChildListDelegate([
                        UploadVariables.checkUserContent==false?  Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:  BouncingScrollPhysics(),
                                    itemCount: ContentDocuments.documents.length,
                                    itemBuilder: (context, int index) {

                                      return filter == null || filter == "" ?

                                      GestureDetector(

                                        onLongPress:(){

                                          _selectDoc(context, ContentDocuments.documents[index], index);

                                          longPressTapped = true;

                                        },

                                        onTap: (){

                                          _tapDoc(context, ContentDocuments.documents[index], index);

                                        },

                                        child:  Card(
                                          color: GetSelectedCard.selectedCard.contains(index)?Colors.yellow:kWhitecolor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0),
                                          ),
                                          elevation: 20.0,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: kScontentPadding1,
                                                top: kScontentPadding2,
                                                left: kScontentPadding3,
                                                right: kScontentPadding4),
                                            //ToDo:displaying the icons
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    ShowIcons(

                                                      //ToDo:Edit content
                                                      edit:(){
                                                        editContentPost(context, ContentDocuments.documents[index], index);},

                                                      playlist: () {

                                                        UploadVariables.selectedVideo =  ContentVideos.videos[index];
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(builder: (context) => PlaylistScreen()));
                                                      },

                                                      //ToDo:deleting of document
                                                      delete: () {
                                                        Navigator.pop(context);
                                                        _onTapItem(context, ContentDocuments.documents[index]);

                                                      },
                                                      //ToDo:Downloading a video
                                                      download: () async {
                                                        Navigator.pop(context);
                                                        UploadVariables.downloadVideoUrl = ContentVideos.videos[index];
                                                         _onSelected(index);

                                                         downloadTasks.add(myTasks[index]);
                                                        _addListDownload();

                                                        //_singleDownload(myTasks[index], index);
                                                        },
                                                      //ToDo:Copying link

                                                      copyLink: () {
                                                        Clipboard.setData( ClipboardData(
                                                            text: 'https://sparksuniverse.com/'+ContentVideoId.videosId[index]));
                                                        Fluttertoast.showToast(
                                                            msg: 'Copied',
                                                            gravity: ToastGravity.CENTER,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            backgroundColor: klistnmber,
                                                            textColor: kWhitecolor);
                                                        Navigator.pop(context);

                                                      },


                                                    ),

                                                    SizedBox(width: 5.0),
                                                    //ToDo:Display the live videos

                                                    Container(
                                                        width:ScreenUtil().setWidth(100),
                                                        child: Stack(
                                                            children: <Widget>[
                                                              ContentThumbnail.thumbnails[index].isEmpty? Center(
                                                                child: ShowUploadedVideo(
                                                                  videoPlayerController:
                                                                  VideoPlayerController.network(ContentVideos.videos[index]),
                                                                  looping: false,
                                                                ),
                                                              ):Image.network(ContentThumbnail.thumbnails[index],
                                                                fit: BoxFit.cover,
                                                                width: ScreenUtil().setWidth(120),
                                                                height: ScreenUtil().setHeight(100),
                                                              ),
                                                              Center(
                                                                  child: ButtonTheme(

                                                                      shape: CircleBorder(),
                                                                      height: ScreenUtil().setHeight(100),

                                                                      child: RaisedButton(
                                                                          color: Colors
                                                                              .transparent,
                                                                          textColor: Colors
                                                                              .white,
                                                                          onPressed: () {},
                                                                          child: GestureDetector(
                                                                              onTap: () {
                                                                                UploadVariables.videoUrlSelected = ContentVideos.videos[index];
                                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                              },
                                                                              child: Icon(
                                                                                  Icons.play_arrow,
                                                                                  size: 40)))))
                                                            ])
                                                    ),

                                                    SizedBox(
                                                      height: 10.0,
                                                    ),

                                                    //ToDo:live text display
                                                    LiveText(
                                                        title:  ContentTitle.title[index],
                                                        desc:  ContentDescription.description[index],
                                                        rate:  ContentRating.rating[index],
                                                        date:  ContentDate.date[index],
                                                        views:  ContentViews.views[index]
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),

                                                //ToDo:displaying the linear progress bar

                                                _buildActionForTask(myTasks[index]),

                                                myTasks[index].status == DownloadTaskStatus.running ||
                                                    myTasks[index].status == DownloadTaskStatus.paused

                                                    ?

                                                Container(
                                                  height: kThickness,
                                                  child: LinearProgressIndicator(
                                                    valueColor:AlwaysStoppedAnimation<Color>(kSsprogresscompleted),
                                                    backgroundColor: kSsprogressbar,
                                                    value: myTasks[index].progress / 100,
                                                  ),
                                                )
                                                    : Divider(
                                                  color: kAshthumbnailcolor,
                                                  thickness: kThickness,
                                                ),


                                                //ToDo:Displaying the live text second
                                                LiveTextSecond(
                                                  visibility: ContentVisibility.visibility[index],
                                                  aLimit: ContentLimit.ageLimit[index],
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),


                                        //ToDo: This displays the items user has filtered




                                      ):'${searchItems[index]}'.toLowerCase()
                                          .contains(filter.toLowerCase())
                                          ? Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0),
                                          ),
                                          elevation: 20.0,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: kScontentPadding1,
                                                top: kScontentPadding2,
                                                left: kScontentPadding3,
                                                right: kScontentPadding4),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    ShowIcons(
                                                      //ToDo:Edit content
                                                      edit:(){
                                                        editContentPost(context, ContentDocuments.documents[index], index);
                                                        Navigator.of(context).push
                                                          (MaterialPageRoute(builder: (context) => EditContentPost()));

                                                      },
                                                      playlist: () {
                                                        UploadVariables.selectedVideo =  ContentVideos.videos[index];
                                                        UploadVariables.title = ContentTitle.title[index];
                                                        UploadVariables.playlistUrl1 = ContentThumbnail.thumbnails[index];
                                                        UploadVariables.playlistUrl2 = ContentEndScreen.endScreen[index];
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(builder: (context) => PlaylistScreen()));
                                                      },

                                                      //ToDo:deleting of document
                                                      delete: () {
                                                        Navigator.pop(context);
                                                        _onTapItem(context, ContentDocuments.documents[index]);

                                                      },
                                                      //ToDo:Downloading a video
                                                      download: () async {
                                                        Navigator.pop(context);
                                                        UploadVariables.downloadVideoUrl = ContentVideos.videos[index];
                                                        _onSelected(index);

                                                        downloadTasks.add(myTasks[index]);
                                                        _addListDownload();

                                                        //_singleDownload(myTasks[index], index);

                                                      },
                                                      //ToDo:Copying link

                                                      copyLink: () {
                                                        Clipboard.setData( ClipboardData(
                                                            text: 'https://sparksuniverse.com/'+ContentVideoId.videosId[index]));
                                                        Fluttertoast.showToast(
                                                            msg: 'Copied',
                                                            gravity: ToastGravity.CENTER,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            backgroundColor: klistnmber,
                                                            textColor: kWhitecolor);
                                                        Navigator.pop(context);

                                                      },


                                                    ),

                                                    SizedBox(width: 5.0),
                                                    //ToDo:Display the live videos

                                                    Container(
                                                        width: ScreenUtil().setWidth(100),

                                                        child: Stack(
                                                            fit: StackFit.loose,
                                                            children: <Widget>[
                                                              ContentThumbnail.thumbnails[index].isEmpty? Center(
                                                                child: ShowUploadedVideo(
                                                                  videoPlayerController:
                                                                  VideoPlayerController.network(ContentVideos.videos[index]),
                                                                  looping: false,
                                                                ),
                                                              ):Image.network(ContentThumbnail.thumbnails[index],
                                                              fit: BoxFit.cover,
                                                                width: ScreenUtil().setWidth(100),
                                                                height: ScreenUtil().setHeight(80),
                                                              ),
                                                              Center(
                                                                  child: ButtonTheme(
                                                                      height: ScreenUtil().setHeight(100),
                                                                      child: RaisedButton(
                                                                          color: Colors.transparent,
                                                                          textColor: Colors.white,
                                                                          onPressed: () {},
                                                                          child: GestureDetector(
                                                                              onTap: () {
                                                                                UploadVariables.videoUrlSelected = ContentVideos.videos[index];
                                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));

                                                                                },
                                                                              child: Icon(
                                                                                  Icons.play_arrow,
                                                                                  size: 40)))))
                                                            ])
                                                    ),

                                                    SizedBox(
                                                      height: 10.0,
                                                    ),

                                                    //ToDo:live text display
                                                    LiveText(
                                                        title:  searchItems[index],
                                                        desc:  ContentDescription.description[index],
                                                        rate:  ContentRating.rating[index],
                                                        date:  ContentDate.date[index],
                                                        views:  ContentViews.views[index]
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),

                                                _buildActionForTask(myTasks[index]),

                                                myTasks[index].status == DownloadTaskStatus.running ||
                                                    myTasks[index].status == DownloadTaskStatus.paused ||
                                                    myTasks[index].status == DownloadTaskStatus.canceled

                                                    ?


                                                //ToDo:displaying the linear progress bar

                                                Container(
                                                  height: kThickness,
                                                  child: LinearProgressIndicator(
                                                    valueColor:AlwaysStoppedAnimation<Color>(kSsprogresscompleted),
                                                    backgroundColor: kSsprogressbar,
                                                    value: myTasks[index].progress /
                                                        100,
                                                  ),
                                                )
                                                    : Divider(
                                                  color: kAshthumbnailcolor,
                                                  thickness: kThickness,
                                                ),

                                                //ToDo:Displaying the live text second
                                                LiveTextSecond(
                                                  visibility: ContentVisibility.visibility[index],
                                                  aLimit: ContentLimit.ageLimit[index],
                                                )
                                              ],
                                            ),
                                          )
                                      )
                                          :Container();

                                    }
                                ),

                              ],
                            )
                        ):NoContentCreated(title: kNocontentcreated,)
                      ]))
                ]),
              )

          ),
    );
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            children: <Widget>[
              DeleteDialog(
                  oneDelete: () async {
                    if (UploadVariables.monVal == true) {
                      Navigator.pop(context);
                      _publishModal = true;
                      User currentUser = await FirebaseAuth.instance.currentUser();

                      ContentDocuments
                          .documents
                          .removeWhere( (toRemoveDocument) => toRemoveDocument
                          .documentID == document
                          .documentID);

                      await FirebaseFirestore.instance
                          .collection('sessioncontent')
                          .doc(currentUser.uid)
                          .collection('usersessionuploads')
                          .doc(document.documentID)
                          .delete();

                      _publishModal = false;

                      Timer.periodic(Duration(milliseconds: 400), (Timer t) => setState((){}));
                      Fluttertoast.showToast(
                          msg: kSdeletedsuuccessfully,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kSsprogresscompleted);
                    }else{
                      Fluttertoast.showToast(
                          msg: kuncheckwarning,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kFbColor);
                    }

                  }
              )
            ]));
  }

  void _onSelected(int index){
    UploadVariables.downloadIndex = index;

    setState(() {
      if (items.contains(index)) {

      } else {
        items.add(index);
      }
    });
  }

  void _selectDoc(BuildContext context, DocumentSnapshot document, int index) {

    SelectedDocuments.items .add(document.documentID);

    setState(() {
      if(GetSelectedCard.selectedCard .contains(index)){
        GetSelectedCard.selectedCard .remove(index);
        selectedDocument.remove(document.documentID);
      }else{
        HapticFeedback.vibrate();
        UploadVariables.showSilverAppbar = false;
        GetSelectedCard.selectedCard .add(index);
        /*Add documents id*/
        selectedDocument.add(document.documentID);
        /*Add the videos selected*/
        UploadVideo.selectedVideo.add(ContentVideos.videos[index]);
        /*add task for downloading*/
        downloadTasks.add(myTasks[index]);

      }

    });
  }

  void _tapDoc(BuildContext context, DocumentSnapshot document, int index) {
    setState(() {
      if( GetSelectedCard.selectedCard.isEmpty){
        longPressTapped = false;
        UploadVariables.showSilverAppbar = true;
        /*clear the video list selected*/
        UploadVideo.selectedVideo.clear();
      }
      else if(GetSelectedCard.selectedCard .contains(index)){
        GetSelectedCard.selectedCard.remove(index);
        selectedDocument.remove(document.documentID);
        /*remove the video selected*/
        UploadVideo.selectedVideo.remove(ContentVideos.videos[index]);
        /*Remove task*/
        downloadTasks.remove(myTasks[index]);
      }
      else{
        GetSelectedCard.selectedCard .add(index);
        /*Add documents id*/
        selectedDocument.add(document.documentID);
        /*Add the videos selected*/
        UploadVideo.selectedVideo.add(ContentVideos.videos[index]);
        /*add task for downloading*/
        downloadTasks.add(myTasks[index]);

      }
    });
  }
//Adding to playlist
  void _addListPlaylist() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistScreen()));

  }
//ToDo:Downloading videos in a list
  Future<void> _addListDownload() async {
    _requestDownloadMultiple(downloadTasks);

  }

  Future<String> _findLocalPath() async {
    final directory = TargetPlatform.android == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _addListDelete() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            children: <Widget>[
              DeleteDialog(
                  oneDelete: () async {
                    if (UploadVariables.monVal == true) {
                      Navigator.pop(context);
                      setState(() {
                        _publishModal = true;
                      });


                      try {

                        User currentUser = await FirebaseAuth.instance.currentUser();

                        for(int i = 0; i < selectedDocument.length; i++) {
                          ContentDocuments
                              .documents
                              .removeWhere( (toRemoveDocument) => toRemoveDocument
                              .documentID == selectedDocument[i]);
                          FirebaseFirestore.instance
                              .collection('sessioncontent')
                              .doc(currentUser.uid)
                              .collection('usersessionuploads')
                              .doc(selectedDocument[i])
                              .delete().then( (onValue) {

                          });
                        }

                        setState(() {
                          _publishModal = false;
                        });
                        Timer.periodic(Duration(milliseconds: 400), (Timer t) => setState((){}));
                        Fluttertoast.showToast(
                            msg: kSdeletedsuuccessfully,
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: kBlackcolor,
                            textColor: kSsprogresscompleted);
                      }catch (e){
                        setState(() {
                          _publishModal = false;
                        });
                        print(e) ;
                      }
                    }
                  }

              )
            ]));
  }
//ToDo: This is getting the document items of the particular document that needs to be edited

  void editContentPost(BuildContext context, DocumentSnapshot document, int index) {
    UploadVariables.cThumbnail = ContentThumbnail.thumbnails[index];
    UploadVariables.cEndScreen = ContentEndScreen.endScreen[index];
    UploadVariables. cTitle = ContentTitle.title[index];
    UploadVariables.cDesc = ContentDescription.description[index];
    UploadVariables.cVideo = ContentVideos.videos[index];
    UploadVariables.cDocumentId = document.documentID;
    UploadVariables.cVisibility = ContentVisibility.visibility[index];

    Navigator.of(context).push
      (MaterialPageRoute(builder: (context) => EditContentPost()));
  }


}



class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}



 /*StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sessioncontent')
                  .doc(UploadVariables.currentUser)
                  .collection('usersessionuploads').where('vido', isGreaterThan: '')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text(''),
                  );
                } else if (!snapshot.hasData) {
                  UploadVariables.checkUserContent = true;
                  return LiveContent();
                } else {
                  //final List<DocumentSnapshot> documents = snapshot.data.documents;
                  ContentDocuments.documents = snapshot.data.documents;

                  final userUploads = snapshot.data.documents;
                  for (var message in userUploads) {

                    *//*content title*//*
                    final title = message.data['title'];
                    if(ContentTitle.title.contains(title)){

                    }else{
                      ContentTitle.title.add(title);

                    }

                    *//*content Description*//*
                    final description = message.data['desc'];
                    ContentDescription.description.add(description);


                    *//*Views content*//*
                    final views = message.data['views'];
                    ContentViews.views.add(views);


                    *//*Rating content*//*

                    final rating = message.data['rate'];
                    ContentRating.rating.add(rating);

                       *//*Thumbnail content*//*

                    final thumbnail = message.data['tmb'];
                    ContentThumbnail.thumbnails.add(thumbnail);

                    *//*EndScreen content*//*

                    final endScreen = message.data['end'];
                    ContentEndScreen.endScreen.add(endScreen);

                    *//*Date content*//*

                    final date = message.data['date'];
                    ContentDate.date.add(date);


                    *//*Visibility content*//*

                    final visibility = message.data['visi'];
                    ContentVisibility.visibility.add(visibility);

                    *//*Age Limit content*//*

                    final ageLimit = message.data['alimit'];
                    ContentLimit.ageLimit.add(ageLimit);

                    *//*video content*//*

                    final video = message.data['vido'];
                    ContentVideos.videos.add(video);


                    *//*Video id content*//*

                    final videoId = message.data['vi_id'];
                    if (ContentVideoId.videosId.contains(videoId)) {} else {
                      ContentVideoId.videosId.add(videoId);
                    }

                  }

                  return Text('');
                }
              }
          ),*/




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/langList.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
class CourseDescriptionSecond extends StatefulWidget {
  @override
  _CourseDescriptionSecondState createState() => _CourseDescriptionSecondState();
}

class _CourseDescriptionSecondState extends State<CourseDescriptionSecond> {
  String? filter;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constants.searchController.addListener(() {
      setState(() {
        filter = Constants.searchController.text;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar: CourseAppBar(),
          body: Column(
children: <Widget>[
  //ToDo:Language used in this course
  FadeHeading(title: kSCourseLang,),
  Container(
    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
    child: Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(80),
      child: OutlineButton(
        shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(6.0),
        ),
        onPressed: () {_showLang();},
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(kSCourseLang2,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kTextcolorhintcolor,
                        fontSize: kFontsize.sp,
                      ),
                    )
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                SvgPicture.asset('images/classroom/edit_add.svg',
                color: kMaincolor,),
              ],
            ),

            SelectedLanguage.data.isNotEmpty ?Container(
              height:40.0,
              child: ListView.builder(

    physics: BouncingScrollPhysics(),
    itemCount:SelectedLanguage.data.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index){
      return Container(

        child: Column(
          children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      SelectedLanguage.data.removeAt(index);

                    });
                  },
                  child: Icon(
                    Icons.cancel,
                    size: 15,
                    color: kBlackcolor,
                  ),
                ),
              ),
              Text(SelectedLanguage.data[index],
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Rajdhani',
                  color: kBlackcolor,
                ),),
          ],
        ),


        width: 150.0,
        decoration: new BoxDecoration(
              color: khorizontallistviewcolor,
              borderRadius: BorderRadius.circular(50.0)
        ),);

    }),
            ):Text(''),
          ],


        ),
      ),
    ),
  ),



],
          )
      )
    );


  }

  void _showLang() {
    showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,

            content: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: kPreviewcolor,
                  child: Text(kDone,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kWhitecolor,
                          fontSize: kFontsize.sp,
                        ),
                      )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                  child: TextFormField(
                    onChanged: (String value){
                      Constants.searchText = value;
                    },
                    cursorColor: kMaincolor,
                    controller: Constants.searchController,
                    decoration: InputDecoration(
                      fillColor: kWhitecolor,
                      filled: true,
                      hintStyle: TextStyle(fontSize: kFontsize.sp,
                        color: kTextcolorhintcolor,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search,color: kMaincolor,),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: kMaincolor)),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0)),),
                  ),
                ),

                Expanded(child: LanguageList()),
              ],
            ),
        ));
  }

  void _addLanguage() {

  }
}

 */
