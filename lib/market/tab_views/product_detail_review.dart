import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/market/components/market_comment_tile.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/show_toast_market.dart';

class ProductDetailReview extends StatefulWidget {
  @override
  _ProductDetailReviewState createState() => _ProductDetailReviewState();
}

class _ProductDetailReviewState extends State<ProductDetailReview>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  MarketDatabaseService _marketDatabaseService = MarketDatabaseService();

  String? storeId;
  String? category;
  late String prodCondition;
  String? docId;

  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>();

  /// TextEditingController for the Alert Dialog pop-up for editing review
  TextEditingController _editingTextController = TextEditingController();

  late AnimationController _animationController;

  final FocusNode _editingFocusNode = FocusNode();

  /// Map that contains 2 keys ("Reviews" && "Images") each having a value of
  /// List<DocumentSnapshot>.
  ///
  /// The key "Reviews" contains the List<DocumentSnapshot> data for the reviews
  /// as pertain the given product
  ///
  /// The key "Images" contains the List<DocumentSnapshot> data for the image of
  /// the user that a review belong to
  ///
  /// NOTE: The length of the "Reviews" List<DocumentSnapshot> value and "Images"
  /// List<DocumentSnapshot> is always be equal
  Map<String, dynamic> info = {};

  /// Map containing unique colors for all review users
  Map<String?, Color>? userCustomColor;

  /// This boolean variable is used to check whether the scroll position is close
  /// to the bottom of the scrollable widget. If "true" then fetch next set of
  /// document data
  bool shouldCheck = false;

  /// This boolean variable is used to check whether the method to fetch new set
  /// of document data is already running (pagination)
  bool shouldRunCheck = true;

  /// This boolean variable is used to verify if there are still any document
  /// left in the database
  bool noMoreDocuments = false;

  /// Boolean variable to verify if the next set of document snapshot has been
  /// fetched
  bool hasGottenNewDocData = false;

  bool _changeDisplay = false;

  /// Boolean variable that determines if a circular progress spinner should be
  /// shown at the bottom of the scrollable widget to indicated data being fetched
  bool _showCircularProgress = false;

  Timer? _timer;

  final Random _random = Random();

  /// Method to get initial set of data. NOTE: This method is called in the initState
  void getFirstTenReviews() async {
    try {
      List<String?> ids = [];

      FirebaseFirestore.instance
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(category)
          .collection(prodCondition)
          .doc(docId)
          .collection("reviews")
          .snapshots()
          .listen((event) => onEventChange(event.docChanges));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(category)
          .collection(prodCondition)
          .doc(docId)
          .collection("reviews")
          .orderBy("ts", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> reviewChunk = querySnapshot.docs;

      List<DocumentSnapshot> reviews =
          LinkedHashSet<DocumentSnapshot>.from(reviewChunk).toList();

      /// TODO: Un-comment this and add the method if duplicate occurs
      // reviews = removeDuplicates(reviews);

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

      hasGottenNewDocData = false;

      List<DocumentSnapshot> prevDocSnapshot = info["Reviews"];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(category)
          .collection(prodCondition)
          .doc(docId)
          .collection("reviews")
          .orderBy("ts", descending: true)
          .startAfterDocument(prevDocSnapshot[prevDocSnapshot.length - 1])
          .limit(10)
          .get();

      List<DocumentSnapshot> reviewChunk = querySnapshot.docs;

      if (reviewChunk.length == 0 || reviewChunk.isEmpty) {
        /// i.e. No more Document Snapshot available in the database
        noMoreDocuments = true;
      } else {
        /// There are still Document Snapshots available in the database
        noMoreDocuments = false;

        info["Reviews"].addAll(reviewChunk);

        for (DocumentSnapshot docSnap in reviewChunk) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          String? id = data["id"];
          ids.add(id);

          assignCustomColorToUser(id);
        }

        List<DocumentSnapshot> nextSetOfUserImagesDoc =
            await fetchNextSetOfUserImages(ids);

        info["Images"].addAll(nextSetOfUserImagesDoc);

        hasGottenNewDocData = true;

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

  Color getRandomColor() {
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
        Color randColor = getRandomColor();
        userCustomColor = {
          id: randColor,
        };
      }

      if (!userCustomColor!.containsKey(id)) {
        Color randColor = getRandomColor();
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
                          storeId: storeId,
                          category: category,
                          prodCondition: prodCondition,
                          docId: docId,
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
              if (_editingTextController.text.trim() != prevUserReview &&
                  _editingTextController.text.trim() != "") {
                print("Difference in reviews");
                String newReview = _editingTextController.text.trim();

                /// Update user's previous review

                await _marketDatabaseService.updateUserProductReview(
                  storeId: storeId,
                  category: category,
                  prodCondition: prodCondition,
                  docId: docId,
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

  @override
  void initState() {
    super.initState();

    storeId = MarketGlobalVariables.viewedStoreId;
    category = MarketGlobalVariables.viewedCategory.toLowerCase();
    prodCondition = MarketGlobalVariables.viewedCondition;
    docId = MarketGlobalVariables.viewedDocId;

    _animationController =
        AnimationController(duration: new Duration(seconds: 1), vsync: this);
    _animationController.repeat();

    getFirstTenReviews();
  }

  @override
  void dispose() {
    _streamController.close();
    _editingTextController.dispose();
    _editingFocusNode.dispose();
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding:
          const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 4.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Waiting...");
                } else if (snapshot.hasError) {
                  return Text("Error loading data");
                } else {
                  List<Map<String, dynamic>> reviews = [];
                  // List<ReviewModel> reviewModels = [];
                  List<DocumentSnapshot>? revDocSnap = snapshot.data!["Reviews"];
                  List<DocumentSnapshot>? imageDocSnap = snapshot.data!["Images"];

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
                      Map<String, dynamic> revData = revDocSnap[i].data() as Map<String, dynamic>;
                      Map<String, dynamic>? imageData = imageDocSnap[i].data() as Map<String, dynamic>?;
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
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        double maxScroll =
                            scrollNotification.metrics.maxScrollExtent;
                        double currentScroll =
                            scrollNotification.metrics.pixels;
                        double delta =
                            MediaQuery.of(context).size.height * 0.20;

                        if (maxScroll - currentScroll <= delta) {
                          shouldCheck = true;

                          if (shouldRunCheck) {
                            // shouldRunCheck = false;
                            fetchNextTenComments();
                          }
                        }
                        // else {
                        //   if (!shouldRunCheck) shouldRunCheck = true;
                        // }

                        /// Bottom of the screen
                        if (scrollNotification.metrics.extentAfter == 0) {
                          if (!hasGottenNewDocData && !noMoreDocuments) {
                            setState(() => _showCircularProgress = true);
                          } else {
                            setState(() => _showCircularProgress = false);
                          }
                        }

                        return false;
                      },
                      child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MarketCommentTile(
                              key: UniqueKey(), //Key('smclvbw-${index}-${ts}'),
                              review: reviews[index],
                              color: userCustomColor![reviews[index]["id"]],
                              onLongPress: () {
                                exploreBottomSheet(reviews[index]);
                              },
                            );
                          }),
                    );
                  }
                }
              },
            ),
          ),
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
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
