import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/market/components/follow_button.dart';
import 'package:sparks/market/components/market_carousel.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/screens/market_comments.dart';
import 'package:sparks/market/screens/market_home.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';

class MarketCard extends StatelessWidget {
  final Function? openExplore;
  final String? commonId;
  final String? productName;
  final String? storeId;
  final String? storeImage;
  final String? storeName;
  final double? storeRating;
  final String? productCondition;
  final String? productCategory;
  final int? following;
  final List<String>? productImages;
  final double? productPrice;
  final int? soldCount;
  final double? productRating;
  final int? productRatingCount;
  final int? productReviewCount;

  final String? docId;

  MarketCard({
    this.openExplore,
    required this.commonId,
    required this.productName,
    required this.storeImage,
    required this.storeName,
    required this.storeId,
    required this.storeRating,
    required this.productCondition,
    required this.productCategory,
    required this.following,
    required this.productImages,
    required this.productPrice,
    required this.soldCount,
    required this.productRating,
    required this.productRatingCount,
    required this.productReviewCount,
    required this.docId,
  });

  final MarketDatabaseService _marketDatabaseService =
      MarketDatabaseService(userId: MarketGlobalVariables.currentUserId);

  /// The product condition passed into [MarketCard] is either "new product"
  /// or "used product" and needs to be converted into either "newProducts"
  /// or "usedProducts" respectively.
  ///
  /// This is so that it can be used to query the appropriate collection
  /// which will bear either of the converted names (i.e. either "newProducts"
  /// or "usedProducts")
  String _prodCondCollectionConverter() {
    String condition;

    if (productCondition == "new product") {
      condition = "newProducts";
    } else {
      condition = "usedProducts";
    }

    return condition;
  }

  /// Function that takes a List of Strings of the image url and return a List of CachedNetworkImages
  List<CachedNetworkImage> cachedProductImages(List<String> images) {
    List<CachedNetworkImage> assets = [];

    for (String image in images) {
      var productAsset = CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            backgroundColor: kMarketPrimaryColor,
            value: progress.progress,
          ),
        ),
        imageUrl: image,
        fit: BoxFit.cover,
      );

      assets.add(productAsset);
    }

    return assets;
  }

  /// Method that returns a String based on the current user's rating of a product
  String? marketReactionButton(int? userRating) {
    String? iconUrl;
    switch (userRating) {
      case 5:
        iconUrl = 'images/market_images/excellent_rating.svg';
        break;
      case 4:
        iconUrl = 'images/market_images/good_rating.svg';
        break;
      case 3:
        iconUrl = 'images/market_images/fair_rating.svg';
        break;
      case 2:
        iconUrl = 'images/market_images/poor_rating.svg';
        break;
      case 1:
        iconUrl = 'images/market_images/bad_rating.svg';
        break;
    }

    return iconUrl;
  }

  String doubleToIntChecker(num value) {
    if (value == value.roundToDouble()) {
      return value.truncate().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }

  /// This Widget method returns the appropriate rating icons for a store
  Widget ratingStarWidget(double? rating) {
    if (rating == 100) {
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating!)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating! >= 90) {
      /// Rating 90 - 99%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_half,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating >= 80) {
      /// Rating 80 - 89%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Color(0xffFF502F),
            size: 16.0,
          ),
          Icon(
            Icons.star,
            color: Color(0xffFF502F),
            size: 16.0,
          ),
          Icon(
            Icons.star,
            color: Color(0xffFF502F),
            size: 16.0,
          ),
          Icon(
            Icons.star,
            color: Color(0xffFF502F),
            size: 16.0,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.0,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating >= 70) {
      /// Rating 70 - 79%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_half,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating >= 60) {
      /// Rating 60 - 69%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating >= 50) {
      /// Rating 50 - 59%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_half,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating >= 40) {
      /// Rating 40 - 49%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating >= 30) {
      /// Rating 30 - 39%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_half,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else if (rating >= 20) {
      /// Rating 20 - 29%
      return Row(
        children: [
          Icon(
            Icons.star,
            color: kMarketPrimaryColor,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16.sp,
          ),
          SizedBox(
            width: ScreenUtil().setWidth(4),
          ),
          Text('${doubleToIntChecker(rating)}% Positive',
              style: kMarketCardContextSecStyle),
        ],
      );
    } else {
      return Text(
        "Not rated yet",
        style: kMarketCardContextSecStyle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Card(
        margin: EdgeInsets.only(bottom: 32.0),
        elevation: 6.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            /// TODO: Navigate to the store's dashboard
                          },
                          child: CircleAvatar(
                            backgroundColor: kMarketPrimaryColor,
                            radius: kMarketSellerCircularAvatar,
                            backgroundImage: CachedNetworkImageProvider(
                              storeImage!,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(8.0),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              storeName!,
                              //marketStoreInstance.username,
                              style: kMarketNameTextStyle,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(8.0),
                            ),

                            /// Widget that displays the store's rating
                            ratingStarWidget(storeRating),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FollowButton(
                            storeId: storeId,
                            storeImgUrl: storeImage,
                            storeName: storeName,
                          ),
                          //marketStoreInstance.followers.length >= 1
                          following! > 0
                              ? Text(
                                  '$following following',
                                  style: kFollowingTextStyle,
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: MarketItemsCarousel(
                images: cachedProductImages(productImages!),
                showIndicator: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end, // May remove
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(72),
                          child: Column(
                            children: [
                              /// Rating block
                              Opacity(
                                opacity: productRatingCount! >= 1 ? 1.0 : 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2.0)),
                                    border: Border.all(
                                        color: Color(0xff707070).withAlpha(179),
                                        style: BorderStyle.solid),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      /// TODO: Product rating count should display in short format (e.g. 100,000 should be 100k)
                                      AutoSizeText(
                                        '${MarketBrain.numberFormatterWithCommaInt(productRatingCount)}/$productRating',
                                        style: kMarketCardContextSecStyle,
                                        maxLines: 1,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: kMarketPrimaryColor,
                                        size: ScreenUtil().setWidth(14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(8),
                              ),

                              /// Reaction and Comment
                              Row(
                                children: [
                                  FlutterReactionButtonCheck(
                                    initialReaction: Reaction(
                                      icon: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("stores")
                                              .doc(storeId)
                                              .collection("userStore")
                                              .doc(
                                                  productCategory!.toLowerCase())
                                              .collection(
                                                  _prodCondCollectionConverter())
                                              .doc(docId)
                                              .collection("productRatings")
                                              .where("id",
                                                  isEqualTo:
                                                      MarketGlobalVariables
                                                          .currentUserId)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return SvgPicture.asset(
                                                'images/market_images/star_outline.svg',
                                                width: 24.0,
                                                height: 24.0,
                                              );
                                            } else if (snapshot.hasData &&
                                                snapshot.connectionState ==
                                                    ConnectionState.active) {
                                              // List<QueryDocumentSnapshot>
                                              //     qDocSnapshot =
                                              //     snapshot.data.docs;

                                              List<Map<String, dynamic>?>
                                                  qDocSnapshot =
                                                  snapshot.data!.docs.map(
                                                      (DocumentSnapshot doc) {
                                                return doc.data
                                                    as Map<String, dynamic>?;
                                              }).toList();
                                              if (qDocSnapshot.length >= 1) {
                                                int? currentUserRating =
                                                    qDocSnapshot[0]!["rate"];
                                                return SvgPicture.asset(
                                                  marketReactionButton(
                                                      currentUserRating)!,
                                                  width: 24.0,
                                                  height: 24.0,
                                                );
                                              } else {
                                                return SvgPicture.asset(
                                                  'images/market_images/star_outline.svg',
                                                  width: 24.0,
                                                  height: 24.0,
                                                );
                                              }
                                            } else {
                                              return SvgPicture.asset(
                                                'images/market_images/star_outline.svg',
                                                width: 24.0,
                                                height: 24.0,
                                              );
                                            }
                                          }),
                                    ),
                                    onReactionChanged:
                                        (reaction, selectedIndex, isChecked) {
                                      int rating = selectedIndex + 1;

                                      _marketDatabaseService.rateProduct(
                                          rating: rating,
                                          storeId: storeId,
                                          prodCategory: productCategory!,
                                          prodCondition: productCondition,
                                          docId: docId);
                                    },
                                    boxRadius: 10.0,
                                    boxColor: Colors.black,
                                    reactions: [
                                      Reaction(
                                        previewIcon: RatingPopUp(
                                          iconURL:
                                              'images/market_images/bad_rating.svg',
                                          iconText: '1',
                                        ),
                                        icon: SvgPicture.asset(
                                          'images/market_images/bad_rating.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                      ),
                                      Reaction(
                                        previewIcon: RatingPopUp(
                                          iconURL:
                                              'images/market_images/poor_rating.svg',
                                          iconText: '2',
                                        ),
                                        icon: SvgPicture.asset(
                                          'images/market_images/poor_rating.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                      ),
                                      Reaction(
                                        previewIcon: RatingPopUp(
                                          iconURL:
                                              'images/market_images/fair_rating.svg',
                                          iconText: '3',
                                        ),
                                        icon: SvgPicture.asset(
                                          'images/market_images/fair_rating.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                      ),
                                      Reaction(
                                        previewIcon: RatingPopUp(
                                          iconURL:
                                              'images/market_images/good_rating.svg',
                                          iconText: '4',
                                        ),
                                        icon: SvgPicture.asset(
                                          'images/market_images/good_rating.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                      ),
                                      Reaction(
                                        previewIcon: RatingPopUp(
                                          iconURL:
                                              'images/market_images/excellent_rating.svg',
                                          iconText: '5',
                                        ),
                                        icon: SvgPicture.asset(
                                          'images/market_images/excellent_rating.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(14),
                                  ),

                                  /// Comment
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.pushNamed(
                                      //     context, MarketComments.id);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MarketComments(
                                            docId: docId,
                                            category: productCategory,
                                            condition: productCondition,
                                            storeId: storeId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.chat_bubble_outline,
                                      color: kMarketDarkIconColor,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: ScreenUtil().setWidth(14),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// Space between "reaction button" & "comment" TO "share button" & "share count"
                        SizedBox(
                          width: ScreenUtil().setWidth(4),
                        ),
                        Container(
                          child: Column(
                            children: [
                              /// TODO: Change "productReviewCount" to "share count ~ shareCount"
                              Opacity(
                                opacity: productReviewCount! >= 1 ? 1.0 : 0.0,
                                child: AutoSizeText(
                                  '${MarketBrain.numberFormatter(productReviewCount)}',
                                  style: kMarketCardContextSecStyle,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Icon(
                                Icons.share,
                                color: kMarketDarkIconColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                productPrice!.toStringAsFixed(2),
                                style: kMarketSellPrice,
                              ),
                            ],
                          ),
                          FlatButton(
                              // padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              onPressed: () {
                                MarketBrain.recentlyViewedNeededValues(
                                  commonId: commonId,
                                  storeId: storeId,
                                  rating: productRating,
                                  condition: productCondition,
                                  category: productCategory,
                                  productImg: productImages![0],
                                  productName: productName,
                                  price: productPrice,
                                  docId: docId,
                                );
                                Navigator.pushNamed(
                                    context, MarketProductDetails.id);
                              },
                              color: Color(0xffFF502F),
                              child: AutoSizeText(
                                'Details',
                                style: kMarketDetails,
                                maxLines: 1,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Column(
                      children: <Widget>[
                        /// Check to see if the product has been sold at least once, then render the appropriate widget
                        soldCount! > 0
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText(
                                  MarketBrain.numberFormatter(soldCount) +
                                      '+ sold',
                                  style: kMarketCardContextSecStyle,
                                  maxLines: 1,
                                ),
                              )
                            : Container(
                                height: ScreenUtil().setHeight(24),
                              ),
                        SizedBox(
                          height: ScreenUtil().setHeight(16),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: openExplore as void Function()?,
                                child: Icon(
                                  Icons.explore,
                                  color: kMarketDarkIconColor,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(10.0),
                              ),
                              GestureDetector(
                                onTap: () {
                                  /*shoppingCart
                                            .addToCartTesting();*/
                                },
                                child: Icon(
                                  Icons.bookmark_border,
                                  color: kMarketDarkIconColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
