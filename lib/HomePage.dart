import 'package:flutter/material.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/MyList.dart';
import 'Screens/Scan.dart';
import 'Screens/Cart.dart';
import 'PopUpOptions.dart';
import 'Settings/AboutCreators.dart';
import 'Settings/AppVersion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MyList/screens/note_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SigninPage");
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser
        ?.reload(); //if not reload then you will always get null into display of user page
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthentication();
    this.getUser();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  void choiceAction(String choice) {
    if (choice == PopUpOptions.aboutCreators) {
      print('About Creators');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AboutCreators();
      }));
    } else if (choice == PopUpOptions.appVersion) {
      print('App VErsion');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppVersion();
      }));
    } else if (choice == PopUpOptions.signOut) {
      print('Sign Out');
      signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "One Click Checkout",
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: <Color>[
              //7
              // Color(0xff0083B0),
              // Color(0xff0090C1),

              //6
              // Color(0xff73CC76),
              // Color(0xff89E28C),
              // Color(0xff7EE081),

              // //selected - 2
              Color(0xff3185FC),
              Color(0xff),

              //selected - 1
              // Color(0xff3958B1),
              // Color(0xff0E34A0),

              //5
              // Colors.lightBlue,
              // Colors.lightGreen,
              // Colors.white60,

              //4
              // Color(0xFFa17fe0),
              // // Color(0xFF5D26C1),
              // Color(0xFF59C173),

              //3
              // Color(0xff514A9D),
              // Color(0xff24CFFF),
              // Color(0xff514A9D),

              //1
              // Color(0xff5433FF),
              // Color(0xff20BDFF),
              // Color(0xff5D26C1),

              //2
              // Color(0xff5433FF),
              // Color(0xff20BFFF),
              // Color(0xff2C5364),
            ],
          )),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.white,
            onPressed: () {
              //TODO: TO GIVE FUNCTION
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Cart();
              }));
            },
          ),

          //TODO: TO GIVE FUNCTION
          PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return PopUpOptions.options.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text("HOME"),
            ),
            Tab(
              child: Text("SCAN"),
            ),
            Tab(
              child: Text("MY LIST"),
            ),
          ],
        ),
      ),
      body: Container(
        child: !isSignedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.redAccent,
                      strokeWidth: 7,
                    ),
                  ),
                ],
              )
            : TabBarView(
                controller: _tabController,
                children: <Widget>[
                  HomeScreen(),
                  Scan(),
                  // MyList(),
                  NoteList(),
                ],
              ),
      ),
    );
  }
}
