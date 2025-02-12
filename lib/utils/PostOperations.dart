import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/AltProfile/alt_profile.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../services/Authentications.dart';

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  String imageTimePosted = '';
  String get getImageTimePosted => imageTimePosted;
  TextEditingController updatedCaptionController = TextEditingController();
  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
                border: Border.all(color: Colors.yellowAccent.withOpacity(0.3),width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 125.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(

                          color: constantColors.blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                18.0), // Set border radius here
                          ),
                          child: Text(
                            'Edit Caption',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: constantColors.darkColor,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.20,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          decoration: BoxDecoration(
                                              color: constantColors
                                                  .blueGreyColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12.0),
                                                      topRight: Radius.circular(
                                                          12.0))),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 150.0),
                                                  child: Divider(
                                                    thickness: 4.0,
                                                    color: constantColors
                                                        .whiteColor,
                                                  ),
                                                ),
                                                Container(
                                                  width: 140.0,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: constantColors
                                                              .whiteColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  child: Center(
                                                    child: Text(
                                                      'Edit Caption',
                                                      style: TextStyle(
                                                          color: constantColors
                                                              .blueColor,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                ),
                                                Container(
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          width: 300,
                                                          height: 50,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  ' Add New Caption',
                                                              hintStyle: TextStyle(
                                                                  color: constantColors
                                                                      .whiteColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0),
                                                            ),
                                                            style: TextStyle(
                                                                color: constantColors
                                                                    .whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0),
                                                            controller:
                                                                updatedCaptionController,
                                                          ),
                                                        ),
                                                        FloatingActionButton(
                                                            backgroundColor:
                                                                constantColors
                                                                    .redColor,
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .upload,
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                            ),
                                                            onPressed: () {
                                                              Provider.of<FirebaseOperations>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .updateCaption(
                                                                      postId, {
                                                                'updatedcaption':
                                                                    updatedCaptionController
                                                                        .text,
                                                              });
                                                              updatedCaptionController
                                                                  .clear();
                                                              Navigator.pop(
                                                                  context);
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ])));
                                }).whenComplete(() => {Navigator.pop(context)});
                          }),
                      MaterialButton(
                          color: constantColors.redColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                18.0), // Set border radius here
                          ),
                          child: Text(
                            'Delete Post',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: constantColors.darkColor,
                                    title: Text(
                                      'Delete This Post',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: [
                                      MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    constantColors.whiteColor,
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      MaterialButton(
                                          color: constantColors.redColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          child: Text(
                                            'yes',
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          onPressed: () {
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .deletePost(
                                                postId, 'posts')
                                                .whenComplete(() =>
                                                    {Navigator.pop(context)});
                                            notifyListeners();
                                          }),
                                    ],
                                  );
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

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).initUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage':
          Provider.of<FirebaseOperations>(context, listen: false).initUserImage,
      'useremail':
          Provider.of<FirebaseOperations>(context, listen: false).initUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).initUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage':
          Provider.of<FirebaseOperations>(context, listen: false).initUserImage,
      'useremail':
          Provider.of<FirebaseOperations>(context, listen: false).initUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
                  border: Border.all(color: Colors.yellowAccent.withOpacity(0.3),width: 1)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                    child: AltProfile(
                                                        userUid:
                                                            documentSnapshot[
                                                                'useruid']),
                                                    type: PageTransitionType
                                                        .bottomToTop));
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                constantColors.darkColor,
                                            radius: 15.0,
                                            backgroundImage: NetworkImage(
                                                documentSnapshot['userimage']),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                            child: Text(
                                          documentSnapshot['username'],
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        )),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.arrowUp,
                                                color: constantColors.blueColor,
                                                size: 12,
                                              ),
                                              onPressed: () {},
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.reply,
                                                color:
                                                    constantColors.yellowColor,
                                                size: 12,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: constantColors.blueColor,
                                            size: 12,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                          child: Text(
                                            documentSnapshot['comment'],
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.trashAlt,
                                            color: constantColors.redColor,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            // Assuming 'comments' is the collection name and each comment has a unique document ID
                                            // You need the ID of the comment to delete
                                            String commentId = documentSnapshot
                                                .id; // Get the comment ID

                                            FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(
                                                    docId) // The ID of the post to which the comment belongs
                                                .collection('comments')
                                                .doc(
                                                    commentId) // The ID of the comment to be deleted
                                                .delete()
                                                .then((_) {
                                              print(
                                                  "Comment successfully deleted!");
                                              // Optionally, refresh the comments list or perform other actions
                                            }).catchError((error) {
                                              print(
                                                  "Error removing comment: $error");
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList());
                        }
                      },
                    ),
                  ),
                  Container(
                      width: 400,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 300.0,
                            height: 20.0,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  hintText: 'Add Comment ...',
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              controller: commentController,
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FloatingActionButton(
                              backgroundColor: constantColors.greenColor,
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: constantColors.whiteColor,
                              ),
                              onPressed: () {
                                print('Adding Comment ...');
                                addComment(context, snapshot['caption'],
                                        commentController.text)
                                    .whenComplete(() {
                                  commentController.clear();
                                  notifyListeners();
                                });
                              })
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
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
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                          var documentData =
                              documentSnapshot.data() as Map<String, dynamic>;
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                            userUid:
                                                documentSnapshot['useruid']),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(documentSnapshot['userimage']),
                              ),
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            subtitle: Text(
                              documentSnapshot['useremail'],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                            trailing: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid ==
                                    documentSnapshot['useruid']
                                ? Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )
                                : MaterialButton(
                                    onPressed: () {
                                      Provider.of<FirebaseOperations>(context,
                                              listen: false)
                                          .followUser(
                                              documentSnapshot['useruid'],
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserUid,
                                              {
                                                'username': Provider.of<
                                                            FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .initUserName,
                                                'userimage': Provider.of<
                                                            FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .initUserImage,
                                                'useruid':
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid,
                                                'useremail': Provider.of<
                                                            FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .initUserEmail,
                                                'time': Timestamp.now()
                                              },
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserUid,
                                              documentSnapshot['useruid'],
                                              {
                                                'username':
                                                    documentData['username'],
                                                'userimage':
                                                    documentData['userimage'],
                                                'useremail':
                                                    documentData['useremail'],
                                                'useruid':
                                                    documentData['useruid'],
                                                'time': Timestamp.now()
                                              })
                                          .whenComplete(() => {
                                                followedNotification(context,
                                                    documentData['username'])
                                              });
                                    },
                                    color: constantColors.blueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                                  ),
                          );
                        }).toList());
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
                border: Border.all(color: Colors.yellowAccent.withOpacity(0.3),width: 1)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Followed $name',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ),
          );
        });
  }
}
