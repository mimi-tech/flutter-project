import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialContent/user_gridView.dart';
import 'package:sparks/social/socialCourse/seeAll.dart';
class NewUsersMatch extends StatefulWidget implements PreferredSizeWidget {
  @override
  _NewUsersMatchState createState() => _NewUsersMatchState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);



}

class _NewUsersMatchState extends State<NewUsersMatch> {
  bool progress = false;
  var _documents = <DocumentSnapshot>[];

  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic> uid = <dynamic>[];
String areaOfSpec = '';
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyInterest();
  }
  @override
  Widget build(BuildContext context) {
    return workingDocuments.length == 0 && progress == false ?SliverAppBar(title: Text('')):
    workingDocuments.length == 0 && progress == true ? SliverAppBar(title: Text(''),):SliverAppBar(
        shape:  RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
            )
        ),
        automaticallyImplyLeading: false,
        expandedHeight: 230,
        backgroundColor: kBlackcolor,
        floating: true,
        pinned: false,
        flexibleSpace: ListView(
        children: [
          space(),

          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialSeeAll()));

            },
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('see all',
                  style: GoogleFonts.rajdhani(
                       fontSize:kFontsize.sp,
                    color: kLightGreen,
                    fontWeight: FontWeight.bold,

                  ),),
              ),
            ),
          ),
    Container(
      height: 180.0,

      child: ListView.builder(
      itemCount: workingDocuments.length,
      //shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
      itemBuilder: (context, int index) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.6,

        child: GestureDetector(
          onTap: (){
            SocialConstant.usersUid = workingDocuments[index]['id'];
            setState(() {
              SocialConstant.isSeeAll = true;

            });
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialUserGridView(doc:_documents[index],)));

          },
          child: Card(
            color: kWhitecolor,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: ClipOval(
                    child: CachedNetworkImage(

                      imageUrl: '${workingDocuments[index]['pimg']}',
                      placeholder: (context, url) => Container(
                        width: 100.0,
                        height: 150.0,
                        color: kMaincolor,
                      ),
                      errorWidget: (context, url, error) =>Container(
                        width: 100.0,
                        height: 150.0,
                        color: kMaincolor,
                      ),
                      fit: BoxFit.cover,
                      width: 200.0,
                      height: 180.0,

                    ),
                  ),
                ),

                Text('${workingDocuments[index]['nm']['fn']} ${workingDocuments[index]['nm']['ln']}',
                  style: GoogleFonts.rajdhani(
                    fontSize:14.sp,
                    color: kMaincolor,
                    fontWeight: FontWeight.bold,

                  ),),

                Text('${workingDocuments[index]['aoi'][0]}'.toString(),
                  style: GoogleFonts.rajdhani(
                    fontSize:14.sp,
                    color: klistnmber,
                    fontWeight: FontWeight.bold,

                  ),),

                Container(
                  width: MediaQuery.of(context).size.width * 0.5,

                  child: RaisedButton(onPressed: (){},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: kFbColor,
                  child: Text(kFollow,
                    style: GoogleFonts.rajdhani(
                      fontSize:14.sp,
                      color: kWhitecolor,
                      fontWeight: FontWeight.bold,

                    ),),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

      ),
    ),



  ])
    );
  }
  Future<void> getMyInterest() async {
    //this query if for area of interest
    workingDocuments.clear();

    for(int i = 0; i < GlobalVariables.loggedInUserObject.aoi!.length; i++){
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('Personal')
          .where('aoi',arrayContains:  GlobalVariables.loggedInUserObject.aoi![i])
          .orderBy('crAt',descending: true).limit(10)
          .get();
      final List <DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        setState(() {
          progress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          setState(() {
            workingDocuments.add(document.data());
            uid.add(data['id']);
            areaOfSpec = data['aoi'][0];
            _documents.add(document);
          });


        }
      }

    }

    //this query if for area of specialization
    for(int i = 0; i < GlobalVariables.loggedInUserObject.spec!.length; i++){

      final QuerySnapshot resultSpecialization = await FirebaseFirestore.instance.collectionGroup('Personal')
          .where('spec',arrayContains: GlobalVariables.loggedInUserObject.spec![i])
          .orderBy('crAt',descending: true).limit(10)
          .get();
      final List <DocumentSnapshot> specializations = resultSpecialization.docs;
      if (specializations.length != 0) {
        for (DocumentSnapshot specialization in specializations) {
          Map<String, dynamic> data = specialization.data() as Map<String, dynamic>;
         if(uid.contains(data['id'])){
           setState(() {
             data.clear();

           });
         }else{
          setState(() {
            workingDocuments.add(specialization.data());
            uid.add(data['id']);
            _documents.add(specialization);

          });
          print(workingDocuments.length);


        }}
      }
    }

    //this query if for area of hobby
    for(int i = 0; i < GlobalVariables.loggedInUserObject.hobb!.length; i++){

      final QuerySnapshot resultHobby = await FirebaseFirestore.instance.collectionGroup('Personal')
        .where('hobb',arrayContains: GlobalVariables.loggedInUserObject.hobb![i])
        .orderBy('crAt',descending: true).limit(10)
        .get();
    final List <DocumentSnapshot> hobbies = resultHobby.docs;
    if (hobbies.length != 0) {

      for (DocumentSnapshot hobby in hobbies) {
        Map<String, dynamic> data = hobby.data() as Map<String, dynamic>;
        if(uid.contains(data['id'])){
          setState(() {
            data.clear();

          });
        }else{

          setState(() {
          workingDocuments.add(hobby.data());
          uid.add(data['id']);
          _documents.add(hobby);


        });


      }}
    }}


    final QuerySnapshot resultUsers = await FirebaseFirestore.instance.collectionGroup('Personal') .orderBy('crAt',descending: true).limit(10)

        .get();
    final List <DocumentSnapshot> user = resultUsers.docs;
    if (user.length != 0) {

      for (DocumentSnapshot users in user) {
        Map<String, dynamic> data = users.data() as Map<String, dynamic>;
        if(uid.contains(data['id'])){
          setState(() {
            data.clear();

          });
        }else{
        setState(() {
          workingDocuments.add(users.data());
          _documents.add(users);
          uid.add(data['id']);


        });


      }}
    }

    //this query if for area of users



}
}
