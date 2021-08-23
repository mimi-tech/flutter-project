import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sparks/market/components/bottom_appbar_full.dart';
import 'package:sparks/market/components/market_appbar.dart';
import 'package:sparks/market/components/market_bottom_appbar_with_end_dock.dart';
import 'package:sparks/market/market_models/Item.dart';
import 'package:sparks/market/providers/shopping_cart.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/market_mixin.dart';

enum DeleteProdFromCart {
  yes,
}

class ShoppingCartScreen extends StatefulWidget {
  static String id = "shopping_cart_screen";
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with MarketMixin {
  DeleteProdFromCart? _deleteProdFromCart;

  ScrollController? _scrollController;

  final checkOutTextStyleWhite = GoogleFonts.rajdhani(
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    color: Colors.white,
  );

  final checkOutTextStyleColored = GoogleFonts.rajdhani(
    fontWeight: FontWeight.w500,
    fontSize: ScreenUtil().setSp(14),
    color: Color(0xffFE7B62),
  );

  void verifyItemsBasePriceAndStock(List<Item> items) async {
    for (int i = 0; i < items.length; i++) {
      try {
        await FirebaseFirestore.instance
            .collectionGroup("variations")
            .where("sku", isEqualTo: items[i].sku)
            .get();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final shoppingCart = Provider.of<ShoppingCart>(context);

    /// This code is to verifies the stock left of the product AND that the base price of the item has not changed
    for (int i = 0; i < shoppingCart.items.length; i++) {
      FirebaseFirestore.instance
          .collectionGroup("variations")
          .where("sku", isEqualTo: shoppingCart.items[i]!.sku)
          .get()
          .then((value) {
        print("update stock and base price working");
        int? stock = value.docs[0]["stock"];
        double? basePrice = value.docs[0]["price"];
        shoppingCart.updateItemStockAndBasePrice(i, stock, basePrice);
        print("update successful");
      }).catchError((onError) {
        print(onError);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    final shoppingCart = Provider.of<ShoppingCart>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF5F6F8),
        body: NestedScrollView(
          controller: _scrollController,
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
                top: 80.0, left: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Cart",
                  style: GoogleFonts.rajdhani(
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 16.0),
                      controller: _scrollController,
                      itemCount: shoppingCart.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        print("INDEX: $index");
                        return Column(
                          children: [
                            Row(
                              children: [
                                /// Circle Widget for the product image
                                GestureDetector(
                                  onTap: () {
                                    MarketBrain.recentlyViewedNeededValues(
                                        commonId:
                                            shoppingCart.items[index]!.cmId,
                                        condition:
                                            shoppingCart.items[index]!.cond);

                                    // MarketGlobalVariables.productCondition =
                                    //     shoppingCart.items[index].cond;
                                    // MarketGlobalVariables.commonId =
                                    //     shoppingCart.items[index].cmId;

                                    Navigator.pushNamed(
                                        context, MarketProductDetails.id);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: CachedNetworkImage(
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: kMarketPrimaryColor,
                                          value: progress.progress,
                                        ),
                                      ),
                                      imageUrl:
                                          shoppingCart.items[index]!.imgUrl!,
                                      width: ScreenUtil().setWidth(112),
                                      height: ScreenUtil().setHeight(112),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20),
                                ),

                                /// Widget for the product details
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Product name
                                      Text(
                                        shoppingCart.items[index]!.name ??
                                            "...",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rajdhani(
                                            color: kMarketSecondaryColor,
                                            fontSize: ScreenUtil().setSp(15),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(4),
                                      ),
                                      Text(
                                        "Color",
                                        style: GoogleFonts.rajdhani(
                                            color: kMarketSecondaryColor,
                                            fontSize: ScreenUtil().setSp(15),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(10),
                                      ),

                                      /// Product price
                                      Text(
                                        "${numberFormatterWithComma(shoppingCart.items[index]!.price!.toStringAsFixed(2))}",
                                        style: GoogleFonts.rajdhani(
                                            color: kMarketPrimaryColor,
                                            fontSize: ScreenUtil().setSp(15),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(10),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          /// Decrease product quantity button
                                          TextButton(
                                            onPressed: () {
                                              shoppingCart
                                                  .decreaseQuantityCount(
                                                      index,
                                                      shoppingCart
                                                          .items[index]!.sku);
                                            },
                                            style: ButtonStyle(
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      Size(8.0, 8.0)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.all(2.0)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffDBDEE3)),
                                              shape: MaterialStateProperty.all(
                                                  CircleBorder()),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: Color(0xff727C8E),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(16),
                                          ),
                                          Text(
                                            "${shoppingCart.items[index]!.quantity}",
                                            style: GoogleFonts.rajdhani(
                                              fontWeight: FontWeight.w600,
                                              fontSize: ScreenUtil().setSp(15),
                                              color: Color(0xff727C8E),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(16),
                                          ),

                                          /// Increase product quantity button
                                          TextButton(
                                            onPressed: () {
                                              if (shoppingCart
                                                      .items[index]!.quantity <
                                                  shoppingCart
                                                      .items[index]!.stock!) {
                                                shoppingCart
                                                    .increaseQuantityCount(
                                                        index,
                                                        shoppingCart
                                                            .items[index]!.sku);
                                              }
                                            },
                                            style: ButtonStyle(
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      Size(8.0, 8.0)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.all(2.0)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffDBDEE3)),
                                              shape: MaterialStateProperty.all(
                                                  CircleBorder()),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Color(0xff727C8E),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(28),
                                          ),
                                          PopupMenuButton<DeleteProdFromCart>(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.more_horiz),
                                            onSelected:
                                                (DeleteProdFromCart result) {
                                              print("Something");
                                              setState(() {
                                                _deleteProdFromCart = result;
                                              });

                                              if (_deleteProdFromCart ==
                                                  DeleteProdFromCart.yes) {
                                                shoppingCart.removeItem(
                                                    shoppingCart.items[index]);
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) => <
                                                    PopupMenuEntry<
                                                        DeleteProdFromCart>>[
                                              const PopupMenuItem<
                                                  DeleteProdFromCart>(
                                                height: 24.0,
                                                value: DeleteProdFromCart.yes,
                                                child: Text("Delete"),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(10),
                                      ),
//                                Container(
//                                  height: 2.0,
//                                  width: mediaQuery.width * 0.56,
//                                  color: Color(0xffE8EAED),
//                                ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 2.0,
                                width: index + 1 == shoppingCart.items.length
                                    ? mediaQuery.width
                                    : mediaQuery.width * 0.52,
                                color: Color(0xffE8EAED),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(40),
                            ),
                          ],
                        );
                      }),
                ),
                Center(
                  child: Text(
                    "TOTAL",
                    style: GoogleFonts.rajdhani(
                        fontSize: ScreenUtil().setSp(26),
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// Widget for product quantity
                        Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("${shoppingCart.numOfItems}",
                                  style: checkOutTextStyleWhite),
                              SizedBox(
                                height: ScreenUtil().setHeight(4),
                              ),
                              Text("Quantity", style: checkOutTextStyleColored),
                            ],
                          ),
                          height: mediaQuery.height * 0.1,
                          width: mediaQuery.width * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10.0),
                            ),
                            color: Color(0xff700000),
                          ),
                        ),

                        /// Widget for checkout
                        Container(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(4),
                              ),
                              Text("CHECKOUT", style: checkOutTextStyleWhite),
                            ],
                          ),
                          height: mediaQuery.height * 0.1,
                          width: mediaQuery.width * 0.32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10.0)),
                            color: kMarketPrimaryColor,
                          ),
                        ),
                      ],
                    ),

                    /// Widget for the total price
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            "${numberFormatterWithComma(shoppingCart.totalPrice.toStringAsFixed(2))}",
                            style: checkOutTextStyleWhite),
                        height: mediaQuery.height * 0.1,
                        width: mediaQuery.width * 0.34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: Color(0xffA60F00),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppbarFull(),
      ),
    );
  }
}
