import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class LandingUtils with ChangeNotifier{
  final picker = ImagePicker();
  late File userAvatar;
  File get getUserAvatar =>userAvatar;
  String userAvatarUrl="";
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context,ImageSource source)async{
    final pickedUserAvatar = await picker.pickImage(source: source);
    if (pickedUserAvatar == null) {
      print('Select image');
    } else {
      userAvatar = File(pickedUserAvatar.path as String);
      print(userAvatar.path);
      //userAvatar !=null ?
    }

  }



}