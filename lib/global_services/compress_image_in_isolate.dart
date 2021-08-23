import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

/// TODO: Remove [debugPrint] from the methods in this class

/// Improvements that can be made include:
/// - Enabling the desired image size output in MB to be determined or assigned
/// by the person using an instance of the class to implement its methods

/// This class utilizes the [flutter_image_compress] - v0.7.0 and
/// [flutter_isolate] - v1.0.0+14 packages to compress an image in a separate
/// isolate if the size of the image exceeds "5MB"
///
/// NOTE: When an instance of this class which calls the [compressImage]
/// method is used, it is equally important to call the [killIsolate] method in
/// the [dispose] method of that class, or if used in a try-catch block, be called
/// in the catch block to terminate the isolate, which could still be running in
/// the background. Thou the [compressImage] automatically calls the [killIsolate]
/// when it has completed its given task, but it is still imperative to call the
/// [killIsolate] method in the off-chance that the isolate could still be running
class CompressImageInIsolate {
  static int _targetSize = 1024 * 1024 * 5;

  FlutterIsolate? _isolate;
  late ReceivePort _receivePort;

  /// This method will return a List of image files which has been compressed
  /// using a Isolate
  Future<List<File>> compressImage(List<File?> files) async {
    _receivePort = ReceivePort();

    _isolate = await FlutterIsolate.spawn(
        _imageCompressHandler, _receivePort.sendPort);

    SendPort sendPort = await (_receivePort.first as Future<SendPort>);

    ReceivePort receivePort2 = ReceivePort();

    /// Converting the passed files to List of String to sent to the isolate
    /// method responsible for compressing the image
    List<String> filePaths = _convertFilesToStringPaths(files);

    sendPort.send([
      filePaths, // Sending the file path
      receivePort2.sendPort,
    ]);

    /// Newly converted file paths received from the isolate
    List<String> newFilePaths =
        await (receivePort2.first as Future<List<String>>);

    /// Converting the received file paths (as List of String) to a List
    /// of File to be return from the method
    List<File> result = _convertStringPathsToFiles(newFilePaths);

    /// Terminating the isolate - Work completed
    killIsolate();

    return result;
  }

  /// This method will handle the compressing of the image file
  static Future<void> _imageCompressHandler(SendPort sendPort) async {
    debugPrint("Isolate is running");

    /// Result to be return from method
    List<String> result = [];

    ReceivePort childReceivePort = ReceivePort();

    sendPort.send(childReceivePort.sendPort);

    final msg = await childReceivePort.first;

    /// Extracting the passed data
    List<String> filePaths = msg[0] as List<String>;
    SendPort replyPort = msg[1] as SendPort;

    /// Get the list of files
    List<File> files = _convertStringPathsToFiles(filePaths);

    for (File fileToCompress in files) {
      bool shouldCompress = await _shouldImageBeCompressed(fileToCompress);

      if (!shouldCompress) {
        result.add(fileToCompress.path);
      } else {
        debugPrint("Image is compressing");
        int percentageToCompressWith =
            await _calculateCompressPercentage(fileToCompress);
        String originalPath = fileToCompress.path;
        String compressPath = _getCompressPath(fileToCompress);

        final compressedFile = await (FlutterImageCompress.compressAndGetFile(
                originalPath, compressPath, quality: percentageToCompressWith)
            as Future<File>);

        int newImageSize = await _getImageSize(compressedFile);

        debugPrint("New Image Size: $newImageSize");

        result.add(compressedFile.path);
      }
    }

    replyPort.send(result);
  }

  /// Determine if image should be compressed
  ///
  /// NOTE: This method uses the [_targetSize] value to determine if the
  /// image should be compressed. If the image size is greater than the
  /// [_targetSize], the method will return "true" and the image compressed
  static Future<bool> _shouldImageBeCompressed(File file) async {
    bool shouldBeCompressed = false;
    int imageSize = await _getImageSize(file);

    if (imageSize > _targetSize) {
      shouldBeCompressed = true;
    }

    return shouldBeCompressed;
  }

  /// The method returns the image size of the passed in image file
  static Future<int> _getImageSize(File file) async {
    final pickedFileByte = await file.readAsBytes();

    return pickedFileByte.lengthInBytes;
  }

  /// This method uses the picked file path and creates a new temporary path
  /// where the compressed image will be written to
  static String _getCompressPath(File file) {
    String imagePath = file.path;

    int? extIndex;
    String newPath;

    for (int i = imagePath.length - 1; i > 0; i--) {
      if (imagePath[i] == ".") {
        extIndex = i;
        break;
      }
    }

    String extensionType = imagePath.substring(extIndex!, imagePath.length);
    String partialPath = imagePath.substring(0, extIndex);

    newPath = "${partialPath}_out$extensionType";

    return newPath;
  }

  /// This method calculates the percentage the [FlutterImageCompress]
  /// package should use in compressing the image file
  static Future<int> _calculateCompressPercentage(File file) async {
    int imageSize = await _getImageSize(file); // Size of image

    debugPrint("Image size before: $imageSize");

    /// Percentage image will be compressed with
    double percentage = (_targetSize / imageSize) * 100;

    debugPrint("Percentage: $percentage");

    return percentage.toInt();
  }

  /// This method takes in a List of String which are the image file paths
  /// and returns a List of File
  static List<File> _convertStringPathsToFiles(List<String> filePaths) {
    List<File> result = [];

    for (String path in filePaths) {
      result.add(File(path));
    }

    return result;
  }

  /// This method takes a List of File and returns a List of String which
  /// is the file paths string values
  static List<String> _convertFilesToStringPaths(List<File?> files) {
    List<String> result = [];

    for (File? file in files) {
      result.add(file!.path);
    }

    return result;
  }

  /// This method terminates the running isolate
  ///
  /// NOTE: This method should be called in the [dispose] method of any
  /// class implementing the [compressImage] method
  void killIsolate() {
    if (_isolate != null) {
      _receivePort.close();
      _isolate!.kill();
      _isolate = null;
      debugPrint("Isolate terminated successfully");
    }
  }
}
