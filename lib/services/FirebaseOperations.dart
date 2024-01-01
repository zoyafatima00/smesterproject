
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/landingPage/landingUtils.dart';
class FirebaseOperations with ChangeNotifier{

  late UploadTask imageUploadTask;

  Future uploadUserAvatar(BuildContext context)async{

    Reference imageReference = FirebaseStorage.instance.ref().child(
      'userProfileAvatar/${Provider.of<LandingUtils>(context,listen: false).getUserAvatar.path}/${TimeOfDay.now()}'
      imageUploadTask = imageReference.putFile(Provider.of<LandingUtils>(context,listen: false).getUserAvatar);
      await imageUploadTask.whenComplete(){

    }
    );
  }
}