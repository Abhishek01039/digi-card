import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class CardServer {
  StorageUploadTask uploadTask;
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://digi-card-c93da.appspot.com');

  Future<String> insertImage(File image) async {
    String fileName = basename(image.path);
    // StorageReference storageReference = await FirebaseStorage()
    // .getReferenceFromUrl(
    //     "gs://digi-card-c93da.appspot.com/images/$fileName");

    // storageReference.delete();
    String storageUrl;

    StorageReference imgref = storage.ref().child("image/$fileName");

    uploadTask = imgref.putFile(image);

    var snapshot = await uploadTask.onComplete;

    if (snapshot.bytesTransferred == snapshot.totalByteCount) {
      storageUrl = await imgref.getDownloadURL();
      print(storageUrl);
      return storageUrl;
    }
    return null;
  }
}
