import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/utils/PlaySocialVideos.dart';
import 'package:sparks/schoolClassroom/utils/social_constants.dart';

import 'package:video_player/video_player.dart';

class SocialVideoStream extends StatefulWidget {
  SocialVideoStream({required this.doc});
  final DocumentSnapshot doc;
  @override
  _SocialVideoStreamState createState() => _SocialVideoStreamState();
}

class _SocialVideoStreamState extends State<SocialVideoStream> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  var _documents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyVideos();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: Container(
                height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: workingDocuments.length == 0 && progress == false
                    ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kFbColor,
                    ))
                    : workingDocuments.length == 0 && progress == true
                    ? Text('No content')
                    : Container(
                    color: kBlackcolor,
                    height: MediaQuery.of(context).size.height *
                        kSocialVideoCurve3,
                    child: ListView.builder(
                        itemCount: workingDocuments.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return Card(
                            color: kBlackcolor,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                UploadVariables.videoUrlSelected =
                                workingDocuments[index]['prom'];
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlaySocialVideo(
                                                doc: _documents[
                                                index])));
                                _viewCount(index);
                              },
                              child: Stack(
                                // alignment: Alignment.center,
                                  children: <Widget>[
                                    workingDocuments[index]['prom'] ==
                                        null &&
                                        workingDocuments[index]
                                        ['vido'] ==
                                            null
                                        ?
                                    //this is just an image
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                          kSocialVideoCurve),
                                      child: FadeInImage
                                          .assetNetwork(
                                        width: kSocialVideoCurve4,
                                        height: MediaQuery.of(
                                            context)
                                            .size
                                            .height *
                                            kSocialVideoCurve3,
                                        fit: BoxFit.cover,
                                        image:
                                        ('${workingDocuments[index]['tmb']}'
                                            .toString()),
                                        placeholder:
                                        'images/classroom/user.png',
                                      ),
                                    )
                                        : workingDocuments[index]
                                    ['tmb'] ==
                                        null
                                        ? Container(
                                      width: MediaQuery.of(
                                          context)
                                          .size
                                          .width,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              kSocialVideoCurve),
                                          child:
                                          ShowUploadedVideo(
                                            videoPlayerController:
                                            VideoPlayerController.network(
                                                workingDocuments[
                                                index]
                                                [
                                                'prom']),
                                            looping: false,
                                          ),
                                        ),
                                      ),
                                    )
                                        : ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                          kSocialVideoCurve),
                                      child: Image.network(
                                        workingDocuments[
                                        index]['tmb'],
                                        fit: BoxFit.cover,
                                        width:
                                        kSocialVideoCurve4,
                                        height: MediaQuery.of(
                                            context)
                                            .size
                                            .height *
                                            kSocialVideoCurve2,
                                      ),
                                    ),
                                    workingDocuments[index]['prom'] ==
                                        null &&
                                        workingDocuments[index]
                                        ['vido'] ==
                                            null
                                        ? Text('')
                                        : Align(
                                        alignment:
                                        Alignment.topRight,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: SvgPicture.asset(
                                              "images/classroom/uploadvideo.svg"),
                                        )),
                                  ]),
                            ),
                          );
                        })))));
  }

  Future<void> getMyVideos() async {
    //this query if for area of interest for expert class
    workingDocuments.clear();

    for (int i = 0; i < GlobalVariables.loggedInUserObject.aoi!.length; i++) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('expertClasses')
          .where('aoi',
          arrayContains: GlobalVariables.loggedInUserObject.aoi![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {
        for (DocumentSnapshot document in documents) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for courses aoi

      final QuerySnapshot resultCourse = await FirebaseFirestore.instance
          .collectionGroup('userCourses')
          .where('aoi',
          arrayContains: GlobalVariables.loggedInUserObject.aoi![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsC = resultCourse.docs;
      if (documentsC.length != 0) {
        for (DocumentSnapshot document in documentsC) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for published aoi

      final QuerySnapshot resultP = await FirebaseFirestore.instance
          .collectionGroup('publishedLive')
          .where('aoi',
          arrayContains: GlobalVariables.loggedInUserObject.aoi![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsP = resultP.docs;
      if (documentsP.length != 0) {
        for (DocumentSnapshot document in documentsP) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for upload aoi

      final QuerySnapshot resultU = await FirebaseFirestore.instance
          .collectionGroup('userSessionUploads')
          .where('aoi',
          arrayContains: GlobalVariables.loggedInUserObject.aoi![i])
          .orderBy('ts', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsU = resultU.docs;
      if (documentsU.length != 0) {
        for (DocumentSnapshot document in documentsU) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }
    }

    //this query if for area of specialization
    for (int i = 0; i < GlobalVariables.loggedInUserObject.spec!.length; i++) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('expertClasses')
          .where('spec',
          arrayContains: GlobalVariables.loggedInUserObject.spec![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {
        for (DocumentSnapshot document in documents) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for courses area of specialization

      final QuerySnapshot resultCourse = await FirebaseFirestore.instance
          .collectionGroup('userCourses')
          .where('spec',
          arrayContains: GlobalVariables.loggedInUserObject.spec![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsC = resultCourse.docs;
      if (documentsC.length != 0) {
        for (DocumentSnapshot document in documentsC) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for published area of specialization

      final QuerySnapshot resultP = await FirebaseFirestore.instance
          .collectionGroup('publishedLive')
          .where('spec',
          arrayContains: GlobalVariables.loggedInUserObject.spec![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsP = resultP.docs;
      if (documentsP.length != 0) {
        for (DocumentSnapshot document in documentsP) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for uploads area of specialization

      final QuerySnapshot resultU = await FirebaseFirestore.instance
          .collectionGroup('userSessionUploads')
          .where('spec',
          arrayContains: GlobalVariables.loggedInUserObject.spec![i])
          .orderBy('ts', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsU = resultU.docs;
      if (documentsU.length != 0) {
        for (DocumentSnapshot document in documentsU) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }
    }

    //this query if for area of hobby
    for (int i = 0; i < GlobalVariables.loggedInUserObject.hobb!.length; i++) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('expertClasses')
          .where('hobb',
          arrayContains: GlobalVariables.loggedInUserObject.hobb![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length != 0) {
        for (DocumentSnapshot document in documents) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for courses area of hobby

      final QuerySnapshot resultCourse = await FirebaseFirestore.instance
          .collectionGroup('userCourses')
          .where('hobb',
          arrayContains: GlobalVariables.loggedInUserObject.hobb![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsC = resultCourse.docs;
      if (documentsC.length != 0) {
        for (DocumentSnapshot document in documentsC) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for published area of hobby

      final QuerySnapshot resultP = await FirebaseFirestore.instance
          .collectionGroup('publishedLive')
          .where('hobb',
          arrayContains: GlobalVariables.loggedInUserObject.hobb![i])
          .orderBy('date', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsP = resultP.docs;
      if (documentsP.length != 0) {
        for (DocumentSnapshot document in documentsP) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }

      ///query for uploads area of hobby

      final QuerySnapshot resultU = await FirebaseFirestore.instance
          .collectionGroup('userSessionUploads')
          .where('hobb',
          arrayContains: GlobalVariables.loggedInUserObject.hobb![i])
          .orderBy('ts', descending: true)
          .limit(SocialConstant.streamLength)
          .get();
      final List<DocumentSnapshot> documentsU = resultU.docs;
      if (documentsU.length != 0) {
        for (DocumentSnapshot document in documentsU) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
          });
        }
      }
    }
    final QuerySnapshot resultUsers = await FirebaseFirestore.instance
        .collectionGroup('userSessionUploads')
        .orderBy('ts', descending: true)
        .limit(SocialConstant.streamLength)
        .get();
    final List<DocumentSnapshot> user = resultUsers.docs;
    if (user.length != 0) {
      for (DocumentSnapshot users in user) {
        setState(() {
          workingDocuments.add(users.data());
          //areaOfSpec.add(users.data()['users']);
          progress = true;
          _documents.add(users);
        });
      }
    } else {
      setState(() {
        progress = true;
      });
    }
  }

  Future<void> _viewCount(int index) async {
    setState(() {
      workingDocuments[index]['views'] = workingDocuments[index]['views'] + 1;
    });
    FirebaseFirestore.instance
        .collection(workingDocuments[index]['sup'])
        .doc(workingDocuments[index]['suid'])
        .collection(workingDocuments[index]['sub'])
        .get()
        .then((value) {
      value.docs.forEach((comm) {
        var count = comm.data()['views'] + 1;
        comm.reference.set({
          'views': count,
        }, SetOptions(merge: true));
      });
    });

    //check if user details is already in database
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('viewedVideos')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      //push to database
      FirebaseFirestore.instance.collection('viewedVideos').add({
        'id': workingDocuments[index]['id'],
        'uid': GlobalVariables.loggedInUserObject.id,
        'fn': GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln': GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts': DateTime.now().toString(),
      });
    }
  }
}
