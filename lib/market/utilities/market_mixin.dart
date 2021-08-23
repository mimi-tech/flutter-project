import 'package:flutter/material.dart';

mixin MarketMixin {
  /// Function that takes a Color argument and returns a String value
  String colorToStringStripper(Color? color) {
    String colorString = color.toString().split('0x').last.substring(0, 8);

    return colorString;
  }

  /// Function that takes in a Color argument and converts it to a Color int
  ///
  /// NOTE: This function relies on the [colorToStringStripper] function
  int colorToIntColorValue(Color? color) {
    String colorStringValue = colorToStringStripper(color);

    int colorIntValue = int.parse(colorStringValue, radix: 16);

    return colorIntValue;
  }

  /// Function that takes in an int argument and generates a Color
  Color intToColor(int color) {
    Color colorFromInt = Color(color);

    return colorFromInt;
  }

  /// Function that takes in an int argument and generates a contrasting Color based on the Color luminance
  ///
  /// NOTE: This function relies on the [intToColor] function
  Color getContrastingColorFromInt(int color) {
    Color colorFromInt = intToColor(color);

    Color generatedColor =
        colorFromInt.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return generatedColor;
  }

  /// Function to get generate either 'black' or 'white' based on the color luminance
  Color getContrastingColorFromString(String color) {
    int value = int.parse(color, radix: 16);

    Color selectedColorValue = Color(value);

    Color generatedColor = selectedColorValue.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return generatedColor;
  }

  /// Function to capitalize the first letter in Strings
  String capitalizeFirstLetterOfWords(String words) {
    String formattedWords;
    formattedWords = words
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return formattedWords;
  }

  /// Logic to format large numbers (e.g. 1000 to 1k, 1000000 to 1M)
  String numberFormatter(int num) {
    String formattedNum;

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

  /// Regex pattern and Function that evaluates 3 digits from the right and adds a comma of a given number
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  /// Method to format number to include commas. E.g. 1000 -> 1,000 and return a String value
  ///
  /// NOTE: This function relies on the [RegExp reg & Function mathFunc] to work
  String numberFormatterWithComma(String number) {
    number = number.replaceAllMapped(reg, mathFunc as String Function(Match));
    return number;
  }

  // String numberFormatterWithCommaOld(num number) {
  //   String commaFormat = number.toString();
  //   commaFormat = commaFormat.replaceAllMapped(reg, mathFunc);
  //   return commaFormat;
  // }

  /// Function that takes a double parameter and return either an int or double value
  String doubleToIntChecker(num value) {
    if (value == value.roundToDouble()) {
      return value.truncate().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }
//  num doubleToIntChecker(num value) {
//    if (value == value.roundToDouble()) {
//      return value.truncate();
//    } else {
//      return value;
//    }
//  }

}
