import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';

import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialContent/social_video_content.dart';
import 'package:sparks/social/socialContent/textConstants.dart';
import 'package:video_player/video_player.dart';

class SocialUserGridView extends StatefulWidget {
  SocialUserGridView({required this.doc});
  final DocumentSnapshot doc;
  @override
  _SocialUserGridViewState createState() => _SocialUserGridViewState();
}

class _SocialUserGridViewState extends State<SocialUserGridView> {
  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic> itemsData = <dynamic>[];
  var _documents = <DocumentSnapshot>[];
  var _docs = <DocumentSnapshot>[];
bool progress = false;
late List <dynamic> aoi;
late List <dynamic> spec;
late List <dynamic> hobby;
late List <dynamic> lang;

dynamic mentors = 0;
dynamic tutors = 0;
dynamic friends = 0;


  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }
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

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SocialConstant.isSeeAll = false;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhitecolor,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: kBlackcolor,),
    onPressed: () {
          Navigator.pop(context);
    }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(SocialConstant.isSeeAll?widget.doc['nm']['fn']:widget.doc['fn'],
                style: GoogleFonts.rajdhani(
                  fontSize:kFontsize.sp,
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,

                ),),

              IconButton(icon:Icon(Icons.more_vert) , onPressed: (){},color: kBlackcolor,)
            ],
          ),
        ),
        body: workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
        workingDocuments.length == 0 && progress == true ? Text('Loading'): SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      //radius: 50,
                      backgroundColor: Colors.transparent,

                      child: ClipOval(

                        child: CachedNetworkImage(

                          imageUrl: workingDocuments[0]['pimg'],
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 40.0,
                          height: 40.0,

                        ),
                      ),
                    ),

                    CountText(text1:'Courses',text2: '8977',),
                    VerticalDivider(),

                    CountText(text1:'Classes',text2: '8977',),
                    VerticalDivider(),

                    CountText(text1:'Tutorials',text2: '8977',)

                  ],
                ),
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                  CountText(text1:'Mentoring',text2: mentors.toString(),),
                  VerticalDivider(),

                  CountText(text1:'Tutoring',text2: tutors.toString(),),
                  VerticalDivider(),

                  CountText(text1:'Friends',text2: friends.toString(),)
                ],),

                Divider(),

                space(),
                space(),
                TextConstants(text1:'Date of birth'),
                Text('${workingDocuments[0]['bdate']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
                space(),
                TextConstants(text1:'Country/State'),
                Text('${workingDocuments[0]['addr']['cty']}/ ${workingDocuments[0]['addr']['st']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
                space(),
                TextConstants(text1:'status/sex'),
                Text('${workingDocuments[0]['marst']}/ ${workingDocuments[0]['sex']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
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


                 prog == false?Center(child: PlatformCircularProgressIndicator()):

                     GridView.builder(
                       physics: BouncingScrollPhysics(),
                       shrinkWrap: true,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                       crossAxisSpacing: 20.0,
                         mainAxisSpacing: 10.0,
                       ),
                       itemCount: itemsData.length,
                         padding: EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialVideoContent(doc:_docs,items:itemsData,userDoc:_documents[0])));

                        },
                        child: Stack(
                          // alignment: Alignment.center,
                            children: <Widget>[

                              itemsData[index]['prom'] == null &&
                                  itemsData[index]['vido'] == null ?
                              //this is just an image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    kSocialVideoCurve),

                                child: FadeInImage.assetNetwork(
                                  width: kSocialVideoCurve4,
                                  height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                                  fit: BoxFit.cover,
                                  image: ('${itemsData[index]['tmb']}'
                                      .toString()),
                                  placeholder: 'images/classroom/user.png',),
                              ) :


                              itemsData[index]['tmb'] == null ? Container
                                (width: MediaQuery.of(context).size.width,

                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        kSocialVideoCurve),

                                    child: ShowUploadedVideo(
                                      videoPlayerController: VideoPlayerController
                                          .network(itemsData[index]['prom']),
                                      looping: false,
                                    ),
                                  ),
                                ),
                              ) : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    kSocialVideoCurve),

                                child: Image.network(itemsData[index]['tmb'],
                                  fit: BoxFit.cover,
                                  width: 400,
                                  height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                                ),
                              ),
                              itemsData[index]['prom'] == null && itemsData[index]['vido'] == null
                                  ? Text('')
                                  : Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                        "images/classroom/uploadvideo.svg"),
                                  )),


                            ]),
                      );


                    }),





                prog == true || _loadMoreProgress == true
                    || _documents.length < SocialConstant.streamGridLength
                    ?Text(''):
                moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                    onTap: (){loadMore();},
                    child: SvgPicture.asset('images/classroom/load_more.svg',))
              ],
            ),
          ),
        )));
  }

  Future<void> getUserDetails() async {

    //get the count of friends
     FirebaseFirestore.instance.collection('sparkUp').doc(SocialConstant.usersUid).get().then((value){
      setState(() {
        mentors = value.data()!['numMe'];
        tutors = value.data()!['numTe'];
        friends = value.data()!['numF'];
      });
    });






    final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').doc(SocialConstant.usersUid

    ).collection('Personal').where('id',isEqualTo:SocialConstant.usersUid )
        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
setState(() {
  progress = true;
});
    }else{
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          workingDocuments.add(document.data());
          _documents.add(document);
          aoi = data['aoi'];
          spec = data['spec'];
          hobby = data['hobb'];
          lang = data['lang'];
        });
      }
    }


    //get users videos from class
    final QuerySnapshot resultClass = await FirebaseFirestore.instance.collectionGroup('expertClasses')
        .where('eid',isEqualTo: SocialConstant.usersUid )
        .orderBy('date',descending: true).limit(SocialConstant.streamGridLength)
        .get();
    final List <DocumentSnapshot> documentsClass = resultClass.docs;
    if (documents.length != 0) {


      for (DocumentSnapshot document in documentsClass) {
        setState(() {
          itemsData.add(document.data());
          _docs.add(document);
        });


      }
    }


    //get users videos from courses
    final QuerySnapshot resultCourse = await FirebaseFirestore.instance.collectionGroup('userCourses')
        .where('suid',isEqualTo: SocialConstant.usersUid )
        .orderBy('date',descending: true).limit(SocialConstant.streamGridLength)
        .get();
    final List <DocumentSnapshot> documentsCourse = resultCourse.docs;
    if(documents.length == 0){
      setState(() {
        prog = true;
      });

    }else {

      for (DocumentSnapshot document in documentsCourse) {
        setState(() {
          itemsData.add(document.data());
          _docs.add(document);
        });


      }
    }


    final QuerySnapshot resultP = await FirebaseFirestore.instance.collectionGroup('userSessionUploads')
        .where('suid',isEqualTo: SocialConstant.usersUid )
        .orderBy('date',descending: true).limit(SocialConstant.streamGridLength)
        .get();
    final List <DocumentSnapshot> documentsP = resultP.docs;
    if (documentsP.length != 0) {

      for (DocumentSnapshot document in documentsP) {
        _lastDocument = documentsP.last;

        setState(() {
          itemsData.add(document.data());
          _docs.add(document);
          prog = true;
        });
print(itemsData.length);
print(_docs.length);

      }
    }else{

      setState(() {
        prog = true;

      });
    }


  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('userSessionUploads')
        .where('suid',isEqualTo: SocialConstant.usersUid )

        .orderBy('date',descending: true).

    startAfterDocument(_lastDocument).limit(SocialConstant.streamGridLength)

        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;


        });
      }
    }
  }
}


