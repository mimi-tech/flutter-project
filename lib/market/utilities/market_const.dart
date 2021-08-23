import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'strings.dart';

/// Market Activity Primary Color
final kMarketPrimaryColor = Color(0xffFF502F);

final kMarketDarkPrimaryColor = Color(0xff950D00);

/// Market card content secondary color
final kMarketSecondaryColor = Color(0xff515C6F);

/// Color of the market drawer container
final kMarketDrawerBgColor = Color(0xffF5F6F8);

/// Market Icon Color (dark version)
final kMarketDarkIconColor = Colors.black.withAlpha(179);

/// CONST AND STYLES FOR MARKET HOME

/// Textstyle for Market category nav
final kCatNavTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: ScreenUtil().setSp(15),
  ),
);

/// Textstyle for Market new/used button
final kNewUsedButtonTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w700,
  ),
);

/// TextStyle for displaying username
final kMarketNameTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black),
);

const topNavChips = [
  kChipNewArrival,
  kChipRecommended,
  kChipPopular,
  kChipRecentlyAdded
];

/// Market appbar container custom height
final kAppBarHeight = ScreenUtil().setHeight(56);

/// Custom color for the market custom selectors (circular categories); both active and inactive colors
final Color kCustomNavActiveColour = Color(0xffFFE07D);
final Color kCustomNavInactiveColour = Color(0xffFFC8BC);

/// Custom size of the sellers circular avatar
final kMarketSellerCircularAvatar = 24.sp;

/// Textstyle of the image counter displayed on the carousel
final kImageCounterTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: ScreenUtil().setSp(12),
    color: Colors.white,
  ),
);

/// Textstyle for the the follow button in market; both for inactive and active
final kFollowButtonInactiveTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: ScreenUtil().setSp(15),
    color: Color(0xffFF502F),
  ),
);

final kFollowButtonActiveTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: ScreenUtil().setSp(15),
    color: Colors.white,
  ),
);

/// Textstyle of "following" displayed alongside the number of followers under the "FOLLOW" button
final kFollowingTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontWeight: FontWeight.w600, fontSize: 12.sp, color: Colors.black),
);

/// Textstyles for items on display after the carousel (rating, price, and sell count)
final kMarketCardTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Color(0xff515C6F),
  ),
);

// Textstyle for prices of listed items
final kMarketSellPrice = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: kMarketPrimaryColor,
  ),
);

// Textstyle for changed prices of listed items
final kMarketChangedPrice = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: 12.sp,
      color: Color(0xff727C8E).withAlpha(179),
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.lineThrough),
);

// Textstyle of secondary items on market card (following, rating, sold count)
final kMarketCardContextSecStyle = GoogleFonts.rajdhani(
    textStyle: TextStyle(
  fontSize: 12.sp,
  color: kMarketSecondaryColor,
  fontWeight: FontWeight.w600,
));

// Textstyle of the "Details" button
final kMarketDetails = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(18),
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ),
);

// Textstyle of the badge counter
final kBadgeTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: 10.sp,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  ),
);

// The container color of the badge counter
final kNotificationBadgeColour = Color(0xffFF502F);

// Textstyle of the market trigger, which encompasses popular, recently viewed and recommended
final kMarketTriggerTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontFamily: 'Rajdhani Bold',
    color: Color(0xff727C8E),
    fontWeight: FontWeight.w700,
  ),
);

// Active color of the market trigger
final Color kMarketTriggerActive = Colors.black;

// Inactive color of the market trigger
final Color kMarketTriggerInactive = Color(0xff727C8E);

// Width and Height of the NEW/USED button on the market appbar
final kNewUsedButtonMinWidth = ScreenUtil().setWidth(45);
final kNewUsedButtonMinHeight = ScreenUtil().setHeight(32);

// Textstyle of the market reaction button
final kRatingPopUpTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Color(0xffFF502F),
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w700,
  ),
);

// Textstyle of "All Category" in market drawer
final kAllCat = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Color(0xff515C6F),
    fontSize: ScreenUtil().setSp(20),
    fontWeight: FontWeight.w700,
  ),
);

// Size of my SVG Category icon active/inactive
final kSvgIconActiveSize = 54.0;
final kSvgIconInactiveSize = 50.0;

//Textstyle for market explore 'SIMILAR PRODUCTS'
final kSimilarProduct = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w700,
      color: kMarketSecondaryColor),
);

// Textstyle for market explore 'from other products'
final kOtherProducts = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      color: kMarketSecondaryColor),
);

// Textstyle for product name on the market explore modal
final kProductNameMarketExplore = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      color: kMarketSecondaryColor),
);

// Textstyle for product price on the market explore modal
final kProductPriceMarketExplore = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(12),
      fontWeight: FontWeight.w700,
      color: kMarketSecondaryColor),
);

// Textstyle for product rating on the market explore modal
final kProductRatingMarketExplore = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(10),
      fontWeight: FontWeight.w700,
      color: Colors.white),
);

// Textstyle for market comment
final kMarketComment = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      color: Colors.black),
);

/// CONST AND TEXTSTYLE FOR THE MARKET SEARCH

// Textstyle for the 'recently viewed' searches
final kMSearchHeading = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      color: kMarketSecondaryColor),
);

// Textstyle for search content details
final kMSearchCardDetails = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: kMarketSecondaryColor),
);

// Textstyle for Market Search persistent header
final kMSearchPersistentHeader = GoogleFonts.rajdhani(
  textStyle: TextStyle(
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      color: kMarketSecondaryColor),
);

// TextStyle for the Market Search 'Apply Filter' button text
final kMSearchApplyFilterTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
);

final kMSearchDrawerTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w500,
    color: kMarketSecondaryColor,
  ),
);

final kMSearchDrawerFadedTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w500,
    color: Color(0xffB9BEC5),
  ),
);

/// MARKET PRODUCT LISTING [Important Info]
/// Product Listing title TextStyle
final kMProductListingTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(18),
    fontWeight: FontWeight.w700,
    color: Color(0xff08799A),
  ),
);

/// TextStyle for the [MarketProductListing] TabPageSelector
final kMProductListingTabTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w700,
  ),
);

/// TextStyle for the [MarketProductListing] labelText
final kMProductListingLabelTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Color(0xffFF9680),
  ),
);

/// TextStyle for the [MarketProductListing] hintText
final kMProductListingHintTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Color(0xffE4E4E4),
  ),
);

/// [MarketProductListing] InputDecoration
final kMProductListingInputDecoration = InputDecoration(
  labelStyle: kMProductListingLabelTextStyle,
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff707070),
    ),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: ThemeData().dividerColor,
    ),
  ),
  hintStyle: kMProductListingHintTextStyle,
  errorStyle: kMCustomErrorMessageTextStyle,
);

/// TextFormField Input TextStyle
final kMProductListingInputTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Colors.black,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  ),
);

/// Custom error message TextStyle
final kMCustomErrorMessageTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    color: Colors.blueGrey,
  ),
);

final kMProductListingNewUsedButtonActive = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
);

final kMProductListingNewUsedButtonInactive = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w700,
    color: Color(0xff464646),
  ),
);

final kMProductListInputTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
  ),
);

final marketProgressDialogTextStyle = GoogleFonts.rajdhani(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
  ),
);

/// MARKET PRODUCT DETAIL
/// TextStyle for Market Product Detail Tab Heading
final kProductDetailTabHeading = GoogleFonts.rajdhani(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
);

/// TextStyle for Market Detail - Product Specification (Heading)
final kProductSpecificationHeading = GoogleFonts.rajdhani(
  fontSize: ScreenUtil().setSp(18),
  fontWeight: FontWeight.w500,
  color: kMarketSecondaryColor.withOpacity(0.5),
);

/// TextStyle for Market Detail - Product Specification (Body)
final kProductSpecificationBody = GoogleFonts.rajdhani(
  fontSize: ScreenUtil().setSp(18),
  fontWeight: FontWeight.w600,
  color: kMarketSecondaryColor,
);

final kProductDetailSubHeading = GoogleFonts.rajdhani(
  fontSize: ScreenUtil().setSp(15),
  fontWeight: FontWeight.w600,
  color: Color(0xffB3B9C3),
);

final kBottomSheetTextStyle = GoogleFonts.rajdhani(
  fontSize: ScreenUtil().setSp(20),
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
