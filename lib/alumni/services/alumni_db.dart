import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sparks/alumni/models/alumni_post.dart';
import 'package:sparks/alumni/models/alumni_school.dart';
import 'package:sparks/alumni/models/alumni_user.dart';
import 'package:sparks/alumni/services/alumni_storage.dart';
import 'package:sparks/alumni/static_variables/alumni_globals.dart';
import 'package:sparks/alumni/utilities/alumni_db_const.dart';
import 'package:sparks/alumni/utilities/strings.dart';

class AlumniDB {
  final String? userId;

  AlumniDB({this.userId});

  /// Instance of [FirebaseFirestore] used for making queries to the database
  final _db = FirebaseFirestore.instance;

  /// This is the limit value used in limiting the query document size. The int
  /// value determines the number of documents that'll be fetch. [_limitBy10] and
  /// [_limitBy15]
  int _limitBy10 = 10;

  int _limitBy15 = 15;

  List<DocumentSnapshot>? _lastDocumentSnapshot;

  /// Method that adds the user and school data to the "pendingUsers" collection
  Future<void> joinSchoolAddPendingUser(
      {String? schMasterId,
      String? schId,
      String? userId,
      required AlumniUser joinSchoolData}) async {
    try {
      await _db
          .collection("users")
          .doc(schMasterId)
          .collection("School")
          .doc(schId)
          .collection("pendingUsers")
          .doc(userId)
          .set(joinSchoolData.toJson());
    } catch (e) {
      print("joinSchoolAddPendingUser: $e");
    }
  }

  /// This method checks if the user has already sent a request to join a
  /// particular school and returns a document snapshot if the user exist in the
  /// "pendingUser" Collection
  Future<DocumentSnapshot?> checkIfPendingUser(
      {String? schMasterId, String? schId, String? userId}) async {
    try {
      return await _db
          .collection("users")
          .doc(schMasterId)
          .collection("School")
          .doc(schId)
          .collection("pendingUsers")
          .doc(userId)
          .get();
    } catch (e) {
      print("checkIfPendingUser: $e");
      return null;
    }
  }

  /// Method that handles deleting a request to join a particular school from the
  /// school's pending users list ("pendingUsers" Collection)
  Future<void> removePendingRequest(
      {String? schMasterId, String? schId, String? userId}) async {
    try {
      await _db
          .collection("users")
          .doc(schMasterId)
          .collection("School")
          .doc(schId)
          .collection("pendingUsers")
          .doc(userId)
          .delete();
    } catch (e) {
      print("removePendingRequest: $e");
    }
  }

  /// This method checks to see if a user is already an alumni of school and
  /// returns either "true" or "false" based on the query to the DB
  Future<bool> checkIfUserAlreadyInSchool(DocumentSnapshot schIdToCheck) async {
    bool isInSchool = false;

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("alumniUsers")
          .where("id", isEqualTo: userId)
          .where("schId", isEqualTo: schIdToCheck.id)
          .get();

      if (querySnapshot.size >= 1) {
        DocumentSnapshot docSnap = querySnapshot.docs[0];

        if (docSnap.exists) {
          isInSchool = true;
        }
      }
    } catch (e) {
      print("checkIfUserAlreadyInSchool: $e");
      throw Exception("Something went wrong");
    }

    return isInSchool;
  }

  /// This method query the "schoolUsers" collection group to fetch school data.
  /// The [checkIfUserAlreadyInSchool] method is used to check if the user is
  /// already a member of a given school and arrange the fetched schools accordingly
  // Future<List<DocumentSnapshot>> getFirstSetOfSchools() async {
  //   List<DocumentSnapshot> schoolDocumentSnapshot = [];
  //   try {
  //     QuerySnapshot querySnapshot = await _db
  //         .collectionGroup("schoolUsers")
  //         .orderBy("name", descending: true)
  //         .limit(_limitBy15)
  //         .get();
  //
  //     List<DocumentSnapshot> schoolChunk = querySnapshot.docs;
  //
  //     print("Length before: ${schoolChunk.length}");
  //
  //     if (schoolChunk.isNotEmpty) {
  //       /// TODO: Removing duplicates might not be necessary. Remove code snippet if length before and after doesn't change
  //       List<DocumentSnapshot> removeDuplicatesSchoolChunk =
  //           LinkedHashSet<DocumentSnapshot>.from(schoolChunk).toList();
  //
  //       print("Length after: ${removeDuplicatesSchoolChunk.length}");
  //
  //       /// TODO: Check to see if [removeDuplicatesSchoolChunk] is empty
  //
  //       List<DocumentSnapshot> schoolsUserIsIn = [];
  //       List<DocumentSnapshot> schoolsUserIsNotIn = [];
  //
  //       for (DocumentSnapshot docSnap in removeDuplicatesSchoolChunk) {
  //         bool isUserInSch = await checkIfUserAlreadyInSchool(docSnap);
  //
  //         if (isUserInSch) {
  //           schoolsUserIsIn.add(docSnap);
  //         } else {
  //           schoolsUserIsNotIn.add(docSnap);
  //         }
  //       }
  //
  //       List<DocumentSnapshot> result = [];
  //       result.addAll(schoolsUserIsIn);
  //       result.addAll(schoolsUserIsNotIn);
  //
  //       schoolDocumentSnapshot = result;
  //     }
  //   } on SocketException {
  //     print("checkIfUserAlreadyInSchool: Please check internet connection");
  //     throw "Please check your internet connection";
  //   } catch (e) {
  //     print("getFirstSetOfSchools: $e");
  //     throw "Something went wrong. Try again";
  //   }
  //
  //   return schoolDocumentSnapshot;
  // }

  /// This method fetches a single school data based on the "schoolId"
  Future<DocumentSnapshot?> getUserAlumnusSchool(String? schoolId) async {
    DocumentSnapshot? result;

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("schoolUsers")
          .where("schId", isEqualTo: schoolId) // sch_id
          .get();

      if (querySnapshot.size >= 1) {
        result = querySnapshot.docs[0];
      }
    } on SocketException {
      print(
          "getUserCurrentlyJoinedSchool: Please check your internet connection");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("getUserCurrentlyJoinedSchool: $e");
      throw Exception("Something went wrong. Try again");
    }

    return result;
  }

  /// This method fetches all the schools a user is an alumni of
  ///
  /// NOTE: The method makes use of the [getUserAlumnusSchool] method to get all
  /// valid alumnus which is complied and returned as a List of [AlumniSchool]
  Future<List<AlumniSchool>> getAllUserAlumniSchools() async {
    print("getAllUserAlumniSchools: USER ID - $userId");
    List<AlumniSchool> alumniSchools = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("alumniUsers")
          .orderBy("ts", descending: true)
          .where("id", isEqualTo: userId)
          .get();

      if (querySnapshot.size >= 1) {
        // List<DocumentSnapshot> alumniUserDocSnapshot = querySnapshot.docs;

        List<Map<String, dynamic>?> alumniUserDocSnapshot =
            querySnapshot.docs.map((DocumentSnapshot doc) {
          return doc.data as Map<String, dynamic>?;
        }).toList();

        // List<String> schoolIds = [];

        List<String?> schoolIds = alumniUserDocSnapshot.map((data) {
          return data!["schId"] as String?;
        }).toList();

        // for (DocumentSnapshot doc in alumniUserDocSnapshot) {
        //   String schoolId = data["schId"];
        //   schoolIds.add(schoolId);
        // }

        List<DocumentSnapshot?> userAlumniSchool = [];
        for (String? schId in schoolIds) {
          DocumentSnapshot? singleAlumniSchool =
              await getUserAlumnusSchool(schId);

          userAlumniSchool.add(singleAlumniSchool);
        }

        for (DocumentSnapshot? doc in userAlumniSchool) {
          Map<String, dynamic> tempMapData =
              doc!.data() as Map<String, dynamic>;

          /// An extra key-value pair is added [kIsInAlumni] = "true" is is further
          /// used in the UI output to display a different card view to the user
          tempMapData[kIsInAlumni] = true;

          AlumniSchool alumniSchool = AlumniSchool.fromJson(tempMapData);

          alumniSchools.add(alumniSchool);
        }
      }
    } on SocketException {
      print("getUserAlumniSchools: Please check internet connection");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("getUserAlumniSchools: $e");
      throw Exception("Something went wrong. Try again");
    }

    return alumniSchools;
  }

  /// This method fetches the initial list of alumni schools data to be displayed
  /// to the user
  ///
  /// In the method, a call to get the user's alumni school [getAllUserAlumniSchool]
  /// is first made and its value stored in a variable. The variable (which is a
  /// List of [AlumniSchool] is then used to check against further school data
  /// that will be queried later to avoid duplication of data
  ///
  /// NOTE: This method returns a Future of Map<String, dynamic> with 2 distinct
  /// keys - [kSchoolListOfMapData] && [kLastDocumentSnapshot]
  /// The [kSchoolListOfMapData] key holds a "List<AlumniSchool>"
  /// The [kLastDocumentSnapshot] key holds a "List<DocumentSnapshot> which is
  /// list of document snapshot that'll be further used to fetch more data during
  /// pagination
  Future<Map<String, dynamic>> getFirstSetOfSchools() async {
    Map<String, dynamic> finalResult = {};
    try {
      List<AlumniSchool> userAlumniSchools = await getAllUserAlumniSchools();

      print(
          "getAllUserAlumniSchools: USER ALUMNUS LENGTH - ${userAlumniSchools.length}");

      List<String?> schoolIdsFromAlumniSchool = [];

      /// TODO: Use a for-in loop if this code block fails to run
      if (userAlumniSchools.isNotEmpty) {
        // userAlumniSchools.map((alumniSchool) {
        //   String alumniSchoolId = alumniSchool.schoolId;
        //   schoolIdsFromAlumniSchool.add(alumniSchoolId);
        // });

        schoolIdsFromAlumniSchool = userAlumniSchools.map((alumniSchool) {
          return alumniSchool.schoolId;
        }).toList();
        print(
            "getFirstSetOfSchools: ALUMNI STRING ID = Using Map ${schoolIdsFromAlumniSchool.length}");
      }

      QuerySnapshot querySnapshot = await _db
          .collectionGroup("schoolUsers")
          .orderBy("name", descending: true)
          .limit(_limitBy15)
          .get();

      if (querySnapshot.size >= 1) {
        // List<DocumentSnapshot> schoolChunk = querySnapshot.docs;

        List<Map<String, dynamic>?> schoolChunk =
            querySnapshot.docs.map((DocumentSnapshot doc) {
          return doc.data as Map<String, dynamic>?;
        }).toList();

        print("Length before: ${schoolChunk.length}");

        /// TODO: Removing duplicates might not be necessary. Remove code snippet if length before and after doesn't change
        List<Map<String, dynamic>> removeDuplicatesSchoolChunk =
            LinkedHashSet<Map<String, dynamic>>.from(schoolChunk).toList();

        print("Length after: ${removeDuplicatesSchoolChunk.length}");

        /// TODO: Check to see if [removeDuplicatesSchoolChunk] is empty

        // List<AlumniSchool> alumniSchools = [];
        //
        // for (Map<String, dynamic> docSnap in removeDuplicatesSchoolChunk) {
        //   if (!schoolIdsFromAlumniSchool.contains(docSnap["schId"])) {
        //     AlumniSchool alumniSchool = AlumniSchool.fromJson(docSnap);
        //     alumniSchools.add(alumniSchool);
        //   }
        // }

        List<AlumniSchool?> alumniSchools =
            removeDuplicatesSchoolChunk.map((docSnap) {
          if (!schoolIdsFromAlumniSchool.contains(docSnap["schId"])) {
            AlumniSchool alumniSchool = AlumniSchool.fromJson(docSnap);
            return alumniSchool;
          }
        }).toList();

        List<AlumniSchool?> result = [];
        result.addAll(userAlumniSchools);
        result.addAll(alumniSchools);

        finalResult[kSchoolListOfMapData] = result;
        finalResult[kLastDocumentSnapshot] = removeDuplicatesSchoolChunk;
      } else {
        finalResult[kSchoolListOfMapData] = [];
        finalResult[kLastDocumentSnapshot] = [];
      }
    } on SocketException {
      print("getAllUserAlumniSchools: Please check internet connection");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("getAllUserAlumniSchools: $e");
      throw Exception("Something went wrong. Try again");
    }

    return finalResult;
  }

  /// Method responsible for fetching subsequent school list data using the prior
  /// fetched document snapshot
  Future<List<DocumentSnapshot>> fetchNextSetOfSchools(
      List<DocumentSnapshot> prevDocSnapshot) async {
    print("fetchNextSetOfSchools: From alumniDB called");
    List<DocumentSnapshot> result = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("schoolUsers")
          .orderBy("name", descending: true)
          .startAfterDocument(prevDocSnapshot[prevDocSnapshot.length - 1])
          .limit(_limitBy10)
          .get();

      if (querySnapshot.size >= 1) {
        List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;

        for (DocumentSnapshot doc in documentSnapshot) {
          bool isUserInSch = await checkIfUserAlreadyInSchool(doc);

          if (!isUserInSch) {
            result.add(doc);
          }
        }
      }

      // result = querySnapshot.docs;
    } on SocketException {
      print("fetchNextSetOfSchools: From Socket Exception");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("fetchNextSetOfSchools: $e");
      throw Exception("Something went wrong. Try again");
    }

    return result;
  }

  /// This method is responsible for inputting user's data that joins a school
  /// as an alumni into the database
  Future<void> joinAlumni(AlumniUser alumniUser) async {
    print("joinAlumni: ${alumniUser.name}");
    try {
      String? schoolId = alumniUser.schId;
      String? schoolOwnerId = alumniUser.accId;

      /// TODO: Change the collection name from "schoolUsers" TO "school"
      _db
          .collection("users")
          .doc(schoolOwnerId)
          .collection("schoolUsers")
          .doc(schoolId)
          .collection("alumni")
          .doc("alumniActivity")
          .collection("alumniUsers")
          .doc(userId)
          .set(alumniUser.toJson());
    } on SocketException {
      print("joinAlumni: From Socket Exception");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("joinAlumni: $e");
      throw Exception("Something went wrong. Try again");
    }
  }

  Future<void> getAlumniUserData() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("alumniUsers")
          .where("id", isEqualTo: userId)
          .get();

      if (querySnapshot.size >= 1) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        AlumniGlobals.currentAlumniUser = AlumniUser.fromJson(
            documentSnapshot.data() as Map<String, dynamic>);
      }
    } on SocketException {
      print("getAlumniUserData: From Socket Exception");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("getAlumniUserData: $e");
      throw Exception("Something went wrong. Try again");
    }
  }

  Future<void> pushTextImagePost({
    required AlumniPost alumniPost,
    required List<File?> files,
  }) async {
    String? schoolOwnerId = AlumniGlobals.currentAlumniUser!.accId;
    String? schoolId = AlumniGlobals.currentAlumniUser!.schId;

    AlumniStorage alumniStorage = AlumniStorage(userId: alumniPost.id);

    try {
      List<String> uploadedImagesString =
          await alumniStorage.uploadPostImage(files);

      /// TODO: This code block might not be necessary - Remove
      if (uploadedImagesString.isEmpty) {
        throw Exception("Something went wrong while uploading image");
      }

      DocumentReference docRef = _db
          .collection("users")
          .doc(schoolOwnerId)
          .collection("schoolUsers") // Change to "school"
          .doc(schoolId)
          .collection("alumni")
          .doc("alumniActivity")
          .collection("alumniPosts")
          .doc();

      alumniPost.docId = docRef.id;
      alumniPost.img = uploadedImagesString;

      docRef.set(alumniPost.toJson());
    } on SocketException {
      print("pushTextImagePost: SocketException");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("pushTextImagePost: $e");
      throw Exception(kCatchErrorMessage);
    }
  }

  /// TODO: Update the method documentation
  /// This method is responsible for fetching the first set of alumni posts data
  /// The method utilizes the [getAlumniProfileImage] method to append the profile
  /// image string to the fetched data
  Future<Map<String, dynamic>> getAlumniPosts() async {
    Map<String, dynamic> result = {};

    try {
      QuerySnapshot querySnapshot = await _db
          .collectionGroup("alumniPosts")
          .orderBy("ts", descending: true)
          .limit(_limitBy10)
          .get();

      if (querySnapshot.size >= 1) {
        print("1 or more data available ${querySnapshot.size}");
        List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;
        List<AlumniPost> alumniPostCache = [];

        /// This variable will hold the "ID" and "Image String" as key-value pairs.
        /// The stored key-values will help in limiting the amount of calls to
        /// get the profile image of post attributed to a given user
        Map<String, String?> storedAlumniIdsToImageKeyValuePairs = {};

        for (DocumentSnapshot doc in documentSnapshot) {
          AlumniPost singlePost =
              AlumniPost.fromJson(doc.data as Map<String, dynamic>);

          String alumniId = singlePost.id;

          if (storedAlumniIdsToImageKeyValuePairs.isEmpty) {
            String? alumniProfileImage = await getAlumniProfileImage(alumniId);

            singlePost.pImg = alumniProfileImage;

            storedAlumniIdsToImageKeyValuePairs = {
              alumniId: alumniProfileImage,
            };

            alumniPostCache.add(singlePost);
          } else if (storedAlumniIdsToImageKeyValuePairs
              .containsKey(alumniId)) {
            String? storedProfileImageString =
                storedAlumniIdsToImageKeyValuePairs[alumniId];

            singlePost.pImg = storedProfileImageString;

            alumniPostCache.add(singlePost);
          } else {
            String? alumniProfileImage = await getAlumniProfileImage(alumniId);

            singlePost.pImg = alumniProfileImage;

            storedAlumniIdsToImageKeyValuePairs = {
              alumniId: alumniProfileImage,
            };

            alumniPostCache.add(singlePost);
          }
        }
        result[kListOfAlumniPost] = alumniPostCache;
        result[kLastDocumentSnapshot] = documentSnapshot;

        print(
            "getAlumniPosts: The length of data = ${result[kListOfAlumniPost].length}");
      } else {
        result[kListOfAlumniPost] = [];
        result[kLastDocumentSnapshot] = [];
      }
    } on SocketException {
      print("on SocketException");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("getAlumniPosts: $e");
      throw Exception(kCatchErrorMessage);
    }

    return result;
  }

  /// Previous implementation
  // Future<List<Map<String, dynamic>>> getAlumniPosts() async {
  //   List<Map<String, dynamic>> result = [];
  //   Map<String, dynamic> testingOne = {};
  //
  //   try {
  //     QuerySnapshot querySnapshot = await _db
  //         .collectionGroup("alumniPosts")
  //         .orderBy("ts", descending: true)
  //         .limit(_limitBy10)
  //         .get();
  //
  //     if (querySnapshot.size >= 1) {
  //       List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;
  //       List<AlumniPost> alumniPostCache = [];
  //
  //       /// This variable will hold the "ID" and "Image String" as key-value pairs.
  //       /// The stored key-values will help in limiting the amount of calls to
  //       /// get the profile image of post attributed to a given user
  //       Map<String, String> storedAlumniIdsToImageKeyValues = {};
  //
  //       for (DocumentSnapshot doc in documentSnapshot) {
  //         Map<String, dynamic> tempMapData = data;
  //
  //         String alumniId = data["id"];
  //
  //         if (storedAlumniIdsToImageKeyValues?.isEmpty ?? true) {
  //           String alumniProfileImage = await getAlumniProfileImage(alumniId);
  //
  //           tempMapData["pImg"] = alumniProfileImage;
  //
  //           storedAlumniIdsToImageKeyValues = {
  //             alumniId: alumniProfileImage,
  //           };
  //
  //           AlumniPost singlePost = AlumniPost.fromJson(tempMapData);
  //           singlePost.pImg = tempMapData["pImg"];
  //
  //           print("TESTING ALUMNI CACHE: ${singlePost.pImg}");
  //
  //           alumniPostCache.add(singlePost);
  //
  //           result.add(tempMapData);
  //         }
  //
  //         if (storedAlumniIdsToImageKeyValues.containsKey(alumniId)) {
  //           String storedProfileImageString =
  //           storedAlumniIdsToImageKeyValues[alumniId];
  //
  //           tempMapData["pImg"] = storedProfileImageString;
  //           result.add(tempMapData);
  //         }
  //       }
  //
  //       print("getAlumniPosts: The length of data = ${result.length}");
  //     } else {
  //       // Return empty arrays [], []
  //     }
  //   } on SocketException {
  //     print("on SocketException");
  //     throw Exception(kSocketExceptionMessage);
  //   } catch (e) {
  //     print("getAlumniPosts: $e");
  //     throw Exception(kCatchErrorMessage);
  //   }
  //
  //   return result;
  // }

  /// Method responsible for getting the profile image of an alumni user
  Future<String?> getAlumniProfileImage(String alumniId) async {
    String? result = "";

    try {
      DocumentSnapshot documentSnapshot = await _db
          .collection("users")
          .doc(alumniId)
          .collection("Personal")
          .doc("personalInfo")
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String? profileImage = data["pimg"];

        result = profileImage;
      }
    } on SocketException {
      print("getAlumniImage: SocketException");
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      print("getAlumniImage: $e");
      throw Exception(kCatchErrorMessage);
    }

    return result;
  }
}
