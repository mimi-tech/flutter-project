import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/socialConstants/reaction_play_video.dart';

import 'package:sparks/social/socialConstants/reactons_text.dart';
import 'package:video_player/video_player.dart';

class LikesReactions extends StatefulWidget {

  LikesReactions({required this.doc});
  final DocumentSnapshot doc;
  @override
  _LikesReactionsState createState() => _LikesReactionsState();
}

class _LikesReactionsState extends State<LikesReactions> {
  late VideoPlayerController _videoPlayerController1;
  late ChewieController _chewieController;

  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {

        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if(isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {

    FirebaseFirestore.instance.collection('likedVideos').where('id',isEqualTo: widget.doc['id']).snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
    _videoPlayerController1.dispose();
    _chewieController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(


            body: SingleChildScrollView(
              child: Container(

                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                      child: widget.doc['prom'] == null && widget.doc['vido'] == null?
                      //this is just an image
                      FadeInImage.assetNetwork(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                        fit: BoxFit.cover,
                        image: ('${widget.doc['tmb']}'.toString()),
                        placeholder: 'images/classroom/user.png',) :
                      Center(
                        child: ReactionVideos(
                          videoPlayerController: VideoPlayerController.network(widget.doc['prom'] == null? widget.doc['vido']:widget.doc['prom']),
                          looping: true,
                        ),
                      ),

                    ),



                    StreamBuilder<List<DocumentSnapshot>>(
                        stream: _streamController.stream,

                        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if(snapshot.data == null){
                            return Center(child:  Text(kReactionsLoading,
                              style: GoogleFonts.rajdhani(fontSize:kFontsize.sp,
                                color:kBlackcolor,
                                fontWeight: FontWeight.bold,

                              ),),);
                          } else {
                            return Column(
                                children: snapshot.data!.map((doc) {
                                  Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;


                                  return Column(
                                    children: [
                                      ReactionText(

                                        text1: data['pimg'].toString(),
                                        text2: data['fn'],
                                        text3: data['ln'],
                                        text4: 'Liked by',
                                        text5: '${_products.length.toString()}  like(s)',
                                      ),
                                    ],
                                  );
                                }).toList()

                            );
                          }
                        }
                    ),
                    _isFinish == false ?
                    isLoading == true ? Center(
                        child: PlatformCircularProgressIndicator()) : Text('')

                        : Text(''),
                  ],
                ),
              ),
            ),
          ),
        ));
  }



  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await FirebaseFirestore.instance.collection('likedVideos').where('id',isEqualTo: widget.doc['id'])
            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await FirebaseFirestore.instance.collection('likedVideos').where('id',isEqualTo: widget.doc['id'])
            .startAfterDocument(_products[_products.length - 1])
            .limit(SchClassConstant.streamCount)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }


}
