import 'package:flutter/services.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class Validator{
  static String? validateUserName(String? value) {
    if(value!.isEmpty) {
      return "Username can't be empty";
    }
    if(value.length < 2) {
      return "Username must be at least 2 characters long";
    }
    if(value.length > 500) {
      return "Username must be less than 500 characters long";
    }
    return null;
  }

  static String? validateUsersName(String? value) {
    if(value!.isEmpty) {
      return "Name can't be empty";
    }
    if(value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if(value.length > 500) {
      return "Name must be less than 500 characters long";
    }
    return null;
  }


  static String? validateAddress(String? value) {
    if(value!.isEmpty) {
      return "Address can't be empty";
    }
    if(value.length < 2) {
      return "Address must be at least 2 characters long";
    }
    if(value.length > 500) {
      return "Address must be less than 500 characters long";
    }
    return null;
  }

  static String? validateCity(String? value) {
    if(value!.isEmpty) {
      return "City can't be empty";
    }
    if(value.length < 2) {
      return "City must be at least 2 characters long";
    }
    if(value.length > 500) {
      return "City must be less than 500 characters long";
    }
    return null;
  }


  static String? validateStreet(String? value) {
    if(value!.isEmpty) {
      return " street can't be empty";
    }
    if(value.length < 2) {
      return " street must be at least 2 characters long";
    }
    if(value.length > 500) {
      return " street must be less than 500 characters long";
    }
    return null;
  }


  static String? validateNumber(String? value) {
    if(value!.isEmpty) {
      return "Phone number can't be empty";
    }
    if(value.length < 4) {
      return "Phone number must be at least 2 characters long";
    }
    if(value.length > 25) {
      return "Phone number must be less than 500 characters long";
    }
    return null;
  }


  static String? validatePin(String? value) {
    if(value!.isEmpty) {
      return "Pin can't be empty";
    }
    if(value.length < 4) {
      return "Pin must be at least 4 numbers";
    }
    if(value.length > 6) {
      return "Pin must be less than 6 numbers";
    }
    return null;
  }


  static String? validateEmail(String? value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return kEmailvalidator;
    else
      return null;
  }

  static String? validatePassword(String? value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return kPasswordvalidator;
    else
      return null;
  }


  static String? validateName(String? value) {
    if (value!.isEmpty) {
      return kNamevalidator;
    }
    return null;
  }







  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

}