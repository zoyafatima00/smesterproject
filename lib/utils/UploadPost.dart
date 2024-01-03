import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smesterproject/constants/Constantcolors.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  // late File uploadPostImage;
  // File get getUploadPostImage => uploadPostImage;
  // late String  uploadPostUrl;
  // String get getUploadPostUrl => uploadPostUrl;
  // final picker= ImagePicker();

  // Future pickUploadPostImage(BuildContext context,ImageSource source)async{
  //   final uploadPostImageVal = await picker.pickImage(source: source);
  //   // Early return if no image is picked or the image picking process failed/canceled
  //   if (uploadPostImageVal == null) {
  //     print('Select image');
  //     return; // Exit the method if no image is picked
  //   }
  //
  //   // If we have a picked image, proceed with the rest of the logic
  //   uploadPostImage = File(uploadPostImageVal.path);
  //   print(uploadPostImageVal!.path);
  //
  //   uploadPostImage !=null ? Provider.of<LandingService>(context,listen: false).showUserAvatar(context) : print('image upload error');
  //   notifyListeners();
  // }



  selectPostImage(BuildContext context) {
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
                    child: Text('Gallery',style: TextStyle(
                        color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16.0
                    ),),
                    onPressed: (){}),
                MaterialButton(
                  color: constantColors.blueColor,
                    child: Text('Camera',style: TextStyle(
                        color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16.0
                    ),),
                    onPressed: (){})
              ],)

            ]),
          );
        });
  }
}
