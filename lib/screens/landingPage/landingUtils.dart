import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/landingPage/landingServices.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';
class LandingUtils with ChangeNotifier{
  ConstantColors? constantColor;
  final picker = ImagePicker();
  File? userAvatar;
  File get getUserAvatar =>userAvatar!;
  String userAvatarUrl="";
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context,ImageSource source)async{
    final pickedUserAvatar = await picker.pickImage(source: source);
    // Early return if no image is picked or the image picking process failed/canceled
    if (pickedUserAvatar == null) {
      print('Select image');
      return; // Exit the method if no image is picked
    }

    // If we have a picked image, proceed with the rest of the logic
    userAvatar = File(pickedUserAvatar.path);
    print(userAvatar!.path);

    userAvatar !=null ? Provider.of<LandingService>(context,listen: false).showUserAvatar(context) : print('image upload error');
    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
    return showModalBottomSheet(context: context, builder:(context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColor?.blueGreyColor,
          borderRadius: BorderRadiusDirectional.circular(12.0),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 150.0),
              child: Divider(
                thickness: 4.0,
                color: Colors.white24,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    color: Colors.lightBlueAccent,
                  child: const Text('Gallery', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),),
                    onPressed: (){
                    pickUserAvatar(context, ImageSource.gallery).whenComplete((){
                      Navigator.pop(context);
                      Provider.of<LandingService>(context,listen: false).showUserAvatar(context);

                    });
                    }),
                MaterialButton(
                    color: Colors.lightBlueAccent,
                  child: const Text('Camera', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),),
                    onPressed: (){
                    pickUserAvatar(context, ImageSource.camera).whenComplete((){
                      Navigator.pop(context);
                      Provider.of<LandingService>(context,listen: false).showUserAvatar(context);

                    });
                    })

              ],
            )
          ],
        )
      );

    });
  }



}