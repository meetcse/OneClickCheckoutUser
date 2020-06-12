import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                ),
                Image(
                  image: AssetImage("images/weekend.jpg"),
                  height: 150,
                  width: 150,
                ),
                Expanded(
                    child: Row(children: <Widget>[
                  Text(
                      "\n  Mega Weekend Sale!\n\n"
                      "  Get upto 80% off on:\n"
                      "  Crockery\n"
                      "  Novels\n"
                      "  Grocery\n"
                      "  Back-To-School Items",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ])),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                ),
                Image(
                  image: AssetImage("images/aashirwad.jpg"),
                  height: 150,
                  width: 150,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\n  Limited period offers:\n\n"
                        "  -Atta-Rs.320/10kg\n"
                        "  -Basmati Rice-Rs.120/kg\n"
                        "  -Olive Oil-Rs.250/200ml\n"
                        "  -Cumin-Rs.190/kg",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Row(
//            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                ),
                Image(
                  image: AssetImage("images/dairy.jpeg"),
                  height: 150,
                  width: 150,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\n  Dairy Products:\n\n"
                        "  --Brand:Amul,Pack:200g\n"
                        "  -Butter-Rs.88\n"
                        "  -Cheese Cubes-Rs105\n"
                        "  -Paneer-Rs.75\n"
                        "  -Cream-Rs.50",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Row(
//            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                ),
                Image(
                  image: AssetImage("images/kids.jpg"),
                  height: 150,
                  width: 150,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\n  For Kids:\n\n"
                        "  --Flat Discounts!\n"
                        "  -Gini & Jony-40%\n"
                        "  -First Cry-35%\n"
                        "  -My BabyCart-20%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Row(
//            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                ),
                Image(
                  image: AssetImage("images/decor.jpg"),
                  height: 150,
                  width: 150,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\n  Home Decor:\n\n"
                        "  --Flat Discounts!\n"
                        "  -Bombay Dyeing-20%\n"
                        "  -Sleepwell-10%\n"
                        "  -D'Decor-10%+",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Row(
//            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                ),
                Image(
                  image: AssetImage("images/dryf.jpg"),
                  height: 150,
                  width: 150,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\n  Imported Items:\n\n"
                        "  -Almonds-Rs.820/kg\n"
                        "  -Farb Dates-Rs.360/kg\n"
                        "  -Cashewnuts-Rs.820/kg\n"
                        "  -Hazelnuts-Rs.1450/kg\n"
                        "  -Pistachios-Rs.900/kg",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    ]);
  }
}
