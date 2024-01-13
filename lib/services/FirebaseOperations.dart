import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/landingPage/landingUtils.dart';
import 'package:smesterproject/services/Authentications.dart';

class FirebaseOperations with ChangeNotifier {
  late UploadTask imageUploadTask;
  late String initUserEmail;
  late String initUserName;
  String initUserImage = '';
  //for sending  stickers to storage
  int count = 0;

  Future uploadUserAvatar(BuildContext context) async {
    // Get the file from the provider
    File userAvatarFile =
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar;

    // Create a unique file name for the upload
    String fileName =
        'userProfileAvatar_${DateTime.now().millisecondsSinceEpoch}';

    // Reference to Firebase Storage
    Reference imageReference = FirebaseStorage.instance.ref().child(fileName);

    try {
      // Start the upload task
      imageUploadTask = imageReference.putFile(userAvatarFile);
      await imageUploadTask.whenComplete(() => print('Image Uploaded'));

      // Get the download URL
      String url = await imageReference.getDownloadURL();
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl = url;
      print('The user profile avatar URL => $url');
      notifyListeners();
    } catch (e) {
      print('Upload error: $e');
      // Handle the error appropriately
    }
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  //use in profile screen
  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching User Data');
      initUserName = doc.data()?['username'];
      initUserEmail = doc.data()?['useremail'];
      initUserImage = doc.data()?['userimage'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  //to handle/share post

  Future uploadPostData(String postId, dynamic data) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(data);
      print('Post added to Firebase FireStore');
    } catch (e) {
      // Handle the error here
      print('Error: $e');
      // You can also rethrow the error or handle it in any other way you prefer
    }
  }

  Future deleteUserDataTwo(String userUid, dynamic collection) async {
    try {
      return FirebaseFirestore.instance
          .collection(collection)
          .doc(userUid)
          .delete();
    } catch (e) {
      print('Error : $e');
    }
  }

  Future updateCaption(String postId, dynamic data) async {
    try {
      return FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update(data);
    } catch (e) {
      print('Error : $e');
    }
  }

  Future deleteUserData(String userUid) async {
    return FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }

  void addImages() {
    var storage = FirebaseStorage.instance;
    List<String> listOfImage = [
      'assets/avatars/chatbot-avatar.jpg',
      'assets/avatars/gif-tenor-image.jpg',
      'assets/avatars/handsome-little-brother.jpg',
      'assets/avatars/live-chat-icon-0.png',
      'assets/avatars/smiling-girl.jpg',
    ];
    listOfImage.forEach((img) async {
      String imageName = img
          .substring(img.lastIndexOf("/"), img.lastIndexOf("."))
          .replaceAll("/", "");

      String path = img.substring(img.indexOf("/") + 1, img.lastIndexOf("/"));

      final Directory systemTempDir = Directory.systemTemp;
      final byteData = await rootBundle.load(img);
      final file = File('${systemTempDir.path}/$imageName.jpeg');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      TaskSnapshot taskSnapshot =
      await storage.ref('$path/$imageName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('chatroomIcons')
          .add({"url": downloadUrl, "avatars": imageName});
      count++;
      print(count);
    });
    print('finished.............');
  }

  Future submitChatroomData(String chatroomName, dynamic chatroomData) async{
    return FirebaseFirestore.instance.collection('chatrooms').doc(
      chatroomName
    ).set(chatroomData);
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }
}
