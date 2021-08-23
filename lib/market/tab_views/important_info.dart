import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/market/components/custom_error_text_widget.dart';
import 'package:sparks/market/components/new_used_switcher.dart';
import 'package:sparks/market/components/product_listing_next_back_button.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
// import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/services.dart';
import 'package:sparks/market/utilities/market_mixin.dart';

class ImportantInfo extends StatefulWidget {
  final TabController? tabController;

  ImportantInfo({Key? key, required this.tabController}) : super(key: key);

  @override
  _ImportantInfoState createState() => _ImportantInfoState();
}

class _ImportantInfoState extends State<ImportantInfo>
    with MarketMixin, AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  final _dataKey = GlobalKey();

  TextEditingController? _textController;

  /// List containing a virtual List of Materials
  /// Note: See initState
  List<String> _fullMaterialList = [];

  /// List containing matches for searched materials
  List<String> _filteredMaterialList = [];

  List<String> _productCondition = ['new product'];

  void conditionSelector(String condition) {
    setState(() {
      if (_productCondition.contains(condition)) {
        _productCondition.retainWhere((e) => e.contains(condition));
      } else {
        _productCondition.clear();
        _productCondition.add(condition);
      }
    });
  }

  /// FocusNodes for the ProductID, Product Name, Product Brand & Manufacturer
  final FocusNode _productIdNode = FocusNode();
  final FocusNode _productNameNode = FocusNode();
  final FocusNode _productBrandNode = FocusNode();
  final FocusNode _manufacturerNode = FocusNode();

  /// String & List for the [Product Category] DropDownButton
  String? _productCategory;
  List<String> productCategoryList = [
    'Books',
    'Clothes',
    'Laptops',
    'Phones',
  ];

  /// String & List for the [Product ID] DropDownButton
  String? _productIdType;
  List<String> productIDList = [
    'UPC',
    'ISBN',
  ];

  /// String & List for the [Cloth Department] DropDownButton
  String? _clothDepartment;
  List<String> clothDepartmentList = [
    'Boy\'s Clothes',
    'Girl\'s Clothes',
    'Men\'s Clothes',
    'Women\'s Clothes',
  ];

  /// String & List for the [Cloth Size] DropDownButton
  String? _clothSizes;
  List<String> clothSizesList = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    '2XL',
    '3XL',
    '4XL',
    '5XL',
  ];

  /// Boolean value of whether to display error message after form validation for Product Category, Product ID
  bool _productCategoryError = false;
  bool _productIdError = false;

  /// Boolean value of whether to display error message after form validation Cloth Department, Cloth Size
  bool _clothDepartmentError = false;
  bool _clothSizeError = false;

  /// Boolean value of whether to display error message after form validation for [quantity]
  bool _quantityError = false;
  String? _quantityErrorMessage;

  /// Boolean value of whether to display error message after form validation for [cloth material]
  bool _clothMaterial = false;

  ColorSwatch? _tempMainColor;
  Color? _tempShadeColor;
  ColorSwatch? _mainColor = Colors.blue;
  Color? _shadeColor = Color(0xff075A9E);

  Color? _complimentaryColor;

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);

                // print('Shade: $_shadeColor');
                // print('Main: $_mainColor');

                setState(() {
                  String colorString = colorToStringStripper(_shadeColor);
                  _complimentaryColor =
                      getContrastingColorFromString(colorString);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _openFullMaterialColorPicker() async {
    // _openDialog(
    //   "Pick a Colour",
    //   MaterialColorPicker(
    //     colors: fullMaterialColors,
    //     selectedColor: _mainColor,
    //     onMainColorChange: (color) => setState(() => _tempMainColor = color),
    //     onColorChange: (color) {
    //       setState(() {
    //         _tempShadeColor = color;
    //       });
    //     },
    //   ),
    // );
  }

  List<String> clothingMaterials = [
    'Canvas',
    'Cashmere',
    'Chenille',
    'Chiffon',
    'Cotton',
    'Crepe',
    'Damask',
    'Denim',
    'Down',
    'Flax',
    'Fur',
    'Georgette',
    'Gingham',
    'Jersey',
    'Lace',
    'Leather',
    'Linen',
    'Merino Wool',
    'Modal',
    'Organza',
    'Polyester',
    'Ramie',
    'Rayon',
    'Satin',
    'Silk',
    'Spandex',
    'Suede',
    'Taffeta',
    'Toile',
    'Tweed',
    'Twill',
    'Wool',
    'Velvet',
    'Viscose',
  ];

  /// List containing name of selected material
  /// Note: This List will only ever contain a single String value
  List<String> _materialBox = [];

  /// Temporary String holding users selected choice of material
  String? _tempSelectedMaterial;

  /// String holding the selected material by the user
  String? _selectedMaterial;

  /// Function to validate a UPC-12 number
  bool upc12Validator(String num) {
    /// Boolean value to be returned at the end of the function
    bool upcStatus = false;

    /// Storing the numbers in the odd positions 1, 3 , 5, 7, 9 & 11
    int firstNum = int.parse(num[0]);
    int thirdNum = int.parse(num[2]);
    int fifthNum = int.parse(num[4]);
    int seventhNum = int.parse(num[6]);
    int ninthNUm = int.parse(num[8]);
    int eleventhNum = int.parse(num[10]);

    /// Adding up & storing all the numbers in the odd position in a variable 'oddNumCal'
    int oddNumCal =
        (firstNum + thirdNum + fifthNum + seventhNum + ninthNUm + eleventhNum);

    /// Multiplying the sum of the numbers in the odd position by 3
    int multiplyOddNumBy3 = oddNumCal * 3;

    /// Storing the numbers in the even positions 2, 4, 6, 8, & 10
    ///
    /// NOTE: The number in the 12th position is omitted intentionally
    /// This is the number that will be used to validate the UPC code
    int secondNum = int.parse(num[1]);
    int forthNum = int.parse(num[3]);
    int sixthNum = int.parse(num[5]);
    int eightNum = int.parse(num[7]);
    int tenthNum = int.parse(num[9]);

    /// Adding up and storing the numbers in the even positions in a variable 'evenNumCal'
    int evenNumCal = (secondNum + forthNum + sixthNum + eightNum + tenthNum);

    /// SUMMING UP of the multiplication by 3 of numbers in odd positions and the sum of the numbers in even positions
    int sumOddAndEven = multiplyOddNumBy3 + evenNumCal;

    /// Duplicate of the 'sumOddAndEven'
    ///
    /// This is for manipulation and use in the logical statement below
    int sumOddAndEvenForWhileLoop = sumOddAndEven;

    /// Variable to store the closest number to the 'sumOddAndEven' that can be divisible by 10
    late int closestNumDivisibleBy10;

    /// Logic to check the closest number to 'sumOddAndEven' using the duplicate value (sumOddAndEvenForWhileLoop)
    /// that is divisible by 10
    if (sumOddAndEvenForWhileLoop % 10 == 0) {
      closestNumDivisibleBy10 = sumOddAndEvenForWhileLoop;
    } else {
      while (sumOddAndEvenForWhileLoop % 10 != 0) {
        sumOddAndEvenForWhileLoop++;
        if (sumOddAndEvenForWhileLoop % 10 == 0) {
          closestNumDivisibleBy10 = sumOddAndEvenForWhileLoop;
        }
      }
    }

    /// Subtracting the 'sumOddAndEven' number from the closest number divisible by 10
    int verifyLastNumber = closestNumDivisibleBy10 - sumOddAndEven;

    /// Logic to check if the number obtained from subtraction above is equal to the last digit of the UPC number
    if (verifyLastNumber == int.parse(num[11])) {
      upcStatus = true;
    } else {
      upcStatus = false;
    }

    // Valid UPC-12 code: 796030114977
    return upcStatus;
  }

  void materialChoiceSetter(String? materialChoice) {
    setState(() {
      _selectedMaterial = materialChoice;
    });
    MarketGlobalVariables.clothMaterial = _selectedMaterial;
  }

  /// Text Editing Controller for the product quantity
  TextEditingController? _quantityTextController;

  /// Function to [increment] quantity by '1'
  void addQuantity() {
    int addValue;

    if (_quantityTextController!.text.trim() == '' ||
        _quantityTextController!.text.trim() == null ||
        _quantityTextController!.text.trim().isEmpty) {
      setState(() {
        _quantityTextController!.text = '1';
      });
    } else {
      addValue = int.parse(_quantityTextController!.text.trim());
      setState(() {
        addValue++;
        _quantityTextController!.text = addValue.toString();
      });
    }
  }

  /// Function to [decrement] quantity by '1'
  void subtractQuantity() {
    int subtractValue;

    if (_quantityTextController!.text.trim() == '' ||
        _quantityTextController!.text.trim() == null ||
        _quantityTextController!.text.trim().isEmpty) {
      setState(() {
        _quantityTextController!.text = '1';
      });
    } else {
      subtractValue = int.parse(_quantityTextController!.text.trim());
      if (subtractValue > 1) {
        setState(() {
          subtractValue--;
          _quantityTextController!.text = subtractValue.toString();
        });
      }
    }
  }

  Widget loadMaterials(List<String> strings) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: Column(
            children: strings
                .map(
                  (material) => CheckboxListTile(
                    title: Text(material),
                    value: _materialBox.contains(material) ? true : false,
                    onChanged: (bool? value) {
                      setState(() {
                        if (_materialBox.contains(material)) {
                          _materialBox.retainWhere((e) => e.contains(material));
                          _tempSelectedMaterial = material;
                        } else {
                          _materialBox.clear();
                          _materialBox.add(material);
                          _tempSelectedMaterial = material;
                        }
                      });
                    },
                  ),
                )
                .toList()),
      );
    });
  }

  void clothMaterialPicker() {
    showPlatformDialog(
      context: context,
      builder: (_) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return PlatformAlertDialog(
          title: Column(
            children: <Widget>[
              Text('Choose a Material'),
              SizedBox(
                height: ScreenUtil().setHeight(16),
              ),
              Container(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search for material...'),
                  onChanged: (value) {
                    // Do something
                    if (_textController!.text.isNotEmpty ||
                        _textController!.text == '' ||
                        _textController!.text == null) {
                      List<String> tempList = [];
                      for (int i = 0; i < _fullMaterialList.length; i++) {
                        if (_fullMaterialList[i]
                            .toLowerCase()
                            .contains(_textController!.text.toLowerCase())) {
                          setState(() {
                            tempList.add(_fullMaterialList[i]);
                          });
                        }
                      }
                      setState(() => _filteredMaterialList = tempList);
                    }
                  },
                ),
              ),
            ],
          ),
          content: loadMaterials(_textController!.text.isEmpty
              ? _fullMaterialList
              : _filteredMaterialList),
          actions: <Widget>[
            PlatformDialogAction(
//              android: (_) => MaterialDialogActionData(),
//              ios: (_) => CupertinoDialogActionData(),
              child: PlatformText('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            PlatformDialogAction(
              child: PlatformText('OK'),
              onPressed: () {
                materialChoiceSetter(_tempSelectedMaterial);
                Navigator.pop(context);
              },
            ),
          ],
        );
      }),
    );
  }

  /// Cloth category widgets
  Widget clothes(double heightValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// Cloth Department Widget
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Department',
              style: kMProductListingLabelTextStyle,
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(140),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration.collapsed(
                  hintStyle: kMProductListingHintTextStyle,
                  hintText: 'Select',
                ),
                value: _clothDepartment,
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  setState(() => _clothDepartment = newValue);
                },
                onSaved: (value) {
                  MarketGlobalVariables.clothDepartment = _clothDepartment;
                },
                validator: (value) {
                  if (value == null) {
                    setState(() {
                      _clothDepartmentError = true;
                    });
                    return;
                  } else {
                    setState(() {
                      _clothDepartmentError = false;
                    });
                    return null;
                  }
                },
                items: clothDepartmentList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: kMSearchDrawerTextStyle.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        CustomErrorTextWidget(
          visible: _clothDepartmentError,
          text: 'Please select a department',
        ),
        Divider(),
        SizedBox(
          height: heightValue,
        ),

        /// Cloth Size Widget
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cloth Size',
              style: kMProductListingLabelTextStyle,
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(64),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration.collapsed(
                  hintStyle: kMProductListingHintTextStyle,
                  hintText: 'Select',
                ),
                value: _clothSizes,
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  setState(() => _clothSizes = newValue);
                },
                onSaved: (value) {
                  MarketGlobalVariables.clothSize = _clothSizes!;
                },
                validator: (value) {
                  if (value == null) {
                    setState(() {
                      _clothSizeError = true;
                    });
                    return;
                  } else {
                    setState(() {
                      _clothSizeError = false;
                    });
                    return null;
                  }
                },
                items: clothSizesList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: kMSearchDrawerTextStyle.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        CustomErrorTextWidget(
          visible: _clothSizeError,
          text: 'Choose a size',
        ),
        Divider(),
        SizedBox(
          height: heightValue,
        ),

        /// Colour Picker Widget
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pick Colour',
              style: kMProductListingLabelTextStyle,
            ),
            SizedBox(
              width: ScreenUtil().setWidth(16),
            ),
            GestureDetector(
              onTap: _openFullMaterialColorPicker,
              child: Container(
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setHeight(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  color: _shadeColor,
                ),
              ),
            ),
          ],
        ),
        Divider(),
        SizedBox(
          height: heightValue,
        ),

        /// Cloth Material Picker Widget
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Material',
              style: kMProductListingLabelTextStyle,
            ),
            SizedBox(
              width: ScreenUtil().setWidth(16),
            ),
            Column(
              key: _dataKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  elevation: 4.0,
                  color: _shadeColor,
                  onPressed: () {
                    clothMaterialPicker();
                  },
                  child: Text(
                    _selectedMaterial ?? 'Select',
                    style: TextStyle(color: _complimentaryColor),
                  ),
                ),
                CustomErrorTextWidget(
                  visible: _clothMaterial,
                  text: 'Please select a material',
                ),
              ],
            ),
          ],
        ),
        Divider(),
        SizedBox(
          height: heightValue,
        ),
      ],
    );
  }

  @override
  void initState() {
    for (int i = 0; i < clothingMaterials.length; i++) {
      _fullMaterialList.add(clothingMaterials[i]);
    }
    _textController = TextEditingController();
    _quantityTextController = TextEditingController(text: '1');

    super.initState();
  }

  @override
  void dispose() {
    _textController!.dispose();
    _quantityTextController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQuery = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /// Company image and name
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 32.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 36.0,
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Text(
                  'Google LLC',
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(
            height: ScreenUtil().setHeight(8),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Product Condition
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Condition',
                      style: kMProductListingLabelTextStyle,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(8),
                    ),
                    Row(
                      children: <Widget>[
                        /// New Button Toggle
                        NewUsedSwitcher(
                          buttonText: 'New',
                          boxColor: _productCondition.contains('new product')
                              ? Color(0xff464646)
                              : Colors.white,
                          textStyle: _productCondition.contains('new product')
                              ? kMProductListingNewUsedButtonActive
                              : kMProductListingNewUsedButtonInactive,
                          onTap: () {
                            conditionSelector('new product');
                          },
                        ),

                        /// Used Button Toggle
                        NewUsedSwitcher(
                          buttonText: 'Used',
                          boxColor: _productCondition.contains('used product')
                              ? Color(0xff464646)
                              : Colors.white,
                          textStyle: _productCondition.contains('used product')
                              ? kMProductListingNewUsedButtonActive
                              : kMProductListingNewUsedButtonInactive,
                          onTap: () {
                            conditionSelector('used product');
                          },
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(8),
                ),
                Divider(),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),

                /// Product Category Widgets
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Product Category',
                      style: kMProductListingLabelTextStyle,
                    ),

                    /// DropDownButton for the 'Product Category'
                    SizedBox(
                      width: ScreenUtil().setWidth(80),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration.collapsed(
                          hintStyle: kMProductListingHintTextStyle,
                          hintText: 'Select',
                        ),
                        value: _productCategory,
                        //underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down),
                        onChanged: (String? newValue) {
                          setState(() => _productCategory = newValue);
                        },
                        onSaved: (value) {
                          MarketGlobalVariables.productCategory =
                              _productCategory;
                        },
                        validator: (value) {
                          if (value == null) {
                            setState(() {
                              _productCategoryError = true;
                            });
                            return;
                          } else {
                            setState(() {
                              _productCategoryError = false;
                            });
                            return null;
                          }
                        },
                        items: productCategoryList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: kMSearchDrawerTextStyle.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    CustomErrorTextWidget(
                      visible: _productCategoryError,
                      text: 'Please select a category',
                    ),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),

                _productCategory == 'Clothes'
                    ? clothes(mediaQuery.height * 0.02)
                    : SizedBox.shrink(),

                /// Product Quantity
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Quantity',
                      style: kMProductListingLabelTextStyle,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(8),
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            subtractQuantity();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            height: ScreenUtil().setHeight(40),
                            color: Color(0xff464646),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: ScreenUtil().setWidth(72),
                            height: ScreenUtil().setHeight(40),
                            child: TextFormField(
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp("[0-9]")),
                              ],
                              keyboardType: TextInputType.number,
                              controller: _quantityTextController,
                              textAlign: TextAlign.center,
                              //initialValue: initialQuantity.toString(),
                              maxLines: 1,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                    color: Color(0xff464646),
                                  ),
                                ),
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                ),
                              ),
                              onSaved: (value) {
                                MarketGlobalVariables.productQuantity =
                                    int.parse(_quantityTextController!.text);
                              },
                              validator: (value) {
                                if (_quantityTextController!.text == null ||
                                    _quantityTextController!.text == '' ||
                                    _quantityTextController!.text.isEmpty) {
                                  setState(() {
                                    _quantityErrorMessage =
                                        'Quantity can\'t be empty';
                                    _quantityError = true;
                                  });
                                  return;
                                } else if (int.parse(
                                        _quantityTextController!.text.trim()) ==
                                    0) {
                                  setState(() {
                                    _quantityErrorMessage =
                                        'Quantity can\'t be 0';
                                    _quantityError = true;
                                  });
                                  return;
                                } else if (_quantityTextController!.text[0] ==
                                    '0') {
                                  setState(() {
                                    _quantityErrorMessage =
                                        'Number can\'t start with 0';
                                    _quantityError = true;
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    _quantityError = false;
                                  });
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            addQuantity();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: ScreenUtil().setHeight(40),
                            color: Color(0xff464646),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Error message for [Quantity]
                    CustomErrorTextWidget(
                      visible: _quantityError,
                      text: _quantityErrorMessage ?? 'Select quantity',
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(8),
                    ),
                    Divider(),
                  ],
                ),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),

                /// Product ID Widgets
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Product ID',
                          style: kMProductListingLabelTextStyle,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(12),
                        ),

                        /// DropDownButton for 'Product ID'
                        SizedBox(
                          width: ScreenUtil().setWidth(80),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration.collapsed(
                              hintStyle: kMProductListingHintTextStyle,
                              hintText: 'Select',
                            ),
                            value: _productIdType,
                            icon: Icon(Icons.keyboard_arrow_down),
                            onChanged: (String? newValue) {
                              setState(() => _productIdType = newValue);
                            },
                            onSaved: (value) {
                              MarketGlobalVariables.productIdType =
                                  _productIdType;
                            },
                            validator: (value) {
                              if (value == null) {
                                setState(() {
                                  _productIdError = true;
                                });
                                return;
                              } else {
                                setState(() {
                                  _productIdError = false;
                                });
                                return null;
                              }
                            },
                            items: productIDList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: kMSearchDrawerTextStyle.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    CustomErrorTextWidget(
                      visible: _productIdError,
                      text: 'Please select an ID type',
                    ),

                    /// TextField for 'Product ID'
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]")),
                      ],
                      maxLines: 1,
                      cursorColor: Colors.black,
                      style: kMProductListingInputTextStyle,
                      textInputAction: TextInputAction.next,
                      focusNode: _productIdNode,
                      decoration: kMProductListingInputDecoration.copyWith(
                        hintText: 'Enter Product ID',
                      ),
                      onFieldSubmitted: (term) {
                        _productIdNode.unfocus();
                        FocusScope.of(context).requestFocus(_productNameNode);
                      },
                      onSaved: (value) {
                        MarketGlobalVariables.productIdCode = value!.trim();
                      },
                      validator: (value) {
                        Pattern pattern = r'^[0-9]+$';
                        RegExp regex = new RegExp(pattern as String);
                        if (value!.isEmpty)
                          return 'Field can\'t be empty';
                        else if (!regex.hasMatch(value.trim()))
                          return 'Only numbers allowed';
                        else if (_productIdType == 'UPC' &&
                            value.trim().length < 12)
                          return 'Enter a valid ID';
                        else if (_productIdType == 'UPC' &&
                            !upc12Validator(value.trim()))
                          return 'Enter a valid UPC code';
                        else
                          return null;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),

                /// Product Name Widget
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  cursorColor: Colors.black,
                  style: kMProductListingInputTextStyle,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  focusNode: _productNameNode,
                  decoration: kMProductListingInputDecoration.copyWith(
                      hintText: 'Enter Product Name',
                      labelText: 'Product Name'),
                  onFieldSubmitted: (term) {
                    _productNameNode.unfocus();
                    FocusScope.of(context).requestFocus(_productBrandNode);
                  },
                  onSaved: (value) {
                    MarketGlobalVariables.productName =
                        capitalizeFirstLetterOfWords(value!.trim());
                  },
                  validator: (value) {
                    if (value!.isEmpty)
                      return 'Field can\'t be empty';
                    else if (value.trim().length < 2)
                      return 'Enter a value name';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),

                /// Product Brand Widget
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  cursorColor: Colors.black,
                  style: kMProductListingInputTextStyle,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  focusNode: _productBrandNode,
                  decoration: kMProductListingInputDecoration.copyWith(
                      hintText: 'Enter Product Brand',
                      labelText: 'Product Brand'),
                  onFieldSubmitted: (term) {
                    _productBrandNode.unfocus();
                    FocusScope.of(context).requestFocus(_manufacturerNode);
                  },
                  onSaved: (value) {
                    MarketGlobalVariables.productBrand =
                        capitalizeFirstLetterOfWords(value!.trim());
                  },
                  validator: (value) {
                    if (value!.isEmpty)
                      return 'Field can\'t be empty';
                    else if (value.trim().length < 2)
                      return 'Enter valid brand';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.height * 0.02,
                ),

                /// Manufacturer Widget
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  cursorColor: Colors.black,
                  style: kMProductListingInputTextStyle,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  focusNode: _manufacturerNode,
                  decoration: kMProductListingInputDecoration.copyWith(
                      hintText: 'Enter Product Manufacturer',
                      labelText: 'Manufacturer'),
                  onFieldSubmitted: (term) {
                    _manufacturerNode.unfocus();
                  },
                  onSaved: (value) {
                    MarketGlobalVariables.manufacturer =
                        capitalizeFirstLetterOfWords(value!.trim());
                  },
                  validator: (value) {
                    if (value!.isEmpty)
                      return 'Field can\'t be empty';
                    else if (value.trim().length < 2)
                      return 'Enter valid manufacturer';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.height * 0.04,
                ),

                /// Next Button Widget
                ProductListingNextBackButton(
                  buttonName: 'Next',
                  onTap: () {
                    if (_selectedMaterial == null) {
                      setState(() {
                        _clothMaterial = true;
                      });
                      Scrollable.ensureVisible(_dataKey.currentContext!);
                    } else {
                      setState(() {
                        _clothMaterial = false;
                      });
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        MarketGlobalVariables.productCondition =
                            _productCondition[0];

                        MarketGlobalVariables.clothColor =
                            colorToIntColorValue(_shadeColor);

                        widget.tabController!.animateTo(1,
                            duration: Duration(
                              microseconds: 300,
                            ),
                            curve: Curves.easeIn);
                      }

                      /// condition
                      /// product category
                      /// department
                      /// cloth size
                      /// color
                      /// material
                      /// quantity
                      /// selected id
                      /// product id
                      /// product name
                      /// product brand
                      /// manufacturer
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
