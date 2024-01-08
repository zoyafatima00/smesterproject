import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/firebase_options.dart';
import 'package:smesterproject/screens/AltProfile/alt_profile_helper.dart';
import 'package:smesterproject/screens/Feed/FeedHelpers.dart';
import 'package:smesterproject/screens/Homepage/HomePageHelpers.dart';
import 'package:smesterproject/screens/Profile/profileHelpers.dart';
import 'package:smesterproject/screens/Splashscreen/splashScreen.dart';
import 'package:smesterproject/screens/landingPage/landingHelpers.dart';
import 'package:smesterproject/screens/landingPage/landingServices.dart';
import 'package:smesterproject/screens/landingPage/landingUtils.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';
import 'package:smesterproject/utils/PostOperations.dart';
import 'package:smesterproject/utils/UploadPost.dart';

import 'services/Authentications.dart';
//import 'package:smesterproject/services/Authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    ConstantColors constantColors=ConstantColors();
    return MultiProvider(
       child: MaterialApp(
          home: Splashscreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: constantColors.blueColor),
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent
          ),
        ),
      providers: [
        ChangeNotifierProvider(create: (_)=> AltProfileHelper()),
        ChangeNotifierProvider(create: (_)=> PostFunctions()),
        ChangeNotifierProvider(create: (_)=> Feedhelpers()),
        ChangeNotifierProvider(create: (_)=> UploadPost()),
        ChangeNotifierProvider(create: (_)=> ProfileHelpers()),
        ChangeNotifierProvider(create: (_)=> HomePageHelpers()),
        ChangeNotifierProvider(create: (_)=> LandingUtils()),
        ChangeNotifierProvider(create: (_)=> FirebaseOperations()),
        ChangeNotifierProvider(create: (_)=> Authentication()),
        ChangeNotifierProvider(create: (_)=> LandingHelpers()),
        ChangeNotifierProvider(create: (_)=> LandingService())

      ],
    );
  }
}

