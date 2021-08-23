import 'dart:collection';

class MarketGlobalVariables {
  /// MARKET HOME [MarketHome]
  /// Current user id
  static String? currentUserId;

  /// MARKETSEARCH CLASS (market_search.dart) [MarketSearch]
  /// Value of typed search word
  /// TODO: Remove this in no longer in use
  static String? searchedWord;

  /// MARKETSEARCHDRAWER CLASS (market_search_filter_drawer.dart) [MarketSearchDrawer]
  ///
  /// Minimum price inputted by the user in the MarketSearchDrawer class
  static String filterMinPrice = "";
  static double? searchMinPrice = 0;

  /// Maximum price inputted by the user in the MarketSearchDrawer class
  static String filterMaxPrice = "";
  static double? searchMaxPrice = 1000000;

  static String? searchCondition = "Any";
  static String? searchCategory = "Any";

  static Map<String?, int>? searchedFilterCategory;

  static bool isCustomFilterAvailable = false;

  static HashSet<dynamic> commonWordsHashSet = HashSet.of(commonWords);

  /// [PRODUCT_LISTING_IMAGES] CLASS (product_listing_images.dart)
  ///
  /// Values for the 'Important Info' TabView (default values)
  static String? productCategory;
  static String? productIdType;
  static String? productIdCode;
  static String? productName;
  static String? productBrand;
  static String? manufacturer;
  static int? productQuantity;
  static String? productCondition;
  static String? productDescription;
  static double? productPrice;

  /// Values for Cloth Category
  static String? clothDepartment;
  static String? clothSize;
  static int? clothColor;
  static String? clothMaterial;

  /// Key words when searching for clothing
  static List<String> commonWords = [];

  /// MARKET PRODUCT DETAILS
  ///
  /// Cloth product details
  static String? activeClothSize;
  static int? activeClothColor;

  /// ***IMPORTANT***
  ///
  /// These variables holds the data needed for adding product to the user's
  /// recently viewed products collection, if any of the values is not set
  /// using the "MarketBrain - recentlyViewedNeededValues" function, the product
  /// been viewed by the user WILL NOT be added to the user's recently viewed
  /// product collection (i.e. marketRecentlyViewed)
  ///
  /// NOTE: The [viewedCommonId] && [viewedCondition] MUST NOT
  /// be null when navigating to the "MARKET PRODUCT DETAILS" screen as it will
  /// throw an error. Their values are needed to fetch the "product name" &&
  /// "product rating"
  static String? viewedCommonId =
      ""; // Needed for getting "product name" and "product rating"
  static String viewedStoreId = "";
  static String viewedCondition =
      ""; // Needed for getting "product name" and "product rating"
  static String viewedCategory = "";
  static String viewedDocId = "";
  static String viewedImage = "";
  static String viewedProductName = "";
  static double viewedProductPrice = 0;
  static double? viewedProductRating;
}
