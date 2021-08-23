import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/strings.dart';

class MarketSearchService {
  final _db = FirebaseFirestore.instance;

  final int limitSizeAny = 6;
  final int limitSizeNewOrUsed = 10;

  /// BEST MATCH

  /// This is the default query. The "new product" and "used product" collection
  /// groups are queried and their respective document snapshots combined together
  Future<Map<String, dynamic>> searchQueryDefaultBestMatch(
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
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup("usedProducts")
          .where("sWords", arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
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
      print("searchQueryDefaultBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchQueryDefaultBestMatchNext(
      {String? searchQuery,
      List<DocumentSnapshot>? newLastDocumentSnapshot,
      List<DocumentSnapshot>? usedLastDocumentSnapshot}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];
    List<DocumentSnapshot> usedDocumentSnapshot = [];

    /// This variable will hold a combination of the [newDocumentSnapshot] and
    /// [usedDocumentSnapshot]
    List<DocumentSnapshot> documentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        print("ENTERED NEW last document if-block");
        QuerySnapshot newProductSnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newProductSnapshot.docs;
        print("New Document Snapshot: ${newDocumentSnapshot.length}");
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        print("ENTERED USED last document if-block");
        QuerySnapshot usedProductSnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedProductSnapshot.docs;
      }

      documentSnapshot.addAll(newDocumentSnapshot);
      documentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: documentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("searchQueryDefaultBestMatchNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> returned from a search query when a user
  /// searches in a particular "product category" with the "product condition"
  /// toggled to "Any"
  ///
  /// Note: "BEST MATCH"
  Future<Map<String, dynamic>> searchInNewAndUsedBasedOnCategoryBestMatch(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
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
      print("searchInNewAndUsedBasedOnCategoryBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewAndUsedBasedOnCategoryBestMatchNext(
      {String? searchQuery,
      List<DocumentSnapshot>? newLastDocumentSnapshot,
      List<DocumentSnapshot>? usedLastDocumentSnapshot}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];
    List<DocumentSnapshot> usedDocumentSnapshot = [];

    /// This variable will hold a combination of the [newDocumentSnapshot] and
    /// [usedDocumentSnapshot]
    List<DocumentSnapshot> documentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot newProductSnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newProductSnapshot.docs;
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot usedProductSnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            .limit(limitSizeAny)
            .get();

        usedDocumentSnapshot = usedProductSnapshot.docs;
      }

      documentSnapshot.addAll(newDocumentSnapshot);
      documentSnapshot.addAll(usedDocumentSnapshot);

      info = {
        kSearchedProducts: documentSnapshot,
        kNewLastDocuments: newDocumentSnapshot,
        kUsedLastDocuments: usedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewAndUsedBasedOnCategoryBestMatchNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "BEST MATCH"
  Future<Map<String, dynamic>> searchInNewProductsBestMatch(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewProductsBestMatchNext(
      {String? searchQuery, List<DocumentSnapshot>? lastDocument}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBestMatchNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// with a selected "product category"
  ///
  /// NOTE: "BEST MATCH"
  Future<Map<String, dynamic>> searchInNewProductsBasedOnCategoryBestMatch(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewProductsBasedOnCategoryBestMatchNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryBestMatchNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "BEST MATCH"
  Future<Map<String, dynamic>> searchInUsedProductsBestMatch(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInUsedProductsBestMatchNext(
      {String? searchQuery, List<DocumentSnapshot>? lastDocument}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBestMatchNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// with a selected "product category"
  ///
  /// NOTE: "BEST MATCH"
  Future<Map<String, dynamic>> searchInUsedProductsBasedOnCategoryBestMatch(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryBestMatch: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInUsedProductsBasedOnCategoryBestMatchNext(
      {String? searchQuery, List<DocumentSnapshot>? lastDocument}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryBestMatchNext: $e");
    }

    return info;
  }

  /// TOP RATED

  /// This is the default query. The "new product" and "used product" collection
  /// groups are queried and their respective document snapshots combined together
  ///
  /// NOTE: "TOP RATED"
  Future<Map<String, dynamic>> searchQueryDefaultTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup('newProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup('usedProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
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
      print("searchQueryDefaultTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchQueryDefaultTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocumentSnapshot,
    List<DocumentSnapshot>? usedLastDocumentSnapshot,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
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
      print("searchQueryDefaultTopRatedNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> returned from a search query when a user
  /// searches in a particular "product category" with the "product condition" toggled to "Any"
  ///
  /// Note: "TOP RATED"
  Future<Map<String, dynamic>> searchInNewAndUsedBasedOnCategoryTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup('newProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("rate", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup('usedProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
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
      print("searchInNewAndUsedBasedOnCategoryTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewAndUsedBasedOnCategoryTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocumentSnapshot,
    List<DocumentSnapshot>? usedLastDocumentSnapshot,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            .orderBy("rate", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
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
      print("searchInNewAndUsedBasedOnCategoryTopRatedNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "TOP RATED"
  Future<Map<String, dynamic>> searchInNewProductsTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewProductsTopRatedNext(
      {String? searchQuery, List<DocumentSnapshot>? lastDocument}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsTopRatedNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// WITH a selected "product category"
  ///
  /// NOTE: "TOP RATED"
  Future<Map<String, dynamic>> searchInNewProductsBasedOnCategoryTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewProductsBasedOnCategoryTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryTopRatedNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "TOP RATED"
  Future<Map<String, dynamic>> searchInUsedProductsTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInUsedProductsTopRatedNext(
      {String? searchQuery, List<DocumentSnapshot>? lastDocument}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsTopRatedNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// WITH a selected "product category"
  ///
  /// NOTE: "TOP RATED"
  Future<Map<String, dynamic>> searchInUsedProductsBasedOnCategoryTopRated(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .orderBy("price")
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("rate", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryTopRated: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInUsedProductsBasedOnCategoryTopRatedNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            .orderBy("rate", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryTopRatedNext: $e");
    }

    return info;
  }

  /// PRICE LOW-HIGH

  /// This is the default query. The "new product" and "used product" collection
  /// groups are queried and their respective document snapshots combined together
  ///
  /// NOTE: "PRICE LOW-HIGH"
  Future<Map<String, dynamic>> searchQueryDefaultPriceLowHigh(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
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
      print("searchQueryDefaultPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchQueryDefaultPriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocumentSnapshot,
    List<DocumentSnapshot>? usedLastDocumentSnapshot,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
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
      print("searchQueryDefaultPriceLowHighNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> returned from a search query when a user
  /// searches in a particular "product category" with the "product condition"
  /// toggled to "Any"
  ///
  /// Note: "PRICE LOW-HIGH"
  Future<Map<String, dynamic>> searchInNewAndUsedBasedOnCategoryPriceLowHigh(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("price")
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
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
      print("searchInNewAndUsedBasedOnCategoryPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      searchInNewAndUsedBasedOnCategoryPriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocumentSnapshot,
    List<DocumentSnapshot>? usedLastDocumentSnapshot,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            // .orderBy("price")
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
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
      print("searchInNewAndUsedBasedOnCategoryPriceLowHighNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "PRICE LOW-HIGH"
  Future<Map<String, dynamic>> searchInNewProductsPriceLowHigh(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewProductsPriceLowHighNext(
      {String? searchQuery, List<DocumentSnapshot>? lastDocument}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsPriceLowHighNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// WITH a selected "product category"
  ///
  /// NOTE: "PRICE LOW-HIGH"
  Future<Map<String, dynamic>> searchInNewProductsBasedOnCategoryPriceLowHigh(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      searchInNewProductsBasedOnCategoryPriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryPriceLowHighNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "PRICE LOW-HIGH"
  Future<Map<String, dynamic>> searchInUsedProductsPriceLowHigh(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInUsedProductsPriceLowHighNext(
      {String? searchQuery, List<DocumentSnapshot>? lastDocument}) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsPriceLowHighNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// WITH a selected "product category"
  ///
  /// NOTE: "PRICE LOW-HIGH"
  Future<Map<String, dynamic>> searchInUsedProductsBasedOnCategoryPriceLowHigh(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("price")
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryPriceLowHigh: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      searchInUsedProductsBasedOnCategoryPriceLowHighNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price")
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            // .orderBy("price")
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryPriceLowHighNext: $e");
    }

    return info;
  }

  /// PRICE HIGH-LOW

  /// This is the default query. The "new product" and "used product" collection
  /// groups are queried and their respective document snapshots combined together
  ///
  /// NOTE: "PRICE HIGH-LOW"
  Future<Map<String, dynamic>> searchQueryDefaultPriceHighLow(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
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
      print("searchQueryDefaultPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchQueryDefaultPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocumentSnapshot,
    List<DocumentSnapshot>? usedLastDocumentSnapshot,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
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
      print("searchQueryDefaultPriceHighLowNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> returned from a search query when a user
  /// searches in a particular "product category" with the "product condition"
  /// toggled to "Any"
  ///
  /// Note: "PRICE HIGH-LOW"
  Future<Map<String, dynamic>> searchInNewAndUsedBasedOnCategoryPriceHighLow(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot newQuerySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("price", descending: true)
          .limit(limitSizeAny)
          .get();

      QuerySnapshot usedQuerySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
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
      print("searchInNewAndUsedBasedOnCategoryPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      searchInNewAndUsedBasedOnCategoryPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? newLastDocumentSnapshot,
    List<DocumentSnapshot>? usedLastDocumentSnapshot,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> newDocumentSnapshot = [];

    List<DocumentSnapshot> usedDocumentSnapshot = [];

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (newLastDocumentSnapshot != null &&
          newLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot newQuerySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(
                newLastDocumentSnapshot[newLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            // .orderBy("price", descending: true)
            .limit(limitSizeAny)
            .get();

        newDocumentSnapshot = newQuerySnapshot.docs;
      }

      if (usedLastDocumentSnapshot != null &&
          usedLastDocumentSnapshot.isNotEmpty) {
        QuerySnapshot usedQuerySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(
                usedLastDocumentSnapshot[usedLastDocumentSnapshot.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
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
      print("searchInNewAndUsedBasedOnCategoryPriceHighLowNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "PRICE HIGH-LOW"
  Future<Map<String, dynamic>> searchInNewProductsPriceHighLow(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInNewProductsPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsPriceHighLowNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "new product"
  /// WITH a selected "product category"
  ///
  /// NOTE: "PRICE HIGH-LOW"
  Future<Map<String, dynamic>> searchInNewProductsBasedOnCategoryPriceHighLow(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('newProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      searchInNewProductsBasedOnCategoryPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('newProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInNewProductsBasedOnCategoryPriceHighLowNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// WITHOUT any selected "product category"
  ///
  /// NOTE: "PRICE HIGH-LOW"
  Future<Map<String, dynamic>> searchInUsedProductsPriceHighLow(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>> searchInUsedProductsPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsPriceHighLowNext: $e");
    }

    return info;
  }

  /// This is the Map<String, dynamic> return when a user searches in "used product"
  /// WITH a selected "product category"
  ///
  /// NOTE: "PRICE HIGH-LOW"
  Future<Map<String, dynamic>> searchInUsedProductsBasedOnCategoryPriceHighLow(
      String? searchQuery) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup('usedProducts')
          .where('sWords', arrayContains: searchQuery)
          .where("price",
              isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
          .where("price",
              isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
          .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
          .orderBy("price", descending: true)
          .limit(limitSizeNewOrUsed)
          .get();

      searchedDocumentSnapshot = querySnapshot.docs;

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryPriceHighLow: $e");
    }

    return info;
  }

  Future<Map<String, dynamic>>
      searchInUsedProductsBasedOnCategoryPriceHighLowNext({
    String? searchQuery,
    List<DocumentSnapshot>? lastDocument,
  }) async {
    Map<String, dynamic> info = {};

    List<DocumentSnapshot> searchedDocumentSnapshot = [];

    try {
      if (lastDocument != null && lastDocument.isNotEmpty) {
        QuerySnapshot querySnapshot = await _db
            .collectionGroup('usedProducts')
            .orderBy("price", descending: true)
            .startAfterDocument(lastDocument[lastDocument.length - 1])
            .where('sWords', arrayContains: searchQuery)
            .where("price",
                isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
            .where("price",
                isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
            .where("prC", isEqualTo: MarketGlobalVariables.searchCategory)
            // .orderBy("price", descending: true)
            .limit(limitSizeNewOrUsed)
            .get();

        searchedDocumentSnapshot = querySnapshot.docs;
      }

      info = {
        kSearchedProducts: searchedDocumentSnapshot,
      };
    } catch (e) {
      print("searchInUsedProductsBasedOnCategoryPriceHighLowNext: $e");
    }

    return info;
  }
}
