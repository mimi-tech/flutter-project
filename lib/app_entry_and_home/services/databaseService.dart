import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sparks/app_entry_and_home/models/bookmark.dart';
import 'package:sparks/app_entry_and_home/models/camera_post_model.dart';
import 'package:sparks/app_entry_and_home/models/comment.dart';
import 'package:sparks/app_entry_and_home/models/comment_reply.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up_mm.dart';
import 'package:sparks/app_entry_and_home/models/create_spark_up_tt.dart';
import 'package:sparks/app_entry_and_home/models/home_notification.dart';
import 'package:sparks/app_entry_and_home/models/spark_up.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user.dart';
import 'package:sparks/app_entry_and_home/models/sparks_user_general.dart';
import 'package:sparks/app_entry_and_home/models/text_post_model.dart';
import 'package:sparks/app_entry_and_home/services/storageService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class DatabaseService {
  /* variable declarations */
  final String? loggedInUserID;

  //TODO: Create a list of database collections.
  final CollectionReference sparksUsername =
      FirebaseFirestore.instance.collection('username');
  final CollectionReference sparksUsers =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference sparksPost =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference sparkUp =
      FirebaseFirestore.instance.collection('sparkUp');

  //TODO: DatabaseService constructor.
  DatabaseService({this.loggedInUserID});

  //TODO: Update the user's 'emv' field to true.
  Future<void> updateUserEmailVerification(
      String? accountType, bool emailVerified) async {
    switch (accountType) {
      case "Personal":
        await sparksUsers
            .doc(loggedInUserID)
            .collection(accountType!)
            .doc("personalInfo")
            .update({
          "emv": emailVerified,
        });
        await sparksUsers.doc(loggedInUserID).update({
          "emv": emailVerified,
        });
        break;
      case "Market":
        await sparksUsers
            .doc(loggedInUserID)
            .collection(accountType!)
            .doc("marketInfo")
            .update({
          "emv": emailVerified,
        });
    }
  }

  //TODO: Update - pimg - to the new download url of the user profile image.
  Future<void> updateProfileImagePath(
      String downloadURL, String accountType) async {
    await sparksUsers
        .doc(loggedInUserID)
        .collection(accountType)
        .doc("personalInfo")
        .update({
      'pimg': downloadURL,
    });
  }

  //TODO: Get the document snapshot of the user's profile.(sub-collection)
  Future<DocumentSnapshot<Map<String, dynamic>>>
      loggedInUserProfileWithDefaultAccount(String accName) async {
    DocumentSnapshot<Map<String, dynamic>> personalInfo = await sparksUsers
        .doc(loggedInUserID)
        .collection(accName)
        .doc("personalInfo")
        .get();

    return personalInfo;
  }

  //TODO: Get the document snapshot of the user's profile.(super-collection)
  Future<DocumentSnapshot> profileInfoFromCollection() async {
    dynamic generalUserInfo = await sparksUsers.doc(loggedInUserID).get();

    return generalUserInfo;
  }

  //TODO: Store the user's text post into the post collection.
  Future<void> createNewUserTextPost(TextPostModel textPostModel) async {
    String messageID = DateTime.now().millisecondsSinceEpoch.toString();

    await sparksPost
        .doc(loggedInUserID)
        .collection("myPost")
        .doc(messageID)
        .set(textPostModel.toJson());

    await sparksPost
        .doc(loggedInUserID)
        .collection("myPost")
        .doc(messageID)
        .update({
      "postId": messageID,
    });
  }

  //TODO: Store the user's camera post into the post collection.
  Future<void> createNewUserCameraPost(CameraPostModel cameraPostModel) async {
    String messageID = DateTime.now().millisecondsSinceEpoch.toString();

    await sparksPost
        .doc(loggedInUserID)
        .collection("myPost")
        .doc(messageID)
        .set(cameraPostModel.toJson());

    await sparksPost
        .doc(loggedInUserID)
        .collection("myPost")
        .doc(messageID)
        .update({
      "postId": messageID,
    });
  }

  //TODO: Store user info/data into cloud firestore.
  Future<void> createNewUserAccount(
      SparksUserGeneral sparksUserGeneral, SparksUser sparksUser) async {
    await sparksUsername
        .doc(loggedInUserID)
        .set({"id": loggedInUserID, "un": GlobalVariables.username});
    await sparksUsers.doc(loggedInUserID).set(sparksUserGeneral.toJson());
    await sparksUsers
        .doc(loggedInUserID)
        .collection(GlobalVariables.accountSelected["act"])
        .doc("personalInfo")
        .set(sparksUser.toJson());
  }

  //TODO: Check if the username already exists in the database.
  Future<bool?> isUsernameAvailable(String personalUsername) async {
    bool? usernameExist;
    try {
      await sparksUsername
          .where("un", isEqualTo: personalUsername)
          .get()
          .then((value) {
        if (value.docs.length == 1) {
          usernameExist = true;
          GlobalVariables.usernameExist = true;
        } else {
          usernameExist = false;
          GlobalVariables.usernameExist = false;
        }
      });
    } catch (e) {
      e.toString();
    }
    return usernameExist;
  }

  //TODO: Get all the account type(s) a sparks user has.
  Future<DocumentSnapshot> getAllAccountTypes() async {
    DocumentSnapshot documentSnapshot;

    documentSnapshot = await sparksUsers.doc(loggedInUserID).get();

    return documentSnapshot;
  }

  //TODO: Get the exact profile the user has made default
  Future<DocumentSnapshot?> getDefaultProfileAccount(String accountName) async {
    DocumentSnapshot? documentSnapshot;

    try {
      switch (accountName) {
        case "Personal":
          documentSnapshot = await sparksUsers
              .doc(loggedInUserID)
              .collection(accountName)
              .doc()
              .get();
          break;
        case "School":
          documentSnapshot = await sparksUsers
              .doc(loggedInUserID)
              .collection(accountName)
              .doc()
              .get();
          break;
        case "Company":
          documentSnapshot = await sparksUsers
              .doc(loggedInUserID)
              .collection(accountName)
              .doc()
              .get();
          break;
        case "Ecommerce":
          documentSnapshot = await sparksUsers
              .doc(loggedInUserID)
              .collection(accountName)
              .doc()
              .get();
          break;
      }
    } catch (e) {
      e.toString();
    }

    return documentSnapshot;
  }

  //TODO: Update the tokenID of the logged in user to the current tokenID
  Future<void> updateTokenID(String? deviceID) async {
    try {
      await sparksUsers.doc(loggedInUserID).update({
        "tkn": deviceID,
      });
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Add the current logged in device ID to the user's documents
  Future<void> addNewDeviceID(String deviceID) async {
    try {
      await sparksUsers.doc(loggedInUserID).update({
        "tokid": FieldValue.arrayUnion([deviceID])
      });
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Delete old device id stored in user's document
  Future<void> removeOldDeviceID(String deviceID) async {
    try {
      await sparksUsers.doc(loggedInUserID).update({
        "tokid": FieldValue.arrayRemove([deviceID])
      });
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Create a user feeds from friends post
  Future<QuerySnapshot> homeFeeds() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collectionGroup("myPost")
        .where("friID", arrayContains: GlobalVariables.loggedInUserObject.id)
        .orderBy("ptc", descending: true)
        .limit(5)
        .get();

    return query;
  }

  //TODO: Get more feeds if the user request for it.
  Future<QuerySnapshot?> getMoreFeeds(DocumentSnapshot lastDocument) async {
    QuerySnapshot? query;

    try {
      query = await FirebaseFirestore.instance
          .collectionGroup("myPost")
          .where("friID", arrayContains: GlobalVariables.loggedInUserObject.id)
          .orderBy("ptc", descending: true)
          .startAfterDocument(lastDocument)
          .limit(5)
          .get();
    } catch (e) {}

    return query;
  }

  //TODO: Make the selected account the active account ie update it's record from false to true
  Future<void> makeThisAccountActive(
      List<Map<String, dynamic>> selectedAccount) async {
    try {
      await sparksUsers.doc(loggedInUserID).update({
        "acct": selectedAccount,
      });
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Update the user's presence to either online or offline
  Future<void> updateUserPresence(bool? presentState) async {
    try {
      await sparksUsers.doc(loggedInUserID).update({
        "ol": presentState,
      });
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Creating/adding a personal account for an existing user.
  Future<void> addPersonalAccount(User fbu) async {
    String? loggedInUsername;

    dynamic acc = {
      "act": "Personal",
      "dp": true,
    };

    try {
      //Fetch the logged in username
      QuerySnapshot qs =
          await sparksUsername.where("id", isEqualTo: fbu.uid).get();
      // List<DocumentSnapshot> dsp = qs.docs;

      List<Map<String, dynamic>?> dsp = qs.docs.map((DocumentSnapshot doc) {
        return doc.data as Map<String, dynamic>?;
      }).toList();
      loggedInUsername = dsp[0]!['un'];

      await sparksUsers.doc(loggedInUserID).update({
        "acct": FieldValue.arrayUnion([acc]),
      });

      await sparksUsers.doc(loggedInUserID).update({
        "sts": GlobalVariables.accountStatus,
        "em": fbu.email,
        "emv": fbu.emailVerified,
      });

      //print(GlobalVariables.accountSelected["act"]);

      SparksUser sparksUser = SparksUser(
        id: fbu.uid,
        nm: {"fn": GlobalVariables.firstName, "ln": GlobalVariables.lastName},
        pimg: GlobalVariables.profileImageDownloadUrl,
        addr: {
          "cty": GlobalVariables.country,
          "st": GlobalVariables.state,
          "ctyR": GlobalVariables.isCountryOFResidence,
          "stR": GlobalVariables.isStateOfResidence
        },
        bdate: GlobalVariables.dob,
        sex: GlobalVariables.gender,
        marst: GlobalVariables.maritalStatus,
        lang: GlobalVariables.spokenLanguages,
        hobb: GlobalVariables.hobbies,
        aoi: GlobalVariables.areaOfInterest,
        ind: GlobalVariables.userIndustries,
        spec: GlobalVariables.specialities,
        isMen: GlobalVariables.amAMentor,
        schVt: false,
        un: loggedInUsername,
        em: fbu.email,
        emv: fbu.emailVerified,
        crAt: DateTime.now(),
      );

      await sparksUsers
          .doc(loggedInUserID)
          .collection(GlobalVariables.accountSelected["act"])
          .doc("personalInfo")
          .set(sparksUser.toJson());

      //TODO: Upload the user's profile image to cloud firebase storage.
      StorageService(userID: fbu.uid).uploadProfileImage(
          GlobalVariables.profileImage!, GlobalVariables.userProfileImage!);

      //Reset all form Global variables
      _resetGlobalVariables();
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Reset all GlobalVariables variables to its default values.
  _resetGlobalVariables() {
    GlobalVariables.accountStatus = "";
    GlobalVariables.firstName = "";
    GlobalVariables.lastName = "";
    GlobalVariables.profileImageDownloadUrl = "";
    GlobalVariables.country = "";
    GlobalVariables.state = "";
    GlobalVariables.isCountryOFResidence = false;
    GlobalVariables.isStateOfResidence = false;
    GlobalVariables.dob = "";
    GlobalVariables.gender = "";
    GlobalVariables.maritalStatus = "";
    GlobalVariables.spokenLanguages = [];
    GlobalVariables.hobbies = [];
    GlobalVariables.areaOfInterest = [];
    GlobalVariables.specialities = [];
    GlobalVariables.userIndustries = [];
    GlobalVariables.amAMentor = false;
  }

  //TODO: Check if the user's id is included in the list containing all the users id who liked this post. If true return true else return false.
  Future<bool?> checkUserIdInLikedCollection(
      String? authorId, String? postID) async {
    bool? isIdIncluded;

    try {
      QuerySnapshot querySnapshot = await sparksPost
          .doc(authorId)
          .collection("myPost")
          .doc(postID)
          .collection("homePostLikes")
          .where("id", isEqualTo: loggedInUserID)
          .where("mPid", isEqualTo: postID)
          .get();

      //Check if a document do exist or not
      if (querySnapshot.size > 0) {
        isIdIncluded = true;
      } else {
        isIdIncluded = false;
      }
    } catch (e) {
      e.toString();
    }

    return isIdIncluded;
  }

  //TODO: Check if the user's id is included in the list containing all the users id who liked this comment. If true return true else return false.
  Future<bool?> checkUserIdInLikedCommentCollection(
      String? authorId, String? postID, String? commentId) async {
    bool? isIdIncluded;

    try {
      QuerySnapshot querySnapshot = await sparksPost
          .doc(authorId)
          .collection("myPost")
          .doc(postID)
          .collection("homeComments")
          .doc(commentId)
          .collection("commentLikes")
          .where("id", isEqualTo: loggedInUserID)
          .where("cid", isEqualTo: commentId)
          .get();

      //Check if a document do exist or not
      if (querySnapshot.size > 0) {
        isIdIncluded = true;
      } else {
        isIdIncluded = false;
      }
    } catch (e) {
      e.toString();
    }

    return isIdIncluded;
  }

  //TODO: Add or delete the user id from the liked collection
  Future<bool?> addDeleteUid(
      String? authorId, String? postId, bool isAvailable) async {
    bool? sparksLiked;

    QuerySnapshot querySnapshot = await sparksPost
        .doc(authorId)
        .collection("myPost")
        .where("postId", isEqualTo: postId)
        .where("friID", arrayContains: loggedInUserID)
        .get();

    List<Map<String, dynamic>?> listOfData =
        querySnapshot.docs.map((DocumentSnapshot doc) {
      return doc.data as Map<String, dynamic>?;
    }).toList();

    //get the common id assigned to this post.
    String? commonId = listOfData[0]!["delID"];

    try {
      if (isAvailable == true) {
        QuerySnapshot querySnapshot = await sparksPost
            .doc(authorId)
            .collection("myPost")
            .doc(postId)
            .collection("homePostLikes")
            .where("id", isEqualTo: loggedInUserID)
            .get();

        //Delete the user id if the uid is found inside the liked collection
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach((element) {
            sparksPost
                .doc(authorId)
                .collection("myPost")
                .doc(postId)
                .collection("homePostLikes")
                .doc(element.id)
                .delete();
          });
        }

        sparksLiked = false;
      } else {
        //Add the user id into the liked collection
        await sparksPost
            .doc(authorId)
            .collection("myPost")
            .doc(postId)
            .collection("homePostLikes")
            .doc()
            .set({
          "id": loggedInUserID,
          "mPid": postId,
          "comID": commonId,
        });

        sparksLiked = true;
      }
    } catch (e) {
      e.toString();
    }

    return sparksLiked;
  }

  //TODO: Add or delete the user id from comment liked collection
  Future<bool?> addDeleteUidComment(String? authorId, String? postId,
      bool isAvailable, String? commentId) async {
    bool? sparksLiked;

    QuerySnapshot querySnapshot = await sparksPost
        .doc(authorId)
        .collection("myPost")
        .where("postId", isEqualTo: postId)
        .where("friID", arrayContains: loggedInUserID)
        .get();

    List<Map<String, dynamic>?> listOfData =
        querySnapshot.docs.map((DocumentSnapshot doc) {
      return doc.data as Map<String, dynamic>?;
    }).toList();

    //get the common id assigned to this post.
    String? commonId = listOfData[0]!["delID"];

    try {
      if (isAvailable == true) {
        QuerySnapshot querySnapshot = await sparksPost
            .doc(authorId)
            .collection("myPost")
            .doc(postId)
            .collection("homeComments")
            .doc(commentId)
            .collection("commentLikes")
            .where("id", isEqualTo: loggedInUserID)
            .get();

        //Delete the user id if the uid is found inside the comment liked collection
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach((element) {
            sparksPost
                .doc(authorId)
                .collection("myPost")
                .doc(postId)
                .collection("homeComments")
                .doc(commentId)
                .collection("commentLikes")
                .doc(element.id)
                .delete();
          });
        }

        sparksLiked = false;
      } else {
        //Add the user id into the comment liked collection
        await sparksPost
            .doc(authorId)
            .collection("myPost")
            .doc(postId)
            .collection("homeComments")
            .doc(commentId)
            .collection("commentLikes")
            .doc()
            .set({
          "id": loggedInUserID,
          "cid": commentId,
          "comID": commonId,
        });

        sparksLiked = true;
      }
    } catch (e) {
      e.toString();
    }

    return sparksLiked;
  }

  //TODO: Fetches the document whose like/comment/share counter has incremented and vice versa.
  Stream<DocumentSnapshot> getCurrentLikesCommentShareCounter(
      String? authorId, String? postId) {
    return sparksPost
        .doc(authorId)
        .collection("myPost")
        .doc(postId)
        .snapshots();
  }

  //TODO: Fetches the document whose like/comment/share counter has incremented and vice versa.
  Stream<DocumentSnapshot> getCurrentLikeCommentCounter(
      String? authorId, String? postId, String? commentId) {
    return sparksPost
        .doc(authorId)
        .collection("myPost")
        .doc(postId)
        .collection("homeComments")
        .doc(commentId)
        .snapshots();
  }

  //TODO: Store all comments of a particular post
  /*
  * Where authorID is the id of the user who created the post.
  *       postID is the id of the generated post.
  *       commentModel is the comment that is being created.
  * */
  Future<void> createComment(String? authorID, String? postID,
      CommentModel commentModel, String commentID) async {
    QuerySnapshot querySnapshot = await sparksPost
        .doc(authorID)
        .collection("myPost")
        .where("postId", isEqualTo: postID)
        .where("friID", arrayContains: loggedInUserID)
        .get();

    List<Map<String, dynamic>?> listOfData =
        querySnapshot.docs.map((DocumentSnapshot doc) {
      return doc.data as Map<String, dynamic>?;
    }).toList();

    //get the common id assigned to this post.
    String? commonId = listOfData[0]!["delID"];

    try {
      await sparksPost
          .doc(authorID)
          .collection("myPost")
          .doc(postID)
          .collection("homeComments")
          .doc(commentID)
          .set(commentModel.toJson());

      await sparksPost
          .doc(authorID)
          .collection("myPost")
          .doc(postID)
          .collection("homeComments")
          .doc(commentID)
          .update({
        "comID": commonId,
      });
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Store the user's bookmark into the bookmark collection
  /*
  * where addBookmark is an object of SparksBookmark the user has created
  *       authorId is the id of the user who created the post.
  *       postId is the id of the generated post.
  * */
  addNewBookmark(
      String? authorId, String? postId, SparksBookmark addBookmark) async {
    await sparksPost
        .doc(authorId)
        .collection("myPost")
        .doc(postId)
        .collection("homeBookmark")
        .doc()
        .set(addBookmark.toJson());
  }

  //TODO: Store the user's bookmark into the bookmark collection
  /*
  * where authorId is the id of the user who created the post.
  *       postId is the id of the generated post.
  * */
  Future<String> deleteBookmark(String? authorId, String? postId) async {
    String bookmarkDocId = "";

    QuerySnapshot querySnapshot = await sparksPost
        .doc(authorId)
        .collection("myPost")
        .doc(postId)
        .collection("homeBookmark")
        .where("bkOwn", isEqualTo: loggedInUserID)
        .where("postId", isEqualTo: postId)
        .get();

    if (querySnapshot.size == 1) {
      bookmarkDocId = querySnapshot.docs[0].id;

      await sparksPost
          .doc(authorId)
          .collection("myPost")
          .doc(postId)
          .collection("homeBookmark")
          .doc(bookmarkDocId)
          .delete();
    }

    return bookmarkDocId;
  }

  //TODO: Check if the user bookmarked this post, if yes return true else false
  Future<bool> isPostBookmarked(String? authorId, String? postId) async {
    bool isPostBookmarked = false;

    QuerySnapshot querySnapshot = await sparksPost
        .doc(authorId)
        .collection("myPost")
        .doc(postId)
        .collection("homeBookmark")
        .where("bkOwn", isEqualTo: loggedInUserID)
        .where("postId", isEqualTo: postId)
        .get();

    if (querySnapshot.size == 1) {
      isPostBookmarked = true;
    } else {
      isPostBookmarked = false;
    }

    return isPostBookmarked;
  }

  //TODO: Fetch the first ten bookmarked post tried to a user
  Future<List<QueryDocumentSnapshot>> fetchFirstTenBookmarkedPost() async {
    List<QueryDocumentSnapshot> myBookmark = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collectionGroup("homeBookmark")
        .where("bkOwn", isEqualTo: loggedInUserID)
        .orderBy("bkCrt", descending: true)
        .limit(10)
        .get();

    List<QueryDocumentSnapshot> userBookmarkList = querySnapshot.docs;
    for (QueryDocumentSnapshot postBookmarked in userBookmarkList) {
      Map<String, dynamic> data = postBookmarked.data() as Map<String, dynamic>;
      QuerySnapshot bookmarkedPost = await FirebaseFirestore.instance
          .collectionGroup("myPost")
          .where("aID", isEqualTo: data["auId"])
          .where("postId", isEqualTo: data["postId"])
          .get();

      if (bookmarkedPost.size == 1) {
        myBookmark.add(bookmarkedPost.docs[0]);
      }
    }

    return myBookmark;
  }

  //TODO: Fetch the next ten bookmarked post tried to a user
  Future<List<QueryDocumentSnapshot>> fetchNextTenBookmarkedPost(
      DocumentSnapshot lastBookmark) async {
    List<QueryDocumentSnapshot> myBookmark = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collectionGroup("homeBookmark")
        .where("bkOwn", isEqualTo: loggedInUserID)
        .orderBy("bkCrt", descending: true)
        .startAfterDocument(lastBookmark)
        .limit(10)
        .get();

    List<QueryDocumentSnapshot> userBookmarkList = querySnapshot.docs;
    for (QueryDocumentSnapshot postBookmarked in userBookmarkList) {
      Map<String, dynamic> data = postBookmarked as Map<String, dynamic>;
      QuerySnapshot bookmarkedPost = await FirebaseFirestore.instance
          .collectionGroup("myPost")
          .where("aID", isEqualTo: data["auId"])
          .where("postId", isEqualTo: data["postId"])
          .get();

      if (bookmarkedPost.size == 1) {
        myBookmark.add(bookmarkedPost.docs[0]);
      }
    }

    return myBookmark;
  }

  //TODO: Setting up the notification monitor/tracker
  notificationMonitor(HomeNotifications homeNotifications) async {
    await sparksPost.doc(loggedInUserID).set(homeNotifications.toJson());
  }

  //TODO: If the notification screen is active/visible, set 'actSrn' to true
  notificationActiveScreen(bool isNotificationScreenActive) async {
    await sparksPost.doc(loggedInUserID).update({
      "actSrn": isNotificationScreenActive,
      //"notCts": notificationCounter,
    });
  }

  //TODO: Reset "actSrn" to false when the notification screen is not active
  resetNotificationScreen(
      bool resetScreenTracker, int notificationCounter) async {
    await sparksPost.doc(loggedInUserID).update({
      "actSrn": resetScreenTracker,
      "notCts": notificationCounter,
    });
  }

  //TODO: Fetch the current notification counter
  Future<DocumentSnapshot> currentNotificationCounter() async {
    DocumentSnapshot cNCounter = await sparksPost.doc(loggedInUserID).get();
    return cNCounter;
  }

  //TODO: Retrieve the number of notification a user has as the notification keeps coming in
  Stream<DocumentSnapshot> getNotificationCounter() {
    return sparksPost.doc(loggedInUserID).snapshots();
  }

  //TODO: Retrieve the post in connection with the notification click
  Future<dynamic> postConnectedToNotification(
      String? postOwner, String? postId) async {
    return await sparksPost
        .doc(postOwner)
        .collection("myPost")
        .doc(postId)
        .get();
  }

  //TODO: Fetch all users with personal accounts
  Future<List<Map<String, dynamic>>> usersWithPersonalAccount() async {
    List<Map<String, dynamic>> personalInfo = [];

    QuerySnapshot q = await sparksUsers.where("acct", arrayContainsAny: [
      {"act": "Personal", "dp": true},
      {"act": "Personal", "dp": false}
    ]).get();

    List<DocumentSnapshot> dst = q.docs;
    List<String?> personalAccWithEmail = []; // holds user's email
    List<String?> usersStatus = []; // holds user's status

    for (DocumentSnapshot documentSnapshot in dst) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (GlobalVariables.loggedInUserObject.em != data["em"]) {
        personalAccWithEmail.add(data["em"]);

        usersStatus.add(data["sts"]);
      }
    }

    for (int i = 0; i < personalAccWithEmail.length; i++) {
      QuerySnapshot qst = await FirebaseFirestore.instance
          .collectionGroup("Personal")
          .where("em", isEqualTo: personalAccWithEmail[i])
          .get();

      Map<String, dynamic> profileInfo = {
        "profileQuerySnapshot": qst,
        "currentProfileStatus": usersStatus[i],
      };

      personalInfo.add(profileInfo);
    }

    return personalInfo;
  }

  //TODO: Create a one-time spark up object that holds the number of ( friends, tutor, tutee, mentee, mentors and hobbyist )
  Future<void> _createOneTimeSparkUpObject(String? uid) async {
    SparkUp sparkUpModel = SparkUp(
      numF: 0,
      numM: 0,
      numMe: 0,
      numT: 0,
      numTe: 0,
      hob: 0,
    );
    await sparkUp.doc(uid).set(sparkUpModel.toJson());
  }

  //TODO: Sending spark up request object ( mentor )
  Future<void> sendingSparkUpRequestMentor(
      List<CreateSparkUpMM> incomingSparkUpRequest,
      String? requestTo,
      String buttonTypeClicked) async {
    //Create a one-time object called spark_up
    DocumentSnapshot documentSnapshot = await sparkUp.doc(loggedInUserID).get();
    DocumentSnapshot documentSnapshot1 = await sparkUp.doc(requestTo).get();

    if (buttonTypeClicked == "Mentor") {
      if ((documentSnapshot.exists) && (documentSnapshot1.exists)) {
        //Object created inside the sender's collection
        await sparkUp
            .doc(loggedInUserID)
            .collection("Mentors")
            .doc()
            .set(incomingSparkUpRequest[0].toJson());

        //Object created inside the receiver's collection
        await sparkUp
            .doc(requestTo)
            .collection("Mentees")
            .doc()
            .set(incomingSparkUpRequest[1].toJson());
      } else {
        await _createOneTimeSparkUpObject(loggedInUserID);
        await _createOneTimeSparkUpObject(requestTo);

        //Object created inside the sender's collection
        await sparkUp
            .doc(loggedInUserID)
            .collection("Mentors")
            .doc()
            .set(incomingSparkUpRequest[0].toJson());

        //Object created inside the receiver's collection
        await sparkUp
            .doc(requestTo)
            .collection("Mentees")
            .doc()
            .set(incomingSparkUpRequest[1].toJson());
      }
    }
  }

  //TODO: Sending spark up request object ( tutor )
  Future<void> sendingSparkUpRequestTutor(
      List<CreateSparkUpTT> incomingSparkUpRequest,
      String? requestTo,
      String buttonTypeClicked) async {
    //Create a one-time object called spark_up
    DocumentSnapshot documentSnapshot = await sparkUp.doc(loggedInUserID).get();
    DocumentSnapshot documentSnapshot1 = await sparkUp.doc(requestTo).get();

    if (buttonTypeClicked == "Tutor") {
      if ((documentSnapshot.exists) && (documentSnapshot1.exists)) {
        //Object created inside the sender's collection
        await sparkUp
            .doc(loggedInUserID)
            .collection("Tutors")
            .doc()
            .set(incomingSparkUpRequest[0].toJson());

        //Object created inside the receiver's collection
        await sparkUp
            .doc(requestTo)
            .collection("Tutees")
            .doc()
            .set(incomingSparkUpRequest[1].toJson());
      } else {
        await _createOneTimeSparkUpObject(loggedInUserID);
        await _createOneTimeSparkUpObject(requestTo);

        //Object created inside the sender's collection
        await sparkUp
            .doc(loggedInUserID)
            .collection("Tutors")
            .doc()
            .set(incomingSparkUpRequest[0].toJson());

        //Object created inside the receiver's collection
        await sparkUp
            .doc(requestTo)
            .collection("Tutees")
            .doc()
            .set(incomingSparkUpRequest[1].toJson());
      }
    }
  }

  //TODO: Sending spark up request object ( friend )
  Future<void> sendingSparkUpRequest(List<CreateSparkUp> incomingSparkUpRequest,
      String? requestTo, String buttonTypeClicked) async {
    //Create a one-time object called spark_up
    DocumentSnapshot documentSnapshot = await sparkUp.doc(loggedInUserID).get();
    DocumentSnapshot documentSnapshot1 = await sparkUp.doc(requestTo).get();

    if (buttonTypeClicked == "Friend") {
      if ((documentSnapshot.exists) && (documentSnapshot1.exists)) {
        //Object created inside the sender's collection
        await sparkUp
            .doc(loggedInUserID)
            .collection("Friends")
            .doc()
            .set(incomingSparkUpRequest[0].toJson());

        //Object created inside the receiver's collection
        await sparkUp
            .doc(requestTo)
            .collection("Friends")
            .doc()
            .set(incomingSparkUpRequest[1].toJson());
      } else {
        await _createOneTimeSparkUpObject(loggedInUserID);
        await _createOneTimeSparkUpObject(requestTo);

        //Object created inside the sender's collection
        await sparkUp
            .doc(loggedInUserID)
            .collection("Friends")
            .doc()
            .set(incomingSparkUpRequest[0].toJson());

        //Object created inside the receiver's collection
        await sparkUp
            .doc(requestTo)
            .collection("Friends")
            .doc()
            .set(incomingSparkUpRequest[1].toJson());
      }
    }
  }

  //TODO: Knowing the state of every spark up request ( friend request )
  /*
  * This is to know exactly if the request is still pending, accepted or not existing at all.
  * */
  Future<String?> sparkUpRequestState(String? profileInView) async {
    String? sparkUpState = "";

    QuerySnapshot qShot = await sparkUp
        .doc(loggedInUserID)
        .collection("Friends")
        .where("fId", isEqualTo: profileInView)
        .get();

    List<DocumentSnapshot> sus = qShot.docs;
    sparkUpState = sus[0]["sUpTy"];

    return sparkUpState;
  }

  //TODO: Knowing the state of every spark up request ( tutor request )
  /*
  * This is to know exactly if the request is still pending, accepted or not existing at all.
  * profileInView - the profile that is viewed currently
  * statusOfTheLoginUser - represents the status of the login user.
  * */
  Future<String?> sparkUpRequestStateForTutor(String? profileInView) async {
    String? sparkUpState = "";

    //Querying tutor's collection to see if profile exist
    QuerySnapshot qShot = await sparkUp
        .doc(loggedInUserID)
        .collection("Tutors")
        .where("tuId", isEqualTo: profileInView)
        .where("asA", isEqualTo: "TUTOR")
        .get();

    List<DocumentSnapshot> sus = qShot.docs;

    if (sus[0].exists) {
      sparkUpState = sus[0]["sUpTy"];
    } else {
      //Querying tutee's collection to see if profile exist
      QuerySnapshot qShot1 = await sparkUp
          .doc(loggedInUserID)
          .collection("Tutees")
          .where("tuId", isEqualTo: profileInView)
          .where("asA", isEqualTo: "TUTEE")
          .get();

      List<DocumentSnapshot> sus1 = qShot1.docs;
      sparkUpState = sus1[0]["sUpTy"];
    }

    return sparkUpState;
  }

  //TODO: Knowing the state of every spark up request ( Mentor request )
  /*
  * This is to know exactly if the request is still pending, accepted or not existing at all.
  * profileInView - the profile that is viewed currently
  * statusOfTheLoginUser - represents the status of the login user.
  * */
  Future<String?> sparkUpRequestStateForMentor(String? profileInView) async {
    String? sparkUpState = "";

    //Querying mentor's collection to see if profile exist
    QuerySnapshot qShot = await sparkUp
        .doc(loggedInUserID)
        .collection("Mentors")
        .where("meId", isEqualTo: profileInView)
        .where("asA", isEqualTo: "MENTOR")
        .get();

    List<DocumentSnapshot> sus = qShot.docs;

    if (sus[0].exists) {
      sparkUpState = sus[0]["sUpTy"];
    } else {
      //Querying mentee's collection to see if profile exist
      QuerySnapshot qShot1 = await sparkUp
          .doc(loggedInUserID)
          .collection("Mentees")
          .where("meId", isEqualTo: profileInView)
          .where("asA", isEqualTo: "MENTEE")
          .get();

      List<DocumentSnapshot> sus1 = qShot1.docs;
      sparkUpState = sus1[0]["sUpTy"];
    }

    return sparkUpState;
  }

  //TODO: Cancelling a spark up request ( friend )
  Future<void> cancelSparkUpRequest(String? removeId) async {
    QuerySnapshot qsRequestToRemove = await sparkUp
        .doc(loggedInUserID)
        .collection("Friends")
        .where("reqTo", isEqualTo: removeId)
        .get();

    QuerySnapshot qsReceivedToRemove = await sparkUp
        .doc(removeId)
        .collection("Friends")
        .where("sid", isEqualTo: loggedInUserID)
        .get();

    List<DocumentSnapshot> ds1 = qsRequestToRemove.docs;
    List<DocumentSnapshot> ds2 = qsReceivedToRemove.docs;

    //Cancel spark up request
    await sparkUp
        .doc(loggedInUserID)
        .collection("Friends")
        .doc(ds1[0].id)
        .delete();
    await sparkUp.doc(removeId).collection("Friends").doc(ds2[0].id).delete();
  }

  //TODO: Cancelling a spark up request ( tutor )
  Future<void> cancelSparkUpRequestTutor(String? removeId) async {
    QuerySnapshot qsRequestToRemove = await sparkUp
        .doc(loggedInUserID)
        .collection("Tutors")
        .where("tuId", isEqualTo: removeId)
        .get();

    QuerySnapshot qsReceivedToRemove = await sparkUp
        .doc(removeId)
        .collection("Tutees")
        .where("tuId", isEqualTo: loggedInUserID)
        .get();

    List<DocumentSnapshot> ds1 = qsRequestToRemove.docs;
    List<DocumentSnapshot> ds2 = qsReceivedToRemove.docs;

    //Cancel spark up request
    await sparkUp
        .doc(loggedInUserID)
        .collection("Tutors")
        .doc(ds1[0].id)
        .delete();
    await sparkUp.doc(removeId).collection("Tutees").doc(ds2[0].id).delete();
  }

  //TODO: Cancelling a spark up request ( mentor )
  Future<void> cancelSparkUpRequestMentor(String? removeId) async {
    QuerySnapshot qsRequestToRemove = await sparkUp
        .doc(loggedInUserID)
        .collection("Mentors")
        .where("meId", isEqualTo: removeId)
        .get();

    QuerySnapshot qsReceivedToRemove = await sparkUp
        .doc(removeId)
        .collection("Mentees")
        .where("meId", isEqualTo: loggedInUserID)
        .get();

    List<DocumentSnapshot> ds1 = qsRequestToRemove.docs;
    List<DocumentSnapshot> ds2 = qsReceivedToRemove.docs;

    //Cancel spark up request
    await sparkUp
        .doc(loggedInUserID)
        .collection("Mentors")
        .doc(ds1[0].id)
        .delete();
    await sparkUp.doc(removeId).collection("Mentees").doc(ds2[0].id).delete();
  }

  //TODO: Accepting spark up request ( friend )
  Future<void> acceptingSparkUpRequest(String? acceptingUserID) async {
    //Fetch the document with the corresponding request (receiver)
    QuerySnapshot qsRequestToAccept = await sparkUp
        .doc(loggedInUserID)
        .collection("Friends")
        .where("fId", isEqualTo: acceptingUserID)
        .get();

    //Fetch the document with the corresponding request (sender)
    QuerySnapshot qsSenderToAccept = await sparkUp
        .doc(acceptingUserID)
        .collection("Friends")
        .where("fId", isEqualTo: loggedInUserID)
        .get();

    List<DocumentSnapshot> getDocumentId = qsRequestToAccept.docs;
    List<DocumentSnapshot> getDocumentIdSender = qsSenderToAccept.docs;

    //Accept the spark up request by updating the necessary field
    await sparkUp
        .doc(loggedInUserID)
        .collection("Friends")
        .doc(getDocumentId[0].id)
        .update({
      "reqCom": DateTime.now().toString(),
      "sUpTy": "CONFIRMED",
    });

    await sparkUp
        .doc(acceptingUserID)
        .collection("Friends")
        .doc(getDocumentIdSender[0].id)
        .update({
      "reqCom": DateTime.now().toString(),
      "sUpTy": "CONFIRMED",
    });
  }

  //TODO: Accepting spark up request ( tutor )
  Future<void> acceptingSparkUpRequestTutor(String? acceptingUserID) async {
    //Fetch the document with the corresponding request (receiver)
    QuerySnapshot qsRequestToAccept = await sparkUp
        .doc(loggedInUserID)
        .collection("Tutees")
        .where("tuId", isEqualTo: acceptingUserID)
        .get();

    //Fetch the document with the corresponding request (sender)
    QuerySnapshot qsSenderToAccept = await sparkUp
        .doc(acceptingUserID)
        .collection("Tutors")
        .where("tuId", isEqualTo: loggedInUserID)
        .get();

    List<DocumentSnapshot> getDocumentId = qsRequestToAccept.docs;
    List<DocumentSnapshot> getDocumentIdSender = qsSenderToAccept.docs;

    //Accept the spark up request by updating the necessary field
    await sparkUp
        .doc(loggedInUserID)
        .collection("Tutees")
        .doc(getDocumentId[0].id)
        .update({
      "reqCom": DateTime.now().toString(),
      "sUpTy": "CONFIRMED",
    });

    await sparkUp
        .doc(acceptingUserID)
        .collection("Tutors")
        .doc(getDocumentIdSender[0].id)
        .update({
      "reqCom": DateTime.now().toString(),
      "sUpTy": "CONFIRMED",
    });
  }

  //TODO: Accepting spark up request ( mentor )
  Future<void> acceptingSparkUpRequestMentor(String? acceptingUserID) async {
    //Fetch the document with the corresponding request (receiver)
    QuerySnapshot qsRequestToAccept = await sparkUp
        .doc(loggedInUserID)
        .collection("Mentees")
        .where("meId", isEqualTo: acceptingUserID)
        .get();

    //Fetch the document with the corresponding request (sender)
    QuerySnapshot qsSenderToAccept = await sparkUp
        .doc(acceptingUserID)
        .collection("Mentors")
        .where("meId", isEqualTo: loggedInUserID)
        .get();

    List<DocumentSnapshot> getDocumentId = qsRequestToAccept.docs;
    List<DocumentSnapshot> getDocumentIdSender = qsSenderToAccept.docs;

    //Accept the spark up request by updating the necessary field
    await sparkUp
        .doc(loggedInUserID)
        .collection("Mentees")
        .doc(getDocumentId[0].id)
        .update({
      "reqCom": DateTime.now().toString(),
      "sUpTy": "CONFIRMED",
    });

    await sparkUp
        .doc(acceptingUserID)
        .collection("Mentors")
        .doc(getDocumentIdSender[0].id)
        .update({
      "reqCom": DateTime.now().toString(),
      "sUpTy": "CONFIRMED",
    });
  }

  //TODO: Fetch all the request marked ' RECEIVED ' depending on the status of the logged in user
  /*
  * For a status marked ' FRIEND ' : we have friend request ' RECEIVED '
  * For a status marked ' TUTOR ' : we have friend request ' RECEIVED ' and tutor request ' RECEIVED '
  * For a status marked ' MENTOR ' : we have friend request ' RECEIVED ', tutor request ' RECEIVED ' and mentor request ' RECEIVED '
  * */
  Future<List<String>> fetchRequestMarkedReceived(
      String? uidOfTheSender, String? statusOfTheLoggedInUser) async {
    List<String> documentMarkedReceived = [];

    switch (statusOfTheLoggedInUser) {
      case "FRIEND":
        documentMarkedReceived = await _trackResponseForFriend(uidOfTheSender);
        break;
      case "TUTOR":
        documentMarkedReceived = await _trackResponseForTutor(uidOfTheSender);
        break;
      case "MENTOR":
        documentMarkedReceived = await _trackResponseForMentor(uidOfTheSender);
        break;
    }

    return documentMarkedReceived;
  }

  //TODO: This functions tracks spark up pending response for profile with the status 'FRIEND'
  Future<List<String>> _trackResponseForFriend(String? uid) async {
    List<String> holdResult = [];

    QuerySnapshot querySnapshot = await sparkUp
        .doc(loggedInUserID)
        .collection("Friends")
        .where("fId", isEqualTo: uid)
        .where("sUpTy", isEqualTo: "RECEIVED")
        .get();

    List<DocumentSnapshot> lDocs = querySnapshot.docs;
    if (lDocs[0].exists) {
      holdResult
          .add("friend"); //shows that the sender is requesting for friendship
    }

    return holdResult;
  }

  //TODO: This functions tracks spark up pending response for profile with the status 'TUTOR'
  Future<List<String>> _trackResponseForTutor(String? uid) async {
    List<String> holdResult = [];

    List<String> mCollections = ["Tutees", "Friends"];
    List<String> mIds = ["tuId", "fId"];
    List<String> res = ["tutee", "friend"];

    for (int i = 0; i < 2; i++) {
      QuerySnapshot querySnapshot = await sparkUp
          .doc(loggedInUserID)
          .collection(mCollections[i])
          .where(mIds[i], isEqualTo: uid)
          .where("sUpTy", isEqualTo: "RECEIVED")
          .get();

      if (querySnapshot.size == 1) {
        holdResult.add(res[
            i]); //shows that the sender is requesting for tutorship or friendship.
      }
    }

    return holdResult;
  }

  //TODO: This functions tracks spark up pending response for profile with the status 'MENTOR'
  Future<List<String>> _trackResponseForMentor(String? uid) async {
    List<String> holdResult = [];

    List<String> mCollections = ["Mentees", "Tutees", "Friends"];
    List<String> mIds = ["meId", "tuId", "fId"];
    List<String> res = ["mentee", "tutee", "friend"];

    for (int i = 0; i < 3; i++) {
      QuerySnapshot querySnapshot = await sparkUp
          .doc(loggedInUserID)
          .collection(mCollections[i])
          .where(mIds[i], isEqualTo: uid)
          .where("sUpTy", isEqualTo: "RECEIVED")
          .get();

      if (querySnapshot.size == 1) {
        holdResult.add(res[
            i]); //shows that the sender is requesting for mentorship, tutorship or friendship.
      }
    }

    return holdResult;
  }

  //TODO: Returns all the group type size ( friend, tutor, mentor, tutee, mentee )
  Future<SparkUp> getGroup() async {
    DocumentSnapshot documentSnapshot = await sparkUp.doc(loggedInUserID).get();
    SparkUp sparkUpModel =
        SparkUp.fromJson(documentSnapshot.data() as Map<String, dynamic>);

    return sparkUpModel;
  }

  //TODO Returns a querySnapShot in each group with limit attached to the query
  /*
  * Parameters: Group name and the limit size
  * */
  Future<QuerySnapshot> allDocumentsInGroup(
      String groupName, int limitSize) async {
    return await sparkUp
        .doc(loggedInUserID)
        .collection(groupName)
        .limit(limitSize)
        .get();
  }

  //TODO: Get the next 10,000 ids in the selected group
  /*
  * Parameters: Group name and the limit size
  * */
  Future<QuerySnapshot> getTheNextTenThousandDocInGroup(
      String groupName, DocumentSnapshot lastDoc, int limitSize) async {
    return await sparkUp
        .doc(loggedInUserID)
        .collection(groupName)
        .startAfterDocument(lastDoc)
        .limit(limitSize)
        .get();
  }

  //TODO: Deleting a post created by the author
  /*
  * Parameter: The delete id of the post.
  * */
  Future<bool> deletingAnAuthorPost(String? postDelId) async {
    bool isPostDeleted;

    QuerySnapshot querySnapshot = await sparksPost
        .doc(loggedInUserID)
        .collection("myPost")
        .where("delID", isEqualTo: postDelId)
        .get();

    List<DocumentSnapshot> postToBeDeleted = querySnapshot.docs;
    for (DocumentSnapshot documentSnapshot in postToBeDeleted) {
      String pd = documentSnapshot.id;

      //Get all the likes associated with this post if any exist.
      QuerySnapshot deleteLikeDocs = await sparksPost
          .doc(loggedInUserID)
          .collection("myPost")
          .doc(pd)
          .collection("homePostLikes")
          .where("comID", isEqualTo: postDelId)
          .get();

      //Get all the comments associated with this post if any exist.
      QuerySnapshot deleteCommentsDocs = await sparksPost
          .doc(loggedInUserID)
          .collection("myPost")
          .doc(pd)
          .collection("homeComments")
          .where("comID", isEqualTo: postDelId)
          .get();

      //Delete all the likes if querysnapshot is not empty.
      if (deleteLikeDocs.docs.isNotEmpty) {
        for (DocumentSnapshot documentSnapshot in deleteLikeDocs.docs) {
          String likeDocToDel = documentSnapshot.id;

          await sparksPost
              .doc(loggedInUserID)
              .collection("myPost")
              .doc(pd)
              .collection("homePostLikes")
              .doc(likeDocToDel)
              .delete();
        }
      }

      //Delete all the comments if querysnapshot is not empty.
      if (deleteCommentsDocs.docs.isNotEmpty) {
        for (DocumentSnapshot documentSnapshot in deleteCommentsDocs.docs) {
          String comDocToDel = documentSnapshot.id;

          await sparksPost
              .doc(loggedInUserID)
              .collection("myPost")
              .doc(pd)
              .collection("homeComments")
              .doc(comDocToDel)
              .delete();
        }
      }

      //Finally, delete the post itself.
      await sparksPost
          .doc(loggedInUserID)
          .collection("myPost")
          .doc(pd)
          .delete();
    }

    // After a successful delete, set 'isPostDeleted' to true
    isPostDeleted = true;

    return isPostDeleted;
  }

  //TODO: Get the common id that links both the main post and the comment together.
  Future<String?> postCommentCommonID(String? commentID, String? postId) async {
    String? commonID;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collectionGroup("homeComments")
        .where("commID", isEqualTo: commentID)
        .where("postID", isEqualTo: postId)
        .orderBy("comID", descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs[0].data() as Map<String, dynamic>;
      commonID = data["comID"];
    }

    return commonID;
  }

  //TODO: Create a new reply object to a given comment
  Future<void> newReplyObject(ReplyComments replyComments, String? parentPostID,
      String? postId, String? commentID) async {
    await sparksPost
        .doc(parentPostID)
        .collection("myPost")
        .doc(postId)
        .collection("homeComments")
        .doc(commentID)
        .collection("commentReplies")
        .doc()
        .set(replyComments.toJson());
  }

  //TODO: Get the author's id of a parent post(ie the id of the user who created the main post)
  Future<String?> authorID(String? postID, String? commonId) async {
    String? authorId;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collectionGroup("myPost")
        .where("postId", isEqualTo: postID)
        .where("delID", isEqualTo: commonId)
        .orderBy("ptc", descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs[0].data() as Map<String, dynamic>;
      authorId = data["aID"];
    }

    return authorId;
  }

  //TODO: Fetch the most recent replies
  Stream<QuerySnapshot> getTheMostRecentReplies(String? commentId) {
    return FirebaseFirestore.instance
        .collectionGroup("commentReplies")
        .where("comID", isEqualTo: commentId)
        .orderBy("tRep", descending: true)
        .snapshots();
  }

  //TODO: Deleting a comment with it's responding likes and replies
  /*
  * Where commentComID is the common Id that's binds the main post, comment and the replies together
  *       commentID is the unique id associated to a given comment
  *       postID is the Id of the main post
  * */
  Future<void> deleteCommentsLikesAndReplies(
      String? commentComID, String? commentID, String? postID) async {
    //Fetch all the replies in this comment
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collectionGroup("commentReplies")
        .where("delRId", isEqualTo: commentComID)
        .where("comID", isEqualTo: commentID)
        .orderBy("tRep", descending: true)
        .get();

    //Fetch all the likes in a given comment
    QuerySnapshot likeCommQuery = await FirebaseFirestore.instance
        .collectionGroup("commentLikes")
        .where("comID", isEqualTo: commentComID)
        .orderBy("cid", descending: true)
        .get();

    //Get the document ID of the main comment
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collectionGroup("homeComments")
        .where("comID", isEqualTo: commentComID)
        .where("commID", isEqualTo: commentID)
        .orderBy("tOfPst", descending: true)
        .get();

    //Fetch the id of the main post
    String? authorPostId = await authorID(postID, commentComID);

    //Delete all the replies in a comment if any exist
    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot document in querySnapshot.docs) {
        await sparksPost
            .doc(authorPostId)
            .collection("myPost")
            .doc(postID)
            .collection("homeComments")
            .doc(commentID)
            .collection("commentReplies")
            .doc(document.id)
            .delete();
      }
    }

    //Delete all the likes in a comment if any exist
    if (likeCommQuery.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in likeCommQuery.docs) {
        await sparksPost
            .doc(authorPostId)
            .collection("myPost")
            .doc(postID)
            .collection("homeComments")
            .doc(commentID)
            .collection("commentLikes")
            .doc(documentSnapshot.id)
            .delete();
      }
    }

    //finally delete the comment itself
    String commentDocId =
        qs.docs[0].id; //This is the document Id of this comment
    await sparksPost
        .doc(authorPostId)
        .collection("myPost")
        .doc(postID)
        .collection("homeComments")
        .doc(commentDocId)
        .delete();

    //Get the main post document to update it's number of comment(s).
    QuerySnapshot updateCommentCounter = await FirebaseFirestore.instance
        .collectionGroup("myPost")
        .where("delID", isEqualTo: commentComID)
        .orderBy("ptc", descending: true)
        .get();

    if (updateCommentCounter.docs.isNotEmpty) {
      for (DocumentSnapshot dtst in updateCommentCounter.docs) {
        Map<String, dynamic> data = dtst.data() as Map<String, dynamic>;
        //Get the post id
        String? uniquePostId = data["postId"];

        //Subtracting one from the number of comments available
        int? commentCounter = data["nOfCmts"] - 1;

        //Finally, update the post comment counter to it's new value
        await sparksPost
            .doc(authorPostId)
            .collection("myPost")
            .doc(uniquePostId)
            .update({"nOfCmts": commentCounter});
      }
    }
  }
}
