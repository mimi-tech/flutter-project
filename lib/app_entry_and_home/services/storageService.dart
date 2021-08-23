import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:sparks/app_entry_and_home/models/camera_post_model.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/camera_post.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class StorageService {
  final String? userID;

  StorageService({this.userID});

  //TODO: Create a variable to hold cloud storage bucket.
  final FirebaseStorage _storageBucket =
      FirebaseStorage.instanceFor(bucket: "gs://sparks-44la.appspot.com");

  //TODO: Upload user profile image to firebase cloud storage.
  Future<String?> uploadProfileImage(String fileName, File profileImage) async {
    String profileImagePath = "pimg/";
    String? imgPath;

    UploadTask storageUploadTask = _storageBucket
        .ref()
        .child(profileImagePath + userID! + "/" + fileName)
        .putFile(profileImage);

    try {
      //TODO: Get the download url of the uploaded image.
      (await storageUploadTask)
          .ref
          .getDownloadURL()
          .then((profileImageDownloadUrl) {
        if (profileImageDownloadUrl != null) {
          //TODO: Get the profile image download link uploaded into cloud storage.
          DatabaseService dService = DatabaseService(loggedInUserID: userID);
          dService.updateProfileImagePath(
              profileImageDownloadUrl, GlobalVariables.accountSelected["act"]);

          //TODO: Store the download url into global variable.
          GlobalVariables.profileImageDownloadUrl = profileImageDownloadUrl;
        }
      });
    } catch (e) {
      e.toString();
    }

    imgPath = GlobalVariables.profileImageDownloadUrl;

    return imgPath;
  }

  //TODO: Upload a media file(camera post) to firebase cloud storage.
  Future<void> uploadMediaFile(String fileName, File mediaFile,
      String postDelId, List<List<String?>> groupsOfIds) async {
    String mediaFilePath = "posts/";
    String imgDir = "images/";
    String vidDir = "videos/";
    late UploadTask storageUploadTask;

    //TODO: Check for the file extension name and upload to the right directory
    if (fileName.endsWith(".jpg"))
      storageUploadTask = _storageBucket
          .ref()
          .child(mediaFilePath + userID! + "/" + imgDir + fileName)
          .putFile(mediaFile);
    else if (fileName.endsWith(".mp4"))
      storageUploadTask = _storageBucket
          .ref()
          .child(mediaFilePath + userID! + "/" + vidDir + fileName)
          .putFile(mediaFile);

    try {
      //TODO: Get the download url of the uploaded media file.
      (await storageUploadTask)
          .ref
          .getDownloadURL()
          .then((mediaFileDownloadURL) {
        if (mediaFileDownloadURL != null) {
          for (List<String?> listOfIds in groupsOfIds) {
            //TODO: Create an object model from post created.
            CameraPostModel cameraPostMod = CameraPostModel(
              aID: GlobalVariables.loggedInUserObject.id,
              nm: GlobalVariables.loggedInUserObject.nm,
              auPimg: GlobalVariables.loggedInUserObject.pimg,
              auSpec: GlobalVariables.loggedInUserObject.spec![0],
              title: GlobalVariables.cameraPostTitle,
              desc: GlobalVariables.cameraImageDescription,
              cln: {
                "cty": GlobalVariables.loggedInUserObject.addr!["cty"],
                "st": GlobalVariables.loggedInUserObject.addr!["st"]
              },
              delID: postDelId,
              nOfCmts: 0,
              nOfLikes: 0,
              nOfShs: 0,
              postId: "",
              friID: listOfIds,
              imgVid: [mediaFileDownloadURL],
              mediaT: fileName.endsWith(".mp4") ? "Videos" : "Images",
              postT: "Camera",
              ptc: DateTime.now(),
            );

            //TODO: Upload the camera post to the database.
            DatabaseService(loggedInUserID: userID)
                .createNewUserCameraPost(cameraPostMod);
          }
        }
      });
    } catch (e) {
      e.toString();
    }
  }

  //TODO: Deleting a file from firebase cloud storage
  Future<void> deletingMediaFile(String filePath) async {
    Reference storageReference = await _storageBucket.refFromURL(filePath);
    await storageReference.delete();
  }
}
