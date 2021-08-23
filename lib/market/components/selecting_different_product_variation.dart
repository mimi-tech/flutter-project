import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/market_mixin.dart';

class SelectingDifferentProductVariation extends StatefulWidget {
  final Function currentVariationIndex;

  SelectingDifferentProductVariation({required this.currentVariationIndex});
  @override
  _SelectingDifferentProductVariationState createState() =>
      _SelectingDifferentProductVariationState();
}

class _SelectingDifferentProductVariationState
    extends State<SelectingDifferentProductVariation> with MarketMixin {
  /// The String representation of the active selected cloth size
  String? activeClothSize;

  /// List of string containing the currently selected product color
  ///
  /// NOTE: This List will only ever contain one item. Refer to the [_handleColorSelection] function.
  List<String> activeProductColor = [];

  /// List containing the strings of the different cloth size pertaining to the product
  ///
  /// NOTE: This list is unsorted
  List<String?> clothSizesUnsorted = [];

  /// Sorted duplicate list of the [clothSizesUnsorted]
  List<String> clothSizes = [];

  HashSet<String?> availableSizesForSelectedColor = new HashSet<String?>();

  /// Function to update the active cloth size
  ///
  /// NOTE: Also updates the size for the Market Global Variable
  void _handleActiveClothSize(String? newClothSize) {
    setState(() {
      activeClothSize = newClothSize;
      MarketGlobalVariables.activeClothSize = activeClothSize;
    });
  }

  /// This function handles color selection
  void _handleColorSelection(int? selectedColor) {
    setState(() {
      if (activeProductColor.contains(selectedColor.toString())) {
        activeProductColor
            .retainWhere((e) => e.contains(selectedColor.toString()));
        MarketGlobalVariables.activeClothColor =
            int.parse(activeProductColor[0]);
      } else {
        activeProductColor.clear();
        activeProductColor.add(selectedColor.toString());
        MarketGlobalVariables.activeClothColor =
            int.parse(activeProductColor[0]);
      }
    });
  }

  void _availableProducts(QuerySnapshot snapshot) {
    availableSizesForSelectedColor.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i]['cCol'] == int.parse(activeProductColor[0])) {
        availableSizesForSelectedColor.add(snapshot.docs[i]['cSize']);
        print("Available Sizes: $availableSizesForSelectedColor");
      }
    }
  }

  @override
  void initState() {
    final productDetailSnapshot =
        Provider.of<QuerySnapshot>(context, listen: false);

    for (DocumentSnapshot size in productDetailSnapshot.docs) {
      if (size['cSize'] != null &&
          !clothSizesUnsorted.contains(size['cSize'])) {
        clothSizesUnsorted.add(size['cSize']);
      }
    }

    /// Method to sort the cloth sizes
    List<String> customClothSizeSorting(List<String?> list) {
      List<String> sortedList = [];

      List<String> clothSortingPattern = [
        "XS",
        "S",
        "M",
        "L",
        "2XL",
        "3XL",
        "4XL",
        "5XL"
      ];

      for (int i = 0; i < clothSortingPattern.length; i++) {
        if (list.contains(clothSortingPattern[i])) {
          sortedList.add(clothSortingPattern[i]);
        }
      }

      return sortedList;
    }

    clothSizes = customClothSizeSorting(clothSizesUnsorted);

    _handleColorSelection(MarketGlobalVariables.activeClothColor);

    _handleActiveClothSize(MarketGlobalVariables.activeClothSize);

    for (int i = 0; i < productDetailSnapshot.docs.length; i++) {
      if (productDetailSnapshot.docs[i]['cCol'] ==
          int.parse(activeProductColor[0])) {
        availableSizesForSelectedColor
            .add(productDetailSnapshot.docs[i]['cSize']);
      }
    }

    print("Available Sizes: $availableSizesForSelectedColor");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productDetailSnapshot = Provider.of<QuerySnapshot>(context);

    List<int?> colorVariations = [];

    for (DocumentSnapshot color in productDetailSnapshot.docs) {
      if (color['cCol'] != null && !colorVariations.contains(color['cCol'])) {
        colorVariations.add(color['cCol']);
      }
    }

    void rightActiveClothColorToClothSize(int color) {
      bool matchFound = false;
      for (int i = 0; i < productDetailSnapshot.docs.length; i++) {
        if (productDetailSnapshot.docs[i]['cSize'] == activeClothSize &&
            productDetailSnapshot.docs[i]['cCol'] == color) {
          _handleActiveClothSize(productDetailSnapshot.docs[i]['cSize']);
          matchFound = true;
        }
      }

      if (!matchFound) {
        print("This was called");
        for (int i = 0; i < productDetailSnapshot.docs.length; i++) {
          if (productDetailSnapshot.docs[i]['cCol'] == color) {
            _handleActiveClothSize(productDetailSnapshot.docs[i]['cSize']);
            matchFound = false;
          }
        }
      }

      _availableProducts(productDetailSnapshot);
    }

    void rightActiveClothSizeToClothColor(String? cSize) {
      int? newIndex;

      bool match = false;

      for (int i = 0; i < productDetailSnapshot.docs.length; i++) {
        if (productDetailSnapshot.docs[i]['cSize'] == cSize &&
            productDetailSnapshot.docs[i]['cCol'] ==
                int.parse(activeProductColor[0])) {
          newIndex = productDetailSnapshot.docs[i]["cCol"];
          _handleColorSelection(newIndex);
          setState(() {
            match = true;
          });
        }
      }

      if (!match) {
        for (int i = 0; i < productDetailSnapshot.docs.length; i++) {
          Map<String, dynamic> data =
              productDetailSnapshot.docs[i].data() as Map<String, dynamic>;
          if (data['cSize'] == cSize) {
            newIndex = data['cCol'];
            _handleColorSelection(newIndex);
          }
        }
      }

      _availableProducts(productDetailSnapshot);
    }

    void toggleVariationIndex() {
      int? variationIndex;

      for (int i = 0; i < productDetailSnapshot.docs.length; i++) {
        Map<String, dynamic> data =
            productDetailSnapshot.docs[i].data() as Map<String, dynamic>;
        if (data['cCol'] == int.parse(activeProductColor[0]) &&
            data['cSize'] == activeClothSize) {
          variationIndex = i;
        }
      }

      widget.currentVariationIndex(variationIndex);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //getColorVariations(colorVariations),
          Text(
            'SELECT COLOR',
            style: GoogleFonts.rajdhani(
              fontSize: ScreenUtil().setSp(15),
              fontWeight: FontWeight.w600,
              color: Color(0xffFFC8BC),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(72),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colorVariations.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _handleColorSelection(colorVariations[index]);
                      rightActiveClothColorToClothSize(
                          int.parse(activeProductColor[0]));
                      toggleVariationIndex();
                      print("Active Product Color: $activeProductColor");

                      //_toggleVariation(index);
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Color(colorVariations[index]!),
                      child: activeProductColor
                              .contains(colorVariations[index].toString())
                          ? Icon(
                              Icons.done,
                              size: 32.0,
                              color: getContrastingColorFromInt(
                                  colorVariations[index]!),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(28),
          ),
          Text(
            'SELECT SIZE',
            style: GoogleFonts.rajdhani(
              fontSize: ScreenUtil().setSp(15),
              fontWeight: FontWeight.w600,
              color: Color(0xffFFC8BC),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(44),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: clothSizes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ChoiceChip(
                    label: Text(
                      clothSizes[index],
                      style: GoogleFonts.rajdhani(
                        color: clothSizes[index] == activeClothSize
                            ? Colors.black
                            : kMarketSecondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    selected: clothSizes[index] == activeClothSize,
                    selectedColor: Color(0xffFE7B62),
                    backgroundColor: !availableSizesForSelectedColor
                            .contains(clothSizes[index])
                        ? Colors.grey[320]
                        : Colors.white,
                    elevation: !availableSizesForSelectedColor
                            .contains(clothSizes[index])
                        ? 0.0
                        : 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                    onSelected: (bool selected) {
                      _handleActiveClothSize(clothSizes[index]);
//                        setState(() {
//                          activeClothSize = clothSizes[index];
//                        });
                      rightActiveClothSizeToClothColor(activeClothSize);
                      toggleVariationIndex();
                      // _toggleVariation(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
