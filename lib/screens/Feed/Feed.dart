import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/Feed/FeedHelpers.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<Feedhelpers>(context,listen: false).appBar(context),
      drawer: Drawer(),
      body: Provider.of<Feedhelpers>(context,listen: false).feedBody(context),

    );
  }
}
