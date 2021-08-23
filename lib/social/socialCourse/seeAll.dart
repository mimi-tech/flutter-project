
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/social/socialConstants/searchAppbar.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialContent/textConstants.dart';
import 'package:sparks/social/socialContent/user_gridView.dart';
import 'package:sparks/social/socialContent/videos_appbar.dart';

class SocialSeeAll extends StatefulWidget {
  @override
  _SocialSeeAllState createState() => _SocialSeeAllState();
}

class _SocialSeeAllState extends State<SocialSeeAll> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMentors();

    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });
  }

  String? filter;
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic> uid = <dynamic>[];
  String areaOfSpec = '';
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }


  List<dynamic> itemsData = <dynamic>[];
  var _documents = <DocumentSnapshot>[];
  var _docs = <DocumentSnapshot>[];
  late List <dynamic> aoi;
late List <dynamic> spec;
late List <dynamic> hobby;
late List <dynamic> lang;


  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < aoi.length; i++){
      Widget w =  Text(aoi[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }
  ///specialization

  List<Widget> getSpecialization(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < spec.length; i++){
      Widget w =  Text(spec[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }

  ///hobby

  List<Widget> getHobby(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < hobby.length; i++){
      Widget w =  Text(hobby[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }
  List<Widget> getLanguage(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < lang.length; i++){
      Widget w =  Text(lang[i].toString(),
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontSize14.sp,
          ),
        ),

      );
      list.add(w);
    }
    return list;
  }

  Widget bodyList(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        ListTile(
          onTap: (){
            SocialConstant.usersUid = workingDocuments[index]['id'];
            setState(() {
              SocialConstant.isSeeAll = true;

            });
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialUserGridView(doc:_documents[index],)));

          },
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 30,
            child: ClipOval(
              child: CachedNetworkImage(

                imageUrl: '${workingDocuments[index]['pimg']}',
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>Icon(Icons.error),
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,

              ),
            ),
          ),

          title:Text(workingDocuments[index]['nm']['fn'],
            style: GoogleFonts.rajdhani(
                       fontSize:kFontsize.sp,
              color: kBlackcolor,
              fontWeight: FontWeight.bold,

            ),) ,

          subtitle: Text(workingDocuments[index]['nm']['ln'],
            style: GoogleFonts.rajdhani(
                       fontSize:kFontsize.sp,
              color: kBlackcolor,
              fontWeight: FontWeight.bold,

            ),) ,

          trailing: RaisedButton(onPressed: (){},
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
        ),

        Divider(),

        space(),

        TextConstants(text1:'Area of interest'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: getImages(),
        ),
        space(),

        TextConstants(text1:'Area of specialization'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getSpecialization(),
        ),
        space(),


        TextConstants(text1:'Hobby'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: getHobby(),
        ),
        space(),

        TextConstants(text1:'Language'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: getLanguage(),
        ),
        space(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
          appBar:  SeeAllAppbar(),
        body:  CustomScrollView(
        slivers: <Widget>[

          SeeAllSearchAppBar(),
      SliverList(
          delegate: SliverChildListDelegate([

            workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
            workingDocuments.length == 0 && progress == true ? Text('Loading...'):  Column(
        children: [
          ListView.builder(
          itemCount: workingDocuments.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, int index) {

              aoi = workingDocuments[index]['aoi'];
              spec = workingDocuments[index]['spec'];
              hobby = workingDocuments[index]['hobb'];
              lang = workingDocuments[index]['lang'];


              return filter == null || filter == "" ?bodyList(index):
              '${workingDocuments[index]['nm']['fn']}'.toLowerCase()
                  .contains(filter!.toLowerCase())

                  ?bodyList(index):Container();
          }),



        ],
      ),
    ]))

    ])));
  }

  Future<void> getMentors() async {
    //this query if for area of interest
    workingDocuments.clear();

    for(int i = 0; i < GlobalVariables.loggedInUserObject.aoi!.length; i++){
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('Personal')
          .where('aoi',arrayContains:  GlobalVariables.loggedInUserObject.aoi![i])
          .orderBy('crAt',descending: true).limit(50)
          .get();
      final List <DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {

        for (DocumentSnapshot document in documents) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;


          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
            uid.add(data['id']);

            aoi = data['aoi'];
            spec = data['spec'];
            hobby = data['hobb'];
            lang = data['lang'];
          });


        }
      }

    }

    //this query if for area of specialization
    for(int i = 0; i < GlobalVariables.loggedInUserObject.spec!.length; i++){

      final QuerySnapshot workingDocumentsSpecialization = await FirebaseFirestore.instance.collectionGroup('Personal')
          .where('spec',arrayContains: GlobalVariables.loggedInUserObject.spec![i])
          .orderBy('crAt',descending: true).limit(50)
          .get();
      final List <DocumentSnapshot> specializations = workingDocumentsSpecialization.docs;
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
            _documents.add(specialization);
            uid.add(data['id']);

          });


        }}
      }else{
        print('444444444');
      }
    }

    //this query if for area of hobby
    for(int i = 0; i < GlobalVariables.loggedInUserObject.hobb!.length; i++){

      final QuerySnapshot workingDocumentsHobby = await FirebaseFirestore.instance.collectionGroup('Personal')
          .where('hobb',arrayContains: GlobalVariables.loggedInUserObject.hobb![i])
          .orderBy('crAt',descending: true).limit(50)
          .get();
      final List <DocumentSnapshot> hobbies = workingDocumentsHobby.docs;
      if (hobbies.length != 0) {

        for (DocumentSnapshot hobbys in hobbies) {
          Map<String, dynamic> data = hobbys.data() as Map<String, dynamic>;

          if(uid.contains(data['id'])){
            setState(() {
              data.clear();

            });
          }else{
          setState(() {
            workingDocuments.add(hobbys.data());
            _documents.add(hobbys);
            uid.add(data['id']);

          });


        }
      }}}

    //this query if for area of language
    for(int i = 0; i < GlobalVariables.loggedInUserObject.lang!.length; i++){

      final QuerySnapshot workingDocumentsLang = await FirebaseFirestore.instance.collectionGroup('Personal')
          .where('lang',arrayContains: GlobalVariables.loggedInUserObject.lang![i])
          .orderBy('crAt',descending: true).limit(50)
          .get();
      final List <DocumentSnapshot> languages = workingDocumentsLang.docs;
      if (languages.length != 0) {
        for (DocumentSnapshot language in languages) {
          Map<String, dynamic> data = language.data() as Map<String, dynamic>;
          if(uid.contains(data['id'])){
            setState(() {
              data.clear();

            });
          }else {
            setState(() {
              workingDocuments.add(language.data());
              _documents.add(language);
              uid.add(data['id']);

            });
          }
        }
      }
    }

    final QuerySnapshot workingDocumentsUsers = await FirebaseFirestore.instance.collectionGroup('Personal')

        .orderBy('crAt',descending: true).limit(50)

        .get();
    final List <DocumentSnapshot> user = workingDocumentsUsers.docs;
    if (user.length != 0) {

      for (DocumentSnapshot users in user) {
        Map<String, dynamic> data = users.data() as Map<String, dynamic>;

        if(uid.contains(data['id'])){
          setState(() {
            data.clear();

          });
        }else {
          setState(() {
            workingDocuments.add(users.data());
            _documents.add(users);
            uid.add(data['id']);
            

            progress = true;
          });
        }
      }
    }else{
      setState(() {

       /* // convert each item to a string by using JSON encoding
        final jsonList = workingDocuments.map((item) => jsonEncode(item)).toList();

        // using toSet - toList strategy
        final uniqueJsonList = jsonList.toSet().toList();

        // convert each item back to the original form using JSON decoding
        workingDocuments = uniqueJsonList.map((item) => jsonDecode(item)).toList();*/

        progress = true;

      });


    }
  }

  }





