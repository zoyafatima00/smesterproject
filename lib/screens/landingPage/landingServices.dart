import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/Homepage/Homepage.dart';
import 'package:smesterproject/screens/landingPage/landingUtils.dart';
import 'package:smesterproject/services/Authentications.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';

class LandingService with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
                border: Border.all(color: Colors.yellowAccent.withOpacity(0.3),width: 1)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundColor: constantColors.transparent,
                    backgroundImage: Provider.of<LandingUtils>(context, listen: false).userAvatar != null
                        ? FileImage(
                        Provider.of<LandingUtils>(context, listen: false).userAvatar!)
                        : null, // Provide a default asset or network image if userAvatar is null
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:12.0),
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
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
                          }),
                      MaterialButton(
                        color: constantColors.blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text(
                            'Confirm Image',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                ),
                          ),
                          onPressed: () {
                          Provider.of<FirebaseOperations>(context, listen: false).uploadUserAvatar(context).whenComplete((){
                            signInSheet(context);
                          });

                          })
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found.'),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                var data = documentSnapshot.data() as Map<String, dynamic>? ?? {};
                String userImage = data['userimage'] as String? ?? '/assets/images/3760.jpg';
                String userEmail = data['useremail'] as String? ?? 'No Email';
                String userName = data['username'] as String? ?? 'No Username';
                String userPassword = data['userpassword'] as String? ?? 'No UserPassword';
                String userUid = data['userid'] as String? ?? 'No UserId';
                print("User-UID in landingService: $userUid");
                print("User-psswrd: $userPassword");

                return ListTile(
                  trailing: Container(
                    width: 100.0,
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: (){
                          Provider.of<Authentication>(context,listen: false).logIntoAccount(
                              userEmail, userPassword).whenComplete(() {
                                Navigator.pushReplacement(context, PageTransition(child: Homepage(), type: PageTransitionType.leftToRight));
                          });
                        }, icon: Icon(FontAwesomeIcons.check,color: constantColors.blueColor,)),
                        IconButton(onPressed: (){
                          Provider.of<FirebaseOperations>(context,listen:false).deleteUserDataTwo(documentSnapshot['useruid'],'users');
                          //Provider.of<FirebaseOperations>(context,listen: false).deleteUserData(userUid);
                        }, icon: Icon(FontAwesomeIcons.trashAlt,color: constantColors.redColor,))

                      ],
                    ),

                  // trailing: IconButton(
                  //   icon: const Icon(FontAwesomeIcons.trash),
                  //   color: constantColors.redColor,
                  //   onPressed: () {
                  //     Provider.of<FirebaseOperations>(context,listen:false).deleteUserData(documentSnapshot['useruid'],'users');
                  //   },

                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                  ),
                  subtitle: Text(
                    userEmail,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.whiteColor,
                      fontSize: 12.0,
                    ),
                  ),
                  title: Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.greenColor,
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),

    );
  }


  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                          hintText: 'Enter email....',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: (TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Enter password....',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: (TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () async {
                          if (userEmailController.text.isNotEmpty) {
                            try {
                              await Provider.of<Authentication>(context, listen: false)
                                  .logIntoAccount(userEmailController.text, userPasswordController.text);
                              Navigator.pushReplacement(context, PageTransition(child: Homepage(), type: PageTransitionType.bottomToTop));
                              userEmailController.text = '';
                              userPasswordController.text='';
                              notifyListeners();
                            } on FirebaseAuthException catch (e) {
                              // Handle different auth errors here
                              warningText(context, e.message ?? 'An error occurred');
                            }

                          } else {
                            warningText(context, 'Fill all the data');
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future signInSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context,listen: false).getUserAvatar
                    ),
                    backgroundColor: constantColors.redColor,
                    radius: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                          hintText: 'Enter name....',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: (TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                          hintText: 'Enter email....',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: (TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Enter password....',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: (TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () async {
                        if (userEmailController.text.isNotEmpty) {
                          bool emailExists = await Provider.of<FirebaseOperations>(context, listen: false)
                              .isEmailRegistered(userEmailController.text);

                          if (emailExists) {
                            // Email already exists, show alert dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.lightGreen.withOpacity(0.4), width: 1),),
                                  backgroundColor: constantColors.transparent,
                                  icon: Icon(Icons.error,color: constantColors.redColor,),

                                  title: Text("Email Already Registered",style: TextStyle(color: constantColors.redColor,fontWeight:FontWeight.bold ),),
                                  content: Text("The email you have entered is already associated with another account.",style: TextStyle(color: constantColors.greenColor.withOpacity(0.6))),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text("OK",style: TextStyle(color: constantColors.whiteColor.withOpacity(0.7),fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.lightGreen.withOpacity(0.7), // Background color
                                        onPrimary: constantColors.greenColor, // Text and icon color (if the button is enabled)
                                        onSurface: Colors.white70, // Text and icon color (if the button is disabled)
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Email does not exist, proceed with account creation
                            await Provider.of<Authentication>(context, listen: false)
                                .createAccount(
                                userEmailController.text, userPasswordController.text)
                                .whenComplete(() async {
                              // Create User Collection
                              await Provider.of<FirebaseOperations>(context, listen: false)
                                  .createUserCollection(context, {
                                'userpassword': userPasswordController.text,
                                'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                                'useremail': userEmailController.text,
                                'username': userNameController.text,
                                'userimage': Provider.of<LandingUtils>(context, listen: false).getUserAvatarUrl,
                              }).whenComplete(() {
                                userPasswordController.clear();
                                userEmailController.clear();
                                userNameController.clear();
                              });

                              // Navigate to Homepage
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: Homepage(),
                                      type: PageTransitionType.bottomToTop));
                            });
                          }
                        } else {
                          warningText(context, 'Fill all the data');
                        }
                      },
                    ),

                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.7),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
                border: Border.all(color: Colors.yellowAccent.withOpacity(0.3),width: 1)
            ),
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }
}
