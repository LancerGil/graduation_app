import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:graduationapp/models/cloud_storage_result.dart';

abstract class BaseCloudStorage {
  Future<void> upload(File file, String fileName);
  Future<void> downloadFile(String fileName);
  Future deleteFile(String fileName);
}

class CloudStorage extends BaseCloudStorage {
  @override
  Future<void> downloadFile(String fileName) {
    throw UnimplementedError();
  }

  @override
  Future<CloudStorageResult> upload(File fileToUpload, String fileName) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(fileToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(fileName: fileName, fileUrl: url);
    }

    return null;
  }

  @override
  Future deleteFile(String fileName) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
