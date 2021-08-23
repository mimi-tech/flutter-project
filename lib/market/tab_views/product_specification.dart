import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sparks/market/utilities/market_const.dart';

class ProductSpecification extends StatelessWidget {
  final int currentIndex;

  ProductSpecification({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final productDetailSnapshot = Provider.of<QuerySnapshot>(context);

    String? productBrand;
    for (DocumentSnapshot documentSnapshot in productDetailSnapshot.docs) {
      if (documentSnapshot['prB'] != null) {
        productBrand = documentSnapshot['prB'];
      } else {
        productBrand = 'Not found';
      }
    }

    String? sku;
    if (productDetailSnapshot.docs[currentIndex]['sku'] == null) {
      sku = 'Not Found';
    } else {
      sku = productDetailSnapshot.docs[currentIndex]['sku'];
    }

    String? condition;
    for (DocumentSnapshot documentSnapshot in productDetailSnapshot.docs) {
      if (documentSnapshot['cond'] != null) {
        if (documentSnapshot['cond'] == 'new product') {
          condition = 'Brand New';
        } else {
          condition = 'Used';
        }
      } else {
        condition = 'Not Found';
      }
    }

    String? material;
    if (productDetailSnapshot.docs[currentIndex]['mat'] == null) {
      material = 'Not found';
    } else {
      material = productDetailSnapshot.docs[currentIndex]['mat'];
    }

    String? subCategory;
    for (DocumentSnapshot documentSnapshot in productDetailSnapshot.docs) {
      if (documentSnapshot['subC'] != null) {
        subCategory = documentSnapshot['subC'];
      } else {
        subCategory = 'Not found';
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        children: <Widget>[
          SpecificationComponent(
            leftHeadingText: "BRAND",
            leftBodyText: productBrand,
            rightHeadingText: "SKU",
            rightBodyText: sku,
          ),
          SizedBox(
            height: ScreenUtil().setHeight(16),
          ),
          SpecificationComponent(
            leftHeadingText: "CONDITION",
            leftBodyText: condition,
            rightHeadingText: 'MATERIAL',
            rightBodyText: material,
          ),
          SizedBox(
            height: ScreenUtil().setHeight(16),
          ),
          SpecificationComponent(
            leftHeadingText: "CATEGORY",
            leftBodyText: subCategory,
          ),
        ],
      ),
    );
  }
}

class SpecificationComponent extends StatelessWidget {
  final String leftHeadingText;
  final String? leftBodyText;
  final String? rightHeadingText;
  final String? rightBodyText;

  SpecificationComponent(
      {required this.leftHeadingText,
      required this.leftBodyText,
      this.rightHeadingText,
      this.rightBodyText});

  @override
  Widget build(BuildContext context) {
    if (rightHeadingText == null || rightBodyText == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    leftHeadingText,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: kProductSpecificationHeading.copyWith(
                        color: kMarketSecondaryColor),
                  ),
                  Text(
                    leftBodyText!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: kProductSpecificationBody,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    leftHeadingText,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: kProductSpecificationHeading.copyWith(
                        color: kMarketSecondaryColor),
                  ),
                  Text(
                    leftBodyText!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: kProductSpecificationBody,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    rightHeadingText!,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: kProductSpecificationHeading.copyWith(
                      color: kMarketSecondaryColor,
                    ),
                  ),
                  Text(
                    rightBodyText!,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: kProductSpecificationBody,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
