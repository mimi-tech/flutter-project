import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/market/components/custom_error_text_widget.dart';
import 'package:sparks/market/components/product_listing_next_back_button.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';

class ProductOffer extends StatefulWidget {
  final TabController? tabController;

  ProductOffer({required this.tabController});

  @override
  _ProductOfferState createState() => _ProductOfferState();
}

class _ProductOfferState extends State<ProductOffer>
    with AutomaticKeepAliveClientMixin {
  TextEditingController? _textEditingController;

  /// Boolean value for the [CustomErrorTextWidget]
  bool productPriceError = false;

  /// Function to verify TextField is not empty
  void priceFieldChecker() {
    if (_textEditingController!.text.trim() == null ||
        _textEditingController!.text.trim() == '' ||
        _textEditingController!.text.isEmpty) {
      setState(() {
        productPriceError = true;
      });
    } else {
      setState(() {
        productPriceError = false;
      });
      MarketGlobalVariables.productPrice =
          double.parse(_textEditingController!.text.trim());

      widget.tabController!.animateTo(3,
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
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Product Price',
                style: kMProductListingLabelTextStyle,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(16),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(112),
                child: TextField(
                  controller: _textEditingController,
                  textAlign: TextAlign.center,
                  style: kMProductListInputTextStyle,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(

                        /// TODO: Get Regular Expression to input only numbers and double to two-decimal places
                        RegExp("^([0-9]+)?(\\.)?([0-9]{1,2})?\$")),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '\$0.00',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),
              CustomErrorTextWidget(
                visible: productPriceError,
                text: 'Product price is required',
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ProductListingNextBackButton(
              buttonName: 'Back',
              onTap: () {
                widget.tabController!.animateTo(1,
                    duration: Duration(
                      microseconds: 300,
                    ),
                    curve: Curves.easeIn);
              },
            ),
            ProductListingNextBackButton(
              buttonName: 'Next',
              onTap: () {
                priceFieldChecker();
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
