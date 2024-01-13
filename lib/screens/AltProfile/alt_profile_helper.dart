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

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
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
                  child: Homepage(), type: PageTransitionType.bottomToTop));
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.364,
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  height: 180.0,
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
                            SizedBox(
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
            ),
            Flexible(
              child: Container(
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
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        else{
                                          return new Text(snapshot.data!.docs.length.toString(),
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
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        else{
                                          return new Text(snapshot.data!.docs.length.toString(),
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
                                '0',
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
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width,
          color: constantColors.redColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
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
                  }),
              MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    'Message',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  onPressed: () {}),
            ],
          ),
        )
      ]),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 5.0,
        width: 350.0,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapShot) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
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
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapShot) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        child: Image.asset('assets/images/empty-removebg-preview.png'),
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
  followedNotification(BuildContext context,String name){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
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
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: BorderRadius.circular(12.0)
        ),
      );
    });
  }
}
