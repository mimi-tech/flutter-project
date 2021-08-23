import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:sparks/market/market_models/cloth_base_model.dart';
import 'package:sparks/market/market_models/cloth_product_listing_model.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:sparks/market/utilities/market_brain.dart';
import 'package:sparks/market/utilities/market_filter_lists.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/strings.dart';

class MarketDatabaseService {
  final String? userId;

  MarketDatabaseService({this.userId});

  final _db = FirebaseFirestore.instance;

  /// Function to upload default product fields
  Future<void> uploadClothBaseFields(DocumentReference documentReference,
      ClothBaseModel clothBaseModel) async {
    try {
      await documentReference.set(clothBaseModel.toJson());
    } catch (e) {
      print(e);
    }
  }

  /// Function to push Cloth Product Listing to the database
  Future<void> uploadClothProductListing(DocumentReference documentReference,
      ClothProductListingModel clothProductListingModel) async {
    try {
      await documentReference.set(clothProductListingModel.toJson());
    } catch (e) {
      print(e);
    }
  }

  /// TODO: Store followers will be a collection under the stores's uid

  /// Method to get the Store Details pertaining to the market products
  Future<List<DocumentSnapshot>> getProductStoreDetail(
      List<String?> storeId) async {
    List<DocumentSnapshot> prodStoreDocSnap = [];
    List<DocumentSnapshot> temp = [];

    for (String? id in storeId) {
      await _db
          .collection('stores')
          .where('id', isEqualTo: id)
          .get()
          .then((storeDetailSnapshot) {
        temp.add(storeDetailSnapshot.docs[0]);
      }).catchError((onError) {
        print(onError);
      });
    }

    prodStoreDocSnap = temp.toList();

    return prodStoreDocSnap;
  }

  /// Method to get Either 'New' or 'Used' Market products based on rating
  /// NOTE: This is the method for fetching "popular" products
  Future<Map<String, dynamic>> getMarketProductsBasedOnCondition(
      String prodCondition) async {
    Map<String, dynamic> info = {};
    List<String?> storeUID = [];
    List<DocumentSnapshot> storeDetailsDocSnap = [];

    /// TODO: Implement logic that calculates the sale percentage of a particular product to determine products with a higher sale percentage ratio

    try {
      QuerySnapshot productDetailSnapshot = await _db
          .collectionGroup(prodCondition)
          .orderBy("rate", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> productDetailsDocSnap = productDetailSnapshot.docs;

      for (DocumentSnapshot docSnap in productDetailsDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? st = mappedData["id"];
        storeUID.add(st);
      }

      storeDetailsDocSnap = await getProductStoreDetail(storeUID);

      info = {
        kProductDetails: productDetailsDocSnap,
        kStoreDetails: storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get Either 'New' or 'Used' Market products based on rating
  Future<Map<String, dynamic>> getMarketProductsBasedOnConditionNextTen(
      String prodCondition, List<DocumentSnapshot> lastDocument) async {
    Map<String, dynamic> info = {};
    List<String?> storeIds = [];
    List<DocumentSnapshot> storeDetailsDocSnap = [];

    /// TODO: Implement logic that calculates the sale percentage of a particular product to determine products with a higher sale percentage ratio

    try {
      QuerySnapshot productDetailSnapshot = await _db
          .collectionGroup(prodCondition)
          .startAfterDocument(lastDocument[lastDocument.length - 1])
          .orderBy("rate", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> productDetailsDocSnap = productDetailSnapshot.docs;

      for (DocumentSnapshot docSnap in productDetailsDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? st = mappedData["id"];
        storeIds.add(st);
      }

      storeDetailsDocSnap = await getProductStoreDetail(storeIds);

      info = {
        kProductDetails: productDetailsDocSnap,
        kStoreDetails: storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get User's Recently Viewed Market Products
  Future<Map<String, dynamic>> getRecentlyViewedProducts(
      String? prodCondition) async {
    String cond;
    if (prodCondition == "newProducts") {
      cond = "new product";
    } else {
      cond = "used product";
    }

    List<DocumentSnapshot> productDetailsDocSnap = [];

    List<DocumentSnapshot> storeDetailsDocSnap = [];

    List<String?> productCommonId = [];
    List<String?> storeUID = [];
    Map<String, dynamic> info = {};

    try {
      /// TODO: Sort the query by "timestamp"
      QuerySnapshot recentlyViewedSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Market")
          .doc("marketInfo")
          .collection("marketRecentlyViewed")
          .where("cond", isEqualTo: cond)
          .orderBy("ts", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> recentlyViewedDocSnap =
          recentlyViewedSnapshot.docs;

      /// Getting the "common ID" of the user's recently viewed products
      for (DocumentSnapshot docSnap in recentlyViewedDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? cmId = mappedData['cmId'];
        productCommonId.add(cmId);
      }

      /// Querying to fetch products that match the "common ID" of the user's
      /// recently viewed products
      for (String? commonId in productCommonId) {
        QuerySnapshot productDetailSnapshot = await FirebaseFirestore.instance
            .collectionGroup(prodCondition!)
            .where('cmId', isEqualTo: commonId)
            .get();
        productDetailsDocSnap.add(productDetailSnapshot.docs[0]);
      }

      if (productDetailsDocSnap.isNotEmpty) {
        for (DocumentSnapshot docSnap in productDetailsDocSnap) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          String? st = data["id"];
          storeUID.add(st);
        }
      }

      storeDetailsDocSnap = await getProductStoreDetail(storeUID);

      /// TODO: Check that the length of the [productDetailsDocSnap] and [storeDetailsDocSnap] are the same.

      info = {
        kRecentlyViewedDoc: recentlyViewedDocSnap,
        kProductDetails: productDetailsDocSnap,
        kStoreDetails: storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get User's Recently Viewed Market Products
  Future<Map<String, dynamic>> getRecentlyViewedProductsNextTen(
      String? prodCondition, List<DocumentSnapshot> lastDocument) async {
    String cond;
    if (prodCondition == "newProducts") {
      cond = "new product";
    } else {
      cond = "used product";
    }

    List<DocumentSnapshot> productDetailsDocSnap = [];

    List<DocumentSnapshot> storeDetailsDocSnap = [];

    List<String?> productCommonId = [];
    List<String?> storeUID = [];
    Map<String, dynamic> info = {};

    try {
      /// TODO: Sort the query by "timestamp"
      QuerySnapshot recentlyViewedSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Market")
          .doc("marketInfo")
          .collection("marketRecentlyViewed")
          .startAfterDocument(lastDocument[lastDocument.length - 1])
          .where("cond", isEqualTo: cond)
          .orderBy("ts", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> recentlyViewedDocSnap =
          recentlyViewedSnapshot.docs;

      /// Getting the "common ID" of the user's recently viewed products
      for (DocumentSnapshot docSnap in recentlyViewedDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? cmId = mappedData['cmId'];
        productCommonId.add(cmId);
      }

      /// Querying to fetch products that match the "common ID" of the user's
      /// recently viewed products
      for (String? commonId in productCommonId) {
        QuerySnapshot productDetailSnapshot = await FirebaseFirestore.instance
            .collectionGroup(prodCondition!)
            .where('cmId', isEqualTo: commonId)
            .get();
        productDetailsDocSnap.add(productDetailSnapshot.docs[0]);
      }

      /// This if-block might not be needed if proper checks are done in the
      /// [MarketHome]
      if (productDetailsDocSnap.isNotEmpty) {
        for (DocumentSnapshot docSnap in productDetailsDocSnap) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          String? st = data["id"];
          storeUID.add(st);
        }
      }

      storeDetailsDocSnap = await getProductStoreDetail(storeUID);

      info = {
        "RecentlyViewedDoc": recentlyViewedDocSnap,
        "ProductDetails": productDetailsDocSnap,
        "StoreDetails": storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get the recently viewed market product by the user based of the "product category"
  Future<Map<String, dynamic>> getRecentlyViewedProductsBasedOnCategory(
      String? prodCondition, String category) async {
    String cond;
    if (prodCondition == "newProducts") {
      cond = "new product";
    } else {
      cond = "used product";
    }

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> productDetailsDocSnap = [];

    List<DocumentSnapshot> storeDetailsDocSnap = [];

    List<String?> productCommonId = [];

    List<String?> storeUID = [];

    try {
      QuerySnapshot recentlyViewedSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Market')
          .doc("marketInfo")
          .collection("marketRecentlyViewed")
          .where('cond', isEqualTo: cond)
          .where('prC', isEqualTo: category)
          .orderBy("ts", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> recentlyViewedDocSnap =
          recentlyViewedSnapshot.docs;

      /// Getting the "common ID" of the user's recently viewed products
      for (DocumentSnapshot docSnap in recentlyViewedDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? cmId = mappedData['cmId'];
        productCommonId.add(cmId);
      }

      /// Querying to fetch products that match the "common ID" of the user's
      /// recently viewed products
      for (String? commonId in productCommonId) {
        QuerySnapshot productDetailSnapshot = await FirebaseFirestore.instance
            .collectionGroup(prodCondition!)
            .where('cmId', isEqualTo: commonId)
            .get();
        productDetailsDocSnap.add(productDetailSnapshot.docs[0]);
      }

      if (productDetailsDocSnap.isNotEmpty) {
        for (DocumentSnapshot docSnap in productDetailsDocSnap) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          String? st = data["id"];
          storeUID.add(st);
        }
      }

      storeDetailsDocSnap = await getProductStoreDetail(storeUID);

      /// TODO: Check that the length of the [productDetailsDocSnap] and [storeDetailsDocSnap] are the same.

      info = {
        "RecentlyViewedDoc": recentlyViewedDocSnap,
        "ProductDetails": productDetailsDocSnap,
        "StoreDetails": storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get the recently viewed market product by the user based of the "product category"
  Future<Map<String, dynamic>> getRecentlyViewedProductsBasedOnCategoryNextTen(
      String? prodCondition,
      String category,
      List<DocumentSnapshot> lastDocument) async {
    String cond;
    if (prodCondition == "newProducts") {
      cond = "new product";
    } else {
      cond = "used product";
    }

    Map<String, dynamic> info = {};

    List<DocumentSnapshot> productDetailsDocSnap = [];

    List<DocumentSnapshot> storeDetailsDocSnap = [];

    List<String?> productCommonId = [];

    List<String?> storeUID = [];

    try {
      /// TODO: Add order by "timestamp"
      QuerySnapshot recentlyViewedSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Market')
          .doc("marketInfo")
          .collection("marketRecentlyViewed")
          .startAfterDocument(lastDocument[lastDocument.length - 1])
          .where('cond', isEqualTo: cond)
          .where('prC', isEqualTo: category)
          .orderBy("ts", descending: true)
          .get();

      List<DocumentSnapshot> recentlyViewedDocSnap =
          recentlyViewedSnapshot.docs;

      /// Getting the "common ID" of the user's recently viewed products
      for (DocumentSnapshot docSnap in recentlyViewedDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? cmId = mappedData['cmId'];
        productCommonId.add(cmId);
      }

      /// Querying to fetch products that match the "common ID" of the user's
      /// recently viewed products
      for (String? commonId in productCommonId) {
        QuerySnapshot productDetailSnapshot = await FirebaseFirestore.instance
            .collectionGroup(prodCondition!)
            .where('cmId', isEqualTo: commonId)
            .get();
        productDetailsDocSnap.add(productDetailSnapshot.docs[0]);
      }

      if (productDetailsDocSnap.isNotEmpty) {
        for (DocumentSnapshot docSnap in productDetailsDocSnap) {
          Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
          String? st = data["id"];
          storeUID.add(st);
        }
      }

      storeDetailsDocSnap = await getProductStoreDetail(storeUID);

      /// TODO: Check that the length of the [productDetailsDocSnap] and [storeDetailsDocSnap] are the same.

      info = {
        "RecentlyViewedDoc": recentlyViewedDocSnap,
        "ProductDetails": productDetailsDocSnap,
        "StoreDetails": storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get market products based on the user's selected category
  Future<Map<String, dynamic>> getProductsBasedOnCategory(
      String prodCondition, String category) async {
    Map<String, dynamic> info = {};

    List<String?> storeIds = [];

    try {
      QuerySnapshot productDetailSnapshot = await FirebaseFirestore.instance
          .collectionGroup(prodCondition)
          .where('prC', isEqualTo: category)
          .orderBy("rate", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> productDetailsDocSnap = productDetailSnapshot.docs;

      for (DocumentSnapshot docSnap in productDetailsDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? st = mappedData["id"];
        storeIds.add(st);
      }

      List<DocumentSnapshot> storeDetailsDocSnap =
          await getProductStoreDetail(storeIds);

      info = {
        kProductDetails: productDetailsDocSnap,
        kStoreDetails: storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get market products based on the user's selected category
  Future<Map<String, dynamic>> getProductsBasedOnCategoryNextTen(
      String prodCondition,
      String category,
      List<DocumentSnapshot> lastDocument) async {
    Map<String, dynamic> info = {};

    List<String?> storeIds = [];

    /// TODO: Create a 'where' clause to retrieve data based on the product rating

    try {
      QuerySnapshot productDetailSnapshot = await FirebaseFirestore.instance
          .collectionGroup(prodCondition)
          .startAfterDocument(lastDocument[lastDocument.length - 1])
          .where('prC', isEqualTo: category)
          .orderBy("rate", descending: true)
          .limit(10)
          .get();

      List<DocumentSnapshot> productDetailsDocSnap = productDetailSnapshot.docs;

      for (DocumentSnapshot docSnap in productDetailsDocSnap) {
        Map<String, dynamic> mappedData =
            docSnap.data() as Map<String, dynamic>;
        String? st = mappedData["id"];
        storeIds.add(st);
      }

      List<DocumentSnapshot> storeDetailsDocSnap =
          await getProductStoreDetail(storeIds);

      info = {
        "ProductDetails": productDetailsDocSnap,
        "StoreDetails": storeDetailsDocSnap,
      };
    } catch (e) {
      print(e);
    }

    return info;
  }

  /// Method to get similar products to that selected by the user
  Future<QuerySnapshot?> getSimilarProducts(
      String prodCondition, String category) async {
    QuerySnapshot? querySnapshot;

    await FirebaseFirestore.instance
        .collectionGroup(prodCondition)
        .where('prC', isEqualTo: category)
        .get()
        .then((snapshot) {
      querySnapshot = snapshot;
    }).catchError((onError) {
      print(onError);
    });

    return querySnapshot;
  }

  /// Fetches the default market products
  Stream<QuerySnapshot> defaultMarketStream(String productCondition) {
    return FirebaseFirestore.instance
        .collectionGroup(productCondition)
        .snapshots();
  }

  /// Stream to fetch similar market products
  Stream<QuerySnapshot> similarProducts(
      String productCondition, String productCategory) {
    productCondition =
        MarketBrain.prodCondCollectionConverter(productCondition);

    return FirebaseFirestore.instance
        .collectionGroup(productCondition)
        .where('prC', isEqualTo: productCategory)
        .snapshots();
  }

  Future<List<DocumentSnapshot>> fetchSimilarProducts(
      String? productCondition, String? productCategory) async {
    productCondition =
        MarketBrain.prodCondCollectionConverter(productCondition);

    List<DocumentSnapshot> similarProducts = [];

    QuerySnapshot querySnapshot = await _db
        .collectionGroup(productCondition)
        .where("prC", isEqualTo: productCategory)
        .limit(10)
        .get();

    similarProducts = querySnapshot.docs;

    return similarProducts;
  }

  Future<List<DocumentSnapshot>> fetchSimilarProductsNext(
      String? productCondition,
      String? productCategory,
      List<DocumentSnapshot> lastDocument) async {
    productCondition =
        MarketBrain.prodCondCollectionConverter(productCondition);

    List<DocumentSnapshot> similarProducts = [];

    QuerySnapshot querySnapshot = await _db
        .collectionGroup(productCondition)
        .startAfterDocument(lastDocument[lastDocument.length - 1])
        .where("prC", isEqualTo: productCategory)
        .limit(10)
        .get();

    similarProducts = querySnapshot.docs;

    return similarProducts;
  }

  /// Method to get User's Recently Viewed Market Products for the search screen
  Stream<QuerySnapshot> get getRecentlyViewedProductsForSearch {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Market")
        .doc("marketInfo")
        .collection("marketRecentlyViewed")
        .orderBy("ts", descending: true)
        .limit(10)
        .snapshots();
  }

  /// Stream to fetch similar market products
  Stream<QuerySnapshot> comeBackToThisLater(String searchQuery) {
    final firstStream = FirebaseFirestore.instance
        .collectionGroup("newProducts")
        .where('sWords', arrayContains: searchQuery)
        .snapshots();

    final secondStream = FirebaseFirestore.instance
        .collectionGroup("usedProducts")
        .where("sWords", arrayContains: searchQuery)
        .snapshots();

    final mergedStream = Rx.merge([firstStream, secondStream]);

    return mergedStream;
  }

  /// TODO: Delete this method and the methods that depend on it
  Stream<List<QuerySnapshot>> searchQueryDefaultBestMatch(String searchQuery) {
    print("BEST MATCH: From Database Service running...");
    Stream newProductStream = FirebaseFirestore.instance
        .collectionGroup('newProducts')
        .where('sWords', arrayContains: searchQuery)
        .where("price",
            isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
        .where("price",
            isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
        .limit(6)
        .snapshots();

    Stream usedProductStream = FirebaseFirestore.instance
        .collectionGroup('usedProducts')
        .where('sWords', arrayContains: searchQuery)
        .where("price",
            isGreaterThanOrEqualTo: MarketGlobalVariables.searchMinPrice)
        .where("price",
            isLessThanOrEqualTo: MarketGlobalVariables.searchMaxPrice)
        .limit(6)
        .snapshots();

    return StreamZip([
      newProductStream as Stream<QuerySnapshot<Object>>,
      usedProductStream as Stream<QuerySnapshot<Object>>
    ]);
  }

  Stream<List<DocumentSnapshot>> usingAStreamController(String userId) {
    final controller = StreamController<List<DocumentSnapshot>>();

    searchQueryDefaultBestMatch(userId).listen((snapshots) {
      List<DocumentSnapshot> documents = [];

      snapshots.forEach((snapshot) {
        documents.addAll(snapshot.docs);
      });

      controller.add(documents);
    });

    return controller.stream;
  }

  Stream<List<DocumentSnapshot>> victorBoss(String searchQuery) {
    Stream<QuerySnapshot> firstStream = FirebaseFirestore.instance
        .collectionGroup("newProducts")
        .where('sWords', arrayContains: searchQuery)
        .snapshots();

    Stream<QuerySnapshot> secondStream = FirebaseFirestore.instance
        .collectionGroup("usedProducts")
        .where("sWords", arrayContains: searchQuery)
        .snapshots();

    //final mergedStream = Rx.merge([firstStream, secondStream]);
    //return mergedStream;
    //return StreamZip([firstStream, secondStream]).asBroadcastStream();

    StreamZip bothStreams = StreamZip([firstStream, secondStream]);

    return merge(
        bothStreams.asBroadcastStream() as Stream<List<QuerySnapshot<Object>>>);
  }

  Stream<List<DocumentSnapshot>> merge(
      Stream<List<QuerySnapshot>> streamFromStreamZip) {
    return streamFromStreamZip.map((List<QuerySnapshot> list) {
      return list.fold([], (distinctList, snapshot) {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          final newDocument = distinctList.firstWhereOrNull(
                  (DocumentSnapshot listed) => listed.id == doc.id) ==
              null;

          if (newDocument) {
            distinctList.add(doc);
          }
        });

        return distinctList;
      });
    });
  }

  Future<void> followStore(
      String? storeId, String? storeImgUrl, String? storeName) async {
    try {
      /// A query in the store collection to ensure that the user is not already
      /// following the store to avoid duplication of data
      QuerySnapshot storeQuerySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeId)
          .collection("followers")
          .where("id", isEqualTo: userId)
          .get();

      List<QueryDocumentSnapshot> storeDocSnapshot = storeQuerySnapshot.docs;

      /// A query in the user's collection to verify that the user is not already
      /// following the store
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Market")
          .doc("marketInfo")
          .collection("followedStores")
          .where("id", isEqualTo: storeId)
          .get();

      List<QueryDocumentSnapshot> userDocSnapshot = userQuerySnapshot.docs;

      if (storeDocSnapshot.isEmpty && userDocSnapshot.isEmpty) {
        DocumentSnapshot userInfo = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("Market")
            .doc("marketInfo")
            .get();

        if (userInfo.exists) {
          DocumentReference storeDocRef = FirebaseFirestore.instance
              .collection("stores")
              .doc(storeId)
              .collection("followers")
              .doc();

          DocumentReference userDocReference = FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("Market")
              .doc("marketInfo")
              .collection("followedStores")
              .doc();

          if (storeDocRef != null && userDocReference != null) {
            WriteBatch batch = FirebaseFirestore.instance.batch();

            batch.set(storeDocRef, {
              "id": userId,
              "em": userInfo["em"] as String?,
              "un": userInfo["un"] as String?,
              "ts": DateTime.now().millisecondsSinceEpoch,
              "docId": storeDocRef.id,
            });

            batch.set(userDocReference, {
              "id": storeId,
              "stNm": storeName,
              "stImg": storeImgUrl,
              "ts": DateTime.now().millisecondsSinceEpoch,
              "docId": userDocReference.id,
            });

            await batch.commit();
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unfollowStore(String? storeId) async {
    try {
      QuerySnapshot storeQuerySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeId)
          .collection("followers")
          .where("id", isEqualTo: userId)
          .get();

      List<QueryDocumentSnapshot> storeDocSnapshot = storeQuerySnapshot.docs;

      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Market")
          .doc("marketInfo")
          .collection("followedStores")
          .where("id", isEqualTo: storeId)
          .get();

      // List<QueryDocumentSnapshot> userDocSnapshot = userQuerySnapshot.docs;

      List<Map<String, dynamic>?> userDocSnapshot =
          userQuerySnapshot.docs.map((DocumentSnapshot doc) {
        return doc.data as Map<String, dynamic>?;
      }).toList();

      if (storeDocSnapshot.length >= 1 && userDocSnapshot.length >= 1) {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        String? storeDocId = storeDocSnapshot[0]["docId"] as String?;
        DocumentReference storeDocRef = FirebaseFirestore.instance
            .collection("stores")
            .doc(storeId)
            .collection("followers")
            .doc(storeDocId);

        String? userDocId = userDocSnapshot[0]!["docId"];
        DocumentReference userDocRef = FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("Market")
            .doc("marketInfo")
            .collection("followedStores")
            .doc(userDocId);

        if (storeDocRef != null && userDocRef != null) {
          batch.delete(storeDocRef);
          batch.delete(userDocRef);

          await batch.commit();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  /// Method that gets the username of the currently logged in user
  Future<String?> getUsername() async {
    String? result;

    await FirebaseFirestore.instance
        .collection("username")
        .doc(userId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        result = documentSnapshot.data()!["un"];
      }
    }).catchError((onError) {
      print(onError);
    });

    return result;
  }

  /// Method called when a user rates a product
  Future<void> rateProduct(
      {int? rating,
      String? storeId,
      required String prodCategory,
      String? prodCondition,
      String? docId}) async {
    /// The product condition passed into [MarketCard] is either "new product"
    /// or "used product" and needs to be converted into either "newProducts"
    /// or "usedProducts" respectively.
    ///
    /// This is so that it can be used to query the appropriate collection
    /// which will bear either of the converted names (i.e. either "newProducts"
    /// or "usedProducts")
    String prodCondCollection() {
      String condition;

      if (prodCondition == "new product") {
        condition = "newProducts";
      } else {
        condition = "usedProducts";
      }

      return condition;
    }

    try {
      /// Query to get user's previous rating
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(prodCategory.toLowerCase())
          .collection(prodCondCollection())
          .doc(docId)
          .collection("productRatings")
          .where("id", isEqualTo: userId)
          .get();

      DocumentSnapshot docSnapShot = await _db
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(prodCategory.toLowerCase())
          .collection(prodCondCollection())
          .doc(docId)
          .collection("productRatings")
          .doc(userId)
          .get();

      List<QueryDocumentSnapshot> qDocSnapshot = querySnapshot.docs;

      /// The user has not rated the product yet
      if (!docSnapShot.exists) {
        if (rating != 0) {
          String? userName = await getUsername();

          if (userName != null) {
            // DocumentReference prodRatingDocRef = FirebaseFirestore.instance
            //     .collection("stores")
            //     .doc(storeId)
            //     .collection("userStore")
            //     .doc(prodCategory.toLowerCase())
            //     .collection(prodCondCollection())
            //     .doc(docId)
            //     .collection("productRatings")
            //     .doc();

            await _db
                .collection("stores")
                .doc(storeId)
                .collection("userStore")
                .doc(prodCategory.toLowerCase())
                .collection(prodCondCollection())
                .doc(docId)
                .collection("productRatings")
                .doc(userId)
                .set({
              "un": userName,
              "id": userId,
              "stId": storeId,
              "ts": DateTime.now().millisecondsSinceEpoch,
              "rate": rating,
            });

            // await prodRatingDocRef.set({
            //   "un": userName,
            //   "id": userId,
            //   "stId": storeId,
            //   "ts": DateTime.now().millisecondsSinceEpoch,
            //   "rate": rating,
            //   "docId": prodRatingDocRef.id,
            // });
          }
        }
      } else {
        /// The user has previously rated the product

        // String prevRatingDocId = qDocSnapshot[0].data()["docId"];
        // int prevRating = qDocSnapshot[0].data()["rate"];

        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        int? prevRating = data["rate"];

        /// The selected rating is "0", which means the user wants to delete
        /// their previous rating
        if (rating == 0) {
          await FirebaseFirestore.instance
              .collection("stores")
              .doc(storeId)
              .collection("userStore")
              .doc(prodCategory.toLowerCase())
              .collection(prodCondCollection())
              .doc(docId)
              .collection("productRatings")
              .doc(userId)
              .delete();
        } else {
          /// The current rating is different from the user's previous rating, an
          /// update will be made on the user's previous rating
          if (prevRating != rating) {
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(storeId)
                .collection("userStore")
                .doc(prodCategory.toLowerCase())
                .collection(prodCondCollection())
                .doc(docId)
                .collection("productRatings")
                .doc(userId)
                .update({
              "rate": rating,
              "ts": DateTime.now().millisecondsSinceEpoch
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postProductReview(
      {String? review,
      String? userId,
      String? userName,
      String? docId,
      String? storeId,
      required String condition,
      String? category}) async {
    try {
      DocumentReference docRef = _db
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(category)
          .collection(condition)
          .doc(docId)
          .collection("reviews")
          .doc();

      await docRef.set({
        "cmt": review,
        "ts": DateTime.now().millisecondsSinceEpoch,
        "un": userName,
        "id": userId,
        "docId": docRef.id,
      });
    } catch (e) {
      print(e);
    }
  }

  /// Method to delete the user's review on a product
  Future<void> deleteUserProductReview(
      {String? storeId,
      String? category,
      required String prodCondition,
      String? docId,
      String? reviewDocId}) async {
    try {
      await _db
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(category)
          .collection(prodCondition)
          .doc(docId)
          .collection("reviews")
          .doc(reviewDocId)
          .delete();
    } catch (e) {
      print("Error deleting product review: $e");
    }
  }

  /// Method to update the user's review on a product
  Future<void> updateUserProductReview(
      {String? storeId,
      String? category,
      required String prodCondition,
      String? docId,
      String? reviewDocId,
      String? newReview}) async {
    try {
      _db
          .collection("stores")
          .doc(storeId)
          .collection("userStore")
          .doc(category)
          .collection(prodCondition)
          .doc(docId)
          .collection("reviews")
          .doc(reviewDocId)
          .update({
        "cmt": newReview,
        "ts": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print("Failed to update review: $e");
    }
  }

  Stream<QuerySnapshot> productReviews(
      {String? storeId,
      String? category,
      required String condition,
      String? docId}) {
    return _db
        .collection("stores")
        .doc(storeId)
        .collection("userStore")
        .doc(category)
        .collection(condition)
        .doc(docId)
        .collection("reviews")
        .snapshots();
  }
}
