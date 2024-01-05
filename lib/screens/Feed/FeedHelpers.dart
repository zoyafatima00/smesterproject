import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/utils/UploadPost.dart';

import '../../constants/Constantcolors.dart';
import '../Profile/profileHelpers.dart';

class Feedhelpers with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false).selectPostImageType(
              context,
            );
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constantColors.greenColor,
          ),
        )
      ],
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      title: RichText(
        text: TextSpan(
            text: 'Social ',
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'Feed',
                style: TextStyle(
                    color: constantColors.lightBlueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0)), // BoxDecoration
        ), // Container
      ),
    ) // Padding
        ); // SingleChildScrollView
  }
}
