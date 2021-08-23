import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/social/showComments.dart';
import 'package:sparks/social/socialConstants/social_icons.dart';
import 'package:sparks/social/socialConstants/social_icons_light.dart';
import 'package:sparks/social/socialContent/videos_appbar.dart';
import 'package:video_player/video_player.dart';

class SocialVideoContent extends StatefulWidget {
  SocialVideoContent({required this.doc, required this.items,required this.userDoc});
  final List <DocumentSnapshot> doc;
  final List <dynamic> items;
  final DocumentSnapshot userDoc;


  @override
  _SocialVideoContentState createState() => _SocialVideoContentState();
}

class _SocialVideoContentState extends State<SocialVideoContent> {
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }

  /*final GlobalKey<BetterPlayerPlaylistState> _betterPlayerPlaylistStateKey =
  GlobalKey();
  List<BetterPlayerDataSource> _dataSourceList = [];
  BetterPlayerController _betterPlayerController;
   BetterPlayerPlaylistConfiguration _betterPlayerPlaylistConfiguration;
   BetterPlayerConfiguration _betterPlayerConfiguration;

  Future<List<BetterPlayerDataSource>> setupData() async {

    for(int i = 0; i < widget.items.length; i++){
      _dataSourceList.add(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, widget.items[i]['prom'] == null?widget.items[i]['vido']:widget.items[i]['prom'],

          //placeholder: CircularProgressIndicator()
        ),
      );
    }

    return _dataSourceList;

  }*/
  late ChewieController _chewieController;
  late  VideoPlayerController videoPlayerController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
/*
setupData();
    _betterPlayerConfiguration = BetterPlayerConfiguration(
     // aspectRatio: 1,
      //fit: BoxFit.cover,
      placeholderOnTop: true,

     // autoPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        showControlsOnInitialize: false,
        controlBarColor: Colors.transparent,
        enableFullscreen: true,
        progressBarBackgroundColor: kRed,
        //backgroundColor: kAYellow

      ),
      //showPlaceholderUntilPlay: true,
      subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(fontSize: 10),
      */
/*deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],*//*

    );

    _betterPlayerPlaylistConfiguration = BetterPlayerPlaylistConfiguration(
      loopVideos: true,
      nextVideoDelay: Duration(seconds: 1),
    );

*/

   }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
         backgroundColor: kBlackcolor,

        body:CustomScrollView(slivers: <Widget>[
        SocialVideosAppbar(text1:widget.userDoc['un'] ,),



    SliverList(
    delegate: SliverChildListDelegate([

    ListView.builder(
    itemCount: widget.items.length,
    shrinkWrap: true,
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, int index) {
      videoPlayerController = VideoPlayerController.network(widget.items[index]['prom'] == null?widget.items[index]['vido']:widget.items[index]['prom']);

      _chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          // aspectRatio: 16/ 9,
          autoInitialize: true,
          looping: false,
          showControlsOnInitialize: false,
          allowedScreenSleep: false,
          allowFullScreen: true,
          autoPlay: false,
          deviceOrientationsOnEnterFullScreen: [

            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ],
          deviceOrientationsAfterFullScreen: [

            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,

          ],
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(errorMessage, style: TextStyle(color: Colors.white)),
            );
          }


      );

      return Container(
        child: Card(
          color: kBlackcolor,
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //space(),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      //radius: 50,
                      backgroundColor: Colors.transparent,

                      child: ClipOval(

                        child: CachedNetworkImage(

                          imageUrl: widget.userDoc['pimg'],
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 40.0,
                          height: 40.0,

                        ),
                      ),
                    ),

                     SizedBox(width: 10,),
                    Text('${widget.userDoc['nm']['fn']} ${widget.userDoc['nm']['ln']}'.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        fontSize:14.sp,
                        color: kFbColor,
                        fontWeight: FontWeight.bold,

                      ),),
                  ],
                ),
              ),

              widget.items[index]['title'] == null?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('${widget.items[index]['name']}',
                      style: GoogleFonts.rajdhani(
                       fontSize:kFontsize.sp,
                        color: kWhitecolor,
                        fontWeight: FontWeight.w600,

                      ),),

                    Text('${widget.items[index]['topic']}',
                      style: GoogleFonts.rajdhani(
                        fontSize:14.sp,
                        color: kExpertColor,
                        fontWeight: FontWeight.w600,

                      ),),
                  ],
                ),
              )

                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                 Text('${widget.items[index]['title']}',
                     style: GoogleFonts.rajdhani(
                       fontSize:kFontsize.sp,
                       color: kWhitecolor,
                       fontWeight: FontWeight.w600,

                     ),),

                 Text('${widget.items[index]['desc']}',
                     style: GoogleFonts.rajdhani(
                       fontSize:14.sp,
                       color: kExpertColor,
                       fontWeight: FontWeight.w600,

                     ),),
               ],
             ),
                  ),

          Chewie(controller: _chewieController,),
             /* BetterPlayerListVideoPlayer(
                BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.items[index]['prom'] == null?widget.items[index]['vido']:widget.items[index]['prom']),

                configuration: BetterPlayerConfiguration(
                  //fit: BoxFit.fill,
                  placeholderOnTop: true,
                    deviceOrientationsOnFullScreen:[
                      DeviceOrientation.landscapeRight,
                      DeviceOrientation.landscapeLeft,
                    ] ,
                  // autoPlay: true,
                  controlsConfiguration: BetterPlayerControlsConfiguration(
                    showControlsOnInitialize: false,
                    controlBarColor: Colors.transparent,
                    enableFullscreen: false,
                    progressBarBackgroundColor: kRed,
                    //backgroundColor: kAYellow

                  ),
                  //showPlaceholderUntilPlay: true,


              ),





                key: Key(_dataSourceList.hashCode.toString()),
                playFraction: 1.0,
              ),*/

              /* BetterPlayerPlaylist(
                 key: Key(_dataSourceList.hashCode.toString()), //_betterPlayerPlaylistStateKey,
                 betterPlayerConfiguration: _betterPlayerConfiguration,
                 betterPlayerPlaylistConfiguration: _betterPlayerPlaylistConfiguration,
                 betterPlayerDataSourceList: _dataSourceList,
               ),*/

              SocialIconsLight(
                views: (){},
                comments: (){_commentCount(index);},
                rating: (){},
                share: (){_shareCount(index);},
                like: (){_likeCount(index);},
                viewsNumber: widget.items[index]['views'].toString(),
                commentsNumber:  widget.items[index]['comm'].toString(),
                ratingNumber:  widget.items[index]['rate'].toString(),
                likeNumber:  widget.items[index]['like'].toString(),
                shareNumber:  widget.items[index]['share'].toString(),
                saveUrl: widget.items[index]['prom'],
                saveName:widget.items[index]['name'] == null?widget.items[index]['title']:widget.items[index]['name'] ,
              ),
               space(),


              /*  FutureBuilder<List<BetterPlayerDataSource>>(
                  future: setupData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Building!");
                    } else {
                      return Container(
                        //height: 300,
                        child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                    "Playlist widget will load automatically next video once current "
                                        "finishes. User can't use player controls when video is changing."),
                              ),
                              AspectRatio(
                                child:  BetterPlayerListVideoPlayer(
                                  BetterPlayerDataSource(
                                      BetterPlayerDataSourceType.network, widget.items[index]['prom'] == null?widget.items[index]['vido']:widget.items[index]['prom']),
                                  key: Key(_dataSourceList.hashCode.toString()),
                                  playFraction: 0.05,
                                ),
                                aspectRatio: 1,
                              ),
                            ]
                        ),
                      );
                    }
                  }
              ),*/
             /* AspectRatio(
                child: BetterPlayerPlaylist(
                  key: _betterPlayerPlaylistStateKey,
                  betterPlayerConfiguration: _betterPlayerConfiguration,
                  betterPlayerPlaylistConfiguration: _betterPlayerPlaylistConfiguration,
                  betterPlayerDataSourceList: snapshot.data,
                ),
                aspectRatio: 1,
              ),*/
             /* ShowUploadedVideo(
                videoPlayerController: VideoPlayerController.network(widget.items[index]['prom'] == null?widget.items[index]['vido']:widget.items[index]['prom']),
                looping: false,
              ),*/
            ],
          ),
        ),
      );
    }),




        ]
    )

    )
    ])));


  }

  void _commentCount(int index) {
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MessageStream(doc:widget.doc[index])));

  }

  Future<void> _shareCount(int index) async {
    Share.share(widget.items[index]['prom'] == null?widget.items[index]['vido']:widget.items[index]['prom']);

    FirebaseFirestore.instance.collection(widget.items[index]['sup']).doc(widget.items[index]['suid']).collection(widget.items[index]['sub'])
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
        .where('id', isEqualTo: widget.items[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video shared to database
      FirebaseFirestore.instance.collection('sharedVideos').add({
        'id':widget.items[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'oid':widget.items[index]['suid'],
        'ofn':widget.items[index]['fn'],
        'oln':widget.items[index]['ln'],

      });

    }}

  Future<void> _likeCount(int index) async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('likedVideos')
        .where('id', isEqualTo: widget.items[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {


    }else {
      setState(() {
        widget.items[index]['like'] = widget.items[index]['like'] + 1;
      });

      FirebaseFirestore.instance.collection(widget.items[index]['sup']).doc(widget.items[index]['suid']).collection(widget.items[index]['sub'])
          .doc(widget.items[index]['id'] )
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
        'id':widget.items[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'oid':widget.items[index]['suid'],
        'ofn':widget.items[index]['fn'],
        'oln':widget.items[index]['ln'],

      });

    }
  }
  void dispose() {
    super.dispose();
    if(videoPlayerController != null){
      videoPlayerController.dispose();
    }
    if( _chewieController != null){
      _chewieController.dispose();
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
