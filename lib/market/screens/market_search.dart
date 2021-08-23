import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/market/components/similar_products_card.dart';
import 'package:sparks/market/market_models/similar_products_model.dart';
import 'package:sparks/market/market_services/cloth_search_service.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/market_services/market_search_service.dart';
import 'package:sparks/market/screens/market_product_details.dart';
import 'package:sparks/market/utilities/category_enum.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_filter_lists.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/strings.dart';
import 'package:sparks/market/components/market_search_filter_drawer.dart';

class MarketSearch extends StatefulWidget {
  static String id = 'market_search';

  @override
  _MarketSearchState createState() => _MarketSearchState();
}

class _MarketSearchState extends State<MarketSearch>
    with AutomaticKeepAliveClientMixin {
  final _searchTextEditingController = TextEditingController();

  /// ScrollController for the market gridview builder
  ScrollController? _scrollController;

  CategoryEnum _categoryEnum = CategoryEnum.defaultCat;

  MarketDatabaseService _marketDatabaseService =
      MarketDatabaseService(userId: MarketGlobalVariables.currentUserId);

  MarketSearchService _marketSearchService = MarketSearchService();

  ClothSearchService _clothSearchService = ClothSearchService();

  /// String that hold the user's search query input
  String? _searchQuery;

  /// Variable that hold the user's previous query String value.
  /// This variable is used to determine whether the user's current search String
  /// value is the same as the previous String value, if it is the same no new
  /// search query is made/returned
  String? prevSearchQuery = "";

  /// Variable that holds the result data from a successful search query
  List<SimilarProductModel> searchedProducts = [];

  /// Variable that holds the List<DocumentSnapshot> for the last set of
  /// document snapshot for "new products".
  /// NOTE: This variable is used when the filter condition is set to "Any"
  List<DocumentSnapshot>? newLastDocumentSnapshot = [];

  /// Variable that holds the List<DocumentSnapshot> for the last set of
  /// document snapshot for "used products".
  /// NOTE: This variable is used when the filter condition is set to "Any"
  List<DocumentSnapshot>? usedLastDocumentSnapshot = [];

  /// Variable that holds the List<DocumentSnapshot> for the last set of
  /// document snapshot of a search query.
  /// NOTE: This variable is utilized when the filter condition is set to
  /// either "new" or "used"
  List<DocumentSnapshot>? lastDocumentSnapshot = [];

  /// Boolean variable that indicates is the search TextField currently has an
  /// inputted text, if so, then shows an icon in the TextField (icon = x) which
  /// can be used to clear the TextField
  bool _searchInputFieldHaveText = false;

  /// Boolean variable used to switch to/display the [_searching] Widget.
  /// NOTE: This boolean variable switches to "true" and therefore displays the
  /// [_searching] Widget when the search TextField is submitted
  bool _isSearching = false;

  /// This boolean variable is used in the [_searching] widget to display a
  /// screen large CircularProgressIndicator
  bool _loadingProducts = false;

  /// This boolean variable is used to hide the "user's recently viewed products"
  /// Widget when the user clicks on "CLEAR" in [_emptySearch]
  ///
  /// NOTE: This recently viewed products is hidden to allow for a cloud function
  /// to recursively delete all documents in the user's recentlyViewed Collection
  bool _isRecentlyViewedVisible = true;

  bool _customFilterAvailable = false;

  /// This boolean variable is used to check whether the scroll position is close
  /// to the bottom of the scrollable widget. If "true" then fetch next set of
  /// document data
  bool _shouldCheck = false;

  /// This boolean variable is used to check whether the method to fetch new set
  /// of document data is already running (pagination)
  bool _shouldRunCheck = true;

  /// Variable to check if the new set of paginated data has been fetched
  bool _hasGottenNextDocData = false;

  /// This boolean variable is used to verify if there are still any documents
  /// left in the database
  bool _moreDocumentsAvailable = true;

  /// Boolean variable that determines if a circular progress spinner should be
  /// shown at the bottom of the scrollable widget to indicated data being fetched
  bool _showCircularProgress = false;

  /// Method to delete the user's recently viewed products
  /// NOTE: This method triggers a cloud function to delete ALL document found
  /// in the user's recentlyViewed Collection
  void deleteRecentlyViewed(String? docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(MarketGlobalVariables.currentUserId)
          .collection("Market")
          .doc("marketInfo")
          .collection("marketRecentlyViewed")
          .doc(docId)
          .delete();
    } catch (e) {
      print("Problem deleting recently viewed: $e");
    }
  }

  /// Method that handles the search nav (BEST MATCH, TOP RATED, PRICE LOW-HIGH,
  /// PRICE HIGH-LOW
  ///
  /// NOTE: The List [_searchPersistentNav] will ONLY contain a single String value
  List<String> _searchPersistentNav = [kBestMatch];
  void _handleSearchFilterNav(String searchPersistentFilter) {
    if (_searchPersistentNav.contains(searchPersistentFilter)) {
      setState(() {
        _searchPersistentNav
            .retainWhere((e) => e.contains(searchPersistentFilter));
      });
    } else {
      _searchPersistentNav.clear();
      setState(() => _searchPersistentNav.add(searchPersistentFilter));
      if (_searchQuery!.length >= 1) getFirstSearchQuery();
    }
  }

  /// This method is attached to the listener of the [_searchTextEditingController]
  /// The search input query of the user is stored to the [_searchQuery] variable
  void _searchControllerListener() {
    _searchQuery = _searchTextEditingController.text.toLowerCase().trim();
    if (_searchQuery == null || _searchQuery == "") {
      MarketGlobalVariables.searchedFilterCategory?.clear();
    }
  }

  /// This method ensures that all the filter parameters are cleared when the
  /// user navigates out of [MarketSearch]
  void _clearAllCategoryFilter() {
    /// Default Values
    MarketGlobalVariables.searchCondition = "Any";
    MarketGlobalVariables.searchCategory = "Any";
    MarketGlobalVariables.filterMinPrice = "";
    MarketGlobalVariables.filterMaxPrice = "";
    MarketGlobalVariables.searchMinPrice = 0;
    MarketGlobalVariables.searchMaxPrice = 1000000;

    /// Clothes
    MarketFilterLists.clothingDepartment = "Any";
    MarketFilterLists.clothSizes = "Any";

    /// Laptops
    MarketFilterLists.laptopRAMCapacity = "Any";
    MarketFilterLists.operatingSys = "Any";
    MarketFilterLists.comGraphicsProcessor = "Any";
    MarketFilterLists.comProcessorType = "Any";
    MarketFilterLists.comGraphicsCardType = "Any";

    /// Phones
    MarketFilterLists.phoneOperatingSys = "Any";
    MarketFilterLists.phoneInternalStorage = "Any";
    MarketFilterLists.phoneDisplaySize = "Any";
  }

  /// This method clears the corresponding custom filter parameters. It is called
  /// in the onChanged function in the search TextField
  void _clearSearchFilterParams() {
    if (_categoryEnum == CategoryEnum.clothes) {
      MarketFilterLists.clothingDepartment = 'Any';
      MarketFilterLists.clothSizes = 'Any';
    } else if (_categoryEnum == CategoryEnum.laptops) {
      MarketFilterLists.laptopRAMCapacity = 'Any';
      MarketFilterLists.operatingSys = 'Any';
      MarketFilterLists.comGraphicsProcessor = 'Any';
      MarketFilterLists.comProcessorType = 'Any';
    } else if (_categoryEnum == CategoryEnum.phones) {
      MarketFilterLists.phoneOperatingSys = 'Any';
      MarketFilterLists.phoneInternalStorage = 'Any';
      MarketFilterLists.phoneDisplaySize = 'Any';
    } else {
      print("No category to clear");
    }
  }

  /// This is the merge sort algorithm that sorts through a List of DocumentSnapshot
  /// from the search query and sorts them recursively [_mergeDocumentSnapshot]
  List<DocumentSnapshot> _mergeSortDocumentSnapshot(
      List<DocumentSnapshot> documentSnapshot) {
    if (documentSnapshot.length <= 1) return documentSnapshot;

    int midPoint = ((documentSnapshot.length - 1) / 2).round();

    List<DocumentSnapshot> left =
        _mergeSortDocumentSnapshot(documentSnapshot.sublist(0, midPoint));
    List<DocumentSnapshot> right =
        _mergeSortDocumentSnapshot(documentSnapshot.sublist(midPoint));

    return _mergeDocumentSnapshot(left, right);
  }

  List<DocumentSnapshot> _mergeDocumentSnapshot(
      List<DocumentSnapshot> arr1, List<DocumentSnapshot> arr2) {
    List<DocumentSnapshot> result = [];

    List<Map<String, dynamic>?> data1 = arr1.map((DocumentSnapshot doc) {
      return doc.data as Map<String, dynamic>?;
    }).toList();

    List<Map<String, dynamic>?> data2 = arr2.map((DocumentSnapshot doc) {
      return doc.data as Map<String, dynamic>?;
    }).toList();

    int i = 0;
    int j = 0;

    while (i < arr1.length && j < arr2.length) {
      switch (_searchPersistentNav[0]) {
        case kTopRated: // If the search tab choice is "TOP-RATED"
          if (data1[i]!["rate"] > data2[i]!["rate"]) {
            result.add(arr1[i]);
            i++;
          } else {
            result.add(arr2[j]);
            j++;
          }
          break;
        case kPriceLowHigh: // If the search tab choice is "PRICE LOW-HIGH"
          if (data1[i]!["price"] < data2[i]!["price"]) {
            result.add(arr1[i]);
            i++;
          } else {
            result.add(arr2[j]);
            j++;
          }
          break;
        case kPriceHighLow: // If the search tab choice is "PRICE HIGH-LOW"
          if (data1[i]!["price"] > data2[i]!["price"]) {
            result.add(arr1[i]);
            i++;
          } else {
            result.add(arr2[j]);
            j++;
          }
          break;
      }
    }

    while (i < arr1.length) {
      result.add(arr1[i]);
      i++;
    }

    while (j < arr2.length) {
      result.add(arr2[j]);
      j++;
    }

    return result;
  }

  /// This functions just calls setState to cause a re-build of the Class (i.e. [MarketSearch])
  ///
  /// It is triggered when "Apply Filter" from the filter drawer is clicked by the user
  void applyFilterSettings() {
    /// TODO: Remove the global variable and just pass a boolean value from the search filter
    setState(() =>
        _customFilterAvailable = MarketGlobalVariables.isCustomFilterAvailable);

    if (_searchQuery!.length >= 1) getFirstSearchQuery();
  }

  /// The CLOTH search algorithm
  ///
  /// The [_searchPersistentNav] is used in a if/else block, followed by a
  /// switch statement on the "condition" [MarketGlobalVariables.searchCondition]
  /// selected by the user, with all the possible filter combination further
  /// wrapped in a if/else block and the appropriate Map<String, dynamic> return
  Future<Map<String, dynamic>> _clothSearchData() async {
    Map<String, dynamic> info = {};
    if (_searchPersistentNav[0] == kBestMatch) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            print("Any - Any ran");
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryBestMatch(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentBestMatch(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizeBestMatch(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizeBestMatch(_searchQuery);
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryBestMatch(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentBestMatch(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizeBestMatch(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBothDepartmentAndSizeBestMatch(_searchQuery);
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryBestMatch(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentBestMatch(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizeBestMatch(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBothDepartmentAndSizeBestMatch(_searchQuery);
          }
          break;
      }
    } else if (_searchPersistentNav[0] == kTopRated) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryTopRated(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentTopRated(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizeTopRated(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizeTopRated(_searchQuery);
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryTopRated(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentTopRated(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizeTopRated(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewDepartmentAndSizeTopRated(_searchQuery);
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryTopRated(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentTopRated(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizeTopRated(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedDepartmentAndSizeTopRated(_searchQuery);
          }
          break;
      }
    } else if (_searchPersistentNav[0] == kPriceLowHigh) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceLowHigh(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentPriceLowHigh(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizePriceLowHigh(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizePriceLowHigh(
                    _searchQuery);
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceLowHigh(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentPriceLowHigh(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizePriceLowHigh(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewDepartmentAndSizePriceLowHigh(_searchQuery);
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceLowHigh(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentPriceLowHigh(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizePriceLowHigh(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedDepartmentAndSizePriceLowHigh(_searchQuery);
          }
          break;
      }
    } else if (_searchPersistentNav[0] == kPriceHighLow) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceHighLow(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentPriceHighLow(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizePriceHighLow(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizePriceHighLow(
                    _searchQuery);
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceHighLow(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentPriceHighLow(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizePriceHighLow(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewDepartmentAndSizePriceHighLow(_searchQuery);
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceHighLow(_searchQuery);
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentPriceHighLow(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizePriceHighLow(
                    _searchQuery);
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedDepartmentAndSizePriceHighLow(_searchQuery);
          }
          break;
      }
    }

    return info;
  }

  /// This method uses the [MarketGlobalVariables.searchCategory] to return the
  /// appropriate Map<String, dynamic> based on the selected/identified product category
  ///
  /// [_categoryEnum] is also set to the right category.
  ///
  Future<Map<String, dynamic>> _searchCategorySelector() async {
    Map<String, dynamic> info = {};
    switch (MarketGlobalVariables.searchCategory) {
      case "Clothes":
        _categoryEnum = CategoryEnum.clothes;
        info = await _clothSearchData();
        break;
      case "Books":
        _categoryEnum = CategoryEnum.books;
        break;
      case "Laptops":
        _categoryEnum = CategoryEnum.laptops;
        break;
      case "Phones":
        _categoryEnum = CategoryEnum.phones;
        break;
    }
    return info;
  }

  /// This algorithm fetches the right Map<String, dynamic> data with the
  /// "key" - [kSearchedProducts] containing a List<DocumentSnapshot> of the
  /// search query result data and the "keys" [kNewLastDocuments], [kUsedLastDocuments]
  /// containing the List<DocumentSnapshot> for the new && used documents respectively
  ///
  /// An if/else block is used to check if a custom filter has been applied. If
  /// [_customFilterAvailable] == "true", the [_searchCategorySelector] is called
  /// with it's proceeding logic executed.
  ///
  /// OR
  ///
  /// Else, if it's the default filter in use, a switch statement is used on
  /// [_searchPersistentNav] with the possible filter combinations wrapped in an
  /// if/else block. The combinations are based on the "condition" & "category"
  void getFirstSearchQuery() async {
    _moreDocumentsAvailable = true;
    _shouldRunCheck = true;

    setState(() => _loadingProducts = true);

    searchedProducts.clear();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot>? searchedProductsDocSnap = [];

    if (_customFilterAvailable) {
      print("Custom filter available");
      info = await _searchCategorySelector();
    } else {
      print("No custom filter available");
      switch (_searchPersistentNav[0]) {

        /// BEST MATCH
        case kBestMatch:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchQueryDefaultBestMatch(_searchQuery);
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryBestMatch(_searchQuery);
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBestMatch(_searchQuery);
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryBestMatch(_searchQuery);
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBestMatch(_searchQuery);
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryBestMatch(_searchQuery);
          }

          break;

        /// TOP RATED
        case kTopRated:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchQueryDefaultTopRated(_searchQuery);
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryTopRated(_searchQuery);
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInNewProductsTopRated(_searchQuery);
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryTopRated(_searchQuery);
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsTopRated(_searchQuery);
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryTopRated(_searchQuery);
          }
          break;

        /// PRICE LOW-HIGH
        case kPriceLowHigh:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchQueryDefaultPriceLowHigh(_searchQuery);
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceLowHigh(_searchQuery);
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInNewProductsPriceLowHigh(_searchQuery);
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceLowHigh(_searchQuery);
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsPriceLowHigh(_searchQuery);
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceLowHigh(_searchQuery);
          }
          break;

        /// PRICE HIGH-LOW
        case kPriceHighLow:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchQueryDefaultPriceHighLow(_searchQuery);
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceHighLow(_searchQuery);
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInNewProductsPriceHighLow(_searchQuery);
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceHighLow(_searchQuery);
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsPriceHighLow(_searchQuery);
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceHighLow(_searchQuery);
          }
          break;
      }
    }

    searchedProductsDocSnap = info["SearchedProducts"];

    if (searchedProductsDocSnap!.isEmpty ||
        searchedProductsDocSnap.length == 0) {
      _moreDocumentsAvailable = false;

      setState(() => _loadingProducts = false);

      return;
    }

    if (MarketGlobalVariables.searchCondition == "Any") {
      newLastDocumentSnapshot = info[kNewLastDocuments];
      usedLastDocumentSnapshot = info[kUsedLastDocuments];
    } else {
      lastDocumentSnapshot = info[kSearchedProducts];
    }

    switch (_searchPersistentNav[0]) {
      case kTopRated:
        searchedProductsDocSnap =
            _mergeSortDocumentSnapshot(searchedProductsDocSnap);
        break;
      case kPriceLowHigh:
        searchedProductsDocSnap =
            _mergeSortDocumentSnapshot(searchedProductsDocSnap);
        break;
      case kPriceHighLow:
        searchedProductsDocSnap =
            _mergeSortDocumentSnapshot(searchedProductsDocSnap);
        break;
    }

    for (DocumentSnapshot docSnap in searchedProductsDocSnap) {
      SimilarProductModel singleSearchedProduct =
          SimilarProductModel.fromJson(docSnap.data() as Map<String, dynamic>);
      searchedProducts.add(singleSearchedProduct);
    }

    Map<String?, int>? availableCategoriesFromSearch;

    /// This function adds the available categories from the search query into [availableCategoriesFromSearch]
    /// If the category already exists in the Map, the value of the key (the key is the category name) which has
    /// a value of "1" when initially inserted is incremented by "1"
    for (int i = 0; i < searchedProducts.length; i++) {
      if (availableCategoriesFromSearch?.isEmpty ?? true) {
        availableCategoriesFromSearch = {
          searchedProducts[i].prC: 1,
        };
      } else if (availableCategoriesFromSearch!
          .containsKey(searchedProducts[i].prC)) {
        availableCategoriesFromSearch.update(searchedProducts[i].prC, (value) {
          return value = value + 1;
        });
      } else {
        availableCategoriesFromSearch[searchedProducts[i].prC] = 1;
      }
    }

    MarketGlobalVariables.searchedFilterCategory =
        availableCategoriesFromSearch;

    print(availableCategoriesFromSearch!.entries);
    print("GLOBAL MAP: ${MarketGlobalVariables.searchedFilterCategory}");

    if (mounted) setState(() => _loadingProducts = false);
  }

  void fetchNextSetOfDocuments() async {
    if (_shouldCheck && _moreDocumentsAvailable) {
      _hasGottenNextDocData = false;

      _shouldRunCheck = false;

      Map<String, dynamic> info = {};

      info = await _searchQueryNextDoc();

      List<DocumentSnapshot> searchedProductsDocSnap = info["SearchedProducts"];

      /// If the length of the [searchedProductsDocSnap] is empty, that means no
      /// more DocumentSnapshot for the user's search query is available.
      /// Then "return" from the function
      if (searchedProductsDocSnap.isEmpty ||
          searchedProductsDocSnap.length == 0) {
        _moreDocumentsAvailable = false;
        _hasGottenNextDocData = true;

        setState(() => _showCircularProgress = false);

        return;
      }

      if (MarketGlobalVariables.searchCondition == "Any") {
        newLastDocumentSnapshot = info["NewLastDocuments"];
        usedLastDocumentSnapshot = info["UsedLastDocuments"];

        print("FROM FETCH NEXT NEW: $newLastDocumentSnapshot");
        print("FROM FETCH NEXT USED: $usedLastDocumentSnapshot");
      } else {
        lastDocumentSnapshot = info[kSearchedProducts];
      }

      switch (_searchPersistentNav[0]) {
        case kTopRated:
          searchedProductsDocSnap =
              _mergeSortDocumentSnapshot(searchedProductsDocSnap);
          break;
        case kPriceLowHigh:
          searchedProductsDocSnap =
              _mergeSortDocumentSnapshot(searchedProductsDocSnap);
          break;
        case kPriceHighLow:
          searchedProductsDocSnap =
              _mergeSortDocumentSnapshot(searchedProductsDocSnap);
          break;
      }

      List<SimilarProductModel> tempChunk = [];

      for (DocumentSnapshot docSnap in searchedProductsDocSnap) {
        SimilarProductModel singleSearchedProduct =
            SimilarProductModel.fromJson(
                docSnap.data() as Map<String, dynamic>);
        tempChunk.add(singleSearchedProduct);
      }

      setState(() {
        searchedProducts.addAll(tempChunk);
        _showCircularProgress = false;
      });

      _shouldRunCheck = true;

      _hasGottenNextDocData = true;
    }
  }

  Future<Map<String, dynamic>> _searchQueryNextDoc() async {
    Map<String, dynamic> info = {};

    if (_customFilterAvailable) {
      info = await _searchCategorySelectorNext();
    } else {
      switch (_searchPersistentNav[0]) {

        /// BEST MATCH
        case kBestMatch:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService.searchQueryDefaultBestMatchNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryBestMatchNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService.searchInNewProductsBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService.searchInUsedProductsBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          break;

        /// TOP RATED
        case kTopRated:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService.searchQueryDefaultTopRatedNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryTopRatedNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService.searchInNewProductsTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info = await _marketSearchService.searchInUsedProductsTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;

        /// PRICE LOW-HIGH
        case kPriceLowHigh:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info =
                await _marketSearchService.searchQueryDefaultPriceLowHighNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceLowHighNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info =
                await _marketSearchService.searchInNewProductsPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info =
                await _marketSearchService.searchInUsedProductsPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;

        /// PRICE HIGH-LOW
        case kPriceHighLow:

          /// Condition == "Any", Category == "Any"
          if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info =
                await _marketSearchService.searchQueryDefaultPriceHighLowNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "Any", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Any" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceHighLowNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info =
                await _marketSearchService.searchInNewProductsPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "New", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "New" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category == "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory == "Any") {
            info =
                await _marketSearchService.searchInUsedProductsPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }

          /// Condition == "Used", Category != "Any"
          else if (MarketGlobalVariables.searchCondition == "Used" &&
              MarketGlobalVariables.searchCategory != "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;
      }
    }

    return info;
  }

  Future<Map<String, dynamic>> _searchCategorySelectorNext() async {
    Map<String, dynamic> info = {};
    switch (MarketGlobalVariables.searchCategory) {
      case "Clothes":
        _categoryEnum = CategoryEnum.clothes;
        info = await _clothQueryNext();
        break;
      case "Books":
        _categoryEnum = CategoryEnum.books;
        break;
      case "Laptops":
        _categoryEnum = CategoryEnum.laptops;
        break;
      case "Phones":
        _categoryEnum = CategoryEnum.phones;
        break;
    }
    return info;
  }

  Future<Map<String, dynamic>> _clothQueryNext() async {
    Map<String, dynamic> info = {};
    if (_searchPersistentNav[0] == kBestMatch) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            print("Any - Any ran");
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryBestMatchNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentBestMatchNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizeBestMatchNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizeBestMatchNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizeBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBothDepartmentAndSizeBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizeBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBothDepartmentAndSizeBestMatchNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;
      }
    } else if (_searchPersistentNav[0] == kTopRated) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryTopRatedNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentTopRatedNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: newLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizeTopRatedNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizeTopRatedNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizeTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewDepartmentAndSizeTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizeTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedDepartmentAndSizeTopRatedNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;
      }
    } else if (_searchPersistentNav[0] == kPriceLowHigh) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceLowHighNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentPriceLowHighNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizePriceLowHighNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizePriceLowHighNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizePriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewDepartmentAndSizePriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentPriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizePriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedDepartmentAndSizePriceLowHighNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;
      }
    } else if (_searchPersistentNav[0] == kPriceHighLow) {
      switch (MarketGlobalVariables.searchCondition) {

        /// If the "Condition" chosen == "Any"
        case "Any":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewAndUsedBasedOnCategoryPriceHighLowNext(
              searchQuery: _searchQuery,
              newLastDocumentSnapshot: newLastDocumentSnapshot,
              usedLastDocumentSnapshot: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnSizeAnyDepartmentPriceHighLowNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnDepartmentAnySizePriceHighLowNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchBasedOnBothDepartmentAndSizePriceHighLowNext(
              searchQuery: _searchQuery,
              newLastDocument: newLastDocumentSnapshot,
              usedLastDocument: usedLastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "New"
        case "New":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInNewProductsBasedOnCategoryPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnSizeAnyDepartmentPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInNewBasedOnDepartmentAnySizePriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInNewDepartmentAndSizePriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;

        /// If the "Condition" chosen == "Used"
        case "Used":
          if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _marketSearchService
                .searchInUsedProductsBasedOnCategoryPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment == "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnSizeAnyDepartmentPriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes == "Any") {
            info = await _clothSearchService
                .clothSearchInUsedBasedOnDepartmentAnySizePriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          } else if (MarketFilterLists.clothingDepartment != "Any" &&
              MarketFilterLists.clothSizes != "Any") {
            info = await _clothSearchService
                .clothSearchInUsedDepartmentAndSizePriceHighLowNext(
              searchQuery: _searchQuery,
              lastDocument: lastDocumentSnapshot,
            );
          }
          break;
      }
    }

    return info;
  }

  /// The Widget displayed when the search TextField is empty
  Widget _emptySearch(Size mediaQuery) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /// Widget for the "RECENTLY VIEWED - CLEAR"
          Visibility(
            visible: _isRecentlyViewedVisible,
            child: StreamBuilder(
                stream:
                    _marketDatabaseService.getRecentlyViewedProductsForSearch,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text("An error has occurred");
                  } else if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.active) {
                    List<QueryDocumentSnapshot> queryDocumentSnapshot =
                        snapshot.data.docs;

                    List<Map<String, dynamic>> recentlyViewedSearch = [];

                    for (QueryDocumentSnapshot doc in queryDocumentSnapshot) {
                      recentlyViewedSearch
                          .add(doc.data as Map<String, dynamic>);
                    }

                    if (recentlyViewedSearch.length >= 1) {
                      print(
                          "FROM EMPTY: ${MarketGlobalVariables.searchedFilterCategory}");
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'RECENTLY VIEWED',
                                  style: kMSearchHeading,
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (_isRecentlyViewedVisible) {
                                      setState(() {
                                        _isRecentlyViewedVisible = false;
                                      });
                                    }
                                    deleteRecentlyViewed(
                                        recentlyViewedSearch[0]["docId"]);
                                    print("Clear recently viewed clicked");
                                  },
                                  style: ButtonStyle(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.zero),
                                  ),
                                  child: Text(
                                    "CLEAR",
                                    style: kMSearchHeading.copyWith(
                                        color: kMarketPrimaryColor),
                                  ),
                                ),
                                // Text(
                                //   'CLEAR',
                                //   style: kMSearchHeading.copyWith(color: kMarketPrimaryColor),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, left: 10.0),
                            child: SizedBox(
                              height: 88.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recentlyViewedSearch.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            print("I've been tapped!");
                                            MarketBrain
                                                .recentlyViewedNeededValues(
                                              commonId:
                                                  recentlyViewedSearch[index]
                                                      ["cmId"],
                                              condition:
                                                  recentlyViewedSearch[index]
                                                      ["cond"],
                                            );

                                            Navigator.pushNamed(context,
                                                MarketProductDetails.id);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 16.0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            width: mediaQuery.width * 0.60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      51, 0, 0, 0),
                                                  offset:
                                                      Offset(0.0, 3.0), //(x,y)
                                                  blurRadius: 6.0,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                AspectRatio(
                                                  aspectRatio: 4 / 3,
                                                  child: CachedNetworkImage(
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                progress) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            kMarketPrimaryColor,
                                                        value:
                                                            progress.progress,
                                                      ),
                                                    ),
                                                    imageUrl:
                                                        recentlyViewedSearch[
                                                            index]["prImg"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        recentlyViewedSearch[
                                                            index]["prN"],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            kMSearchCardDetails,
                                                      ),
                                                      SizedBox(
                                                        height: ScreenUtil()
                                                            .setHeight(4),
                                                      ),
                                                      Text(
                                                        recentlyViewedSearch[
                                                                index]["price"]
                                                            .toStringAsFixed(2),
                                                        style:
                                                            kMSearchCardDetails,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  } else {
                    return SizedBox.shrink();
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'RECOMMENDED',
                  style: kMSearchHeading,
                ),
                Text(
                  'REFRESH',
                  style: kMSearchHeading.copyWith(color: kMarketPrimaryColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 8.0,
                children: <Widget>[
                  Chip(
                    label: Text(
                      'Denim Jeans',
                      style: kMSearchHeading,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Denim Jeans',
                      style: kMSearchHeading,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Denim Jeans',
                      style: kMSearchHeading,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Denim Jeans',
                      style: kMSearchHeading,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Denim Jeans',
                      style: kMSearchHeading,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Denim Jeans',
                      style: kMSearchHeading,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Denim Jeans',
                      style: kMSearchHeading,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The Widget displayed when the user starts typing in the search TextField
  Widget _searching() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: PersistentHeader(
            widget: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav(kBestMatch);
                        },
                        child: Text(
                          kBestMatch,
                          style: kMSearchPersistentHeader.copyWith(
                            color: _searchPersistentNav.contains(kBestMatch)
                                ? kMarketPrimaryColor
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav(kTopRated);
                        },
                        child: Text(
                          kTopRated,
                          style: kMSearchPersistentHeader.copyWith(
                            color: _searchPersistentNav.contains(kTopRated)
                                ? kMarketPrimaryColor
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav(kPriceLowHigh);
                        },
                        child: Text(
                          kPriceLowHigh,
                          style: kMSearchPersistentHeader.copyWith(
                            color: _searchPersistentNav.contains(kPriceLowHigh)
                                ? kMarketPrimaryColor
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav(kPriceHighLow);
                        },
                        child: Text(
                          kPriceHighLow,
                          style: kMSearchPersistentHeader.copyWith(
                            color: _searchPersistentNav.contains(kPriceHighLow)
                                ? kMarketPrimaryColor
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: _loadingProducts
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kMarketPrimaryColor,
                  ),
                )
              : searchedProducts.length == 0
                  ? Center(
                      child: Text("No Products"),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 2 / 3,
                            ),
                            itemCount: searchedProducts.length,
                            itemBuilder: (context, index) {
                              return SimilarProductsCard(
                                onTap: () {
                                  MarketBrain.recentlyViewedNeededValues(
                                      commonId: searchedProducts[index].cmId,
                                      storeId: searchedProducts[index].id,
                                      condition: searchedProducts[index].cond,
                                      category: searchedProducts[index].prC,
                                      productImg:
                                          searchedProducts[index].prImg![0],
                                      productName: searchedProducts[index].prN,
                                      price: searchedProducts[index].price,
                                      rating: searchedProducts[index].rate);

                                  if (!_isRecentlyViewedVisible) {
                                    setState(() {
                                      _isRecentlyViewedVisible = true;
                                    });
                                  }
                                  Navigator.pushNamed(
                                      context, MarketProductDetails.id);
                                },
                                imageUrl: searchedProducts[index].prImg![0],
                                productName: searchedProducts[index].prN,
                                productPrice: searchedProducts[index].price,
                                productRating: searchedProducts[index].rate,
                              );
                            },
                          ),
                        ),
                        _showCircularProgress
                            ? Center(
                                child: SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    backgroundColor: kMarketPrimaryColor,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _searchTextEditingController.addListener(_searchControllerListener);

    _scrollController = ScrollController();

    _scrollController!.addListener(() {
      double maxScroll = _scrollController!.position.maxScrollExtent;
      double currentScroll = _scrollController!.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;

      /// Bottom of the screen
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        if (!_hasGottenNextDocData && _moreDocumentsAvailable) {
          setState(() => _showCircularProgress = true);
        } else {
          setState(() => _showCircularProgress = false);
        }
      }

      if (maxScroll - currentScroll <= delta) {
        _shouldCheck = true;

        if (_shouldRunCheck && _moreDocumentsAvailable) {
          fetchNextSetOfDocuments();
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _clearAllCategoryFilter();
    _searchTextEditingController.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF3F4F6),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kMarketDarkPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Container(
            height: 40.0,
            decoration: BoxDecoration(
              color: Color(0xffF5F6F8),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              controller: _searchTextEditingController,
              autofocus: true,
              textCapitalization: TextCapitalization.none,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: kMarketSecondaryColor,
                ),
              ),
              onSubmitted: (value) {
                if (_searchQuery != null && _searchQuery!.length >= 1) {
                  if (prevSearchQuery != "") {
                    if (prevSearchQuery != _searchQuery) {
                      prevSearchQuery = _searchQuery;
                      setState(() => _isSearching = true);
                      getFirstSearchQuery();
                    }
                  } else {
                    prevSearchQuery = _searchQuery;
                    setState(() => _isSearching = true);
                    getFirstSearchQuery();
                  }
                }
              },
              onChanged: (value) {
                /// TODO: Remove, not in use
                MarketGlobalVariables.searchedWord = value.trim().toLowerCase();

                if (value.trim().length >= 1) {
                  if (!_searchInputFieldHaveText)
                    setState(() => _searchInputFieldHaveText = true);
                }

                /// TODO: Come back to this code after implementing the algorithm to check in specific categories
                // if (MarketGlobalVariables.searchedFilterCategory?.isEmpty ?? true) {
                //   if (_customFilterAvailable) {
                //     setState(() {
                //       _customFilterAvailable = false;
                //     });
                //   }
                // }

                /// I'm using this logic for testing, prior to testing the one above when more data is available
                ///
                /// If a custom filter was available prior to the user changing the the search query input,
                /// The boolean value of "_customFilterAvailable" is changed to false.
                if (_customFilterAvailable) {
                  setState(() {
                    _customFilterAvailable = false;
                  });
                }

                _clearSearchFilterParams();
              },
              decoration: InputDecoration(
                hintText: 'Search Something',
                hintStyle: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                border: InputBorder.none,
                prefixIcon: IconButton(
                  icon: SvgPicture.asset(
                    'images/market_images/market_search_left.svg',
                    height: ScreenUtil().setHeight(14),
                    color: _searchTextEditingController.text.length >= 1
                        ? kMarketSecondaryColor
                        : Colors.grey,
                  ),
                  onPressed: () {},
                ),
                suffixIcon: _searchInputFieldHaveText
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 18.0,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _searchTextEditingController.clear();

                          /// TODO: Remove [MarketGlobalVariables.searchedWord]
                          MarketGlobalVariables.searchedWord = '';
                          setState(() {
                            _isSearching = false;
                            _searchInputFieldHaveText = false;
                            prevSearchQuery = "";
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: SvgPicture.asset(
                    'images/market_images/m_filter_icon.svg',
                    width: 20.0,
                    height: 20.0,
                    color: Scaffold.of(context).isEndDrawerOpen
                        ? kCustomNavActiveColour
                        : null,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
          ],
        ),
        body: _isSearching ? _searching() : _emptySearch(mediaQuery),
        endDrawer: MarketSearchFilterDrawer(
          applyFilter: applyFilterSettings,
        ),
        endDrawerEnableOpenDragGesture: false,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget? widget;

  PersistentHeader({this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4.0,
      color: Colors.white,
      child: widget,
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
