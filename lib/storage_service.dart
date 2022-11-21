import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _ref = FirebaseDatabase.instance.ref('messages');

  Future<void> uploadFile(String filePath, String fileName, String sender, String recipient) async {
    File file = File(filePath);

    try {
      await storage.ref('image/$fileName').putFile(file);
      downloadUrl(fileName, sender, recipient);
    } on FirebaseException catch(e) {
      print(e);
    }
  }

  Future<String> downloadUrl(String imageName, String sender, String recipient) async {
    String downloadUrl = await storage.ref('image/$imageName').getDownloadURL();
    print(downloadUrl);

    _ref.push().set({
      'sender': sender,
      'recipient': recipient,
      'message': "",
      'image': downloadUrl
    }).asStream();

    return downloadUrl;
  }
}