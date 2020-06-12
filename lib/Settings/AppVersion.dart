import 'package:flutter/material.dart';

class AppVersion extends StatefulWidget {
  @override
   _AppVersionState createState() => _AppVersionState();
}
class _AppVersionState extends State<AppVersion> {
   @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Version"),
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
        child: Text(
          "v1.0.0\nYour App is Updated!",
          style: TextStyle(
            fontSize: 28,
            
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  } 
}