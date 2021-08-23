import 'dart:async';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/models/comment.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SparksComments extends StatefulWidget {
  static const String commentId = kSparks_comments;

  final String? postToComment;
  final String? ownerOfThePost;

  SparksComments({
    this.postToComment,
    this.ownerOfThePost,
  });

  @override
  _SparksCommentsState createState() => _SparksCommentsState();
}

class _SparksCommentsState extends State<SparksComments> {
  final commentTextFormController = TextEditingController();
  AutoScrollController commentScrollController = AutoScrollController();
  StreamController<List<DocumentSnapshot>> _commentStreamController =
      StreamController<List<DocumentSnapshot>>();
  Widget? commentStreamBuilder;

  List<DocumentSnapshot> _commentDocumentList = [];

  int check = 0;
  bool shouldCheck = false;
  bool shouldRunCheck = true;

  bool shouldRunFirstTen = true;

  //TODO: Fetch the first ten comments from a particular post
  Future fetchFirstTenComments(String? authorID, String? postID) async {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(authorID)
        .collection("myPost")
        .doc(postID)
        .collection("homeComments")
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    _commentDocumentList = (await FirebaseFirestore.instance
            .collection("posts")
            .doc(authorID)
            .collection("myPost")
            .doc(postID)
            .collection("homeComments")
            .where("postID", isEqualTo: postID)
            .orderBy("tOfPst", descending: true)
            .limit(10)
            .get())
        .docs;

    _commentDocumentList.sort((b, a) => a['commID'].compareTo(b['commID']));

    _commentDocumentList =
        LinkedHashSet<DocumentSnapshot>.from(_commentDocumentList).toList();

    if (mounted) {
      setState(() {
        _commentStreamController.add(_commentDocumentList);
      });
    }
  }

  //TODO: Fetch the next ten comments of a particular post
  fetchNextTenComments(String? authorID, String? postID) async {
    if (shouldCheck) {
      shouldRunCheck = false;
      shouldCheck = false;

      check++;

      List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
              .collection("posts")
              .doc(authorID)
              .collection("myPost")
              .doc(postID)
              .collection("homeComments")
              .where("postID", isEqualTo: postID)
              .orderBy("tOfPst", descending: true)
              .startAfterDocument(
                  _commentDocumentList[_commentDocumentList.length - 1])
              .limit(10)
              .get())
          .docs;

      _commentDocumentList.addAll(newDocumentList);

      sortAndRemoveDuplicates();

      setState(() {
        _commentStreamController.add(_commentDocumentList);
      });
    }
  }

  //TODO: Takes a list of comments, sorts through it and remove duplicates
  void sortAndRemoveDuplicates() {
    _commentDocumentList.sort((b, a) => a['commID'].compareTo(b['commID']));

    _commentDocumentList =
        LinkedHashSet<DocumentSnapshot>.from(_commentDocumentList).toList();

    for (int i = 0; i < _commentDocumentList.length; i++) {
      if (i == 0 && _commentDocumentList.length > 1) {
        if (_commentDocumentList[i]['commID'] ==
            _commentDocumentList[i + 1]['commID']) {
          _commentDocumentList.removeAt(i);
        }
      }
      if (i == _commentDocumentList.length - 1 &&
          _commentDocumentList.length > 1) {
        if (_commentDocumentList[i]['commID'] ==
            _commentDocumentList[i - 1]['commID']) {
          _commentDocumentList.removeAt(i);
        }
      }
      if (i != 0 && i != _commentDocumentList.length - 1) {
        if (_commentDocumentList[i]['commID'] ==
            _commentDocumentList[i + 1]['commID']) {
          _commentDocumentList.removeAt(i);
        }
      }
    }
  }

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;

    documentChanges.forEach((change) {
      if (change.type == DocumentChangeType.removed) {
        _commentDocumentList.removeWhere((comment) {
          return change.doc.id == comment.id;
        });

        isChange = true;
      } else if (change.type == DocumentChangeType.modified) {
        int indexWhere = _commentDocumentList.indexWhere((comment) {
          return change.doc.id == comment.id;
        });

        if (indexWhere >= 0) {
          _commentDocumentList[indexWhere] = change.doc;
        }

        isChange = true;
      } else if (change.type == DocumentChangeType.added) {
        int indexWhere = _commentDocumentList.indexWhere((comment) {
          return change.doc.id == comment.id;
        });

        if (indexWhere >= 0) {
          //_commentDocumentList.removeAt(indexWhere);
        }

        _commentDocumentList.add(change.doc);

        isChange = true;
      }
    });

    if (isChange) {
      sortAndRemoveDuplicates();

      if (mounted) {
        setState(() {
          _commentStreamController.add(_commentDocumentList);
        });
      }
    }
  }

  //TODO: Initializes the comment streambuilder inside the initstate
  init() {
    commentStreamBuilder = StreamBuilder(
      stream: _commentStreamController.stream,
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.waiting) &&
            (!snapshot.hasData)) {
          return Container();
        }

        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: commentScrollController,
            itemCount: _commentDocumentList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot currentDocument = _commentDocumentList[index];
              CommentModel commentModel = CommentModel.fromJson(
                  currentDocument.data() as Map<String, dynamic>);
              return Container(
                key: Key('${currentDocument['commID']}'),
                child: CustomFunctions.createCommentCard(commentModel),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    commentScrollController.addListener(() {
      double maxScroll = commentScrollController.position.maxScrollExtent;
      double currentScroll = commentScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;

      if (maxScroll - currentScroll <= delta) {
        shouldCheck = true;

        if (shouldRunCheck) {
          fetchNextTenComments(widget.ownerOfThePost, widget.postToComment);
        }
      } else {
        shouldRunCheck = true;
      }
    });

    init();

    Timer(Duration(seconds: 2), () {
      fetchFirstTenComments(widget.ownerOfThePost, widget.postToComment);
    });

    super.initState();
  }

  @override
  void dispose() {
    _commentStreamController.close();
    commentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            kComm,
          ),
          backgroundColor: kLight_orange,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //TODO: Display comments from other users
            commentStreamBuilder!,
            //TODO: Display the add comment textfield and the post comment button
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.014,
                right: MediaQuery.of(context).size.width * 0.014,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                color: kComment_bg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //TODO: Displays logged in user profile image
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: CachedNetworkImage(
                        imageUrl: "${GlobalVariables.loggedInUserObject.pimg}",
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  //TODO: Display comment textfield
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.022,
                        right: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: TextFormField(
                        controller: commentTextFormController,
                        keyboardType: TextInputType.multiline,
                        cursorColor: kHintColor,
                        minLines: 1,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.headline6!.apply(
                              color: kHintColor,
                              fontSizeFactor: 0.65,
                              fontSizeDelta: 4,
                            ),
                        decoration: InputDecoration(
                          hintText: kAddComment,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kTransparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kTransparent,
                            ),
                          ),
                          hintStyle:
                              Theme.of(context).textTheme.headline6!.apply(
                                    color: kHintColor,
                                    fontSizeFactor: 0.65,
                                    fontSizeDelta: 4,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  //TODO: Display comment post button
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        String userComment = commentTextFormController.text;
                        commentTextFormController.clear();

                        if ((userComment != null) && (userComment != "")) {
                          String commentID =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          //TODO: Create a comment object
                          CommentModel commentModel = CommentModel(
                            auID: GlobalVariables.loggedInUserObject.id,
                            commID: commentID,
                            postID: widget.postToComment,
                            nm: {
                              "fn":
                                  GlobalVariables.loggedInUserObject.nm!["fn"],
                              "ln":
                                  GlobalVariables.loggedInUserObject.nm!["ln"],
                            },
                            pimg: GlobalVariables.loggedInUserObject.pimg,
                            auSpec: GlobalVariables.loggedInUserObject.spec![0],
                            comment: userComment,
                            nOfLikes: 0,
                            nOfRpy: 0,
                            tOfPst: DateTime.now(),
                          );

                          //TODO: Call the database function to store the comment
                          await DatabaseService(
                            loggedInUserID:
                                GlobalVariables.loggedInUserObject.id,
                          ).createComment(widget.ownerOfThePost,
                              widget.postToComment, commentModel, commentID);
                        }
                      },
                      child: Image.asset(
                        "images/app_entry_and_home/post_btn.png",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
