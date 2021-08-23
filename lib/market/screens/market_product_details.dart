import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/market/components/adding_to_cart_bottom_appbar.dart';
import 'package:sparks/market/components/bottom_appbar_full.dart';
import 'package:sparks/market/components/custom_pill_button.dart';
import 'package:sparks/market/components/market_persistent_header.dart';
import 'package:sparks/market/components/selecting_different_product_variation.dart';
import 'package:sparks/market/market_models/Item.dart';
import 'package:sparks/market/market_models/recently_viewed_model.dart';
import 'package:sparks/market/tab_views/product_detail_review.dart';
import 'package:sparks/market/tab_views/product_specification.dart';
import 'package:sparks/market/tab_views/product_detail_tab_view.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/components/badge_counter.dart';
import 'package:provider/provider.dart';
import 'package:sparks/market/providers/shopping_cart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/market/components/market_carousel.dart';
import 'package:sparks/market/tab_views/product_description_tab_view.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/market_mixin.dart';

enum ActivateAddToCartWidget {
  TRUE,
  FALSE,
}

class MarketProductDetails extends StatefulWidget {
  static String id = 'product_detail';

  @override
  _MarketProductDetailsState createState() => _MarketProductDetailsState();
}

class _MarketProductDetailsState extends State<MarketProductDetails>
    with SingleTickerProviderStateMixin, MarketMixin {
  TabController? _tabController;
  ScrollController? _scrollController;
  bool fixedScroll = false;

  int currentIndex = 0;

  double productDetailVisibility = 0;

  /// ID of the currently logged in user
  String? userId;

  ActivateAddToCartWidget? activateAddToCart;

  Item? item;

  /// When a user newly adds a product to cart, the default quantity of the product added is "1"
  int? defaultProductQuantity = 1;

  double? productPrice = 0;

  /// Variable that stores the index of product item in the shopping cart
  late int getItemInCartIndex;

  /// Boolean value that determines if a user is selecting a different variation of a product
  bool selectingDifferentProductVariation = false;

  /// Boolean value to show or hide [AppBar]
  bool showAppBar = false;

  bool showAddToCartBottomAppBar = true;

  String? _productName;
  double? _productRating = 0.0;

  late RecentlyViewedModel recentlyViewedModel;

  /// Function to toggle [selectingDifferentProductVariation] value
  ///
  /// This function also shows or hides the different BottomAppBars [AddingToCartBottomAppbar] || [BottomAppbarFull]
  void toggleReSelectingProductVariation() {
    setState(() {
      selectingDifferentProductVariation = !selectingDifferentProductVariation;
    });

    if (selectingDifferentProductVariation) {
      setState(() {
        showAddToCartBottomAppBar = true; // show [AddingToCartBottomAppbar]
      });
    } else {
      setState(() {
        showAddToCartBottomAppBar = false; // show [BottomAppbarFull]
      });
    }
  }

  /// Function to toggle adding product to user's cart
  void activateAddToCartToggle() {
    if (activateAddToCart == ActivateAddToCartWidget.FALSE) {
      setState(() {
        activateAddToCart = ActivateAddToCartWidget.TRUE;
        showAppBar = true;
      });
    }
  }

  void newProductVisibilityValue(double visibilityValue) {
    setState(() {
      productDetailVisibility = visibilityValue;
    });
  }

  /// Functions that gets the index of a product variation that is currently selected
  void newIndex(int variationIndex) {
    if (currentIndex == variationIndex) {
      setState(() {
        currentIndex = currentIndex;
      });
    } else {
      setState(() {
        currentIndex = variationIndex;
      });
    }
  }

  /// Function that takes a List of Strings of the image url and return a List of CachedNetworkImages
  List<CachedNetworkImage> cachedProductImages(List<String?> images) {
    List<CachedNetworkImage> assets = [];

    for (String? image in images) {
      var productAsset = CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            backgroundColor: kMarketPrimaryColor,
            value: progress.progress,
          ),
        ),
        imageUrl: image!,
        fit: BoxFit.cover,
      );

      assets.add(productAsset);
    }

    return assets;
  }

  /// Function to add product item to user's list of currently viewed market products
  void addToRecentlyViewedProducts() async {
    print("Adding to Recently Viewed running...");

    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(MarketGlobalVariables.currentUserId)
          .collection("Market")
          .doc("marketInfo")
          .collection("marketRecentlyViewed")
          .where("cmId", isEqualTo: MarketGlobalVariables.viewedCommonId)
          .get();

      print("Gotten users document");

      List<QueryDocumentSnapshot> documentSnapshot = querySnapshot.docs;

      if (documentSnapshot.isEmpty || documentSnapshot.length == 0) {
        if (MarketGlobalVariables.viewedCommonId != "" &&
            MarketGlobalVariables.viewedStoreId != "" &&
            MarketGlobalVariables.viewedCondition != "" &&
            MarketGlobalVariables.viewedCategory != "" &&
            MarketGlobalVariables.viewedImage != "" &&
            MarketGlobalVariables.viewedProductName != "" &&
            MarketGlobalVariables.viewedProductPrice != 0) {
          print("Proceeding to add item to recently viewed");

          String productCondition = "";
          if (MarketGlobalVariables.viewedCondition == "newProducts") {
            productCondition = "new product";
          } else {
            productCondition = "used product";
          }

          DocumentReference documentReference = FirebaseFirestore.instance
              .collection("users")
              .doc(MarketGlobalVariables.currentUserId)
              .collection("Market")
              .doc("marketInfo")
              .collection("marketRecentlyViewed")
              .doc();

          recentlyViewedModel = RecentlyViewedModel(
            id: MarketGlobalVariables.viewedStoreId,
            cmId: MarketGlobalVariables.viewedCommonId,
            cond: productCondition,
            prC: MarketGlobalVariables.viewedCategory,
            prImg: MarketGlobalVariables.viewedImage,
            prN: MarketGlobalVariables.viewedProductName,
            price: MarketGlobalVariables.viewedProductPrice,
            docId: documentReference.id,
            ts: DateTime.now().millisecondsSinceEpoch,
          );

          await documentReference.set(recentlyViewedModel.toJson());
        }
      } else {
        print("Document exist, updating date time");
        String? recentlyViewedId = documentSnapshot[0]["docId"];

        int timeFromDatabase = documentSnapshot[0]["ts"];

        int timeInMillis = timeFromDatabase;
        var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        var formattedDate = DateFormat.yMMMd().format(date);

        print(formattedDate);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(MarketGlobalVariables.currentUserId)
            .collection("Market")
            .doc("marketInfo")
            .collection("marketRecentlyViewed")
            .doc(recentlyViewedId)
            .update({"ts": DateTime.now().millisecondsSinceEpoch});
      }
      print("success!");
    } catch (e) {
      print(e);
    }
  }

  void getProductNameAndRating() async {
    if (MarketGlobalVariables.viewedProductName != "" &&
        MarketGlobalVariables.viewedProductRating != null) {
      print("Product name and rating passed in");
      _productName = MarketGlobalVariables.viewedProductName;
      _productRating = MarketGlobalVariables.viewedProductRating;
    } else {
      print("Getting name and rating from Firebase");
      await FirebaseFirestore.instance
          .collectionGroup(MarketGlobalVariables.viewedCondition)
          .where("cmId", isEqualTo: MarketGlobalVariables.viewedCommonId)
          .get()
          .then((value) {
        setState(() {
          _productRating = value.docs[0]["rate"];
          _productName = value.docs[0]["prN"];
        });
      }).catchError((onError) {
        print("Error getting name and rating: $onError");
      });
    }
  }

  /// Cloth Widget before adding to cart
  Widget clothBeforeCart(
      QuerySnapshot productDetailSnapshot, List<String?> productImgUrlStrings) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.black.withAlpha(204),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: kMarketPrimaryColor,
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            title: Column(
              children: <Widget>[
                Text(
                  _productName ?? "...",
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${numberFormatterWithComma(productDetailSnapshot.docs[currentIndex]['price'].toStringAsFixed(2))}',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(8),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14.0),
                        ),
                        color: kMarketPrimaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 14.0,
                          ),
                          Text(
                            '$_productRating',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            actions: <Widget>[
              Consumer<ShoppingCart>(
                builder: (context, cart, child) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: BadgeCounter(
                    onTap: () {
                      print("Shopping cart tapped!");
                    },
                    badgeText: cart.numOfItems.toString(),
                    iconData: Icons.shopping_cart,
                    showBadge: cart.numOfItems >= 1 ? true : false,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: MarketItemsCarousel(
              images: cachedProductImages(productImgUrlStrings),
              showIndicator: true,
            ),
          ),
          SliverOverlapAbsorber(
            // This widget takes the overlapping behavior of the SliverAppBar,
            // and redirects it to the SliverOverlapInjector below. If it is
            // missing, then it is possible for the nested "inner" scroll view
            // below to end up under the SliverAppBar even when the inner
            // scroll view thinks it has not been scrolled.
            // This is not necessary if the "headerSliverBuilder" only builds
            // widgets that do not overlap the next sliver.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: MarketPersistentHeader(
                color: Colors.white,
                widget: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(56),
                  //color: Colors.white,
                  child: Center(
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: Colors.black,
                      labelColor: kMarketPrimaryColor,
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 32.0),
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            'Product',
                            style: kProductDetailTabHeading,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Description',
                            style: kProductDetailTabHeading,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Specification',
                            style: kProductDetailTabHeading,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Reviews',
                            style: kProductDetailTabHeading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        padding: EdgeInsets.only(top: 48.0),
        child: Builder(
          builder: (context) {
            final primaryController = PrimaryScrollController.of(context);
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                ProductDetailTabView(
                  //newIndexValue: newIndex,
                  currentVariationIndex: newIndex,
                  productDetailVisibility: newProductVisibilityValue,
                ),
                ProductDescriptionTabView(),
                ProductSpecification(
                  currentIndex: currentIndex,
                ),
                ProductDetailReview(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Cloth Widget adding to cart
  Widget clothAddingToCart(List<String?> productImgUrlStrings,
      QuerySnapshot productDetailSnapshot, ShoppingCart shoppingCart) {
    return Column(
      children: [
        MarketItemsCarousel(
          images: cachedProductImages(productImgUrlStrings),
          showIndicator: true,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffA60F00),
              border: Border(
                bottom: BorderSide(color: Color(0xffB83F33), width: 4.0),
              ),
            ),
            child: !selectingDifferentProductVariation
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// Widget for "cloth color" & "size"
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomPillButton(
                              height:
                                  MediaQuery.of(context).size.height * 0.066,
                              width: MediaQuery.of(context).size.width * 0.22,
                              onTap: () {
                                toggleReSelectingProductVariation();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    /// TODO: Use the color name from the database
                                    "Lime",
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w700,
                                      fontSize: ScreenUtil().setSp(14),
                                      color: Color(0xffFFC8BC),
                                    ),
                                  ),
                                  Container(
                                    height: ScreenUtil().setHeight(12),
                                    width: ScreenUtil().setWidth(48),
                                    decoration: BoxDecoration(
                                      color: Color(MarketGlobalVariables
                                          .activeClothColor!),
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(24),
                            ),

                            /// Cloth Size Widget
                            CustomPillButton(
                              height:
                                  MediaQuery.of(context).size.height * 0.066,
                              width: MediaQuery.of(context).size.width * 0.22,
                              onTap: () {
                                toggleReSelectingProductVariation();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Size",
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w700,
                                      fontSize: ScreenUtil().setSp(14),
                                      color: Color(0xffFFC8BC),
                                    ),
                                  ),
                                  Text(
                                    "( ${MarketGlobalVariables.activeClothSize} )",
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Widget for "quantity" & "price"
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Widget for "quantity"
                            CustomPillButton(
                              height:
                                  MediaQuery.of(context).size.height * 0.066,
                              width: MediaQuery.of(context).size.width * 0.34,
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      /// TODO: Add an "if" statement here; if "defaultProductQuantity" == "0" show a dialog to remove product from cart
//                                      if (defaultProductQuantity > 1) {
//                                        setState(() {
//                                          defaultProductQuantity--;
//                                        });
//                                        shoppingCart.decreaseQuantityCount(
//                                          productDetailSnapshot
//                                              .docs[currentIndex]['sku'],
//                                          defaultProductQuantity,
//                                        );
//                                      }

                                      int indexOfIndex = shoppingCart
                                          .getItemIndex(productDetailSnapshot
                                              .docs[currentIndex]['sku']);

                                      shoppingCart.decreaseQuantityCount(
                                          indexOfIndex,
                                          productDetailSnapshot
                                              .docs[currentIndex]["sku"]);
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kMarketPrimaryColor,
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Text(
                                      "${shoppingCart.items[getItemInCartIndex]!.quantity}",
                                      style: GoogleFonts.rajdhani(
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(14),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
//                                      if (defaultProductQuantity <
//                                          productDetailSnapshot
//                                              .docs[currentIndex]["stock"]) {
//                                        setState(() {
//                                          defaultProductQuantity++;
//                                        });
//                                        shoppingCart.increaseQuantityCount(
//                                            productDetailSnapshot
//                                                .docs[currentIndex]['sku'],
//                                            defaultProductQuantity);
//                                      }

                                      int indexOfItem = shoppingCart
                                          .getItemIndex(productDetailSnapshot
                                              .docs[currentIndex]["sku"]);
                                      if (shoppingCart
                                              .items[indexOfItem]!.quantity <
                                          productDetailSnapshot
                                              .docs[currentIndex]["stock"]) {
                                        shoppingCart.increaseQuantityCount(
                                            indexOfItem,
                                            productDetailSnapshot
                                                .docs[currentIndex]["sku"]);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(24),
                            ),

                            /// Widget for "price"
                            CustomPillButton(
                              height:
                                  MediaQuery.of(context).size.height * 0.066,
                              width: MediaQuery.of(context).size.width * 0.34,
                              onTap: () {},
                              child: Consumer<ShoppingCart>(
                                builder: (_, cart, __) => Text(
                                  '${numberFormatterWithComma(cart.items[getItemInCartIndex]!.price!.toStringAsFixed(2))}',
                                  style: GoogleFonts.rajdhani(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// "View Cart" button widget
                      CustomPillButton(
                        onTap: () {
                          print("Open market cart");
                        },
                        color: kMarketPrimaryColor,
                        height: MediaQuery.of(context).size.height * 0.162,
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Consumer<ShoppingCart>(
                              builder: (context, cart, child) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: BadgeCounter(
                                  badgeText: cart.numOfItems.toString(),
                                  iconData: Icons.shopping_cart,
                                  color: Color(0xffA60F00),
                                  position: BadgePosition.bottomStart(
                                      bottom: -8.0, start: -6.0),
                                  showBadge:
                                      cart.numOfItems >= 1 ? true : false,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(8),
                            ),
                            Text(
                              "View Cart",
                              style: GoogleFonts.rajdhani(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(15),
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : SelectingDifferentProductVariation(
                    currentVariationIndex: newIndex),
          ),
        ),
      ],
    );
  }

//  _scrollListener() {
//    if (fixedScroll) {
//      _scrollController.jumpTo(0);
//    }
//  }

  _smoothScrollToTop() {
//    _scrollController.animateTo(
//      0,
//      duration: Duration(microseconds: 300),
//      curve: Curves.ease,
//    );

    if (_tabController!.index == 0) {
      _scrollController!.animateTo(
        0,
        duration: Duration(microseconds: 300),
        curve: Curves.ease,
      );
      if (productDetailVisibility == 100.0) {
        setState(() {
          fixedScroll = true;
        });
      } else {
        setState(() {
          fixedScroll = false;
        });
      }
    }

    setState(() {
      fixedScroll = _tabController!.index == 0;
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);

    //_tabController.addListener(_smoothScrollToTop);

    userId = MarketGlobalVariables.currentUserId;

    print(MarketGlobalVariables.currentUserId);

    getProductNameAndRating();

    Future.delayed(Duration(seconds: 3), () {
      addToRecentlyViewedProducts();
    });

    activateAddToCart = ActivateAddToCartWidget.FALSE;
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: kStatusbar,
      ),
    );

    _tabController!.dispose();
    _scrollController!.dispose();
    MarketGlobalVariables.viewedProductName = "";
    MarketGlobalVariables.viewedProductRating = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      ),
    );

    final shoppingCart = Provider.of<ShoppingCart>(context);

//    final productDetailArg =
//        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
//    String commonId = productDetailArg['cmId'];
//    String productName = productDetailArg['prN'];
//    double productRating = productDetailArg['rate'];

    final mediaQuery = MediaQuery.of(context).size;

    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
      value: FirebaseFirestore.instance
          .collectionGroup('variations')
          .where('cmId', isEqualTo: MarketGlobalVariables.viewedCommonId)
          .snapshots(),
      builder: (context, _) {
        var productDetailSnapshot = Provider.of<QuerySnapshot>(context);

        if (productDetailSnapshot == null) {
          return Scaffold(
            body: Text('Not working'),
          );
        } else {
          //MarketGlobalVariables.querySnapshot = productDetailSnapshot;

          List<String?> productImgUrlStrings = [];

          for (var imageUrl in productDetailSnapshot.docs[currentIndex]
              ['prImg']) {
            productImgUrlStrings.add(imageUrl);
          }

          return SafeArea(
            child: Scaffold(
              appBar:
                  showAppBar // This will display when a user click on "Add" to cart
                      ? AppBar(
                          backgroundColor: Colors.black.withAlpha(204),
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: kMarketPrimaryColor,
                            onPressed: () {
                              Navigator.maybePop(context);
                            },
                          ),
                          title: Column(
                            children: <Widget>[
                              Text(
                                _productName ?? "...",
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(8),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${numberFormatterWithComma(productDetailSnapshot.docs[currentIndex]['price'].toStringAsFixed(2))}',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14.0),
                                      ),
                                      color: kMarketPrimaryColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          size: 14.0,
                                        ),
                                        Text(
                                          '$_productRating',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          actions: <Widget>[
                            Consumer<ShoppingCart>(
                              builder: (context, cart, child) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: BadgeCounter(
                                  onTap: () {
                                    print("Shopping cart tapped!");
                                  },
                                  badgeText: cart.numOfItems.toString(),
                                  iconData: Icons.shopping_cart,
                                  showBadge:
                                      cart.numOfItems >= 1 ? true : false,
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,

              /// NOTE: When integrating different product categories, "CLOTH"
              /// category for example will have both the "before cart" and "adding
              /// to cart" logic in it's widget method
              body: activateAddToCart == ActivateAddToCartWidget.TRUE
                  ? clothAddingToCart(
                      productImgUrlStrings, productDetailSnapshot, shoppingCart)
                  : clothBeforeCart(
                      productDetailSnapshot, productImgUrlStrings),
              bottomNavigationBar: showAddToCartBottomAppBar
                  ? AddingToCartBottomAppbar(
                      onPressed: () {
                        activateAddToCartToggle();
                        setState(() {
                          selectingDifferentProductVariation = false;
                          showAddToCartBottomAppBar = false;
                        });
                        item = Item(
                            cmId: productDetailSnapshot.docs[currentIndex]
                                ['cmId'],
                            sku: productDetailSnapshot.docs[currentIndex]
                                ['sku'],
                            name: productDetailSnapshot.docs[currentIndex]
                                ['prN'],
                            imgUrl: productDetailSnapshot.docs[currentIndex]
                                ["prImg"][0],
                            basePrice: productDetailSnapshot.docs[currentIndex]
                                ['price'],
                            price: productDetailSnapshot.docs[currentIndex]
                                ['price'],
                            quantity: 1,
                            stock: productDetailSnapshot.docs[currentIndex]
                                ['stock'],
                            cond: productDetailSnapshot.docs[currentIndex]
                                ['cond'],
                            size: productDetailSnapshot.docs[currentIndex]
                                ['cSize']);

                        if (shoppingCart.isItemInCart(item)) {
                          setState(() {
                            /// This gets the index of item in cart
                            getItemInCartIndex =
                                shoppingCart.getItemIndex(item!.sku);

                            print("getItemInCartIndex $getItemInCartIndex");

                            defaultProductQuantity = shoppingCart
                                .items[getItemInCartIndex]!.quantity;
                            productPrice =
                                shoppingCart.items[getItemInCartIndex]!.price;
                          });
                        } else {
                          shoppingCart.addToCart(item);
                          setState(() {
                            productPrice = item!.price;
                            getItemInCartIndex =
                                shoppingCart.getItemIndex(item!.sku);
                          });
                        }
                      },
                    )
                  : BottomAppbarFull(),
            ),
          );
        }
      },
      catchError: (_, __) => null,
    );
  }
}
