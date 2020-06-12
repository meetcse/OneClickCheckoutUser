import 'package:flutter/material.dart';

class AboutCreators extends StatefulWidget {
  @override
  _AboutCreatorsState createState() => _AboutCreatorsState();
}

class _AboutCreatorsState extends State<AboutCreators> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Creators"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,

              colors: <Color>[

                Color(0xff3185FC),
                Color(0xff),
             
              ],
              )
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Created By: One Click Team",
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            Text(
              "\nxyz@oneclick.com",
              style: TextStyle(
                fontSize: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}