import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/ChatRoom/ChatRoom.dart';
import 'package:smesterproject/screens/Feed/Feed.dart';
import 'package:smesterproject/screens/Homepage/HomePageHelpers.dart';
import 'package:smesterproject/screens/Profile/Profile.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';
class Homepage extends StatefulWidget {
   const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homePageController = PageController();
  int pageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseOperations>(context,listen: false).initUserData(context);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homePageController,
        children: [
          Feed(), ChatRoom(), Profile(),],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page){
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomePageHelpers>(context,listen: false).bottomNavBar(pageIndex, homePageController,context),


    );
  }
}
