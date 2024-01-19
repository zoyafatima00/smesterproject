import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/services/Authentications.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';

import '../screens/landingPage/landingServices.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController captionController = TextEditingController();
  late File? uploadPostImage;
  File get getUploadPostImage => uploadPostImage!;
  late String uploadPostUrl;
  String get getUploadPostUrl => uploadPostUrl;
  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    // Early return if no image is picked or the image picking process failed/canceled
    if (uploadPostImageVal == null) {
      print('Select image');
      return; // Exit the method if no image is picked
    }

    // If we have a picked image, proceed with the rest of the logic
    uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImageVal!.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('image upload error');
    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage?.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage!);
    await imagePostUploadTask.whenComplete(() {
      print('Post image uploaded to storage');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostUrl = imageUrl;
      print(uploadPostUrl);
    });
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.gallery);
                      }),
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                      })
                ],
              )
            ]),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.43,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Container(
                  height: 200.0,
                  width: 400.0,
                  child: Image.file(uploadPostImage!, fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        child: Text(
                          'Reselect',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: constantColors.whiteColor),
                        ),
                        onPressed: () {
                          selectPostImageType(context);
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Confirm Image',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          uploadPostImageToFirebase().whenComplete(() {
                            editPostSheet(context);
                            print('Image/Post Uploaded');
                          });
                        })
                  ],
                ),
              )
            ]),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                  child: Row(
                children: [
                  Container(
                    child: Column(children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.image_aspect_ratio,
                            color: constantColors.greenColor,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.fit_screen,
                            color: constantColors.yellowColor,
                          )),
                    ]),
                  ),
                  Container(
                    height: 200.0,
                    width: 300.0,
                    child: Image.file(
                      uploadPostImage!,
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              )),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset(
                            'assets/icons/sunflower-removebg-preview.png'),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: constantColors.blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 120.0,
                          width: 300.0,
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLength: 100,
                            controller: captionController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Add Caption...',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
              MaterialButton(
                onPressed: () async {
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .uploadPostData(captionController.text, {
                        'postimage' : getUploadPostUrl,
                    'caption': captionController.text,
                    'updatedcaption':captionController.text,
                    'username': Provider.of<FirebaseOperations>(context,listen: false).initUserName,
                    'userimage': Provider.of<FirebaseOperations>(context,listen: false).initUserImage,
                    'useruid': Provider.of<Authentication>(context,listen: false).getUserUid,
                    'time': Timestamp.now(),
                    'useremail': Provider.of<FirebaseOperations>(context,listen: false).initUserEmail,
                  }).whenComplete(() async{
                    //Add data under user profile
                    await FirebaseFirestore.instance.collection('users').doc(
                      Provider.of<Authentication>(context, listen: false).getUserUid
                    ).collection('posts').add({
                      'postimage' : getUploadPostUrl,
                      'updated caption' :captionController.text,
                      'caption': captionController.text,
                      'username': Provider.of<FirebaseOperations>(context,listen: false).initUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,listen: false).initUserImage,
                      'useruid': Provider.of<Authentication>(context,listen: false).getUserUid,
                      'time': Timestamp.now(),
                      'useremail': Provider.of<FirebaseOperations>(context,listen: false).initUserEmail,
                    });
                  }).whenComplete(() {
                    captionController.clear();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);

                  });
                },
                color: constantColors.blueColor,
                child: Text(
                  'Share',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              )
            ]),
          );
        });
  }

}
