import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';

class SimilarProductsCard extends StatelessWidget {
  final String imageUrl;
  final String? productName;
  final double? productPrice;
  final double? productRating;
  final Function onTap;

  SimilarProductsCard({
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.productRating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 14.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kMarketPrimaryColor,
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: imageUrl,
                  //fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kProductNameMarketExplore,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          productPrice!.toStringAsFixed(2),
                          style: kProductPriceMarketExplore,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: kMarketPrimaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                size: 12.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '$productRating',
                                style: kProductRatingMarketExplore,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
