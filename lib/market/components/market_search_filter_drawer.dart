import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/market/market_services/market_keywords.dart';
import 'package:sparks/market/utilities/category_enum.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/strings.dart';
import 'package:sparks/market/utilities/market_filter_lists.dart';

/// TODO: Remove this enum. Might be no longer in use
enum Category {
  defaultCat,
  clothes,
  laptops,
  books,
  phones,
}

class MarketSearchFilterDrawer extends StatefulWidget {
  final VoidCallback applyFilter;

  MarketSearchFilterDrawer({
    required this.applyFilter,
  });

  @override
  _MarketSearchFilterDrawerState createState() =>
      _MarketSearchFilterDrawerState();
}

class _MarketSearchFilterDrawerState extends State<MarketSearchFilterDrawer> {
  /// TODO: Abstract the filter design into a separate class to make the code more concise.
  /// The class should be built with the class having the 'condition' & 'price range' pre-built in
  ///
  /// Then the rest of the parameters for the filter will be passed in from the class constructor (a Widget) in a [Column]
  /// Widget set up in the class
  ///
  /// The Widget will also have parameters to customise the value of the data that will be passed in
  /// Parameters to be passed in includes:
  ///
  /// Filter title (e.g. 'Price Range')
  /// Value for the [DropDownButton] e.g. 'Any'
  /// And the [List<String>] of the [DropDownMenuItems]

  // Category _cate = Category.defaultCat;

  CategoryEnum _categoryEnum = CategoryEnum.defaultCat;

  /// FocusNodes for the 'min price' & 'max price' TextFields
  /// TODO: Remove focus nodes if not necessary
  final FocusNode _minPriceFocusNode = FocusNode();
  final FocusNode _maxPriceFocusNode = FocusNode();

  List<String> victorBoss = [];

  bool _isCustomFilterAvailable = false;

  /// This is the variable where the product category is stored when there's a
  /// custom filter available from search result.
  ///
  /// NOTE: The value is assigned in the [singleSelector] method
  String? _customFilterProductCategory = "";

  /// The dynamic minimum and maximum values for the price
  /// These values are also on display as formatted text (0 - 1,000,000) on the
  /// "Price Range" in the search filter
  ///
  /// These are the RangeValues for the RangeSlider Widget
  double? _lowPriceRange;
  double? _highPriceRange;

  /// The minimum and maximum values allowed for the price input
  double minRangeSliderValue = 0.0;
  double maxRangeSliderValue = 1000000.0;

  /// Default List of Strings for the Condition filter
  String? _condition;
  List<String> _conditionList = [
    'Any',
    'New',
    'Used',
  ];

  /// Default String and List of Strings for the Category filter
  String? _category;
  List<String> _categoryList = [
    'Any',
    'Books',
    'Clothes',
    'Laptops',
    'Phones',
  ];

  /// TextEditing Controller for the 'MIN' & 'MAX' TextFields
  TextEditingController? _minTextController;
  TextEditingController? _maxTextController;

  /// Boolean validator for 'MIN' and 'MAX' price TextFields
  bool isMinValid = true;
  bool isMaxValid = true;

  /// This function sets the default config for the search parameters
  ///
  /// Note: This function is called in the "initState"
  void setDefaultValuesOfFilterParams() {
    setState(() {
      _condition = MarketGlobalVariables.searchCondition;
      _category = MarketGlobalVariables.searchCategory;

      if (_minTextController!.text.trim() == null ||
          _minTextController!.text.trim() == "") {
        _lowPriceRange = 0;
      } else {
        _lowPriceRange = double.parse(_minTextController!.text.trim());
      }

      if (_maxTextController!.text.trim() == null ||
          _maxTextController!.text.trim() == "") {
        _highPriceRange = 1000000;
      } else {
        _highPriceRange = double.parse(_maxTextController!.text.trim());
      }
    });
  }

  /// Resets recurring common values back to the default values (Default Filter)
  void resetRecurringFilterValues() {
    setState(() {
      _condition = "Any";
      MarketGlobalVariables.searchCondition = "Any";
      _category = "Any";
      MarketGlobalVariables.searchCategory = "Any";
      _minTextController!.clear();
      _maxTextController!.clear();
      MarketGlobalVariables.filterMinPrice = "";
      MarketGlobalVariables.filterMaxPrice = "";
      MarketGlobalVariables.searchMinPrice = 0;
      MarketGlobalVariables.searchMaxPrice = 1000000;
      _lowPriceRange = 0;
      _highPriceRange = 1000000;
    });
  }

  /// Resets the filter parameters back to the default values based on the category
  /// of the searched word
  void reSetFilterValues() {
    if (_categoryEnum == CategoryEnum.clothes) {
      resetRecurringFilterValues();
      setState(() {
        MarketFilterLists.clothingDepartment = 'Any';
        MarketFilterLists.clothSizes = 'Any';
      });
    } else if (_categoryEnum == CategoryEnum.laptops) {
      resetRecurringFilterValues();
      setState(() {
        MarketFilterLists.laptopRAMCapacity = 'Any';
        MarketFilterLists.operatingSys = 'Any';
        MarketFilterLists.comGraphicsProcessor = 'Any';
        MarketFilterLists.comProcessorType = 'Any';
      });
    } else if (_categoryEnum == CategoryEnum.phones) {
      resetRecurringFilterValues();
      setState(() {
        MarketFilterLists.phoneOperatingSys = 'Any';
        MarketFilterLists.phoneInternalStorage = 'Any';
        MarketFilterLists.phoneDisplaySize = 'Any';
      });
    } else {
      resetRecurringFilterValues();
    }
  }

  @override
  void initState() {
    super.initState();

    _minTextController =
        TextEditingController(text: MarketGlobalVariables.filterMinPrice);
    _maxTextController =
        TextEditingController(text: MarketGlobalVariables.filterMaxPrice);

    setDefaultValuesOfFilterParams();

    // sortingAlphabetically()
  }

  @override
  void dispose() {
    _minTextController!.dispose();
    _maxTextController!.dispose();

    super.dispose();
  }

  /// Condition widget present in every category in the search filter
  Widget conditionWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(128),
            child: Text(
              'Condition',
              style: kMSearchDrawerTextStyle,
            ),
          ),
          Spacer(),
          DropdownButton<String>(
            value: _condition,
            underline: Container(),
            icon: SvgPicture.asset(
              'images/market_images/circle_arrow.svg',
              width: 18.0,
            ),
            onChanged: (String? newValue) {
              setState(() => _condition = newValue);
            },
            items: _conditionList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: SizedBox(
                  width: ScreenUtil().setWidth(80),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: kMSearchDrawerTextStyle,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Expansion widget for the 'price range' present in every category in the search filter
  Widget priceExpandedWidget() {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Price Range',
            style: kMSearchDrawerTextStyle,
          ),
          Text(
            '${MarketBrain.numberFormatterWithCommaDouble(_lowPriceRange!)} - ${MarketBrain.numberFormatterWithCommaDouble(_highPriceRange!)}',
            style: kMSearchDrawerTextStyle,
          ),
        ],
      ),
      trailing: SvgPicture.asset(
        'images/market_images/circle_arrow.svg',
        width: 18.0,
      ),
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// TextField for the 'MIN' price input field
                Flexible(
                  child: Container(
                    width: ScreenUtil().setWidth(96),
                    child: TextField(
                      controller: _minTextController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: kMSearchDrawerTextStyle,
                      keyboardType: TextInputType.number,
                      focusNode: _minPriceFocusNode,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kMarketPrimaryColor),
                        ),
                        hintText: 'MIN',
                        hintStyle: kMSearchDrawerTextStyle,
                      ),
                      onSubmitted: (value) {
                        _minPriceFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_maxPriceFocusNode);
                      },
                      onChanged: (value) {
                        if (value == null || value == '') {
                          setState(() {
                            _lowPriceRange = minRangeSliderValue;
                          });
                        } else if (double.parse(value) <= maxRangeSliderValue &&
                            double.parse(value) >= minRangeSliderValue &&
                            double.parse(value) <= _highPriceRange!) {
                          setState(() {
                            _lowPriceRange = double.parse(value);
                          });
                        } else {
                          setState(() {
                            _lowPriceRange = minRangeSliderValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(44),
                ),

                /// TextField for the 'MAX' price input field
                Flexible(
                  child: Container(
                    width: ScreenUtil().setWidth(96),
                    child: TextField(
                      controller: _maxTextController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: kMSearchDrawerTextStyle,
                      keyboardType: TextInputType.number,
                      focusNode: _maxPriceFocusNode,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kMarketPrimaryColor),
                        ),
                        hintText: 'MAX',
                        hintStyle: kMSearchDrawerTextStyle,
                        errorText: isMaxValid ? null : 'Shit not working',
                      ),
                      onSubmitted: (value) {
                        _maxPriceFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        if (value == null || value == '') {
                          setState(() {
                            _highPriceRange = maxRangeSliderValue;
                          });
                        } else if (double.parse(value) <= maxRangeSliderValue &&
                            double.parse(value) >= minRangeSliderValue &&
                            double.parse(value) >= _lowPriceRange!) {
                          setState(() {
                            _highPriceRange = double.parse(value);
                          });
                        } else {
                          setState(() {
                            _highPriceRange = maxRangeSliderValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            /// RangeSlider for the 'Price Range'
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RangeSlider(
                activeColor: kMarketSecondaryColor,
                inactiveColor: Color(0xffB9BEC5),
                values: RangeValues(_lowPriceRange!, _highPriceRange!),
                divisions: 50,
                onChanged: (RangeValues values) {
                  setState(() {
                    _lowPriceRange = values.start.roundToDouble();
                    _highPriceRange = values.end.roundToDouble();
                    _minTextController!.text = values.start.toInt().toString();
                    _maxTextController!.text = values.end.toInt().toString();
                  });
                },
                min: minRangeSliderValue,
                max: maxRangeSliderValue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// DropDownButton Hint Widget
  // Widget dropDownButtonHint() {
  //   return SizedBox(
  //     width: ScreenUtil().setWidth(100),
  //     child: Text(
  //       'Select',
  //       textAlign: TextAlign.center,
  //       style: kMSearchDrawerTextStyle.copyWith(color: Colors.grey),
  //     ),
  //   );
  // }

  /// Default Search Filter
  Widget defaultSearchFilter() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /// Dropdown menu for 'Condition'
              conditionWidget(),
              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),

              /// Dropdown for 'Category'
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Category',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: _category,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() => _category = newValue);
                      },
                      items: _categoryList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(80),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: kMSearchDrawerTextStyle,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// ExpansionTile for price input
              priceExpandedWidget(),

              /// Dropdown for 'Department'
            ],
          ),
        ),
      ),
    );
  }

  /// Search filter for 'Clothing'
  Widget clothingSearchFilter() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              conditionWidget(),
              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),
              priceExpandedWidget(),

              /// Widget for 'cloth department'
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Department',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.clothingDepartment,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() =>
                            MarketFilterLists.clothingDepartment = newValue);
                      },
                      items: MarketFilterLists.clothingDepartmentList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: Text(
                              value,
                              style: kMSearchDrawerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Widget for 'cloth sizes'
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Size',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.clothSizes,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() => MarketFilterLists.clothSizes = newValue);
                      },
                      items: MarketFilterLists.clothSizesList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: Text(
                              value,
                              style: kMSearchDrawerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
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

  /// Search filter for 'Laptop'
  Widget laptopSearchFilter() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /// Widget for the 'condition' filter
              conditionWidget(),

              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),

              /// Widget for the 'Price Range' filter
              priceExpandedWidget(),

              /// RAM capacity filter option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'RAM Capacity',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.laptopRAMCapacity,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() =>
                            MarketFilterLists.laptopRAMCapacity = newValue);
                      },
                      items: MarketFilterLists.laptopRAMCapacityList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: Text(
                              value,
                              style: kMSearchDrawerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Operating system filter option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'OS',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.operatingSys,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(
                            () => MarketFilterLists.operatingSys = newValue);
                      },
                      items: MarketFilterLists.operatingSysList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setHeight(120),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: kMSearchDrawerTextStyle,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Graphics processor filter option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Graphics Processor',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.comGraphicsProcessor,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() =>
                            MarketFilterLists.comGraphicsProcessor = newValue);
                      },
                      items: MarketFilterLists.comGraphicsProcessorList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: Text(
                              value,
                              style: kMSearchDrawerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Processor filter option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Processor',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.comProcessorType,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() =>
                            MarketFilterLists.comProcessorType = newValue);
                      },
                      items: MarketFilterLists.comProcessorTypeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: Text(
                              value,
                              style: kMSearchDrawerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
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

  /// Search filter for 'Phone'
  Widget phoneSearchFilter() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /// Widget for the 'condition' filter
              conditionWidget(),

              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),

              /// Widget for the 'Price Range' filter
              priceExpandedWidget(),

              /// Phone Operating System
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Operating System',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.phoneOperatingSys,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() =>
                            MarketFilterLists.phoneOperatingSys = newValue);
                      },
                      items: MarketFilterLists.phoneOperatingSysList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: Text(
                              value,
                              style: kMSearchDrawerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Phone Internal Storage Memory
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Internal Storage',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.phoneInternalStorage,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() =>
                            MarketFilterLists.phoneInternalStorage = newValue);
                      },
                      items: MarketFilterLists.phoneInternalStorageList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setHeight(120),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: kMSearchDrawerTextStyle,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Phone Display Sizes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(128),
                      child: Text(
                        'Display Size',
                        style: kMSearchDrawerTextStyle,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: MarketFilterLists.phoneDisplaySize,
                      underline: Container(),
                      icon: SvgPicture.asset(
                        'images/market_images/circle_arrow.svg',
                        width: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() =>
                            MarketFilterLists.phoneDisplaySize = newValue);
                      },
                      items: MarketFilterLists.phoneDisplaySizeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(120),
                            child: Text(
                              value,
                              style: kMSearchDrawerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
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

  /// TODO: Remove this method if no longer in use
  /// Widget with conditions that determines which filter will be displayed
  // Widget filterSelectorOld() {
  //   if (MarketKeywords.clothingKeyWords
  //       .contains(MarketGlobalVariables.searchedWord)) {
  //     _cate = Category.clothes;
  //     return clothingSearchFilter();
  //   } else if (MarketKeywords.laptopKeyWords
  //       .contains(MarketGlobalVariables.searchedWord)) {
  //     _cate = Category.laptops;
  //     return laptopSearchFilter();
  //   } else if (MarketKeywords.phoneKeyWords
  //       .contains(MarketGlobalVariables.searchedWord)) {
  //     _cate = Category.phones;
  //     return phoneSearchFilter();
  //   } else {
  //     return defaultSearchFilter();
  //   }
  // }

  /// This method uses the "category" argument to return the right custom filter
  /// in the search drawer to the user
  Widget singleSelector(String? category) {
    Widget filter;
    switch (category) {
      case "Clothes":
        _categoryEnum = CategoryEnum.clothes;
        filter = clothingSearchFilter();
        break;
      case "Laptops":
        _categoryEnum = CategoryEnum.laptops;
        filter = laptopSearchFilter();
        break;
      case "Phones":
        _categoryEnum = CategoryEnum.phones;
        filter = phoneSearchFilter();
        break;
      default:
        _categoryEnum = CategoryEnum.defaultCat;
        filter = defaultSearchFilter();
    }

    _customFilterProductCategory = category;
    return filter;
  }

  /// This Widget algorithm uses the Map value(s) of [MarketGlobalVariables.searchedFilterCategory]
  /// to determine which custom filter should be made visible to the user
  ///
  /// If the [MarketGlobalVariables.searchedFilterCategory] length is equal to 1,
  /// it's ensuring key is passed to the [singleSelector] which then proceeds to
  /// return the appropriate custom filter widget to the user. Also the
  /// [_isCustomFilterAvailable] is set to "true" to notify the [MarketSearch] that
  /// a tailored filter is available for the user
  ///
  /// In the event that the [MarketGlobalVariables.searchedFilterCategory] length is
  /// greater than "1" the "else-block" runs with its proceeding logic, if at
  /// least two categories occurred the same number of times in
  /// [MarketGlobalVariables.searchedFilterCategory] the [defaultSearchFilter] is
  /// returned and the [_isCustomFilterAvailable] is set to "false".
  /// Else, the category with the highest number of occurrence is passed to the
  /// [singleSelector] and the appropriate custom filter returned.
  ///
  /// NOTE: The [_isCustomFilterAvailable] only comes to effect when the user
  /// clicks on the "Apply Filter" button.
  ///
  Widget filterSelector() {
    if (MarketGlobalVariables.searchedFilterCategory?.isEmpty ?? true) {
      _isCustomFilterAvailable = false;
      return defaultSearchFilter();
    } else if (MarketGlobalVariables.searchedFilterCategory!.length == 1) {
      _isCustomFilterAvailable = true;
      return singleSelector(
          MarketGlobalVariables.searchedFilterCategory!.keys.first);
    } else {
      HashSet<int> unique = new HashSet<int>.from(
          MarketGlobalVariables.searchedFilterCategory!.values.toList());

      late MapEntry<String?, int> filterCategory;

      if (unique.length ==
          MarketGlobalVariables.searchedFilterCategory!.length) {
        _isCustomFilterAvailable = true;
        List<int> mappedValues =
            MarketGlobalVariables.searchedFilterCategory!.values.toList();

        int? highestCategoryOccurrence;
        int pointer = 0;

        while (pointer < mappedValues.length - 1) {
          for (int i = 1; i < mappedValues.length; i++) {
            if (mappedValues[pointer] > mappedValues[i]) {
              highestCategoryOccurrence = mappedValues[pointer];
              pointer++;
            } else {
              highestCategoryOccurrence = mappedValues[i];
              pointer++;
            }
          }
        }
        filterCategory = MarketGlobalVariables.searchedFilterCategory!.entries
            .firstWhere(
                (element) => element.value == highestCategoryOccurrence);
      } else {
        // MarketGlobalVariables.isCustomFilterAvailable = false;
        _isCustomFilterAvailable = false;
      }
      return unique.length ==
              MarketGlobalVariables.searchedFilterCategory!.length
          ? singleSelector(filterCategory.key)
          : defaultSearchFilter();
    }
  }

//  void sortingAlphabetically() {
//    MarketGlobalVariables.commonWordsHashSet.forEach((element) {
//      victorBoss.add(element);
//    });
//    victorBoss.sort((String a, String b) => a.compareTo(b));
//    victorBoss.forEach((element) {
//      print(element);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    // _categoryList.sort((String a, String b) => a.compareTo(b));

    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: Drawer(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: 56.0,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                kMSRefine,
                                style: kMSearchDrawerTextStyle,
                              ),
                              InkWell(
                                onTap: () {
                                  reSetFilterValues();
                                },
                                child: Text(
                                  kMSClear,
                                  style: kMSearchDrawerTextStyle.copyWith(
                                      color: kMarketPrimaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      filterSelector(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: FlatButton(
                    onPressed: () {
                      MarketGlobalVariables.searchCondition = _condition;
                      MarketGlobalVariables.filterMinPrice =
                          _minTextController!.text.trim();
                      MarketGlobalVariables.searchMinPrice = _lowPriceRange;

                      MarketGlobalVariables.filterMaxPrice =
                          _maxTextController!.text.trim();
                      MarketGlobalVariables.searchMaxPrice = _highPriceRange;

                      MarketGlobalVariables.isCustomFilterAvailable =
                          _isCustomFilterAvailable;

                      /// If a custom filter is available, then the value of the static variable
                      /// [MarketGlobalVariables.searchCategory] is set from [_customFilterProductCategory]
                      ///
                      /// Else the value of [MarketGlobalVariables.searchCategory] is set from [_category]
                      /// which derives is value from the category selected from the default filter
                      if (_isCustomFilterAvailable) {
                        MarketGlobalVariables.searchCategory =
                            _customFilterProductCategory;
                      } else {
                        MarketGlobalVariables.searchCategory = _category;
                      }

                      widget.applyFilter();

                      Navigator.pop(context);
                    },
                    color: kMarketPrimaryColor,
                    padding: EdgeInsets.all(6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: ScreenUtil().setWidth(36),
                        ),
                        Text(
                          'APPLY FILTERS',
                          style: kMSearchApplyFilterTextStyle,
                        ),
                        Container(
                          margin: EdgeInsets.all(6.0),
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14.0,
                            color: kMarketPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// TODO: Remove this method if not in user
extension CustomString on String {
  String capitalizeFirst() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
