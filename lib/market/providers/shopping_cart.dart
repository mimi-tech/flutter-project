import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/market/market_models/Item.dart';

class ShoppingCart extends ChangeNotifier {
  // List of items in the cart
  List<Item?> _items = [];

  /// A copy of [_items]
  ///
  /// NOTE: This is to prevent order Class from directly modifying [_items]
  List<Item?> get items {
    return [..._items];
  }

  // Number of items in the cart
  int get numOfItems => _items.length;

  double get totalPrice {
    double totalPrice = 0;
    _items.forEach((product) {
      totalPrice += product!.price!;
    });
    return totalPrice;
  }

  bool isItemInCart(item) {
    if (_items.isEmpty) {
      return false;
    }
    final indexOfItem =
        _items.indexWhere((product) => item.sku == product!.sku);
    return indexOfItem >= 0;
  }

  int getItemIndex(String? sku) {
    final indexOfItem = _items.indexWhere((product) => product!.sku == sku);
    return indexOfItem;
  }

  void updateItemStockAndBasePrice(
      int indexOfItem, int? stock, double? basePrice) {
    _items[indexOfItem]!.stock = stock;
    _items[indexOfItem]!.basePrice = basePrice;
  }

  // Add item reference to cart
  void addToCart(Item? item) {
    if (_items.isEmpty) {
      _items.add(item);
    }

    if (!isItemInCart(item)) {
      _items.add(item);
    }

    notifyListeners();
  }

  void increaseQuantityCount(int indexOfItem, String? sku) {
//    _items.forEach((product) {
//      if (sku == product.sku) {
//        product.quantity = newQuantity;
//        product.price = product.basePrice * newQuantity;
//      }
//    });

    _items[indexOfItem]!.quantity++;
    _items[indexOfItem]!.price =
        _items[indexOfItem]!.basePrice! * _items[indexOfItem]!.quantity;
    print(_items[indexOfItem]!.quantity);

    notifyListeners();
  }

  void decreaseQuantityCount(int indexOfItem, String? sku) {
//    _items.forEach((product) {
//      if (sku == product.sku) {
//        product.quantity = newQuantity;
//        product.price = product.basePrice * newQuantity;
//      }
//    });

    if (_items[indexOfItem]!.quantity > 1) {
      _items[indexOfItem]!.quantity--;

      _items[indexOfItem]!.price =
          _items[indexOfItem]!.basePrice! * _items[indexOfItem]!.quantity;
    }

    notifyListeners();
  }

  void removeItem(Item? item) {
    if (_items.isEmpty) return;

    final indexOfItem = getItemIndex(item!.sku);

    if (indexOfItem >= 0) {
      _items.removeAt(indexOfItem);
    }

    notifyListeners();
  }
}
