import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/showComments.dart';
import 'package:sparks/social/socialConstants/PlaySocialVideos.dart';
import 'package:sparks/social/socialConstants/second_appbar.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialConstants/social_icons.dart';
import 'package:sparks/social/socialConstants/user_desc.dart';
import 'package:sparks/social/socialContent/user_gridView.dart';

import 'package:sparks/social/socialCourse/searchservice.dart';
import 'package:sparks/social/socialCourse/socialCourses.dart';
import 'package:sparks/social/socialCourse/social_classes.dart';
import 'package:sparks/social/social_reactions.dart';
import 'package:sparks/social/usersTabs/tabsTitle.dart';
import 'package:video_player/video_player.dart';

class CourseSearchStream extends StatefulWidget {
  @override
  _CourseSearchStreamState createState() => _CourseSearchStreamState();
}

class _CourseSearchStreamState extends State<CourseSearchStream> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {

      SearchService().searchByCourseName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {

          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: SearchAppBar(title: kSearchBarClass2,),
        body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                backgroundColor: kWhitecolor,
                automaticallyImplyLeading: false,
                //expandedHeight: 100,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (dynamic val) {
                      initiateSearch(val);
                    },
                    decoration: SocialConstant.kSearchDecoration,
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([

                    tempSearchStore.length == 0?Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(kReactionsLoading2),
                    )):
                    ListView.builder(
                        itemCount: tempSearchStore.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {

                          return  Card(
                            elevation: 5,
                            child: Container(

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  space(),
                                  TabsTitle(title:tempSearchStore[index]['topic'] == null?tempSearchStore[index]['title']:tempSearchStore[index]['topic'] ,desc:tempSearchStore[index]['desc'] ,),

                                  space(),
                                  GestureDetector(
                                    onTap:(){
                                      UploadVariables.videoUrlSelected = tempSearchStore[index]['prom'] == null?tempSearchStore[index]['vido']:tempSearchStore[index]['prom'];
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaySocialVideo(doc:tempSearchStore[index])));
                                      _viewCount(index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),

                                      child: Stack(
                                        // alignment: Alignment.center,
                                          children: <Widget>[

                                            tempSearchStore[index]['prom'] == null && tempSearchStore[index]['vido'] == null?
                                            //this is just an image
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(kSocialVideoCurve),

                                              child: FadeInImage.assetNetwork(
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                                                fit: BoxFit.cover,
                                                image: ('${tempSearchStore[index]['tmb']}'.toString()),
                                                placeholder: 'images/classroom/user.png',),
                                            ) :


                                            tempSearchStore[index]['tmb'] == null? Container(
                                              width:MediaQuery.of(context).size.width,

                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(kSocialVideoCurve),

                                                  child: ShowUploadedVideo(
                                                    videoPlayerController: VideoPlayerController.network(tempSearchStore[index]['prom']),
                                                    looping: false,
                                                  ),
                                                ),
                                              ),
                                            ): Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(kSocialVideoCurve),

                                                child: Image.network(tempSearchStore[index]['tmb'],
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                                                ),
                                              ),
                                            ),
                                            tempSearchStore[index]['prom'] == null && tempSearchStore[index]['vido'] == null?Text(''):Align(
                                                alignment:Alignment.topRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset("images/classroom/uploadvideo.svg"),
                                                )),




                                            Positioned(
                                              bottom:0,
                                              top:0,
                                              left:0,
                                              right:0,
                                              child: Align(
                                                  alignment:Alignment.bottomCenter,

                                                  child: UserDescription(text1: '${tempSearchStore[index]['pix']}',
                                                      text2: tempSearchStore[index]['fn'],
                                                      text3: tempSearchStore[index]['ln'],
                                                      text4: 'Not in uniform yet',//tempSearchStore[index]['aoi'][0],
                                                      text5:kFollowings,
                                                      click:(){
                                                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialUserGridView(doc:tempSearchStore[index],)));

                                                      }
                                                  )
                                              ),
                                            ),


                                          ]),
                                    ),
                                  ),
                                  space(),

                                  SocialIcons(
                                    views: (){},
                                    comments: (){_commentCount(index);},
                                    rating: (){_ratingCount(index);},
                                    share: (){_shareCount(index);},
                                    like: (){_likeCount(index);},
                                    viewsNumber: tempSearchStore[index]['views'].toString(),
                                    commentsNumber: tempSearchStore[index]['comm'].toString(),
                                    ratingNumber: tempSearchStore[index]['rate'].toString(),
                                    likeNumber: tempSearchStore[index]['like'].toString(),
                                    shareNumber: tempSearchStore[index]['share'].toString(),

                                    saveUrl: tempSearchStore[index]['prom'],
                                    saveName:tempSearchStore[index]['name'] == null?tempSearchStore[index]['title']:tempSearchStore[index]['name'] ,
                                  ),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      tempSearchStore[index]['sub']== kSub? BtnSecond(next: (){
                                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SocialCoursesClasses(doc:tempSearchStore[index],item:tempSearchStore,title:'Course')));

                                      }, title: kBuyCourse, bgColor:kLightGreen):
                                      tempSearchStore[index]['sub']== kSup? BtnSecond(next: (){
                                        print('cc');
                                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SocialExpectClasses(doc:tempSearchStore[index],item:tempSearchStore,title:'Class')));

                                      }, title: kBuyClass, bgColor:kLightGreen):
                                      Text(''),

                                      BtnSecond(next: (){
                                        print('ooo');
                                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SocialReactions(doc:tempSearchStore[index])));},
                                          title: kReactions, bgColor: Colors.tealAccent
                                      ),



                                    ],
                                  )
                                ],


                              ),
                            ),
                          );
                        })])
              )])


    ));


  }

  Future<void> _viewCount(int index) async {

    FirebaseFirestore.instance.collection(tempSearchStore[index]['sup']).doc(tempSearchStore[index]['suid']).collection(tempSearchStore[index]['sub'])
        .get()
        .then((value) {
      value.docs.forEach((comm) {
        var count = comm.data()['views'] + 1;
        comm.reference.set({
          'views':count,
        },SetOptions(merge: true));

      });
    });

    //check if user details is already in database
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('viewedVideos')
        .where('id', isEqualTo: tempSearchStore[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push to database
      FirebaseFirestore.instance.collection('viewedVideos').add({
        'id':tempSearchStore[index]['id'],
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
        .where('id', isEqualTo: tempSearchStore[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {


    }else {

      FirebaseFirestore.instance.collection(tempSearchStore[index]['sup']).doc(tempSearchStore[index]['suid']).collection(tempSearchStore[index]['sub'])
          .doc(tempSearchStore[index]['id'] )
      //.doc(tempSearchStore[index]['id'])
          .get()
          .then((value) {

        var count = value.data()!['like'] + 1;
        value.reference.set({
          'like': count,
        }, SetOptions(merge: true));


      });

      //push to database
      FirebaseFirestore.instance.collection('likedVideos').add({
        'id':tempSearchStore[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'oid':tempSearchStore[index]['suid'],
        'ofn':tempSearchStore[index]['fn'],
        'oln':tempSearchStore[index]['ln'],

      });

    }}

  Future<void> _shareCount(int index) async {

    Share.share(tempSearchStore[index]['prom'] == null?tempSearchStore[index]['vido']:tempSearchStore[index]['prom']);

    FirebaseFirestore.instance.collection(tempSearchStore[index]['sup']).doc(tempSearchStore[index]['suid']).collection(tempSearchStore[index]['sub'])
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
        .where('id', isEqualTo: tempSearchStore[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video shared to database
      FirebaseFirestore.instance.collection('sharedVideos').add({
        'id':tempSearchStore[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'oid':tempSearchStore[index]['suid'],
        'ofn':tempSearchStore[index]['fn'],
        'oln':tempSearchStore[index]['ln'],

      });

    }

  }

  void _commentCount(int index) {
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MessageStream(doc:tempSearchStore[index])));


  }
  void _ratingCount(int index) {
    SocialConstant.showRating(submit: (){_submitRating(index);});
  }
  Future<void> _submitRating(int index) async {
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('ratedVideos')
          .where('id', isEqualTo: tempSearchStore[index]['id'])
          .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length >= 1) {
        SchClassConstant.displayBotToastError(title: kRated);

      }else {
        //update the rating like count

        FirebaseFirestore.instance.collection(tempSearchStore[index]['sup']).doc(tempSearchStore[index]['suid']).collection(tempSearchStore[index]['sub']).doc(tempSearchStore[index]['id'] ).get().then((result) {
          dynamic total = result.data()!['rate'] + SocialConstant.ratingCount;

          result.reference.set({
            'rate': total,

          }, SetOptions(merge: true));
        });


        //push video rating to database
        FirebaseFirestore.instance.collection('ratedVideos').add({
          'id':tempSearchStore[index]['id'],
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

