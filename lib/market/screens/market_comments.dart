import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/market/components/market_appbar.dart';
import 'package:sparks/market/components/market_comment_tile.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/show_toast_market.dart';

class MarketComments extends StatefulWidget {
  static String id = 'market_comment';

  final String? docId;
  final String? category;
  final String? condition;
  final String? storeId;

  MarketComments({
    this.docId,
    this.category,
    this.condition,
    this.storeId,
  });

  @override
  _MarketCommentsState createState() => _MarketCommentsState();
}

class _MarketCommentsState extends State<MarketComments>
    with SingleTickerProviderStateMixin {
  late MarketDatabaseService _marketDatabaseService;

  final _commentTextController = TextEditingController();

  /// TextEditingController for the Alert Dialog pop-up for editing review
  TextEditingController _editingTextController = TextEditingController();

  final FocusNode _commentFocusNode = FocusNode();
  final FocusNode _editingFocusNode = FocusNode();

  late AnimationController _animationController;

  ScrollController? _scrollController;

  Timer? _timer;

  bool commentLength = false;

  late String prodCondition;
  String? _userName;
  String _newReview = "";

  final Random _random = Random();

  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>();

  /// Map that contains 2 keys ("Reviews" && "Images") each having a value of
  /// List<DocumentSnapshot>.
  ///
  /// The key "Reviews" contains the List<DocumentSnapshot> data for the reviews
  /// as pertain the given product
  ///
  /// The key "Images" contains the List<DocumentSnapshot> data for the image of
  /// the user that a review belongs to
  ///
  /// NOTE: The length of the "Reviews" List<DocumentSnapshot> value and "Images"
  /// List<DocumentSnapshot> are always equal
  Map<String, dynamic> info = {};

  /// Map containing unique colors for all review users
  Map<String?, Color>? userCustomColor;

  /// This boolean variable is used to check whether the scroll position is close
  /// to the bottom of the scrollable widget. If "true" then fetch next set of
  /// document data
  bool shouldCheck = false;

  /// This boolean variable is used to check whether the method to fetch new set
  /// of document data is already running (pagination), if it is then the method
  /// is not called again
  bool shouldRunCheck = true;

  /// This boolean variable is used to verify if there are still any documents
  /// left in the database
  bool noMoreDocuments = false;

  /// Boolean variable to verify if the next set of document snapshot has been
  /// fetched
  bool _hasGottenNextDocData = false;

  /// Boolean variable that determines if a circular progress spinner should be
  /// shown at the bottom of the scrollable widget to indicated data being fetched
  bool _showCircularProgress = false;

  bool _changeDisplay = false;

  /// Text Editing Controller Listener function
  void _commentControllerListener() {
    _newReview = _commentTextController.text.trim();
  }

  /// Method to get initial set of data. NOTE: This method is called in the initState
  void getFirstTenReviews() async {
    try {
      List<String?> ids = [];

      FirebaseFirestore.instance
          .collection("stores")
          .doc(widget.storeId)
          .collection("userStore")
          .doc(widget.category!.toLowerCase())
          .collection(prodCondition)
          .doc(widget.docId)
          .collection("reviews")
          .snapshots()
          .listen((event) => onEventChange(event.docChanges));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(widget.storeId)
          .collection("userStore")
          .doc(widget.category!.toLowerCase())
          .collection(prodCondition)
          .doc(widget.docId)
          .collection("reviews")
          .orderBy("ts", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> reviewChunk = querySnapshot.docs;

      List<DocumentSnapshot> reviews =
          LinkedHashSet<DocumentSnapshot>.from(reviewChunk).toList();

      /// TODO: Remove the [removeDuplicates] method, Might not be needed
      reviews = removeDuplicates(reviews);

      for (DocumentSnapshot docSnap in reviews) {
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
        String? id = data["id"];
        ids.add(id);

        assignCustomColorToUser(id);
      }

      List<DocumentSnapshot> imageDocSnap = await getFirstUserImages(ids);

      info = {
        "Reviews": reviews,
        "Images": imageDocSnap,
      };

      if (mounted) {
        setState(() {
          _streamController.add(info);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<DocumentSnapshot> removeDuplicates(List<DocumentSnapshot> originalList) {
    print("remove duplicates running...");
    List<DocumentSnapshot> finalList = [];

    originalList.sort((b, a) => a['ts'].compareTo(b['ts']));

    for (int i = 0; i < originalList.length; i++) {
      if (i == 0)
        finalList.add(originalList[i]);
      else if (i > 0) {
        if (originalList[i]['ts'] != originalList[i - 1]['ts']) {
          finalList.add(originalList[i]);
        }
      }
    }

    return finalList;
  }

  /// Method that get the image docs of the first set of review documents loaded
  /// on screen
  Future<List<DocumentSnapshot>> getFirstUserImages(
      List<String?> userIds) async {
    List<DocumentSnapshot> tempImages = [];
    List<DocumentSnapshot> imageDocSnap = [];
    for (String? id in userIds) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("Market")
          .doc("marketInfo")
          .get()
          .then((doc) {
        tempImages.add(doc);
      }).catchError((onError) {
        print(onError);
      });
    }

    imageDocSnap = LinkedHashSet<DocumentSnapshot>.from(tempImages).toList();

    return imageDocSnap;
  }

  void onEventChange(List<DocumentChange> documentChanges) async {
    var isChange = false;

    for (DocumentChange change in documentChanges) {
      if (change.type == DocumentChangeType.removed) {
        // int indexWhere1 = reviews.indexWhere((review) {
        //   return change.doc.id == review.id;
        // });

        List<DocumentSnapshot> reviews = info["Reviews"];

        int indexWhere = reviews.indexWhere((review) {
          return change.doc.id == review.id;
        });

        // reviews.removeWhere((review) {
        //   return change.doc.id == review.id;
        // });

        info["Reviews"].removeWhere((review) {
          return change.doc.id == review.id;
        });

        // imageDocSnap.removeAt(indexWhere1);

        info["Images"].removeAt(indexWhere);

        isChange = true;
      } else if (change.type == DocumentChangeType.modified) {
        List<DocumentSnapshot> reviews = info["Reviews"];

        int indexWhere = reviews.indexWhere((review) {
          return change.doc.id == review.id;
        });

        if (indexWhere >= 0) {
          info["Reviews"][indexWhere] = change.doc;
        }

        // int indexWhere1 = reviews.indexWhere((review) {
        //   return change.doc.id == review.id;
        // });

        // if (indexWhere1 >= 0) {
        //   reviews[indexWhere] = change.doc;
        // }

        isChange = true;
      } else if (change.type == DocumentChangeType.added) {
        // int indexWhere = defaultReviewDocSnap.indexWhere((comment) {
        //   return change.doc.id == comment.id;
        // });

        // if (indexWhere >= 0) {
        //   //_commentDocumentList.removeAt(indexWhere);
        // }

        Map<String, dynamic> data = change.doc.data as Map<String, dynamic>;

        String? userId = data["id"];

        assignCustomColorToUser(userId);

        await getNewlyAddedDocImage(userId);

        if (change.doc.exists) {
          info["Reviews"].insert(0, change.doc);
        }

        isChange = true;
      }
    }

    if (isChange) {
      if (mounted) setState(() => _streamController.add(info));
    }
  }

  /// Method that gets the image doc of the latest review posted by a user
  Future<void> getNewlyAddedDocImage(userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Market")
        .doc("marketInfo")
        .get()
        .then((value) {
      //imageDocSnap.add(value);
      //  imageDocSnap.insert(0, value);
      if (value.exists) {
        info["Images"].insert(0, value);
      }
    }).catchError((onError) {
      print("Adding new image $onError");
    });
  }

  void fetchNextTenComments() async {
    if (shouldCheck && !noMoreDocuments) {
      List<String?> ids = [];
      shouldRunCheck = false;
      shouldCheck = false;

      _hasGottenNextDocData = false;

      print("fetchNextTenComments running...");

      List<DocumentSnapshot> prevDocSnapshot = info["Reviews"];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(widget.storeId)
          .collection("userStore")
          .doc(widget.category!.toLowerCase())
          .collection(prodCondition)
          .doc(widget.docId)
          .collection("reviews")
          .orderBy("ts", descending: true)
          .startAfterDocument(prevDocSnapshot[prevDocSnapshot.length - 1])
          .limit(10)
          .get();

      List<DocumentSnapshot> reviewChunk = querySnapshot.docs;

      print("NEW REVIEW CHUNK LENGTH: ${reviewChunk.length}");

      if (reviewChunk.length == 0 || reviewChunk.isEmpty) {
        noMoreDocuments = true;
      } else {
        noMoreDocuments = false;

        print("REVIEW CHUNK: ${reviewChunk.length}");

        // reviews.addAll(reviewChunk);
        info["Reviews"].addAll(reviewChunk);

        for (DocumentSnapshot docSnap in reviewChunk) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          String? id = data["id"];
          ids.add(id);

          assignCustomColorToUser(id);
        }

        List<DocumentSnapshot> nextSetOfUserImagesDoc =
            await fetchNextSetOfUserImages(ids);

        // imageDocSnap.addAll(nextSetOfUserImagesDoc);
        info["Images"].addAll(nextSetOfUserImagesDoc);

        // info = {
        //   "Reviews": reviews,
        //   "Images": imageDocSnap,
        // };

        _hasGottenNextDocData = true;

        setState(() {
          _showCircularProgress = false;
          _streamController.add(info);
        });
      }
    }
  }

  Future<List<DocumentSnapshot>> fetchNextSetOfUserImages(
      List<String?> userIds) async {
    List<DocumentSnapshot> tempImages = [];
    for (String? id in userIds) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("Market")
          .doc("marketInfo")
          .get()
          .then((doc) {
        tempImages.add(doc);
      }).catchError((onError) {
        print(onError);
      });
    }

    return tempImages;
  }

  Color generateRandomColor() {
    Color resultColor;

    resultColor =
        Color(_random.nextInt(0xFFFFFF)).withAlpha(0xff).withOpacity(1.0);

    return resultColor;
  }

  /// This method assigns users random colors using their different IDs as the
  /// key in a Map.
  /// TODO: If assigned color occurs for multiple users, perform a check in the Map to make sure a color has not being assign already
  void assignCustomColorToUser(String? id) {
    if (id != null || id != "") {
      if (userCustomColor?.isEmpty ?? true) {
        Color randColor = generateRandomColor();
        userCustomColor = {
          id: randColor,
        };
      }

      /// TODO: Set a number limit for the amount of attempts to assign unique color to user
      if (!userCustomColor!.containsKey(id)) {
        Color randColor = generateRandomColor();
        userCustomColor![id] = randColor;
      }
    }
  }

  Widget timerNotActive() {
    Widget displayWidget;

    displayWidget = Text("No content");

    return displayWidget;
  }

  Widget loadingOrEmptyWidget() {
    Widget displayWidget;

    displayWidget = Text("Loading");

    _timer = new Timer(const Duration(seconds: 5), () {
      print("Timer started");
      if (!_changeDisplay) {
        setState(() {
          _changeDisplay = true;
        });
      }
    });

    return displayWidget;
  }

  void exploreBottomSheet(Map review) {
    final mediaQuery = MediaQuery.of(context).size;

    double height;
    MarketGlobalVariables.currentUserId == review["id"]
        ? height = mediaQuery.height * 0.20
        : height = mediaQuery.height * 0.10;
    showModalBottomSheet(
      context: this.context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 16.0, bottom: 16.0),
          child: MarketGlobalVariables.currentUserId == review["id"]
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        /// Removing the Edit - Delete bottom modal from the display
                        Navigator.pop(context);

                        String? prevUserReview = review["cmt"];
                        String? reviewDocId = review["docId"];

                        _showMyDialog(
                            prevUserReview: prevUserReview,
                            reviewDocId: reviewDocId);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 28.0,
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(16),
                          ),
                          Text(
                            "Edit",
                            style: kBottomSheetTextStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(32),
                    ),
                    InkWell(
                      onTap: () async {
                        String? reviewDocId = review["docId"];

                        Navigator.pop(context);

                        await _marketDatabaseService.deleteUserProductReview(
                          storeId: widget.storeId,
                          category: widget.category!.toLowerCase(),
                          prodCondition: prodCondition,
                          docId: widget.docId,
                          reviewDocId: reviewDocId,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 28.0,
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(16),
                          ),
                          Text(
                            "Delete",
                            style: kBottomSheetTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: review["cmt"]),
                    ).then((value) {
                      Navigator.pop(context);
                      ShowToastMarket.showToastMessage(
                        toastMessage: "Copied",
                        gravity: ToastGravity.CENTER,
                        bgColor: Colors.grey,
                        textColor: Colors.white,
                      );
                    }).catchError((onError) {
                      Navigator.pop(context);
                      print("Error copying: $onError");
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.copy_outlined,
                        size: 28.0,
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                      Text(
                        "Copy",
                        style: kBottomSheetTextStyle,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// Method to show dialog (both Cupertino and Material styles) Alert Dialog
  /// with a TextField for editing user's product review
  Future<void> _showMyDialog(
      {String? prevUserReview, String? reviewDocId}) async {
    _editingTextController = TextEditingController(text: prevUserReview);
    return showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Edit'),
        content: TextField(
          autofocus: true,
          controller: _editingTextController,
          focusNode: _editingFocusNode,
          textCapitalization: TextCapitalization.sentences,
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color(0xffE7E9ED),
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            hintText: 'Edit comment',
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffE7E9ED),
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          PlatformDialogAction(
            onPressed: () async {
              /// Tucking the keyboard from view
              if (_editingFocusNode.hasFocus) {
                _editingFocusNode.unfocus();
              }

              /// Verifying that the old review and new review are not the same
              if (_editingTextController.text.trim() != prevUserReview) {
                String newReview = _editingTextController.text.trim();

                /// Update user's previous review
                await _marketDatabaseService.updateUserProductReview(
                  storeId: widget.storeId,
                  category: widget.category!.toLowerCase(),
                  prodCondition: prodCondition,
                  docId: widget.docId,
                  reviewDocId: reviewDocId,
                  newReview: newReview,
                );

                // TODO: If a delay is observed when updating review, move the Navigator pop before the call to update
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  /// Method that get the username of the currently logged in user
  void _getUserName() async {
    _userName = await _marketDatabaseService.getUsername();
  }

  // List<DocumentSnapshot> removeImageDuplicates(
  //     List<DocumentSnapshot> originalList) {
  //   List<DocumentSnapshot> finalList = [];
  //
  //   //originalList.sort( (b, a) => a['pimg'].compareTo(b['pimg']));
  //
  //   for (int i = 0; i < originalList.length; i++) {
  //     if (i == 0)
  //       finalList.add(originalList[i]);
  //     else if (i > 0) {
  //       if (originalList[i]['ts'] != originalList[i - 1]['ts']) {
  //         finalList.add(originalList[i]);
  //       }
  //     }
  //   }
  //
  //   return finalList;
  // }

  String extractFirstLetterOfUsername(String userName) {
    return userName[0].toUpperCase();
  }

  @override
  void initState() {
    super.initState();

    prodCondition = MarketBrain.prodCondCollectionConverter(widget.condition);

    _animationController =
        AnimationController(duration: new Duration(seconds: 1), vsync: this);
    _animationController.repeat();

    _scrollController = ScrollController();

    _commentTextController.addListener(_commentControllerListener);

    _scrollController!.addListener(() {
      double maxScroll = _scrollController!.position.maxScrollExtent;
      double currentScroll = _scrollController!.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;

      /// Bottom of the screen
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        if (!_hasGottenNextDocData && !noMoreDocuments) {
          setState(() => _showCircularProgress = true);
        } else {
          setState(() => _showCircularProgress = false);
        }
      }

      if (maxScroll - currentScroll <= delta) {
        shouldCheck = true;

        if (shouldRunCheck) {
          // shouldRunCheck = false;
          print('Attention Attention');
          print('Attention Attention: Fetching next 10.');
          print('Attention Attention');

          fetchNextTenComments();
        }
      } else {
        if (!shouldRunCheck) shouldRunCheck = true;
      }
    });

    _marketDatabaseService =
        MarketDatabaseService(userId: MarketGlobalVariables.currentUserId);

    _getUserName();

    getFirstTenReviews();
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    _editingTextController.dispose();
    _commentFocusNode.dispose();
    _editingFocusNode.dispose();
    _streamController.close();
    _scrollController!.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // List<Map<String, dynamic>> uche = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /// TODO: Switch to CustomScrollView if scroll listener issue arise
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: MarketAppBar(),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(
              top: 64.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _showCircularProgress
                    ? Center(
                        child: SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: _animationController.drive(
                              ColorTween(
                                  begin: kMarketPrimaryColor,
                                  end: kMarketSecondaryColor),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Expanded(
                  child: StreamBuilder<Map<String, dynamic>>(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Waiting...");
                      } else if (snapshot.hasError) {
                        return Text("An error has occurred");
                      } else {
                        // uche.clear();
                        List<Map<String, dynamic>> reviews = [];
                        // List<ReviewModel> reviewModels = [];
                        List<DocumentSnapshot>? revDocSnap =
                            snapshot.data!["Reviews"];
                        List<DocumentSnapshot>? imageDocSnap =
                            snapshot.data!["Images"];

                        if (revDocSnap == null ||
                            revDocSnap.length == 0 ||
                            imageDocSnap!.length == 0) {
                          return _changeDisplay
                              ? timerNotActive()
                              : loadingOrEmptyWidget();
                        } else {
                          if (_timer?.isActive ?? true) {
                            _timer?.cancel();

                            /// TODO: Use setState for the _changeDisplay
                            _changeDisplay = false;
                          }

                          /// TODO: Use an if-statement to verify the length of both DocumentSnapshots
                          for (int i = 0; i < revDocSnap.length; i++) {
                            Map<String, dynamic> revData =
                                revDocSnap[i].data() as Map<String, dynamic>;
                            Map<String, dynamic>? imageData =
                                imageDocSnap[i].data() as Map<String, dynamic>?;
                            Map<String, dynamic> data = {
                              "un": revData["un"],
                              "cmt": revData["cmt"],
                              "ts": revData["ts"],
                              "id": revData["id"],
                              "docId": revData["docId"],
                              "pimg": (imageDocSnap.length != revDocSnap.length)
                                  ? null
                                  : imageData!["pimg"],
                            };
                            reviews.add(data);
                            // ReviewModel reviewModel = ReviewModel(
                            //     un: revDocSnap[i].data()["un"],
                            //     cmt: revDocSnap[i].data()["cmt"],
                            //     ts: revDocSnap[i].data()["ts"],
                            //     id: revDocSnap[i].data()["id"],
                            //     docId: revDocSnap[i].data()["docId"],
                            //     pimg: imageDocSnap[i].data()["pimg"]);
                            // reviewModels.add(reviewModel);
                          }

                          return ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              itemCount: reviews.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MarketCommentTile(
                                  key:
                                      UniqueKey(), //Key('smclvbw-${index}-${ts}'),
                                  review: reviews[index],
                                  color: userCustomColor![reviews[index]["id"]],
                                  onLongPress: () {
                                    /// Check to see if the product review belongs to the currently
                                    /// logged in user

                                    exploreBottomSheet(reviews[index]);
                                  },
                                );
                              });
                        }
                      }
                    },
                  ),
                ),

                /// Comment TextField
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _commentTextController,
                            focusNode: _commentFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: 5,
                            onChanged: (value) {
                              if (value.trim().length >= 1) {
                                setState(() {
                                  commentLength = true;
                                });
                              } else {
                                setState(() {
                                  commentLength = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.camera_alt,
                                      color: Color(0xff434343),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(16),
                                    ),
                                    SvgPicture.asset(
                                      'images/market_images/market_add_picture.svg',
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                              fillColor: Color(0xffE7E9ED),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: 'Add a comment',
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffE7E9ED),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(24),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_newReview.length >= 1) {
                              String review = _newReview;
                              String? id = MarketGlobalVariables.currentUserId;

                              /// Clearing the TextEditingController
                              _commentTextController.clear();

                              _marketDatabaseService.postProductReview(
                                  review: review,
                                  userId: id,
                                  userName: _userName,
                                  docId: widget.docId,
                                  storeId: widget.storeId,
                                  condition: prodCondition,
                                  category: widget.category!.toLowerCase());

                              /// Tucking the keyboard from view
                              if (_commentFocusNode.hasFocus) {
                                _commentFocusNode.unfocus();
                              }
                            }
                          },
                          child: _newReview == null || _newReview.length > 1
                              ? Material(
                                  elevation: 5.0,
                                  shadowColor: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  color: kMarketPrimaryColor,
                                  child: SvgPicture.asset(
                                    'images/market_images/m_comment_button.svg',
                                  ),
                                )
                              : Material(
                                  elevation: 0.0,
                                  shadowColor: Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  color: Color(0xff000000).withAlpha(51),
                                  child: SvgPicture.asset(
                                    'images/market_images/m_comment_button.svg',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class SparksMarketCommentListViewBuilderWidget extends StatefulWidget {
//   final Map<String, dynamic> ucheItem;
//
//   const SparksMarketCommentListViewBuilderWidget({
//     Key key,
//     this.ucheItem,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() =>
//       _SparksMarketCommentListViewBuilderWidgetState(
//         ucheItem: ucheItem,
//       );
// }
//
// class _SparksMarketCommentListViewBuilderWidgetState
//     extends State<SparksMarketCommentListViewBuilderWidget> {
//   final Map<String, dynamic> ucheItem;
//
//   _SparksMarketCommentListViewBuilderWidgetState({
//     Key key,
//     required this.ucheItem,
//   });
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   String extractFirstLetterOfUsername(String userName) {
//     return userName[0].toUpperCase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//           top: 8.0, left: 16.0, right: 16.0, bottom: 24.0),
//       child: Row(
//         children: <Widget>[
//           ucheItem["pimg"] != null
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(100.0),
//                   child: CachedNetworkImage(
//                     progressIndicatorBuilder: (context, url, progress) =>
//                         Center(
//                       child: CircularProgressIndicator(
//                         backgroundColor: kMarketPrimaryColor,
//                         value: progress.progress,
//                       ),
//                     ),
//                     imageUrl: ucheItem["pimg"],
//                     width: ScreenUtil().setWidth(64),
//                     height: ScreenUtil().setHeight(64),
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               : CircleAvatar(
//                   backgroundColor: kMarketPrimaryColor,
//                   radius: 32.0,
//                   child: Text(
//                     extractFirstLetterOfUsername(ucheItem["un"]),
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.rajdhani(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 32.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//           SizedBox(
//             width: ScreenUtil().setWidth(8),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   ucheItem["un"] ?? "Username",
//                   style: kMarketNameTextStyle,
//                 ),
//                 SizedBox(
//                   height: ScreenUtil().setHeight(8),
//                 ),
//                 Text(
//                   ucheItem["cmt"] ?? "Hello world",
//                   style: kMarketComment,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
