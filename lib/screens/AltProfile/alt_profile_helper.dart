import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/Homepage/Homepage.dart';
import 'package:smesterproject/services/Authentications.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';

import '../../utils/PostOperations.dart';
import 'alt_profile.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  int noOfPosts =0 ;
  Widget appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: constantColors.whiteColor,
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const Homepage(), type: PageTransitionType.bottomToTop));
        },
      ),
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.9),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Homepage(), type: PageTransitionType.bottomToTop));
          },
        ),
      ],
      title: RichText(
        text: TextSpan(
            text: 'The',
            style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                  text: ' Social',
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0))
            ]),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: SizedBox(
                    //height: 180.0,
                    width: 185.0,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: constantColors.transparent,
                            radius: 60.0,
                            backgroundImage:
                                NetworkImage(snapshot.data!['userimage']),
                          ),
                          onTap: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            snapshot.data!['username'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(EvaIcons.email,
                                  color: constantColors.greenColor, size: 12.0),
                              const SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                snapshot.data!['useremail'],
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
                                Container(
                                  height: 70.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                      color: constantColors.darkColor,
                                      borderRadius: BorderRadius.circular(15.0)),
                                  child: Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('users').doc(
                                              snapshot.data!['useruid']
                                          ).collection('followers').snapshots(),
                                          builder: (context,snapshot){
                                            if(snapshot.connectionState == ConnectionState.waiting){
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            else{
                                              return Text(snapshot.data!.docs.length.toString(),
                                                style: TextStyle(
                                                    color: constantColors.whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28.0
                                                ),
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
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Container(
                                  height: 70.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                      color: constantColors.darkColor,
                                      borderRadius: BorderRadius.circular(15.0)),
                                  child: Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('users').doc(
                                            snapshot.data!['useruid']
                                          ).collection('following').snapshots(),
                                          builder: (context,snapshot){
                                            if(snapshot.connectionState == ConnectionState.waiting){
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            else{
                                              return Text(snapshot.data!.docs.length.toString(),
                                                style: TextStyle(
                                                  color: constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28.0
                                                ),
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
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: constantColors.blueColor,
                        child: Text(
                          'Follow',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        onPressed: () {
                          Provider.of<FirebaseOperations>(context, listen: false)
                              .followUser(
                                  userUid,
                                  Provider.of<Authentication>(context, listen: false)
                                      .getUserUid,
                                  {
                                    'username': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .initUserName,
                                    'userimage': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .initUserImage,
                                    'useruid': Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid,
                                    'useremail': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .initUserEmail,
                                    'time': Timestamp.now()
                                  },
                                  Provider.of<Authentication>(context, listen: false)
                                      .getUserUid,
                                  userUid,
                                  {
                                    'username': snapshot.data!['username'],
                                    'userimage': snapshot.data!['userimage'],
                                    'useremail': snapshot.data!['useremail'],
                                    'useruid': snapshot.data!['useruid'],
                                    'time': Timestamp.now()
                                  }).whenComplete(() => {
                                    followedNotification(context,
                                        snapshot.data!['username']
                                        )
                                  });
                        }
                        ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 5.0,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
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
                color : Colors.blueGrey,
                //color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
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
                                  padding: const EdgeInsets.only(left: 8.0),
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


  followedNotification(BuildContext context,String name){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
            border: Border.all(color: Colors.yellowAccent.withOpacity(0.3),width: 1)
        ),
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
              Text('Followed $name',style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),)
            ],
          ),
        ),
      );
    });
  }

  showPostDetails(BuildContext context,DocumentSnapshot documentSnapshot){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12.0)),
            border: Border.all(color: Colors.yellowAccent.withOpacity(0.3),width: 1)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(documentSnapshot['postimage']),
                ),
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
