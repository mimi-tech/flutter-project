class EmailValidator {

  /* validate user email address to see if it is valid */
  static String? validateEmail(String value) {
    Pattern pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regex = RegExp(pattern as String);

    if (!regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  //TODO: Validate user phone number.
  static String? validatePhoneNumber(String phoneNumber) {
    Pattern phonePattern = r'^([0-9]+[0-9]*$)';

    RegExp regex = RegExp(phonePattern as String);

    if (!regex.hasMatch(phoneNumber))
      return 'Phone number is invalid.';
    else
      return null;
  }

  //TODO: This function checks to see if the first number is a zero, if true, removes the number.
  static String removeZeroFromPhoneNumber(String phoneNumber){
    Pattern phonePattern = r'^([0-9]+[0-9]*$)';
    String phoneNumberWithZero;
    RegExp regex = RegExp(phonePattern as String);

    if (regex.hasMatch(phoneNumber)){
      String removeZero = phoneNumber.substring(0, 1);

      if(removeZero == "0"){
        phoneNumberWithZero = phoneNumber.substring(1, phoneNumber.length);
      }
      else {
        phoneNumberWithZero = phoneNumber;
      }
    }
    else
      phoneNumberWithZero = "Invalid";

    return phoneNumberWithZero;
  }

  //TODO: This function is used to obscure the user's email address.
  static String obscureEmail(String e) {

    Pattern pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regex = RegExp(pattern as String);

    String result = "";

    if(regex.hasMatch(e)) {
      String firstPart = e.split("@").first;

      String obscureFirstPart = firstPart.replaceRange(2, (firstPart.length - 4), "**************");
      String lastPart = e.split("@").last;

      result = obscureFirstPart + "@" + lastPart;
    }

    return result;
  }

}