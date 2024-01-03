import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/Profile/profileHelpers.dart';
import 'package:smesterproject/screens/landingPage/landingPage.dart';
import 'package:smesterproject/services/Authentications.dart';

import '../../constants/Constantcolors.dart';

class Profile extends StatelessWidget {
   Profile({super.key});
  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    // Retrieve the user UID and print it for debugging
    String userUid = Provider.of<Authentication>(context, listen: false).getUserUid;
    print("User UID: $userUid");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(EvaIcons.settings,color: constantColors.lightBlueColor,), onPressed: () {  },
        ),
        actions: [
          IconButton(onPressed: (){
            Provider.of<ProfileHelpers>(context,listen: false).logOutDialogue(context,);
          }, icon: Icon(EvaIcons.logInOutline,color: constantColors.greenColor,),

            )
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: 'My ',
            style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Profile',
                style: TextStyle(color: constantColors.lightBlueColor,fontSize: 20,fontWeight: FontWeight.bold),)
            ]
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: constantColors.blueGreyColor.withOpacity(0.6)
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: Provider.of<Authentication>(context, listen: false).getUserUid.isNotEmpty
                  ? FirebaseFirestore.instance.collection('users').doc(
                  Provider.of<Authentication>(context, listen: false).getUserUid).snapshots()
                  : null, // Handle null or empty UID
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("No data available"));
                } else {
                  return new Column(
                    children: [
                      Provider.of<ProfileHelpers>(context,listen: false).headerProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context,listen: false).divider(),
                      Provider.of<ProfileHelpers>(context,listen: false).middleProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context,listen: false).footerProfile(context, snapshot),


                    ],
                  );
                  // Your existing code
                }
              },
            ),

          ),
        ),
      ),

    );
  }
}
