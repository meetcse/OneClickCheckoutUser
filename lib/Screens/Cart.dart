// import 'dart:html';

// import 'dart:js';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneclickcheckout/HomePage.dart';
import 'package:oneclickcheckout/ItemList.dart';
import 'Scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'GetItemListFromDatabase.dart';
import 'HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Payments.dart';

class Cart extends StatefulWidget {
  // String name;
  // int quantity;
  // double price;
  // Cart(this.name, this.price, this.quantity);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String _name = "HELLO";
  double _quantity = 0;
  double _price;
  double _total = 0;
  double _productTotalPrice = 0;

  int _counter = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  DateTime dateTime = DateTime.now();

  String _date;

  String _userId;

  QuerySnapshot documentList;

  GetItemListFromDatabase getItems;

  DocumentReference _firestoreReference;

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  bool isLoading = true;
  bool isDocumentLength = true;
  // DocumentReference _firestoreReference = Firestore.instance.collection(path)

  // _CartState(this._name, this._price, this._quantity);

  // ItemList itemList;

  List<String> itemList = List<String>();
  List<String> itemBarcode = List<String>();
  List<double> itemPrice = List<double>();
  List<double> itemQuantity = List<double>();
  List<double> itemTotalPrice = List<double>();

  int _documentLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser().then((uuid) {
      print(uuid);
      this.callgetData();
    });
    // this.getData().then((QuerySnapshot results) {
    //   setState(() {
    //     documentList = results;
    //     // isLoading = false;
    //     _documentLength = documentList.documents.length;
    //   });
    //   print(_documentLength);
    //   if (_documentLength != 0) {
    //     fillItemList();
    //     isDocumentLength = false;
    //   } else {
    //     isLoading = false;
    //   }
    // });

    print("printing.......................");
    // Future.delayed(Duration(seconds: 5), (){
    //   // print(documentList);
    //    fillItemList();

    // });
    // this.getData();
    // print("Document Lent+documeg $_documentLength");
    // if(_documentLength == 0)
    // {
    //   print("chinta na kar");
    //   Future.delayed(Duration(seconds: 5), (){
    //   // print(documentList);
    //    fillItemList();
    //   print(_documentLength);

    // });
    // }
    // else
    // {
    //   print("beta me aayo");
    //   fillItemList();

    // }
  }

  callgetData() {
    this.getData().then((QuerySnapshot results) {
      setState(() {
        documentList = results;
        // isLoading = false;
        _documentLength = documentList.documents.length;
      });
      print(_documentLength);
      if (_documentLength != 0) {
        fillItemList();
        isDocumentLength = false;
      } else {
        isLoading = false;
      }
    });
  }

  //Get Data from Cloud Firestore
  getData() {
    _date = DateFormat.yMd().format(dateTime);
    // _date = _date + "/" + _userId;
    print(_userId);
    return Firestore.instance.collection(_date + _userId).getDocuments();
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser
        ?.reload(); //if not reload then you will always get null into display of user page
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        // this.isSignedIn = true;
      });
    }
    _userId = firebaseUser.uid;
    return _userId;
  }

  fillDocumentList() {
    this.getData().then((QuerySnapshot results) {
      setState(() {
        documentList = results;
        // isLoading = false;
        _documentLength = documentList.documents.length;
        print("BHALE PADHARYA....");
      });
      print("DOUCMNET LENGTH $_documentLength");
      if (_documentLength != 0) {
        itemList.clear();
        itemBarcode.clear();
        itemTotalPrice.clear();
        itemPrice.clear();
        _total = 0;
        itemQuantity.clear();
        fillItemList();
        print("AAVI GAYO ME PN");
      } else {
        itemList.clear();
        itemBarcode.clear();
        itemTotalPrice.clear();
        itemPrice.clear();
        itemQuantity.clear();
        isLoading = false;
        isDocumentLength = true;
      }
      print("DEKHO MUJHE");
    });
  }

  fillItemList() {
    int i = documentList.documents.length;

    _documentLength = i;

    int j = 0;
    for (j = 0; j < i; j++) {
      String s = documentList.documents[j].data["barcodeNumber"];
      String quantity = documentList.documents[j].data["quantity"].toString();
      _quantity = double.parse(quantity);
      itemQuantity.add(_quantity);
      // print("In LOOP $j");

      Firestore.instance
          .collection("BarcodeNumber")
          .document(s)
          .snapshots()
          .listen((event) {
        // print("INSIDE IN");

        setState(() {
          _name = event.data["name"];
          _price = event.data["price"];

          // print(_name);
          itemList.add("$_name");
          itemBarcode.add(s);
          // print(itemList[0]);
          // print(_price);
          itemPrice.add(_price);
          // print(itemPrice[0]);

          if (itemList.length == i) {
            this.getProductTotalPrice();
            setState(() {
              // isLoading = false;
            });
          }
        });
      });
    }

    // Future.delayed(Duration(seconds: 10), () {
    //   print(itemList[0]);
    //   print(itemPrice[0]);
    // });
  }

  // getItemList() async{

  //   // int i = documentList.documents.length;
  //   print("INSIDE GETITEMLIST....");
  //   // int j;
  //    await _databaseReference.child(documentList.documents[_counter].data['barcodeNumber']).onValue.listen((event){

  //       // print("INSIDE FOR 2");
  //       //  setState(() {
  //         itemList.add(event.snapshot.value['name']);
  //       //  itemList[j] = event.snapshot.value['name'];
  //        itemPrice.add(double.parse(event.snapshot.value['price'].toString()));
  //       //  itemPrice[j] = (double.parse(event.snapshot.value['price'].toString()));

  //       //  });

  //       // print("Inside For");
  //       // tmp1[j] = (event.snapshot.value['name']);
  //       // tm2[j] = (double.parse(event.snapshot.value['price'].toString()));
  //       // print(tmp1[j]);
  //       // print(tm2[j]);
  //       _counter++;
  //       print("EXITING $_counter times");
  //      });

  //      print("EXITING GETITEM LIST");
  //   }

  // getname(int i) {
  //   String name;
  //   // name = getItems.getName(documentList.documents[i].data['barcodeNumber$i']);

  //    _databaseReference.child(documentList.documents[i].data['barcodeNumber']).onValue.listen((event){

  //     setState(() {
  //       name =  event.snapshot.value['name'].toString();
  //     // print("*********************dishoom    $name");
  //       _name=name;
  //     });

  //   });

  //   // print("*********************    $name");
  //   return true;

  // }

  //  getprice(int i) {

  //   String price;
  //   double x;
  //    _databaseReference.child(documentList.documents[i].data['barcodeNumber']).onValue.listen((event){

  //     setState(() {
  //       price =  event.snapshot.value['price'].toString() ;
  //       _price = double.parse(price);
  //     });

  //   });

  //    return true;

  // }

  getItemQuantity() {
    int i = documentList.documents.length;

    _documentLength = i;

    int j = 0;
    for (j = 0; j < i; j++) {
      String s = documentList.documents[j].data["quantity"].toString();
      itemQuantity.add(double.parse(s));
    }
  }

  getProductTotalPrice() {
    int length = itemPrice.length;
    int i;
    // _productTotalPrice = 1;
    for (i = 0; i < length; i++) {
      setState(() {
        double d = itemQuantity[i] * itemPrice[i];
        itemTotalPrice.add(d);
      });

      print("QUANTITY" + itemQuantity[i].toString());
      print(itemTotalPrice[i]);
      _total = _total + itemTotalPrice[i];
    }
    // setState(() {
    isLoading = false;
    // });
    // return _productTotalPrice;
  }

  //Decrement quantity
  decrementQuantity(int id) {
    int i = documentList.documents.length;
    int j = 0;
    String s;
    double quantity;
    for (j = 0; j < i; j++) {
      if (documentList.documents[j].data["barcodeNumber"] == itemBarcode[id]) {
        s = documentList.documents[j].reference.path;
        print(s);
        quantity = itemQuantity[j];
        break;
      }
    }
    // String quantity = documentList.documents[s].data["quantity"].toString();
    _quantity = quantity;
    _quantity = _quantity - 1;
    if (_quantity == 0) {
      print("ENTERING In");

      removeItem(id);
      setState(() {
        _total = 0.0;
      });
      // deleteItem(id,s);

    } else {
      updateQuantity(id, _quantity, s);
    }
  }

  //increment Quantity
  incrementQuantity(int id) {
    int i = documentList.documents.length;
    int j = 0;
    String s;
    double quantity;
    for (j = 0; j < i; j++) {
      if (documentList.documents[j].data["barcodeNumber"] == itemBarcode[id]) {
        s = documentList.documents[j].reference.path;
        print(s);
        quantity = itemQuantity[j];
        break;
      }
    }
    // String quantity = documentList.documents[id].data["quantity"].toString();
    _quantity = quantity;
    setState(() {
      _quantity = _quantity + 1;
    });

    updateQuantity(id, _quantity, s);
  }

  //Update Quantity in Firebase
  updateQuantity(int id, double quantity, String path) {
    _firestoreReference = Firestore.instance.document(path);
    _firestoreReference.updateData({
      'quantity': quantity,
    });
    // fillItemList();
    fillDocumentList();
    // isLoading = false;
  }

  //Delete Entry
  deleteItem(int id, String path) {
    _firestoreReference = Firestore.instance.document(path);
    _firestoreReference.delete();
    setState(() {
      _total = 0.0;
    });
    fillDocumentList();
    // fillItemList();
    // isLoading = true;
  }

  removeItem(int id) {
    int i = documentList.documents.length;
    int j = 0;
    String s;
    // double quantity;
    for (j = 0; j < i; j++) {
      if (documentList.documents[j].data["barcodeNumber"] == itemBarcode[id]) {
        s = documentList.documents[j].reference.path;
        print(s);
        // quantity = itemQuantity[j];
        break;
      }
    }

    deleteItem(id, s);
  }

  alertDialog(message) {
    // BuildContext context;
    return AlertDialog(
      title: Text(
        "OOPS",
        style: TextStyle(
          color: Colors.red,
          // backgroundColor: Colors.red
        ),
      ),

      content: Text(message),
      // actions: <Widget>[
      //   FlatButton(
      //     onPressed: (){
      //       Navigator.push(context, MaterialPageRoute(builder: (context){
      //         return HomePage();

      //       // Navigator.of(context).pop();
      //       }));
      //     },
      //     child: Text("Scan Items"),
      //     ),

      // ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  navigateToPaymentsScreen() {
    if (_total != 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Payments(_total);
      }));
    } else {
      setState(() {
        alertDialog("You cannot Pay");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: <Color>[
              Color(0xff5433FF),
              Color(0xff20BDFF),
              Color(0xff2C5364),
            ],
          )),
        ),
      ),
      body: Container(
        child: ((isLoading)
            // (itemPrice.isEmpty) &&
            // (itemList.isEmpty) &&
            // (_documentLength != itemList.length) &&
            // (itemTotalPrice.isEmpty) &&
            // (itemQuantity.isEmpty)
            // (itemList.length != itemTotalPrice.length)

            )
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                  strokeWidth: 7,
                ),
              )
            : Container(
                child: (isDocumentLength)
                    ? Center(child: alertDialog("Your Cart is Empty"))
                    : ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.black,
                            thickness: 0.8,
                          );
                        },
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            // this.getname(index) ? "$_name" : ""

                            title: Row(
                              children: <Widget>[
                                Text(
                                  itemList[index],
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),

                                // Expanded(
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: <Widget>[
                                //       Text("x"+itemQuantity[index].toString(),
                                //           style: TextStyle(
                                //           fontSize: 18.0,
                                //           fontWeight: FontWeight.bold

                                //           ),
                                //         ),
                                //     ],
                                //   ),
                                // ),

                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      // Padding(padding: EdgeInsets.only(left:100)),

                                      GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(
                                            Icons.remove_shopping_cart,
                                            color: Colors.red,
                                          ),
                                        ),
                                        onTap: () {
                                          isLoading = true;
                                          removeItem(index);
                                        },
                                      ),

                                      GestureDetector(
                                        child: Icon(
                                          Icons.remove_circle_outline,
                                          size: 27,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          decrementQuantity(index);
                                          // setState(() {
                                          //   fillItemList();
                                          // });
                                        },
                                      ),

                                      Text(
                                        "x" + itemQuantity[index].toString(),
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      GestureDetector(
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          size: 27,
                                        ),
                                        onTap: () {
                                          isLoading = true;
                                          incrementQuantity(index);
                                          // fillItemList();
                                          // this.reassemble();
                                          // isLoading = false;
                                          // setState(() {
                                          //   fillItemList();
                                          // });
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Divider()
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Text("x$_quantity",
                                //   style: TextStyle(
                                //     fontSize: 12.0,
                                //     color: Colors.grey,

                                //   ),
                                // ),

                                Text(
                                  itemPrice[index].toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),

                                //ADD GESTURE DETECTOR FOR QUANTITY UPDATE

                                // Column(
                                //   children: <Widget>[
                                //     GestureDetector(
                                //       child: Icon(Icons.remove),
                                //       //ADD GESTURE
                                //     ),
                                //   ],
                                // ),

                                // Divider(),
                              ],
                            ),
                          );
                        },
                      ),
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 12.0, top: 12.0, left: 10.0, right: 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Total:  ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,

                  // fontStyle: FontStyle.italic
                ),
              ),
              Text(
                _total.toString(),
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        navigateToPaymentsScreen();
                      },
                      child: Text("Pay Securely"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.yellow,
                      splashColor: Color(0xff0A79DF),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        color: Colors.indigoAccent,
      ),
    );
  }
}
