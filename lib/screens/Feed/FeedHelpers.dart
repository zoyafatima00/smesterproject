import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/AltProfile/alt_profile.dart';
import 'package:smesterproject/services/Authentications.dart';
import 'package:smesterproject/utils/PostOperations.dart';
import 'package:smesterproject/utils/UploadPost.dart';
import '../../constants/Constantcolors.dart';
import '../Profile/profileHelpers.dart';

class Feedhelpers with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      leading: Text(''),
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0)), // BoxDecoration
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 500.0,
                  width: 400.0,
                ),
              );
            } else {
              return loadPost(context, snapshot);
            }
          },
        ), // Container
      ),
    ) // Padding
        ); // SingleChildScrollView
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0 , bottom: 5.0),
      child: ListView(
        shrinkWrap: true,
        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Provider.of<PostFunctions>(context, listen: false)
              .showTimeAgo(documentSnapshot['time']);
          var userData = documentSnapshot.data()
              as Map<String, dynamic>?; // Cast with null safety
          String userImageUrl =
              userData?['userimage'] ?? 'empty-removebg-preview.png';
          String caption = userData?['caption'] ?? 'No caption';
          String username = userData?['username'] ?? 'Anonymous';
          String userUid = userData?['useruid'] ?? 'Anonymous';

          String postImageUrl =
              userData?['postimage'] ?? 'empty-removebg-preview.png';
          print("User-UID in FeedHelpers: $userUid");

          // String postImageUrl =
          //     userData?['postimage'] ?? 'empty-removebg-preview.png';

          return Container(
            height: MediaQuery.of(context).size.height * 0.86,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only( left: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (documentSnapshot['useruid'] !=
                              Provider.of<Authentication>(context, listen: false)
                                  .getUserUid) {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userUid: documentSnapshot['useruid'],
                                    ),
                                    type: PageTransitionType.bottomToTop));
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: constantColors.blueGreyColor,
                          radius: 20.0,
                          backgroundImage: NetworkImage(userImageUrl),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                caption,
                                style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: username,
                                  style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          ' , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}', // Example time text
                                      style: TextStyle(
                                          color: constantColors.lightColor
                                              .withOpacity(0.8)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.46,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Image.network(postImageUrl, scale: 2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: SizedBox(
                              height: 80.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .showLikes(context,
                                              documentSnapshot['caption']);
                                    },
                                    onTap: () {
                                      print('Adding like...');
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .addLike(
                                              context,
                                              documentSnapshot['caption'],
                                              Provider.of<Authentication>(context,
                                                      listen: false)
                                                  .getUserUid);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.heart,
                                      color: constantColors.redColor,
                                      size: 22.0,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(documentSnapshot['caption'])
                                          .collection('likes')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              snapshot.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Container(
                              height: 80.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<PostFunctions>(context,
                                              listen: false)
                                          .showCommentsSheet(
                                              context,
                                              documentSnapshot,
                                              documentSnapshot['caption']);
                                    },
                                    child: Icon(
                                      Icons.comment_rounded,
                                      color: constantColors.blueColor,
                                      size: 22.0,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(documentSnapshot['caption'])
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              snapshot.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: SizedBox(
                              height: 80.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //Provider.of<PostFunctions>(context,listen: false).showRewards(context);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.award,
                                      color: constantColors.yellowColor,
                                      size: 22.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              userUid
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context, listen: false)
                                    .showPostOptions(
                                        context, documentSnapshot['caption']);
                              },
                              icon: Icon(
                                EvaIcons.moreVertical,
                                color: constantColors.whiteColor,
                              ))
                          : const SizedBox(
                             // color: Colors.red,
                              height: 0.0,
                              width: 0.0,
                            )
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
