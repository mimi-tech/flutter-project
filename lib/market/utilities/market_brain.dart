import 'package:flutter/material.dart';
import 'package:sparks/market/utilities/market_colors.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';
import 'package:sparks/market/utilities/strings.dart';

class MarketBrain {
  /// Regex pattern and Function that evaluates 3 digits from the right and adds a comma of a given number
  static RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static Function mathFunc = (Match match) => '${match[1]},';

  /// Logic to format large numbers (e.g. 1000 to 1k, 1000000 to 1M)
  static String numberFormatter(int? num) {
    String formattedNum;

    if (num == null) return "0";

    /// Logic to convert 1 Billion to '1B'
    if (num >= 1000000000) {
      formattedNum = (num / 1000000000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 Billion and then add 'B' at the end
      double remainder = num.remainder(1000000000);
      if (remainder >= 100000000) {
        remainder = remainder / 100000000;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'B';
      } else {
        formattedNum += 'B';
      }
    } else if (num >= 1000000) {
      /// Logic to convert 1 Million to '1M'
      formattedNum = (num / 1000000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 million and then add 'M' at the end
      double remainder = num.remainder(1000000);
      if (remainder >= 100000) {
        remainder = remainder / 100000;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'M';
      } else {
        formattedNum += 'M';
      }
    } else if (num >= 1000) {
      /// Logic to convert 1 thousand to '1k'
      formattedNum = (num / 1000).truncate().toString();

      /// Logic to check if there's number (remainder) exceeding 1 thousand and then add 'k' at the end
      double remainder = num.remainder(1000);
      if (remainder >= 100) {
        remainder = remainder / 100;
        remainder.round();
        formattedNum += '.' + remainder.truncate().toString() + 'k';
      } else {
        formattedNum += 'k';
      }
    } else {
      return num.toString();
    }
    return formattedNum;
  }

  /// Method to format double number to include commas. E.g. 1000 -> 1,000 and return a String value
  static String numberFormatterWithCommaDouble(double num) {
    String commaFormat = num.toInt().toString();
    commaFormat = commaFormat.replaceAllMapped(reg, mathFunc as String Function(Match));
    return commaFormat;
  }

  /// Method to format int number to include commas. E.g. 1000 -> 1,000 and return a String value
  static String numberFormatterWithCommaInt(int? num) {
    String commaFormat = num.toString();
    commaFormat = commaFormat.replaceAllMapped(reg, mathFunc as String Function(Match));
    return commaFormat;
  }

  /// Method for getting the values needed to add products to user's recently viewed collection
  static void recentlyViewedNeededValues({
    required String? commonId,
    required String? condition,
    String? storeId,
    String? category,
    String? productImg,
    String? productName,
    double? price,
    double? rating,
    String? docId,
  }) {
    if (condition == "new product") {
      MarketGlobalVariables.viewedCondition = "newProducts";
    } else {
      MarketGlobalVariables.viewedCondition = "usedProducts";
    }
    MarketGlobalVariables.viewedCommonId = commonId;
    MarketGlobalVariables.viewedProductRating = rating ?? null;
    MarketGlobalVariables.viewedStoreId = storeId ?? "";
    MarketGlobalVariables.viewedCategory = category ?? "";
    MarketGlobalVariables.viewedImage = productImg ?? "";
    MarketGlobalVariables.viewedProductName = productName ?? "";
    MarketGlobalVariables.viewedProductPrice = price ?? 0;
    MarketGlobalVariables.viewedDocId = docId ?? "";
  }

  static String prodCondCollectionConverter(String? productCondition) {
    String condition;

    if (productCondition == "new product") {
      condition = "newProducts";
    } else {
      condition = "usedProducts";
    }

    return condition;
  }

  static List<Color> marketLinearColorSelector(String label) {
    List<Color> linearOutputColor = [];

    switch (label) {
      case kAll:
        linearOutputColor = allLinearColor;
        break;
      case kClothes:
        linearOutputColor = clothLinearColor;
        break;
      case kShoes:
        linearOutputColor = shoeLinearColor;
        break;
      case kBeauty:
        linearOutputColor = beautyLinearColor;
        break;
      case kElectronics:
        linearOutputColor = electronicsLinearColor;
        break;
      case kBooks:
        linearOutputColor = booksLinearColor;
        break;
      case kStationary:
        linearOutputColor = stationaryLinearColor;
        break;
    }

    return linearOutputColor;
  }
}
