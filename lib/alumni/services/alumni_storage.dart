import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:sparks/alumni/utilities/strings.dart';
import 'package:sparks/global_services/compress_image_in_isolate.dart';
import 'package:sparks/utilities/service_const.dart';

class AlumniStorage {
  final String? userId;

  AlumniStorage({this.userId});

  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: kFirebaseStorage);

  Future<List<String>> uploadPostImage(List<File?> images) async {
    String alumniPostImagePath = "alumniPostImages/";

    CompressImageInIsolate compressImageInIsolate = CompressImageInIsolate();

    List<String> uploadedImages = [];

    try {
      List<File> compressedImages =
          await compressImageInIsolate.compressImage(images);

      for (File file in compressedImages) {
        UploadTask uploadTask = _storage
            .ref()
            .child(alumniPostImagePath +
                userId! +
                "/" +
                DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(file);

        TaskSnapshot taskSnapshot = await uploadTask;

        String url = (await taskSnapshot.ref.getDownloadURL());

        // final TaskSnapshot downloadUrl = (await uploadTask);

        // String url = (await downloadUrl.ref.getDownloadURL());
        uploadedImages.add(url);
      }
    } on SocketException {
      compressImageInIsolate.killIsolate();
      throw Exception(kSocketExceptionMessage);
    } catch (e) {
      compressImageInIsolate.killIsolate();
      print("upLoadPostImage: $e");
      throw Exception(kCatchErrorMessage);
    }

    return uploadedImages;
  }
}
