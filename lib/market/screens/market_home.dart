import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/reusables/smaller_fab.dart';
import 'package:sparks/app_entry_and_home/reusables/sparks_bottom_menu.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/market/components/category_nav.dart';
import 'package:sparks/market/components/custom_small_fab.dart';
import 'package:sparks/market/components/market_appbar.dart';
import 'package:sparks/market/components/market_bottom_appbar_with_end_dock.dart';
import 'package:sparks/market/components/market_card.dart';
import 'package:sparks/market/components/market_home_drawer.dart';
import 'package:sparks/market/components/market_home_end_drawer.dart';
import 'package:sparks/market/market_models/displayed_product_model.dart';
import 'package:sparks/market/market_models/product_home_detail_model.dart';
import 'package:sparks/market/market_models/store_details_model.dart';
import 'package:sparks/market/screens/market_comments.dart';
import 'package:sparks/market/screens/market_explore.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/strings.dart';
import 'package:sparks/utilities/styles.dart';
import '../utilities/market_const.dart';
import 'package:sparks/market/providers/shopping_cart.dart';
import 'package:sparks/market/market_models/similar_products_model.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/components/similar_products_card.dart';
import 'package:sparks/market/providers/new_used_provider.dart';
import 'package:sparks/market/utilities/market_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

enum FabState {
  OPEN,
  CLOSE,
}

class MarketHome extends StatefulWidget {
  static String id = 'market_home';

  @override
  _MarketHomeState createState() => _MarketHomeState();
}

class _MarketHomeState extends State<MarketHome>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        MarketMixin {
  FabState fabState = FabState.CLOSE;

  final _auth = FirebaseAuth.instance;

  late MarketDatabaseService _marketDatabaseService;

  // AnimationController _animationController;

  /// Variables holding badge counters for shopping cart and notifications
  int notificationCounter = 0;

  bool _fabVisibilityState = false;

  double? exploreModalHeight;

  /// Variable to hold either 'new product' or 'used product'
  String? prodCondition;

  List<String> productDefaultCategories = [
    kAll,
    kClothes,
    kShoes,
    kSeeAll,
  ];

  List<Map<String, String>> homeNavCategory = [
    {"label": kAll, "icon": "all_icon"},
    {"label": kClothes, "icon": "clothes_icon"},
    {"label": kShoes, "icon": "shoes_icon"},
    {"label": kSeeAll, "icon": "see_all_icon"}
  ];

  /// Variable containing the list of products to display on the Market Home
  List<DisplayedProductModel> productChunks = [];

  List<SimilarProductModel> similarProductsNew = [];

  /// Variable holding the last/previous DocumentSnapshot before a new set of
  /// DocumentSnapshot is requested/fetched during pagination
  List<DocumentSnapshot>? lastDocument = [];

  StreamController<List<DocumentSnapshot>> _exploreStreamController =
      StreamController<List<DocumentSnapshot>>();

  /// Variable to check if a fresh set of DocumentSnapshot is being fetched
  /// NOTE: This variable is mainly utilized when the Market Home is loaded/visited
  /// for the first time and when a new category of data is being selected
  bool _loadingProducts = false;

  bool exploreLoadingProducts = false;

  /// Boolean variable that determines if a circular progress spinner should be
  /// shown at the bottom of the scrollable widget to indicated data being fetched
  bool _showCircularProgress = false;

  bool exploreShowCircularProgress = false;

  /// This boolean variable is used to check whether the scroll position is close
  /// to the bottom of the scrollable widget. If "true" then fetch next set of
  /// document data
  bool _shouldCheck = false;

  bool exploreShouldCheck = false;

  /// This boolean variable is used to check whether the method to fetch new set
  /// of document data is already running (pagination)
  bool _shouldRunCheck = true;

  bool exploreShouldRunCheck = true;

  /// Variable to check if the new set of paginated data has been fetched
  bool _hasGottenNextDocData = false;

  bool exploreHasGottenNextDocData = false;

  /// This boolean variable is used to verify if there are still any documents
  /// left in the database
  bool _moreDocumentsAvailable = true;

  bool exploreMoreDocumentsAvailable = true;

  /// ScaffoldKey for the Market
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Datetime variable needed for double-tap to exit the Market activity
  DateTime? _currentBackPressTime;

  bool _showBottomNavBar = true;

  /// Function to open the endDrawer
  /// Clicking on 'SEE ALL' calls this function
  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  /// The method that handles the selection and logic of the market category
  List<String?> category = [kAll];
  void _handleCategoryOnTap(String? selectedCategory) {
    if (!category.contains(selectedCategory)) {
      print(category);
      setState(() {
        _loadingProducts = true;
        category.clear();
        category.add(selectedCategory);
        _moreDocumentsAvailable = true;
        getFirstDisplayedProducts();
        // marketProducts = getMarketProducts();
      });
    }
  }

  /// The method that handles the selection and triggering of the market view
  /// based on the available option Popular, Recently Viewed, Recommended
  List<String> _marketTrigger = [kPopular];
  void _handleMarketTrigger(String marketTrigger) {
    if (_marketTrigger.contains(marketTrigger)) {
      /// TODO: Implement scroll-to-top here
      _marketTrigger.retainWhere((e) => e.contains(marketTrigger));
      print(_marketTrigger);
    } else {
      setState(() {
        _loadingProducts = true;
        _marketTrigger.clear();
        _marketTrigger.add(marketTrigger);
        _moreDocumentsAvailable = true;
        getFirstDisplayedProducts();
      });
    }
  }

  /// Method that assigns the right icon path to a Map<String, String>. Used to
  /// handle the Market Home End Drawer selection [handleEndDrawerSelection]
  Map<String, String> assignLabelAndIcon(String label) {
    Map<String, String> labelIconPair = {};
    switch (label) {
      case kClothes:
        labelIconPair = {"label": label, "icon": "clothes_icon"};
        break;

      case kShoes:
        labelIconPair = {"label": label, "icon": "shoes_icon"};
        break;

      case kBeauty:
        labelIconPair = {"label": label, "icon": "beauty_icon"};
        break;

      case kElectronics:
        labelIconPair = {"label": label, "icon": "electronics_icon"};
        break;

      case kBooks:
        labelIconPair = {"label": label, "icon": "books_icon"};
        break;

      case kStationary:
        labelIconPair = {"label": label, "icon": "stationary_icon"};
        break;
    }

    return labelIconPair;
  }

  /// Handle End Drawer selection
  void handleEndDrawerSelection(String endDrawerSelection) {
    Map<String, String> labelIcon = assignLabelAndIcon(endDrawerSelection);

    bool navContainsCategory = false;

    for (int i = 1; i < homeNavCategory.length - 1; i++) {
      if (homeNavCategory[i]["label"] == endDrawerSelection) {
        navContainsCategory = true;
        if (i == 2) {
          homeNavCategory.remove(homeNavCategory[i]);
          homeNavCategory.insert(1, labelIcon);
        }
        break;
      }
    }

    if (!navContainsCategory) {
      homeNavCategory.removeAt(2);
      homeNavCategory.insert(2, labelIcon);
    }

    _handleCategoryOnTap(endDrawerSelection);
  }

  /// Method for showing toast messages to the user
  void showToastMessage(String toastMessage) {
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      textColor: Colors.black,
      backgroundColor: Colors.white70,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      showToastMessage("Press back again to exit");

      return Future.value(false);
    }

    /// TODO: Check if this code to exit app works on iOS
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', true);

    // SystemNavigator.pop();
    return Future.value(true);
  }

  /// Function to get the currently logged in user
  void getCurrentUser() {
    try {
      User? loggedInUser = _auth.currentUser;
      if (loggedInUser != null) {
        MarketGlobalVariables.currentUserId = loggedInUser.uid;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Function that controls the visibility of the Sparks floating button
  void fabController() {
    if (fabState == FabState.CLOSE) {
      setState(() {
        fabState = FabState.OPEN;
        _fabVisibilityState = true;
      });
    } else {
      setState(() {
        fabState = FabState.CLOSE;
        _fabVisibilityState = false;
      });
    }
  }

  void resetFab() {
    print("Disposing of Market Home");
    setState(() {
      fabState = FabState.CLOSE;
      _fabVisibilityState = false;
    });
  }

  Widget marketWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Builder(
          builder: (BuildContext context) {
            final primaryController = PrimaryScrollController.of(context);

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                double maxScroll = scrollNotification.metrics.maxScrollExtent;
                double currentScroll = scrollNotification.metrics.pixels;
                double delta = MediaQuery.of(context).size.height * 0.20;

                if (maxScroll - currentScroll <= delta) {
                  _shouldCheck = true;

                  if (_shouldRunCheck && _moreDocumentsAvailable) {
                    fetchNextDocuments();
                  }
                }

                if (scrollNotification is ScrollUpdateNotification) {
                  if (primaryController!.position.userScrollDirection ==
                          ScrollDirection.reverse &&
                      !primaryController.position.outOfRange) {
                    if (_showBottomNavBar) {
                      setState(() {
                        _showBottomNavBar = false;
                      });
                    }
                  }
                } else if (scrollNotification is ScrollEndNotification) {
                  if (primaryController!.offset >=
                          primaryController.position.maxScrollExtent &&
                      !primaryController.position.outOfRange) {
                    /// If-Else block to determine whether to show a circular
                    /// progress indicator while fetching new data at the bottom
                    /// of the screen
                    if (!_hasGottenNextDocData && _moreDocumentsAvailable) {
                      setState(() => _showCircularProgress = true);
                    } else {
                      setState(() => _showCircularProgress = false);
                    }

                    Future.delayed(const Duration(milliseconds: 250), () {
                      if (_showBottomNavBar)
                        setState(() => _showBottomNavBar = false);
                    });
                  } else {
                    print("Scroll stopped");
                    Future.delayed(const Duration(milliseconds: 250), () {
                      if (!_showBottomNavBar)
                        setState(() => _showBottomNavBar = true);
                    });
                  }
                }
                return false;
              },
              child: Expanded(
                child: ListView.builder(
                    itemCount: productChunks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MarketCard(
                        openExplore: () {
                          exploreBottomSheet(
                            // context: context,
                            productCondition: productChunks[index]
                                .productHomeDetailModel!
                                .cond,
                            productCategory: productChunks[index]
                                .productHomeDetailModel!
                                .prC,
                            commonId: productChunks[index]
                                .productHomeDetailModel!
                                .cmId,
                          );
                        },
                        commonId:
                            productChunks[index].productHomeDetailModel!.cmId,
                        productName:
                            productChunks[index].productHomeDetailModel!.prN,
                        storeName: productChunks[index].storeDetailsModel!.stNm,
                        storeImage:
                            productChunks[index].storeDetailsModel!.stImg,
                        storeRating:
                            productChunks[index].storeDetailsModel!.rate,
                        following: productChunks[index].storeDetailsModel!.fols,
                        productImages:
                            productChunks[index].productHomeDetailModel!.prImg,
                        productRatingCount:
                            productChunks[index].productHomeDetailModel!.rtC,
                        productRating:
                            productChunks[index].productHomeDetailModel!.rate,
                        productReviewCount:
                            productChunks[index].productHomeDetailModel!.rvC,
                        productPrice:
                            productChunks[index].productHomeDetailModel!.price,
                        soldCount:
                            productChunks[index].productHomeDetailModel!.sdCnt,
                        productCondition:
                            productChunks[index].productHomeDetailModel!.cond,
                        productCategory:
                            productChunks[index].productHomeDetailModel!.prC,
                        storeId:
                            productChunks[index].productHomeDetailModel!.id,
                        docId:
                            productChunks[index].productHomeDetailModel!.docId,
                      );
                    }),
              ),
            );
          },
        ),
        _showCircularProgress
            ? SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  backgroundColor: kMarketPrimaryColor,
                  // valueColor: _animationController.drive(
                  //   ColorTween(
                  //       begin: kMarketPrimaryColor, end: kMarketSecondaryColor),
                  // ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  /// Algorithm running the Market Home based on the user's selection
  Future<Map<String, dynamic>?> getMarketProducts() async {
    if (category[0] == kAll && _marketTrigger[0] == kPopular) {
      return await _marketDatabaseService
          .getMarketProductsBasedOnCondition(prodCondition!);
    } else if (category[0] == kAll && _marketTrigger[0] == kRecentlyViewed) {
      print("Recently viewed - All running...");
      return await _marketDatabaseService
          .getRecentlyViewedProducts(prodCondition);
    } else if (category[0] == kAll && _marketTrigger[0] == kRecommended) {
      print("All - Recommended Running");

      /// TODO: Write an algorithm to fetch products based on product rating
      return null;
    } else if (_marketTrigger[0] == kPopular) {
      return await _marketDatabaseService.getProductsBasedOnCategory(
          prodCondition!, capitalizeFirstLetterOfWords(category[0]!));
    } else if (_marketTrigger[0] == kRecentlyViewed) {
      return await _marketDatabaseService
          .getRecentlyViewedProductsBasedOnCategory(
              prodCondition, capitalizeFirstLetterOfWords(category[0]!));
    } else if (_marketTrigger[0] == kRecommended) {
      print("Recommended based on Category running");

      /// TODO: Write the algorithm to fetch Recommended products based on Category
      return null;
    } else {
      print("Fall back running");

      /// TODO: Just return here
      return await _marketDatabaseService
          .getMarketProductsBasedOnCondition(prodCondition!);
    }
  }

  void getFirstSimilarProducts(
      {String? prodCondition, String? prodCategory, String? commonId}) async {
    setState(() => exploreLoadingProducts = true);
    similarProductsNew.clear();

    /// TODO: Set all boolean values to default here && other variables

    try {
      List<DocumentSnapshot> similarProdDocSnap = [];

      similarProdDocSnap = await _marketDatabaseService.fetchSimilarProducts(
          prodCondition, prodCategory);

      if (similarProdDocSnap.isEmpty || similarProdDocSnap.length == 0) {
        exploreMoreDocumentsAvailable = false;

        return;
      }

      if (similarProdDocSnap.length < 10) exploreMoreDocumentsAvailable = false;

      List<SimilarProductModel> tempSimilar = [];

      for (DocumentSnapshot doc in similarProdDocSnap) {
        Map<String, dynamic> data = doc.data as Map<String, dynamic>;
        if (data['cmId'] != commonId) {
          SimilarProductModel singleSimilarProductModel =
              SimilarProductModel.fromJson(data as Map<String, dynamic>);
          tempSimilar.add(singleSimilarProductModel);
        }
      }

      similarProductsNew.addAll(tempSimilar);
      print("SIMILAR PRODUCT: ${similarProductsNew.length}");
    } catch (e) {
      print("Problem getting explore similar products: $e");
    }

    if (mounted) setState(() => exploreLoadingProducts = false);

    print("EXPLORE LOAD: $exploreLoadingProducts");
  }

  void getFirstDisplayedProducts() async {
    setState(() => _loadingProducts = true);

    productChunks.clear();

    try {
      Map<String, dynamic> info =
          await (getMarketProducts() as Future<Map<String, dynamic>>);

      List<DocumentSnapshot> prodDocSnap = info[kProductDetails];
      List<DocumentSnapshot>? storeDocSnap = info[kStoreDetails];

      /// Assigning the lastDocument variable
      _marketTrigger[0] == kRecentlyViewed
          ? lastDocument = info[kRecentlyViewedDoc]
          : lastDocument = prodDocSnap;

      if (prodDocSnap.length == 0 || prodDocSnap.isEmpty) {
        _moreDocumentsAvailable = false;

        return;
      }

      if (prodDocSnap.length < 10) _moreDocumentsAvailable = false;

      List<Map<String, dynamic>?> productDetails = [];
      List<Map<String, dynamic>?> storeDetails = [];

      for (DocumentSnapshot docSnap in prodDocSnap) {
        productDetails.add(docSnap.data() as Map<String, dynamic>?);
      }

      for (DocumentSnapshot docSnap in storeDocSnap!) {
        storeDetails.add(docSnap.data() as Map<String, dynamic>?);
      }

      if (storeDetails.length == productDetails.length) {
        for (int i = 0; i < storeDetails.length; i++) {
          StoreDetailsModel storeDetailsModel =
              StoreDetailsModel.fromJson(storeDetails[i]!);

          ProductHomeDetailModel productHomeDetailModel =
              ProductHomeDetailModel.fromJson(productDetails[i]!);

          DisplayedProductModel productChunk = DisplayedProductModel(
            storeDetailsModel: storeDetailsModel,
            productHomeDetailModel: productHomeDetailModel,
          );

          productChunks.add(productChunk);
        }
      }
    } catch (e) {
      print(e);
    }

    if (mounted) setState(() => _loadingProducts = false);
  }

  /// Method to get next set of products using pagination
  void fetchNextDocuments() async {
    try {
      if (_shouldCheck && _moreDocumentsAvailable) {
        _hasGottenNextDocData = false;

        _shouldRunCheck = false;

        Map<String, dynamic> info = {};

        if (category[0] == kAll && _marketTrigger[0] == kPopular) {
          // Do something
          info = await _marketDatabaseService
              .getMarketProductsBasedOnConditionNextTen(
            prodCondition!,
            lastDocument!,
          );
        } else if (category[0] == kAll &&
            _marketTrigger[0] == kRecentlyViewed) {
          // Do something
          info = await _marketDatabaseService.getRecentlyViewedProductsNextTen(
            prodCondition,
            lastDocument!,
          );
        } else if (category[0] == kAll && _marketTrigger[0] == kRecommended) {
          // Do something
        } else if (_marketTrigger[0] == kPopular) {
          // Do something
          info = await _marketDatabaseService.getProductsBasedOnCategoryNextTen(
            prodCondition!,
            capitalizeFirstLetterOfWords(category[0]!),
            lastDocument!,
          );
        } else if (_marketTrigger[0] == kRecentlyViewed) {
          // Do something
          info = await _marketDatabaseService
              .getRecentlyViewedProductsBasedOnCategoryNextTen(
            prodCondition,
            capitalizeFirstLetterOfWords(category[0]!),
            lastDocument!,
          );
        } else if (_marketTrigger[0] == kRecommended) {
          // Do something
        } else {
          return;
        }

        List<DocumentSnapshot> prodDocSnap = info[kProductDetails];
        List<DocumentSnapshot>? storeDocSnap = info[kStoreDetails];

        if (prodDocSnap.length == 0 || prodDocSnap.isEmpty) {
          _moreDocumentsAvailable = false;
          _hasGottenNextDocData = false;

          setState(() => _showCircularProgress = false);

          return;
        }

        if (prodDocSnap.length < 10) _moreDocumentsAvailable = false;

        /// Assigning the lastDocument variable
        _marketTrigger[0] == kRecentlyViewed
            ? lastDocument = info[kRecentlyViewedDoc]
            : lastDocument = prodDocSnap;

        List<Map<String, dynamic>?> productDetails = [];
        List<Map<String, dynamic>?> storeDetails = [];

        for (DocumentSnapshot docSnap in prodDocSnap) {
          productDetails.add(docSnap.data() as Map<String, dynamic>?);
        }

        for (DocumentSnapshot docSnap in storeDocSnap!) {
          storeDetails.add(docSnap.data() as Map<String, dynamic>?);
        }

        if (storeDetails.length == productDetails.length) {
          List<DisplayedProductModel> tempChunk = [];

          for (int i = 0; i < storeDetails.length; i++) {
            StoreDetailsModel storeDetailsModel =
                StoreDetailsModel.fromJson(storeDetails[i]!);

            ProductHomeDetailModel productHomeDetailModel =
                ProductHomeDetailModel.fromJson(productDetails[i]!);

            DisplayedProductModel chunk = DisplayedProductModel(
              storeDetailsModel: storeDetailsModel,
              productHomeDetailModel: productHomeDetailModel,
            );

            tempChunk.add(chunk);
          }

          setState(() {
            productChunks.addAll(tempChunk);
            _showCircularProgress = false;
          });

          _shouldRunCheck = true;

          _hasGottenNextDocData = true;
        }
      }
    } catch (e) {
      print("fetchNextDocuments: $e");

      /// TODO: Display at error widget to the user
    }
  }

  void showSmallerFab() {
    /// TODO: implement smaller FAB buttons
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              print("Gesture tapped!");
              resetFab();
              Navigator.of(context, rootNavigator: true).pop(context);
            },
            onVerticalDragStart: (dragStart) {
              resetFab();
              Navigator.of(context, rootNavigator: true).pop(context);
            },
            child: Container(
              color: Colors.transparent,
              child: CustomSmallFAB(
                children: [
                  SmallerFAB(
                    heroTag: null,
                    imageName: "images/app_entry_and_home/sparks_brand_svg.svg",
                    smallFabOnPressed: () {
                      //TODO: Do something when this fab button is pressed.

                      print('one pressed');
                      fabController();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SmallerFAB(
                    heroTag: null,
                    imageName: "images/app_entry_and_home/fab_briefcase.svg",
                    smallFabOnPressed: () {
                      //TODO: Do something when this fab button is pressed.
                      print("Second button form the top");
                      fabController();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SmallerFAB(
                    heroTag: null,
                    imageName: "images/app_entry_and_home/fab_money.svg",
                    smallFabOnPressed: () {
                      //TODO: Do something when this fab button is pressed.
                      print("Third button form the top");
                      fabController();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// The method that returns a Widget with a draggable container when users click on 'explore'
  void exploreBottomSheet(
      {String? productCondition, String? productCategory, String? commonId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: exploreModalHeight,
        color: Colors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: 0.64,
          minChildSize: 0.24,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return MarketExplore(
              productCondition: productCondition,
              productCategory: productCategory,
              commonId: commonId,
              scrollController: scrollController,
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // _animationController =
    //     AnimationController(duration: new Duration(seconds: 1), vsync: this);
    // _animationController.repeat();

    getCurrentUser();

    /// TODO: Check that the user Id is not "null"
    _marketDatabaseService =
        MarketDatabaseService(userId: MarketGlobalVariables.currentUserId);
  }

  @override
  void didChangeDependencies() {
    final newUsedButton = Provider.of<NewUsedProvider>(context);

    if (this.mounted) {
      if (newUsedButton.newUsedSwitch == true) {
        setState(() => prodCondition = 'newProducts');
      } else {
        setState(() => prodCondition = 'usedProducts');
      }
      getFirstDisplayedProducts();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _animationController.dispose();
    _exploreStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final shoppingCart = Provider.of<ShoppingCart>(context);

    /// This variable contains the screen dimension (.height & .width) of any device
    final mediaQuery = MediaQuery.of(context).size;

    /// The container height of the DraggableScrollableSheet for the market explore container
    exploreModalHeight = mediaQuery.height -
        (AppBar().preferredSize.height + MediaQuery.of(context).padding.top);

    /// Setting the allowed orientation of the Market Section. Only 'portrait' mode is allowed
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /// Initialization of the [ScreenUtil] package

    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                MarketAppBar(),

                /// Widget containing product categories
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: kMarketDarkPrimaryColor,
                    ),
                    alignment: Alignment.center,
                    height: ScreenUtil().setHeight(100),
                    width: mediaQuery.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        for (int i = 0; i < homeNavCategory.length; i++)
                          CategoryNav(
                            iconText:
                                homeNavCategory[i]["label"]!.toUpperCase(),
                            imageURL:
                                'images/market_images/${homeNavCategory[i]["icon"]}.svg',
                            width:
                                category.contains(homeNavCategory[i]["label"])
                                    ? kSvgIconActiveSize
                                    : kSvgIconInactiveSize,
                            onTap: () {
                              if (i == (homeNavCategory.length - 1)) {
                                _openEndDrawer();
                              } else {
                                _handleCategoryOnTap(
                                    homeNavCategory[i]["label"]);
                              }
                            },
                            textStyle: kTextStyleFont15Bold.copyWith(
                                color: category
                                        .contains(homeNavCategory[i]["label"])
                                    ? kCustomNavActiveColour
                                    : kCustomNavInactiveColour),
                          ),
                        // CategoryNav(
                        //   iconText: kAll,
                        //   imageURL: 'images/market_images/market_all_icon.svg',
                        //   width: category.contains(kAll)
                        //       ? kSvgIconActiveSize
                        //       : kSvgIconInactiveSize,
                        //   onTap: () {
                        //     _handleCategoryOnTap(kAll);
                        //   },
                        //   textActiveColor: category.contains(kAll)
                        //       ? kCustomNavActiveColour
                        //       : kCustomNavInactiveColour,
                        // ),
                        // CategoryNav(
                        //   iconText: kClothes,
                        //   imageURL:
                        //       'images/market_images/market_cloth_icon.svg',
                        //   width: category.contains(kClothes)
                        //       ? kSvgIconActiveSize
                        //       : kSvgIconInactiveSize,
                        //   onTap: () {
                        //     _handleCategoryOnTap(kClothes);
                        //   },
                        //   textActiveColor: category.contains(kClothes)
                        //       ? kCustomNavActiveColour
                        //       : kCustomNavInactiveColour,
                        // ),
                        // CategoryNav(
                        //   iconText: kShoes,
                        //   imageURL: 'images/market_images/market_shoe_icon.svg',
                        //   width: category.contains(kShoes)
                        //       ? kSvgIconActiveSize
                        //       : kSvgIconInactiveSize,
                        //   onTap: () {
                        //     _handleCategoryOnTap(kShoes);
                        //   },
                        //   textActiveColor: category.contains(kShoes)
                        //       ? kCustomNavActiveColour
                        //       : kCustomNavInactiveColour,
                        // ),
                        // CategoryNav(
                        //   iconText: kSeeAll,
                        //   imageURL:
                        //       'images/market_images/market_seeAll_icon.svg',
                        //   width: kSvgIconInactiveSize,
                        //   onTap: () {
                        //     _openEndDrawer();
                        //   },
                        //   textActiveColor: category.contains(kSeeAll)
                        //       ? kCustomNavActiveColour
                        //       : kCustomNavInactiveColour,
                        // ),
                      ],
                    ),
                  ),
                ),

                // Persistent sticky header for the secondary Market navigation which includes
                // 'Popular', 'Recently Viewed' & 'Recommended'
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeader(
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _handleMarketTrigger(kPopular);
                            },

                            /// TODO: Fix using "AutoSizeText" or remove it entirely
                            child: Text(
                              kPopular,
                              style: kMarketTriggerTextStyle.copyWith(
                                color: _marketTrigger.contains(kPopular)
                                    ? kMarketTriggerActive
                                    : null,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _handleMarketTrigger(kRecentlyViewed);
                            },
                            child: Text(
                              kRecentlyViewed,
                              style: kMarketTriggerTextStyle.copyWith(
                                color: _marketTrigger.contains(kRecentlyViewed)
                                    ? kMarketTriggerActive
                                    : null,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _handleMarketTrigger(kRecommended);
                            },
                            child: Text(
                              kRecommended,
                              style: kMarketTriggerTextStyle.copyWith(
                                color: _marketTrigger.contains(kRecommended)
                                    ? kMarketTriggerActive
                                    : null,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: _loadingProducts
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kMarketPrimaryColor,
                    ),
                  )
                : productChunks.length == 0
                    ? Center(
                        child: Text(
                          "No Products",
                        ),
                      )
                    : marketWidgets(),
          ),
          drawer: MarketHomeDrawer(),
          endDrawer: MarketHomeEndDrawer(
            endDrawerCategoryValue: handleEndDrawerSelection,
          ),
          endDrawerEnableOpenDragGesture: false,
          bottomNavigationBar: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: _showBottomNavBar ? 56.0 : 0.0,
            child: MarketBottomAppbarWithEndDock(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: _showBottomNavBar
              ? fabState == FabState.CLOSE
                  ? FloatingActionButton(
                      heroTag: "mainFAB",
                      backgroundColor: kMarketPrimaryColor,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: kWhiteColour,
                        ),
                      ),
                      onPressed: () {
                        print("I was pressed");
                        showSmallerFab();
                        fabController();
                      },
                      child: SvgPicture.asset(
                        "images/app_entry_and_home/sparks_brand_svg.svg",
                        width: MediaQuery.of(context).size.width * 0.05,
                        height: MediaQuery.of(context).size.height * 0.038,
                      ),
                    )
                  : FloatingActionButton(
                      backgroundColor: kMarketPrimaryColor,
                      onPressed: () {
                        print("FAB close");
                        fabController();
                      },
                      child: Icon(
                        Icons.close,
                        size: ScreenUtil().setWidth(36),
                      ),
                    )
              : null,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RatingPopUp extends StatelessWidget {
  RatingPopUp({required this.iconURL, required this.iconText});

  final String iconURL;
  final String iconText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              iconURL,
              width: 32.0,
              height: 32.0,
            ),
            Text(
              iconText,
              style: kRatingPopUpTextStyle,
            ),
          ],
        ),
        SizedBox(
          width: ScreenUtil().setWidth(8),
        ),
      ],
    );
  }
}

// The persistent header (sticky header) Class  for the market secondary navigation toggles
// which includes 'popular', 'recently viewed' & 'recommended'
class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget? widget;

  PersistentHeader({this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 56.0,
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.white,
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
