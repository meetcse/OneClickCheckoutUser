import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import '../ItemList.dart';
import 'Cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String result;
  String _scanQrCode = "";
  var dataForCollection;

  int _counter = 0;

  DateTime dateTime = DateTime.now();

  String _date;

  String _userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  DataSnapshot snapshot;
  ItemList itemList;
  DocumentReference _firestoreReference;
  DocumentReference _firestoreReferenceForBarcode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
    result = "Scan Barcode";
    // addItemsToFireBase();
  }

  List<ItemList> barcodeNumbers = [
    ItemList("1234567890128", "Maggie Small", 20, 0),
    ItemList("036000291452", "Kurkure", 10, 0),
    ItemList("051111407592", "Hide & Seek", 10, 0),
    ItemList("21047572", "Nutualla", 40, 0),
  ];

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
  }

  addItemsToFireBase() async {
    for (int i = 0; i < barcodeNumbers.length; i++) {
      // await _databaseReference.push().set(value)
      // await _databaseReference.push().set(barcodeNumbers[i].toJson());
      // await _databaseReference.set(barcodeNumbers[i].barcodeNumber);
      // await _databaseReference.child(barcodeNumbers[i].barcodeNumber).set(barcodeNumbers[i].toJson());

      Firestore.instance
          .collection("BarcodeNumber")
          .document(barcodeNumbers[i].barcodeNumber)
          .setData(
            barcodeNumbers[i].toJson(),
            merge: true,
          );
    }
  }

  // FirebaseAnimatedList _firebaseAnimatedList;

  navigateToCartScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Cart();
    }));
  }

  Map<String, String> barcodeToJson(String barcode) {
    return <String, String>{
      "barcodeNumber": barcode,
    };
  }

  checkBarCode() async {
    String s = Firestore.instance
        .collection("BarcodeNumber")
        .document(_scanQrCode)
        .documentID;
    print(s);

    int n = num.parse(Firestore.instance
        .collection("BarcodeNumber")
        .document(_scanQrCode)
        .documentID);
    print(n);

    // if(await )

    if (s == _scanQrCode) {
      _date = DateFormat.yMd().format(dateTime);
      // _date = DateFormat.yMd().parse(inputString)
      // print("DATE = " +_date);

      QuerySnapshot temp1;

      var document = Firestore.instance
          .collection("BarcodeNumber")
          .getDocuments()
          .then((QuerySnapshot results) {
        setState(() {
          temp1 = results;
        });
      });

      Firestore.instance
          .collection("BarcodeNumber")
          .document(_scanQrCode)
          .snapshots()
          .listen((event) {
        setState(() {
          result = event.data["name"];
        });
      }).onDone(() {
        print("DONE");
      });

      print(result);

      setState(() {
        //  int wer = temp1.documents.;
        print(result);
      });

      //  _databaseReference.child(_scanQrCode).onValue.listen((event){

      //    setState(() {

      //     result = event.snapshot.value["name"];

      //    });
      //   //  navigateToCartScreen();

      //  });

      //    Map<String, String> data = <String, String> {
      //    "barcodeNumber" : "HELLO"
      // };

      // dataForCollection = barcodeToJson(_scanQrCode);
      // String path = _userId  + "/barcodeNumber$_counter";

      // String collection = _date + "/" + _userId;
      // print(collection);
      _firestoreReference = Firestore.instance
          .collection(_date + _userId)
          .document("barcodeNumber$_counter");
      _firestoreReference.setData(
        {'barcodeNumber': _scanQrCode, 'quantity': 1, 'name': result},
        merge: true,
      );

      setState(() {
        _counter++;
      });
    }
    // if(await _databaseReference.equalTo(_scanQrCode).) {
    //   setState(() {
    //       result = barcodeNumbers[0].name + " is added";
    //     });

    // }
    else {
      setState(() {
        result = "Match not found";
      });
    }

    // String check = "051111407592";
    // for(int i=0; i<barcodeNumbers.length;i++) {

    // if(barcodeNumbers[i].barcodeNumber == _scanQrCode) {
    //   setState(() {
    //     // result = barcodeNumbers[i].getItemName() + " is added";
    //   });
    //   navigateToCartScreen(i);
    //   break;
    // }
    // else {
    //   setState(() {
    //     result = "MATCH NOT FOUND";
    //   });
    // }

    // }
  }

  printBarCodeNumber() {
    setState(() {
      result = _scanQrCode;
    });
  }

  Future _qrCodeScan() async {
    _scanQrCode = await BarcodeScanner.scan();
    // printBarCodeNumber();

    checkBarCode();
    // if(check=="TRUE"){

    //   setState(() {
    //     result = "Match";
    //   });

    // }

    // else {
    //   setState(() {
    //     result = "MATCH NOT FOUND";
    //   });

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _qrCodeScan();
        },
        backgroundColor: Color(0xff5433FF),
        child: Icon(Icons.scanner),
      ),
      body: Center(
        child: Text(
          result,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
