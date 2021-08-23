import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/market/components/category_nav.dart';
import 'package:sparks/market/components/category_sublist_card.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/products_sublist_data.dart';
import 'package:sparks/market/utilities/strings.dart';
import 'package:sparks/utilities/styles.dart';

class MarketHomeEndDrawer extends StatefulWidget {
  final Function(String) endDrawerCategoryValue;

  const MarketHomeEndDrawer({
    Key? key,
    required this.endDrawerCategoryValue,
  }) : super(key: key);

  @override
  _MarketHomeEndDrawerState createState() => _MarketHomeEndDrawerState();
}

class _MarketHomeEndDrawerState extends State<MarketHomeEndDrawer> {
  List<String> category = [kClothes];

  Map<String, String> testingOne = {};

  void handleCategorySelection(String? selectedCategory) {
    if (!category.contains(selectedCategory)) {
      setState(() {
        category.clear();
        category.add(selectedCategory!);
        subListSelector();
      });
    }
  }

  void handleLabelSublistClick(String labelName) {
    print("LABEL NAME: $labelName");
    print("CATEGORY: ${category[0]}");
  }

  List<Map<String, String>> drawerDefaultCategory = [
    {"label": kClothes, "icon": "clothes_icon"},
    {"label": kBeauty, "icon": "beauty_icon"},
    {"label": kShoes, "icon": "shoes_icon"},
    {"label": kElectronics, "icon": "electronics_icon"},
    {"label": kBooks, "icon": "books_icon"},
    {"label": kStationary, "icon": "stationary_icon"},
  ];

  List<Widget> sublistWidgetBuilder() {
    List<Widget> sublistWidget = [];

    List<Widget> spaceAndDivider = [
      SizedBox(
        height: 24.0,
      ),
      Divider(),
      SizedBox(
        height: 24.0,
      ),
    ];

    for (int i = 0; i < subListSelector().length; i++) {
      List<Widget> tempWidget = [
        CategorySublistCard(
          sublistItems: subListSelector()[i],
          getStringValue: (String listTitleName) {
            // handleLabelSublistClick(listTitleName);
            Navigator.pop(context);
            widget.endDrawerCategoryValue(category[0]);
          },
        ),
      ];

      if (subListSelector().length > 1 && i != (subListSelector().length - 1)) {
        tempWidget.addAll(spaceAndDivider);
      }

      sublistWidget.addAll(tempWidget);
    }

    return sublistWidget;
  }

  /// Method that returns the right "sublist" based on the currently active sublist
  List<Map<String, dynamic>> subListSelector() {
    List<Map<String, dynamic>> sublist = [];

    switch (category[0]) {
      case kClothes:
        sublist = clothSublists;
        break;

      case kBooks:
        sublist = booksSublist;
        break;

      case kBeauty:
        sublist = beautySublists;
        break;

      case kShoes:
        sublist = shoesSublists;
        break;

      case kElectronics:
        sublist = electronicsSublists;
        break;

      case kStationary:
        sublist = stationarySublists;
        break;
    }

    return sublist;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
            color: kMarketDrawerBgColor,
            child: Column(
              children: <Widget>[
                /// Drawer title and "X" button
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        kAllCategories,
                        style: kAllCat,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.clear,
                          size: 32.0,
                          color: kMarketPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Drawer categories
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ...drawerDefaultCategory
                              .map((drawerCategory) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CategoryNav(
                                        onTap: () {
                                          handleCategorySelection(
                                              drawerCategory["label"]);
                                        },
                                        iconText: drawerCategory["label"],
                                        imageURL:
                                            "images/market_images/${drawerCategory["icon"]}.svg",
                                        textStyle:
                                            kTextStyleFont15Bold.copyWith(
                                                fontSize: 17.0,
                                                color: category.contains(
                                                        drawerCategory["label"])
                                                    ? Colors.black
                                                    : Colors.grey),
                                        shadowColor: Color(0xffF24949),
                                        elevation: 8.0,
                                        width: 60.0,
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(40),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 18.0,
                    ),

                    /// Drawer category sublist
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...sublistWidgetBuilder(),
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
    );
  }
}
