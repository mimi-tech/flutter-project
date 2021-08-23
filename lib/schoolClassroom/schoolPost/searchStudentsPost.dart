import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postComments.dart';
import 'package:sparks/schoolClassroom/schoolPost/seeImagePost.dart';
import 'package:sparks/schoolClassroom/schoolPost/watchPostVideos.dart';
import 'package:sparks/schoolClassroom/utils/postIconsSecond.dart';
import 'package:sparks/schoolClassroom/utils/postPlayingVideos.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';
import 'package:sparks/schoolClassroom/utils/searchservice.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class SearchStudentsPost extends StatefulWidget {
  @override
  _SearchStudentsPostState createState() => _SearchStudentsPostState();
}

class _SearchStudentsPostState extends State<SearchStudentsPost> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
bool isPlaying = false;
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

      SearchService().searchByStudentsPost(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['fn'].startsWith(capitalizedValue)) {

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
        appBar: AppBar(
          backgroundColor: kStatusbar,
          title: Text('Search for a post',
            style: GoogleFonts.rajdhani(
              fontSize:kFontsize.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),
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
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by first name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([

                    tempSearchStore.length == 0?Text(''):
                  ListView.builder(
                  itemCount: tempSearchStore.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, int index) {

                    return Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ProfilePix(pix: tempSearchStore[index]['pimg'],),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${tempSearchStore[index]['fn']} ${tempSearchStore[index]['ln']}',
                                    style: GoogleFonts.rajdhani(
                                      fontSize:kFontsize.sp,
                                      fontWeight: FontWeight.bold,
                                      color: kBlackcolor,
                                    ),
                                  ),

                                  Text('${tempSearchStore[index]['dept']} department',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontSize14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: klistnmber,
                                    ),
                                  ),
                                  Text('${timeago.format(DateTime.parse(tempSearchStore[index]['ts']), locale: 'en_short')} ago',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontSize14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: klistnmber,
                                    ),
                                  ),


                                ],
                              ),
                            ],
                          ),

                          tempSearchStore[index]['mpix'] == true?
                          Stack(
                            children: [

                              GestureDetector(
                                onTap:(){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SeeImagePost(doc:tempSearchStore[index])));

                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      kSocialVideoCurve),

                                  child: FadeInImage.assetNetwork(

                                    //height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                                    fit: BoxFit.cover,
                                    image: ('${tempSearchStore[index]['pix'][0]}'.toString()),
                                    placeholder: 'images/classroom/user.png',),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.add,color: kIconColor,),
                                      Text(tempSearchStore[index]['ct'].toString(),
                                        style: GoogleFonts.rajdhani(
                                          fontSize:kFontsize.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kExpertColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )

                              :tempSearchStore[index]['txt'] == true?

                          Container(

                            decoration:BoxDecoration(
                                borderRadius:BorderRadius.circular(6.0),
                                color: Color(int.parse(tempSearchStore[index]['bg'])).withOpacity(1)
                            ),
                            child:  Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),

                                child: Text(tempSearchStore[index]['msg'],
                                  textAlign:TextAlign.center,
                                  style: GoogleFonts.rajdhani(

                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kWhitecolor,
                                  ),
                                ),
                              ),
                            ),
                          )

                              :GestureDetector(
                            onLongPress:(){
                              SchoolPostConst.doc = tempSearchStore[index];

                              UploadVariables.videoUrlSelected = tempSearchStore[index]['vido'];
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WatchPostVideos(doc:tempSearchStore[index])));

                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(kSocialVideoCurve),

                                    child: /*AspectRatio(
                          aspectRatio: 16 / 9,
                          child: BetterPlayerListVideoPlayer(
                            BetterPlayerDataSource(
                                BetterPlayerDataSourceType.network, tempSearchStore[index]['vido']),
                            key: Key(tempSearchStore[index]['vido'].hashCode.toString()),
                            playFraction: 0.8,
                          ),
                        ),
*/

                                    PlayingSchoolPostVideos(
                                      videoPlayerController: VideoPlayerController.network(tempSearchStore[index]['vido']),
                                      looping: false,
                                      playing: isPlaying,
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                          SchoolPostIconsSecond(
                            myColor:kWhitecolor,
                            comments: (){
                              Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: PostCommentStream(doc:tempSearchStore[index])));

                            },
                            share: (){ if(tempSearchStore[index]['txt']== false) {
                              _shareCount(index);
                            }},
                            like: (){_likeCount(index);},

                            commentsNumber: tempSearchStore[index]['com'].toString(),
                            likeNumber: tempSearchStore[index]['like'].toString(),
                            shareNumber:tempSearchStore[index]['share'].toString(),
                            saveVideo: (){
                              if( tempSearchStore[index]['txt'] == true){
                                _saveThisVideo(index);

                              }},

                            viewsNumber: tempSearchStore[index]['txt'] == true || tempSearchStore[index]['txt'] == null?Visibility(
                                visible:false,
                                child: Text('')):Row(
                              children: [
                                SvgPicture.asset('images/classroom/views.svg',color: kIconColor,height: 15,width: 15,),
                                //IconButton(icon:SvgPicture.asset('images/classroom/views.svg'), onPressed:widget.views,),
                                Text(tempSearchStore[index]['view'].toString(),
                                  style: GoogleFonts.rajdhani(fontSize: 12.sp,
                                    color:kIconColor,
                                    fontWeight: FontWeight.bold,

                                  ),),
                              ],
                            ), viewLikes: (){}, viewShare: (){},
                          ),


                        ],
                      ),
                    );

                  }),
                  
              ]
    )
    )])));
  }


  Future<void> _likeCount(int index) async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('likedSchPost')
        .where('id', isEqualTo: tempSearchStore[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {


    }else {


      FirebaseFirestore.instance.collection('schoolPost').doc(tempSearchStore[index]['schId']).collection('campusPost')
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
      FirebaseFirestore.instance.collection('likedSchPost').add({
        'id':tempSearchStore[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],

      });

    }}

  Future<void> _shareCount(int index) async {

    Share.share(tempSearchStore[index]['vido']);

    FirebaseFirestore.instance.collection('schoolPost').doc(tempSearchStore[index]['schId']).collection('campusPost')

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
      FirebaseFirestore.instance.collection('sharedSchPost').add({
        'id':tempSearchStore[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],

      });

    }

  }

  Future<void> _saveThisVideo(int index) async {
//check if student have saved this video before
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('studentSavedPost').doc(GlobalVariables.loggedInUserObject.id).collection('savedPost')
        .where('id', isEqualTo: tempSearchStore[index]['id'])

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video saved to database
      DocumentReference docRef =  FirebaseFirestore.instance.collection('studentSavedPost').doc(GlobalVariables.loggedInUserObject.id).collection('savedPost').doc();
      docRef.set({

        'pid':tempSearchStore[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],
        'id':docRef.id,
        'post': tempSearchStore[index]['vido']

      });
      SchClassConstant.displayToastCorrect(title: 'SavedSuccessfully');

    }else{
      SchClassConstant.displayToastError(title: 'You have saved this video already');
    }

  }
}

