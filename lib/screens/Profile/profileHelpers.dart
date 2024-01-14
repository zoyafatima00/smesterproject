import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';

import '../../services/Authentications.dart';
import '../../utils/PostOperations.dart';
import '../AltProfile/alt_profile.dart';
import '../landingPage/landingPage.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  int noOfPosts = 0;
  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                //height: 220.0,
                width: 185.0,
                child: Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: constantColors.transparent,
                        radius: 60.0,
                        backgroundImage:
                            NetworkImage(snapshot.data.data()['userimage']),
                      ),
                      onTap: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data.data()['username'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0,left: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(EvaIcons.email,
                              color: constantColors.greenColor, size: 12.0),
                          const SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            snapshot.data.data()['useremail'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: SizedBox(
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap:() {
                              showFollowersSheet(context, snapshot);

                            },
                            child: Container(
                              height: 70.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(snapshot.data!['useruid'])
                                          .collection('followers')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data!.docs.length.toString(),
                                            style: TextStyle(
                                                color: constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28.0),
                                          );
                                        }
                                      }),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              showFollowingsSheet(context, snapshot);
                            },
                            child: Container(
                              height: 70.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  color: constantColors.darkColor,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(snapshot.data!['useruid'])
                                          .collection('following')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data!.docs.length.toString(),
                                            style: TextStyle(
                                                color: constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28.0),
                                          );
                                        }
                                      }),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        height: 70.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: constantColors.darkColor,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(
                          children: [
                            Text(
                              '$noOfPosts',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 10.0),
          child: Divider(
            color: constantColors.whiteColor,
          ),
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapShot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.userAstronaut,
                      color: constantColors.yellowColor,
                      size: 16.0,
                    ),
                    Text(
                      'Recently Added',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: constantColors.whiteColor),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.095,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: constantColors.yellowColor.withOpacity(0.6))
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(snapShot.data!['useruid'])
                          .collection('following')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 3.0),
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor: constantColors.darkColor,
                                      backgroundImage: NetworkImage(documentSnapshot['userimage']),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                                userUid:
                                                documentSnapshot['useruid']),
                                            type: PageTransitionType.bottomToTop));

                              }
    );}
                            }).toList(),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapShot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.39,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc((snapShot.data as DocumentSnapshot).get('useruid'))
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data == null || !snapshot.hasData) {
              return const Center(child: Text('No Data Available'));
            } else {
              noOfPosts = snapshot.data!.docs.length;
              notifyListeners();
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3
                ),
                children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                  var data = documentSnapshot.data() as Map<String, dynamic>?;
                  if (data == null) {
                    return const Center(child: Text('Document is null'));
                  }
                  if (!data.containsKey('postimage')) {
                    return const Center(child: Text('No Image Available'));
                  }
                  return GestureDetector(
                    onTap: (){
                  showPostDetails(context, documentSnapshot);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          child: Image.network(
                              data['postimage']
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

              );
            }
          },
        ),
      ),
    );
  }


  logOutDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Log Out?',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutViaEmail()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: Landingpage(),
                              type: PageTransitionType.bottomToTop));
                    });
                  })
            ],
          );
        });
  }

  showFollowingsSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
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
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Following',
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
                        .collection('users')
                        .doc(snapshot.data!['useruid'])
                        .collection('following')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
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
                                    NetworkImage(documentSnapshot!['userimage']),
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
                                trailing: MaterialButton(
                                  onPressed: () {},
                                  color: constantColors.blueColor,
                                  child: Text(
                                    'Unfollow',
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


  showFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
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
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'followers',
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
                        .collection('users')
                        .doc(snapshot.data!['useruid'])
                        .collection('followers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    if(Provider.of<Authentication>(context,
                                        listen: false)
                                        .getUserUid !=
                                        documentSnapshot['useruid']
                                    ){
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: AltProfile(
                                                  userUid:
                                                  documentSnapshot['useruid']),
                                              type: PageTransitionType.bottomToTop));

                                    }
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
                                    ? const SizedBox(
                                  width: 0.0,
                                  height: 0.0,
                                )
                                    : MaterialButton(
                                  onPressed: () {},
                                  color: constantColors.blueColor,
                                  child: Text(
                                    'Unfollow',
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

  showPostDetails(BuildContext context,DocumentSnapshot documentSnapshot){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12.0)
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                child: Image.network(documentSnapshot['postimage']),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(documentSnapshot['caption'],style:TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),),
            ),
            Container(
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
                      documentSnapshot['useruid']
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
            )

          ],
        ),
      );
    });

  }







}
