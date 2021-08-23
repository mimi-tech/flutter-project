import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/market/tab_views/important_info.dart';
import 'package:sparks/market/tab_views/product_description.dart';
import 'package:sparks/market/tab_views/product_listing_images.dart';
import 'package:sparks/market/tab_views/product_offer.dart';

import 'package:sparks/market/utilities/market_const.dart';

class MarketProductListing extends StatefulWidget {
  static const id = 'market_product_listing';

  @override
  _MarketProductListingState createState() => _MarketProductListingState();
}

class _MarketProductListingState extends State<MarketProductListing>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          elevation: 5.0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset('images/market_images/market_delivery_cart.svg'),
              SizedBox(
                width: ScreenUtil().setWidth(16),
              ),
              Text(
                'Product Listing',
                style: kMProductListingTextStyle,
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              height: ScreenUtil().setHeight(64),
              width: double.infinity,
              child: Center(
                child: AbsorbPointer(
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: Colors.black,
                    labelColor: Color(0xff08799A),
                    controller: _tabController,
                    isScrollable: true,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 32.0),
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          'IMPORTANT INFO',
                          style: kMProductListingTabTextStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'PRODUCT DESCRIPTION',
                          style: kMProductListingTabTextStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'OFFER',
                          style: kMProductListingTabTextStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'IMAGES',
                          style: kMProductListingTabTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    ImportantInfo(
                      tabController: _tabController,
                    ),
                    ProductDescription(
                      tabController: _tabController,
                    ),
                    ProductOffer(
                      tabController: _tabController,
                    ),
                    ProductListingImages(
                      tabController: _tabController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
