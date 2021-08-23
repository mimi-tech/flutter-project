import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/market/components/similar_products_card.dart';
import 'package:sparks/market/market_models/similar_products_model.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/strings.dart';

class MarketExplore extends StatefulWidget {
  final String? productCondition;
  final String? productCategory;
  final String? commonId;
  final ScrollController scrollController;

  MarketExplore(
      {required this.productCondition,
      required this.productCategory,
      required this.commonId,
      required this.scrollController});

  @override
  _MarketExploreState createState() => _MarketExploreState();
}

class _MarketExploreState extends State<MarketExplore> {
  MarketDatabaseService _marketDatabaseService = MarketDatabaseService();

  /// Variable holding similar products data
  List<SimilarProductModel> similarProducts = [];

  /// Variable holding the last List<DocumentSnapshot> from the previous query
  /// used to for pagination
  List<DocumentSnapshot> lastDocument = [];

  /// Variable to check if a fresh set of DocumentSnapshot is being fetched
  /// NOTE: This variable is mainly utilized when the Market Home is loaded/visited
  /// for the first time and when a new category of data is being selected
  bool _loadingProducts = false;

  /// Boolean variable that determines if a circular progress spinner should be
  /// shown at the bottom of the scrollable widget to indicated data being fetched
  bool _showCircularProgress = false;

  /// This boolean variable is used to check whether the scroll position is close
  /// to the bottom of the scrollable widget. If "true" then fetch next set of
  /// document data
  bool _shouldCheck = false;

  /// This boolean variable is used to check whether the method to fetch new set
  /// of document data is already running (pagination)
  bool _shouldRunCheck = true;

  /// Variable to check if the new set of paginated data has been fetched
  bool _hasGottenNextDocData = false;

  /// This boolean variable is used to verify if there are still any documents
  /// left in the database
  bool _moreDocumentsAvailable = true;

  /// Method to get the first set of similar products data, called from the initState
  void getFirstSimilarProducts() async {
    setState(() => _loadingProducts = true);
    // similarProducts?.clear();

    try {
      List<DocumentSnapshot> similarProdDocSnap = [];

      similarProdDocSnap = await _marketDatabaseService.fetchSimilarProducts(
          widget.productCondition, widget.productCategory);

      if (similarProdDocSnap.isEmpty || similarProdDocSnap.length == 0) {
        _moreDocumentsAvailable = false;

        return;
      }

      if (similarProdDocSnap.length < 10) _moreDocumentsAvailable = false;

      lastDocument = similarProdDocSnap;

      List<SimilarProductModel> tempSimilar = [];

      for (DocumentSnapshot doc in similarProdDocSnap) {
        Map<String, dynamic> data = doc.data as Map<String, dynamic>;
        if (data['cmId'] != widget.commonId) {
          SimilarProductModel singleSimilarProductModel =
              SimilarProductModel.fromJson(data as Map<String, dynamic>);
          tempSimilar.add(singleSimilarProductModel);
        }
      }

      // similarProducts.addAll(tempSimilar);

      similarProducts = tempSimilar;
    } catch (e) {
      print("getFirstSimilarProducts: $e");
    }

    if (mounted) setState(() => _loadingProducts = false);
  }

  /// Method to get the next set of similar products data
  void getNextSimilarProducts() async {
    try {
      if (_shouldCheck && _moreDocumentsAvailable) {
        _hasGottenNextDocData = false;

        _shouldRunCheck = false;

        List<DocumentSnapshot> newSimilarProducts = [];

        newSimilarProducts =
            await _marketDatabaseService.fetchSimilarProductsNext(
                widget.productCondition, widget.productCategory, lastDocument);

        if (newSimilarProducts.length == 0 || newSimilarProducts.isEmpty) {
          _moreDocumentsAvailable = false;
          _hasGottenNextDocData = false;

          setState(() => _showCircularProgress = false);

          return;
        }

        if (newSimilarProducts.length < 10) _moreDocumentsAvailable = false;

        lastDocument = newSimilarProducts;

        List<SimilarProductModel> tempSimilar = [];

        for (DocumentSnapshot doc in newSimilarProducts) {
          Map<String, dynamic> data = doc.data as Map<String, dynamic>;
          if (data['cmId'] != widget.commonId) {
            SimilarProductModel singleSimilarProductModel =
                SimilarProductModel.fromJson(data as Map<String, dynamic>);
            tempSimilar.add(singleSimilarProductModel);
          }
        }

        setState(() {
          similarProducts.addAll(tempSimilar);
          _showCircularProgress = false;
        });

        _shouldRunCheck = true;

        _hasGottenNextDocData = true;
      }
    } catch (e) {
      print("getNextSimilarProducts: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    getFirstSimilarProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0),
        child: Stack(
          overflow: Overflow.visible,
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(80),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ListView(
                  controller: widget.scrollController,
                  children: <Widget>[
                    ListTile(
                      leading: SvgPicture.asset(
                        'images/market_images/explore_products.svg',
                      ),
                      title: Text(
                        kSimilarProducts,
                        style: kSimilarProduct,
                      ),
                      subtitle: Text(
                        kFromOtherBrands,
                        style: kOtherProducts,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: _loadingProducts
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kMarketPrimaryColor,
                      ),
                    )
                  : similarProducts.length == 0
                      ? Center(
                          child: Text(
                            "No Products",
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            double maxScroll =
                                scrollNotification.metrics.maxScrollExtent;
                            double currentScroll =
                                scrollNotification.metrics.pixels;
                            double delta =
                                MediaQuery.of(context).size.height * 0.20;

                            if (maxScroll - currentScroll <= delta) {
                              _shouldCheck = true;

                              if (_shouldRunCheck && _moreDocumentsAvailable) {
                                getNextSimilarProducts();
                              }
                            }

                            /// At bottom of screen
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              if (scrollNotification.metrics.extentAfter == 0) {
                                /// If-Else block to determine whether to show a circular
                                /// progress indicator while fetching new data at the bottom
                                /// of the screen
                                if (!_hasGottenNextDocData &&
                                    _moreDocumentsAvailable) {
                                  setState(() => _showCircularProgress = true);
                                } else {
                                  setState(() => _showCircularProgress = false);
                                }
                              }
                            });

                            return false;
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: GridView.builder(
                                    controller: widget.scrollController,
                                    itemCount: similarProducts.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 2 / 3,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0),
                                    // controller: scrollController,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            SimilarProductsCard(
                                      onTap: () {
                                        MarketBrain.recentlyViewedNeededValues(
                                            commonId:
                                                similarProducts[index].cmId,
                                            storeId: similarProducts[index].id,
                                            condition:
                                                similarProducts[index].cond,
                                            category:
                                                similarProducts[index].prC,
                                            productImg:
                                                similarProducts[index].prImg![0],
                                            productName:
                                                similarProducts[index].prN,
                                            price:
                                                similarProducts[index].price);
                                        Navigator.pushNamed(
                                            context, MarketProductDetails.id);
                                      },
                                      productName: similarProducts[index].prN,
                                      imageUrl: similarProducts[index].prImg![0],
                                      productPrice:
                                          similarProducts[index].price,
                                      productRating:
                                          similarProducts[index].rate,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0),
                                child: _showCircularProgress
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          backgroundColor: kMarketPrimaryColor,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              )
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
