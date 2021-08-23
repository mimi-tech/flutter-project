import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/showComments.dart';
import 'package:sparks/social/socialConstants/PlaySocialVideos.dart';
import 'package:sparks/social/socialConstants/SocialSlivers/new_appbar.dart';
import 'package:sparks/social/socialConstants/searchAppbar.dart';
import 'package:sparks/social/socialConstants/second_appbar.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialConstants/social_icons.dart';
import 'package:sparks/social/socialConstants/SocialSlivers/new_appbar.dart';
import 'package:sparks/social/socialConstants/topAppbar.dart';
import 'package:sparks/social/socialConstants/video_text.dart';
import 'package:sparks/social/socialContent/user_gridView.dart';
import 'package:sparks/social/socialCourse/socialCourses.dart';
import 'package:sparks/social/socialCourse/social_classes.dart';
import 'package:sparks/social/social_reactions.dart';
import 'package:sparks/social/usersTabs/tabsTitle.dart';
import 'package:sparks/social/users_match.dart';


class SocialNewMatchesClasses extends StatefulWidget {
  @override
  _SocialNewMatchesClassesState createState() => _SocialNewMatchesClassesState();
}

class _SocialNewMatchesClassesState extends State<SocialNewMatchesClasses> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  var _documents = <DocumentSnapshot>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatusColor();
    getMyVideos();
    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });
  }
  void getStatusColor(){
    setState(() {
      //changing the status bar color
      stColor = kBlackcolor;
    });
  }

  double radius = 0.0;
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * kSocialWidgetHeight,
    );
  }
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  Widget bodyList(int index){
    return Card(
      elevation: kSocialElevation,
      child: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space(),
            TabsTitle(title:workingDocuments[index]['topic'] == null?workingDocuments[index]['title']:workingDocuments[index]['topic'] ,desc:workingDocuments[index]['desc'] ,),

            space(),

            VideoText(
              descClick: (){
                SocialConstant.usersUid =  workingDocuments[index]['suid']== null?workingDocuments[index]['eid']:workingDocuments[index]['suid'];

                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialUserGridView(doc:_documents[index],)));

              },
              descFn: workingDocuments[index]['fn'],
              descLn: workingDocuments[index]['ln'],
              descPix: workingDocuments[index]['pix'],
              vido:workingDocuments[index]['vido'] ,
              promo: workingDocuments[index]['prom'],
              thumbnail:  workingDocuments[index]['tmb'],
              show: (){
                UploadVariables.videoUrlSelected = workingDocuments[index]['prom'] == null?workingDocuments[index]['vido']:workingDocuments[index]['prom'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaySocialVideo(doc:_documents[index])));
                _viewCount(index);
              },
            ),

            space(),

            SocialIcons(
              views: (){},
              comments: (){_commentCount(index);},
              rating: (){_ratingCount(index);},
              share: (){_shareCount(index);},
              like: (){_likeCount(index);},
              viewsNumber: workingDocuments[index]['views'].toString(),
              commentsNumber: workingDocuments[index]['comm'].toString(),
              ratingNumber: workingDocuments[index]['rate'].toString(),
              likeNumber: workingDocuments[index]['like'].toString(),
              shareNumber: workingDocuments[index]['share'].toString(),

              saveUrl: workingDocuments[index]['prom'],
              saveName:workingDocuments[index]['name'] == null?workingDocuments[index]['title']:workingDocuments[index]['name'] ,
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                workingDocuments[index]['sub']== kSub? BtnSecond(next: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SocialCoursesClasses(doc:_documents[index],item:_documents,title:'Course')));

                }, title: kBuyCourse, bgColor:kLightGreen):
                workingDocuments[index]['sub']== kSup? BtnSecond(next: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SocialExpectClasses(doc:_documents[index],item:_documents,title:'Class')));

                }, title: kBuyClass, bgColor:kLightGreen):
                Text(''),

                BtnSecond(next: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SocialReactions(doc:_documents[index])));},
                    title: kReactions, bgColor: Colors.tealAccent
                ),



              ],
            )
          ],


        ),
      ),
    );
  }

  String? filter;


  @override
  Widget build(BuildContext context) {


    return SafeArea(child: Scaffold(
        backgroundColor: kBlackcolor,

        body:CustomScrollView(slivers: <Widget>[
          SocialTopAppBar(search: (){},),

          SocialSilverAppBar(
              matches: kFbColor,
              friends: kMaincolor,
              classroom: kMaincolor,
              content: kMaincolor),

          SocialSearchAppBar(),
          NewUsersMatch(),
          SocialThirdSilverAppBar(
            all:klistnmber,
            matches: kFbColor,
            friends: klistnmber,
            classroom: klistnmber,
            content: klistnmber,
          ),

          SliverList(
              delegate: SliverChildListDelegate([


                Container(

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: kWhitecolor,
                    //borderRadius:  BorderRadius.only(topRight: Radius.circular(15.0),topLeft: Radius.circular(radius),

                  ),

                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      workingDocuments.length == 0 && progress == false ?PlatformCircularProgressIndicator():
                      workingDocuments.length == 0 && progress == true ? NoContentText(title: kNoContent):
                      SingleChildScrollView(
                        child: ListView.builder(
                            itemCount: workingDocuments.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, int index) {
                              return filter == null || filter == "" ?bodyList(index):
                              '${workingDocuments[index]['topic']}'.toLowerCase()
                                  .contains(filter!.toLowerCase())

                                  ?bodyList(index):Container();
                            }),
                      ),

                      prog == true || _loadMoreProgress == true
                          || _documents.length < SocialConstant.streamLength
                          ?Text(''):
                      moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                          onTap: (){loadMore();},
                          child: SvgPicture.asset('assets/classroom/load_more.svg',))
                    ],
                  ),
                ),

              ])

          )
        ])
    )
    );
  }

  Future<void> getMyVideos() async {
    //this query if for area of interest for expert class
    workingDocuments.clear();

    for(int i = 0; i < GlobalVariables.loggedInUserObject.aoi!.length; i++){
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('expertClasses')
          .where('aoi',arrayContains:  GlobalVariables.loggedInUserObject.aoi![i])
          .orderBy('date',descending: true).limit(SocialConstant.streamLength)
          .get();
      final List <DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {


        for (DocumentSnapshot document in documents) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });


        }
      }



    }

    //this query if for area of specialization
    for(int i = 0; i < GlobalVariables.loggedInUserObject.spec!.length; i++){

      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('expertClasses')
          .where('spec',arrayContains: GlobalVariables.loggedInUserObject.spec![i])
          .orderBy('date',descending: true).limit(SocialConstant.streamLength)
          .get();
      final List <DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {

        for (DocumentSnapshot document in documents) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);

          });


        }
      }



    }

    //this query if for area of hobby
    for(int i = 0; i < GlobalVariables.loggedInUserObject.hobb!.length; i++){
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('expertClasses')
          .where('hobb',arrayContains: GlobalVariables.loggedInUserObject.hobb![i])
          .orderBy('date',descending: true).limit(SocialConstant.streamLength)
          .get();
      final List <DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {

        for (DocumentSnapshot document in documents) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);

          });


        }
      }





    }
    final QuerySnapshot resultUsers = await FirebaseFirestore.instance.collectionGroup('expertClasses')

        .orderBy('date',descending: true).limit(SocialConstant.streamLength)

        .get();
    final List <DocumentSnapshot> user = resultUsers.docs;
    if (user.length != 0) {

      for (DocumentSnapshot users in user) {
        _lastDocument = user.last;

        setState(() {
          workingDocuments.add(users.data());
          //areaOfSpec.add(users.data()['users']);
          progress = true;
          _documents.add(users);



        });


      }
    }else{
      setState(() {
        progress = true;
      });    }


  }


  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('expertClasses')

        .orderBy('date',descending: true).

    startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

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
          workingDocuments.add(document.data());

          moreData = false;


        });
      }
    }
  }


  Future<void> _viewCount(int index) async {

    FirebaseFirestore.instance.collection(workingDocuments[index]['sup']).doc(workingDocuments[index]['suid']).collection(workingDocuments[index]['sub'])
        .get()
        .then((value) {
      value.docs.forEach((comm) {
        var count = comm.data()['views'] + 1;
        comm.reference.set({
          'views':count,
        },SetOptions(merge: true));

      });
    });
    setState(() {
      workingDocuments[index]['views'] = workingDocuments[index]['views'] + 1;
    });
    //check if user details is already in database
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('viewedVideos')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push to database
      FirebaseFirestore.instance.collection('viewedVideos').add({
        'id':workingDocuments[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'pimg':GlobalVariables.loggedInUserObject.pimg,

        'ts':DateTime.now().toString(),


      });

    }


  }

  Future<void> _likeCount(int index) async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('likedVideos')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {


    }else {
      setState(() {
        workingDocuments[index]['like'] = workingDocuments[index]['like'] + 1;
      });

      FirebaseFirestore.instance.collection(workingDocuments[index]['sup']).doc(workingDocuments[index]['suid']).collection(workingDocuments[index]['sub'])
          .doc(workingDocuments[index]['id'] )
      //.doc(workingDocuments[index]['id'])
          .get()
          .then((value) {

        var count = value.data()!['like'] + 1;
        value.reference.set({
          'like': count,
        }, SetOptions(merge: true));


      });

      //push to database
      FirebaseFirestore.instance.collection('likedVideos').add({
        'id':workingDocuments[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'oid':workingDocuments[index]['suid'],
        'ofn':workingDocuments[index]['fn'],
        'oln':workingDocuments[index]['ln'],

      });

    }}

  Future<void> _shareCount(int index) async {

    Share.share(workingDocuments[index]['prom'] == null?workingDocuments[index]['vido']:workingDocuments[index]['prom']);

    FirebaseFirestore.instance.collection(workingDocuments[index]['sup']).doc(workingDocuments[index]['suid']).collection(workingDocuments[index]['sub'])
        .get()
        .then((value) {
      value.docs.forEach((comm) {
        var count = comm.data()['share'] + 1;
        comm.reference.set({
          'share':count,
        },SetOptions(merge: true));

      });
    });

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('sharedVideos')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video shared to database
      FirebaseFirestore.instance.collection('sharedVideos').add({
        'id':workingDocuments[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'oid':workingDocuments[index]['suid'],
        'ofn':workingDocuments[index]['fn'],
        'oln':workingDocuments[index]['ln'],

      });

    }
    setState(() {
      workingDocuments[index]['share'] = workingDocuments[index]['share'] + 1;
    });

  }

  void _commentCount(int index) {
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MessageStream(doc:_documents[index])));

    /*showModalBottomSheet(
        isDismissible: true,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {return MessageStream(doc:_documents[index]);});*/

  }
  void _ratingCount(int index) {
    SocialConstant.showRating(submit: (){_submitRating(index);});
  }
  Future<void> _submitRating(int index) async {
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('ratedVideos')
          .where('id', isEqualTo: workingDocuments[index]['id'])
          .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length >= 1) {
        SchClassConstant.displayBotToastError(title: kRated);

      }else {
        //update the rating like count

        FirebaseFirestore.instance.collection(workingDocuments[index]['sup']).doc(workingDocuments[index]['suid']).collection(workingDocuments[index]['sub']).doc(workingDocuments[index]['id'] ).get().then((result) {
          dynamic total = result.data()!['rate'] + SocialConstant.ratingCount;

          result.reference.set({
            'rate': total,

          }, SetOptions(merge: true));
        });


        //push video rating to database
        FirebaseFirestore.instance.collection('ratedVideos').add({
          'id':workingDocuments[index]['id'],
          'uid':GlobalVariables.loggedInUserObject.id,
          'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
          'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
          'ts':DateTime.now().toString(),
          'pimg':GlobalVariables.loggedInUserObject.pimg,


        });
        SchClassConstant.displayBotToastCorrect(title: kRatedThanks);

      }}catch(e){
      print(e);
    }
  }


}


