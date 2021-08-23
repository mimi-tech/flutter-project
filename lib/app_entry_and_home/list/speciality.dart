//TODO: Merge high_school_courses list, occupations list and university_courses_asset list together.

import 'package:sparks/app_entry_and_home/list/industries.dart';

class Specialties {
  List<String> specialities(List<String> highSchool, List<String> occupations,
      List<String> university) {
    List<String> mergedList = [];

    mergedList.addAll(highSchool);
    mergedList.addAll(occupations);
    mergedList.addAll(university);

    return mergedList;
  }

  //TODO: This function takes in a list of user interest(s) and returns a list of industries associated with it.
  static List<String> myIndustries(List<String?>? interest) {
    List<String> collectionOfIndustries = [];

    for (int x = 0; x < industries.length; x++) {
      bool isAvailable =
          checkInterest(industries.values.elementAt(x), interest!);
      if (isAvailable) {
        collectionOfIndustries.add(industries.keys.elementAt(x));
      }
    }

    return collectionOfIndustries;
  }

  /*
  * This function takes two parameters:
  *     A list of interest found in a particular industry - listOfInterests
  *     A list of interest from the user - userInterest
  *
  *     Returns a bool value - ie true if userInterest is found in listOfInterests.
  * */
  static bool checkInterest(
      List<String> listOfInterests, List<String?> userInterest) {
    bool interestFound = false;
    List<String?> tempCollection = [];

    for (String? ui in userInterest) {
      if (listOfInterests.contains(ui)) {
        tempCollection.add(ui);
      }
    }

    if (tempCollection.isNotEmpty) {
      interestFound = true;
    }

    return interestFound;
  }
}
