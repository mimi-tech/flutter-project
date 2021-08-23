import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/market/components/custom_error_text_widget.dart';
import 'package:sparks/market/components/product_listing_next_back_button.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/market_mixin.dart';

class ProductDescription extends StatefulWidget {
  final TabController? tabController;

  ProductDescription({required this.tabController});

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription>
    with MarketMixin, AutomaticKeepAliveClientMixin {
  TextEditingController? _textEditingController;

  bool productDescriptionError = false;

  void checkForEmptyTextField() {
    if (_textEditingController!.text.trim() == null ||
        _textEditingController!.text.trim() == '' ||
        _textEditingController!.text.isEmpty) {
      setState(() {
        productDescriptionError = true;
      });
    } else {
      setState(() {
        productDescriptionError = false;
      });
      MarketGlobalVariables.productDescription =
          _textEditingController!.text.trim();

      widget.tabController!.animateTo(2,
          duration: Duration(
            microseconds: 300,
          ),
          curve: Curves.easeIn);
    }
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color selectedColor = intToColor(MarketGlobalVariables.clothColor!);
    Color contrastColor =
        getContrastingColorFromInt(MarketGlobalVariables.clothColor!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Product Description',
                      style: kMProductListingLabelTextStyle,
                    ),
                  ),
                  TextField(
                    controller: _textEditingController,
                    style: kMProductListInputTextStyle.copyWith(
                        color: contrastColor),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 2000,
                    maxLines: null,
                    maxLengthEnforced: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: selectedColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: contrastColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: contrastColor,
                        ),
                      ),
                    ),
                  ),
                  CustomErrorTextWidget(
                    visible: productDescriptionError,
                    text: 'Product description can\'t be empty',
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ProductListingNextBackButton(
              buttonName: 'Back',
              onTap: () {
                widget.tabController!.animateTo(0,
                    duration: Duration(
                      microseconds: 300,
                    ),
                    curve: Curves.easeIn);
              },
            ),
            ProductListingNextBackButton(
              buttonName: 'Next',
              onTap: () {
                checkForEmptyTextField();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
