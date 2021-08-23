import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/market/utilities/market_filter_lists.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/strings.dart';

class ClothSearchService {
  final _db = FirebaseFirestore.instance;

  final int limitSizeAny = 6;
  final int limitSizeNewOrUsed = 10;

  /// Method to get the appropriate "Cloth Department" for "Cloth search"
  String clothDepartmentGetter() {
    String result = "";

    switch (MarketFilterLists.clothingDepartment) {
      case "Boys' Fashion":
        result = "Boy's Clothes";
        break;
      case "Girls' Fashion":
        result = "Girl's Clothes";
        break;
      case "Men's Fashion":
        result = "Men's Clothes";
        break;
      case "Women's Fashion":
        result = "Women's Clothes";
        break;
    }
    return result;
  }

  /// Search query based on "CLOTHES" - "BEST MATCH"
  ///
  /// Condition = "Any" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size"
  /// WITHOUT selecting a "department"
  Future<Map<String, dynamic>> clothSearchBasedOnSizeAnyDepartmentBestMatch(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnSizeAnyDepartmentBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentBestMatchNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "BEST MATCH"
  ///
  /// Condition = "Any" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>> clothSearchBasedOnDepartmentAnySizeBestMatch(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizeBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnDepartmentAnySizeBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizeBestMatchNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "BEST MATCH"
  ///
  /// Condition - "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchBasedOnBothDepartmentAndSizeBestMatch(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizeBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnBothDepartmentAndSizeBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizeBestMatchNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "BEST MATCH"
  ///
  /// Condition = "New" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size"
  /// WITHOUT selecting a "department"
  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnSizeAnyDepartmentBestMatch(
          String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnSizeAnyDepartmentBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentBestMatchNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "BEST MATCH"
  ///
  /// Condition = "New" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnDepartmentAnySizeBestMatch(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizeBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnDepartmentAnySizeBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizeBestMatchNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "BEST MATCH"
  ///
  /// Condition = "New"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInNewBothDepartmentAndSizeBestMatch(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBothDepartmentAndSizeBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBothDepartmentAndSizeBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBothDepartmentAndSizeBestMatchNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "BEST MATCH"
  ///
  /// Condition = "Used" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size"
  /// WITHOUT selecting a "department"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentBestMatch(
          String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentBestMatchNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "BEST MATCH"
  ///
  /// Condition = "Used" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizeBestMatch(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizeBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizeBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizeBestMatchNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "BEST MATCH"
  ///
  /// Condition - "Used"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInUsedBothDepartmentAndSizeBestMatch(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBothDepartmentAndSizeBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBothDepartmentAndSizeBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBothDepartmentAndSizeBestMatchNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "TOP RATED"
  ///
  /// Condition = "Any" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>> clothSearchBasedOnSizeAnyDepartmentTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> clothSearchBasedOnSizeAnyDepartmentTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentTopRatedNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "TOP RATED"
  ///
  /// Condition = "Any" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>> clothSearchBasedOnDepartmentAnySizeTopRated(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizeTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> clothSearchBasedOnDepartmentAnySizeTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizeTopRatedNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "TOP RATED"
  ///
  /// Condition = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchBasedOnBothDepartmentAndSizeTopRated(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizeTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnBothDepartmentAndSizeTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizeTopRatedNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "TOP RATED"
  ///
  /// Condition = "New" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>> clothSearchInNewBasedOnSizeAnyDepartmentTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnSizeAnyDepartmentTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentTopRatedNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "TOP RATED"
  ///
  /// Condition = "New" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>> clothSearchInNewBasedOnDepartmentAnySizeTopRated(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizeTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnDepartmentAnySizeTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizeTopRatedNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "TOP RATED"
  ///
  /// Condition - "New"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInNewDepartmentAndSizeTopRated(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewDepartmentAndSizeTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> clothSearchInNewDepartmentAndSizeTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewDepartmentAndSizeTopRatedNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "TOP RATED"
  ///
  /// Condition = "Used" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentTopRated(
          String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentTopRatedNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "TOP RATED"
  ///
  /// Condition = "Used" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizeTopRated(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizeTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizeTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizeTopRatedNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "TOP RATED"
  ///
  /// Condition - "Used"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInUsedDepartmentAndSizeTopRated(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .orderBy("price")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedDepartmentAndSizeTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> clothSearchInUsedDepartmentAndSizeTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedDepartmentAndSizeTopRatedNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition = "Any" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>> clothSearchBasedOnSizeAnyDepartmentPriceLowHigh(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnSizeAnyDepartmentPriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price")
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price")
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentPriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition = "Any" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>> clothSearchBasedOnDepartmentAnySizePriceLowHigh(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizePriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnDepartmentAnySizePriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price")
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price")
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizePriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>>
      clothSearchBasedOnBothDepartmentAndSizePriceLowHigh(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizePriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnBothDepartmentAndSizePriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price")
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price")
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizePriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition = "New" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnSizeAnyDepartmentPriceLowHigh(
          String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnSizeAnyDepartmentPriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentPriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition = "New" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnDepartmentAnySizePriceLowHigh(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizePriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnDepartmentAnySizePriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizePriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition - "New"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInNewDepartmentAndSizePriceLowHigh(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewDepartmentAndSizePriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewDepartmentAndSizePriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewDepartmentAndSizePriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition = "Used" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentPriceLowHigh(
          String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentPriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            //  .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentPriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition = "Used" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT
  /// selecting a "size"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizePriceLowHigh(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizePriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizePriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizePriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE LOW-HIGH"
  ///
  /// Condition - "Used"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInUsedDepartmentAndSizePriceLowHigh(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedDepartmentAndSizePriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedDepartmentAndSizePriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedDepartmentAndSizePriceLowHighNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition = "Any" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>> clothSearchBasedOnSizeAnyDepartmentPriceHighLow(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnSizeAnyDepartmentPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnSizeAnyDepartmentPriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition = "Any" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>> clothSearchBasedOnDepartmentAnySizePriceHighLow(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizePriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnDepartmentAnySizePriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price", descending: true)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnDepartmentAnySizePriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>>
      clothSearchBasedOnBothDepartmentAndSizePriceHighLow(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      newDocumentSnapshot = newQuerySnapshot.docs;
      usedDocumentSnapshot = usedQuerySnapshot.docs;

      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizePriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchBasedOnBothDepartmentAndSizePriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocument,
    List<DocumentSnapshot>? usedLastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocument != null && newLastDocument.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(newLastDocument[newLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocument != null && usedLastDocument.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(usedLastDocument[usedLastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedQuerySnapshot.docs;
      }
      searchedDocumentSnapshot.addAll(newDocumentSnapshot);
      searchedDocumentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchBasedOnBothDepartmentAndSizePriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition = "New" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnSizeAnyDepartmentPriceHighLow(
          String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnSizeAnyDepartmentPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnSizeAnyDepartmentPriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition = "New" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnDepartmentAnySizePriceHighLow(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizePriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewBasedOnDepartmentAnySizePriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewBasedOnDepartmentAnySizePriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition - "New"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInNewDepartmentAndSizePriceHighLow(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("newProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewDepartmentAndSizePriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInNewDepartmentAndSizePriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("newProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInNewDepartmentAndSizePriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query for "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition = "Used" && Department = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "size" WITHOUT
  /// selecting a "department"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentPriceHighLow(
          String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnSizeAnyDepartmentPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnSizeAnyDepartmentPriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition = "Used" && Size = "Any"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// WITHOUT selecting a "size"
  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizePriceHighLow(
          String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizePriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedBasedOnDepartmentAnySizePriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedBasedOnDepartmentAnySizePriceHighLowNext: $e");
    }

    return info;
  }

  /// Search query based on "CLOTHES" - "PRICE HIGH-LOW"
  ///
  /// Condition - "Used"
  /// This is the Map<String, dynamic> returned when a user chooses a "department"
  /// AND a "size"
  Future<Map<String, dynamic>> clothSearchInUsedDepartmentAndSizePriceHighLow(
      String? searchQuery) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("subC", isEqualTo: clothDepartment)
          .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedDepartmentAndSizePriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      clothSearchInUsedDepartmentAndSizePriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    String clothDepartment = clothDepartmentGetter();

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup("usedProducts")
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where("sWords", arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("subC", isEqualTo: clothDepartment)
            .where("cSize.${MarketFilterLists.clothSizes}", isEqualTo: true)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("clothSearchInUsedDepartmentAndSizePriceHighLowNext: $e");
    }

    return info;
  }
}
