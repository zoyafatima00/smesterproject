import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/Feed/FeedHelpers.dart';

import '../../constants/Constantcolors.dart';

class Feed extends StatelessWidget {
   Feed({super.key});
  final ConstantColors constantColors = ConstantColors();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: Provider.of<Feedhelpers>(context,listen: false).appBar(context),
      drawer: Drawer(),
      body: Provider.of<Feedhelpers>(context,listen: false).feedBody(context),

    );
  }
}
