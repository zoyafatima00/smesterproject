import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/firebase_options.dart';
import 'package:smesterproject/screens/Splashscreen/splashScreen.dart';
import 'package:smesterproject/screens/landingPage/landingHelpers.dart';
import 'package:smesterproject/services/Authentication.dart';

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
        ChangeNotifierProvider(create: (_)=>Authentication()),
        ChangeNotifierProvider(create: (_)=>LandingHelpers())
      ],
    );
  }
}

