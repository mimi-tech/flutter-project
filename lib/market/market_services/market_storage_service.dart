import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sparks/utilities/service_const.dart';

class MarketStorageService {
  final String? userId;

  MarketStorageService({this.userId});

  final FirebaseStorage _storageBucket =
      FirebaseStorage.instanceFor(bucket: kFirebaseStorage);

  Future<List<String>> uploadProductImages(List<File?> productImages) async {
    String _productImagePath = 'marketImages/';

    List<String> uploadedImages = [];

    try {
      for (File? file in productImages) {
        UploadTask storageUploadTask = _storageBucket
            .ref()
            .child(_productImagePath +
                userId! +
                '/' +
                'prodImg' +
                DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(file!);

        final TaskSnapshot downloadUrl = (await storageUploadTask);

        final String url = (await downloadUrl.ref.getDownloadURL());
        uploadedImages.add(url);
      }
    } catch (e) {
      print(e);
    }

    return uploadedImages;
  }
}
