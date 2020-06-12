import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oneclickcheckout/HomePage.dart';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';

//Check Card Numbers 4111 1111 1111 1111	CVV-111 Month = 11/22 zip - 11

// Brand	                     Number	                          CVV
// Visa	                 4111 1111 1111 1111	                 111
// MasterCard	           5105 1051 0510 5100	                 111
// Discover	             6011 0000 0000 0004	                  111
// Diners Club	           3000 0000 0000 04	                   111
// JCB	                   3569 9900 1009 5841	                 111
// American Express	     3400 000000 00009	                  1111
// China UnionPay	       6222 9888 1234 0000	                  123

class Payments extends StatefulWidget {
  double _total;

  Payments(this._total);

  @override
  _PaymentsState createState() => _PaymentsState(_total);
}

class _PaymentsState extends State<Payments> {
  double _total;
  int length = 0;

  _PaymentsState(this._total);
  var payId = Uuid();
  String _paymentUniqueId;

  DocumentReference _firestoreReferenceFromCart;
  DocumentReference _firestoreReferenceForPayments;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String _userId;
  DateTime dateTime = DateTime.now();
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  String _date;
  QuerySnapshot documentList;
  bool isDocumentLength = true;
  int _documentLength = 0;
  bool isLoading = true;
  double _quantity = 0;
  String _name;
  double _price;
  int _counter = 0;

  setCounter() {
    _date = DateFormat.yMd().format(dateTime);

    Firestore.instance
        .collection("Payments/" + _date + "/" + _userId)
        .getDocuments()
        .then((QuerySnapshot results) {
      QuerySnapshot snapshot;
      snapshot = results;

      _counter = snapshot.documents.length;
      _counter = _counter + 1;
    }).whenComplete(() => null);
  }

  //Get Data from Cloud Firestore
  getData() {
    _date = DateFormat.yMd().format(dateTime);
    Firestore.instance
        .collection("Payments/" + _date + "/" + _userId)
        .getDocuments()
        .then((QuerySnapshot results) {
      QuerySnapshot snapshot;
      snapshot = results;

      _counter = snapshot.documents.length;
      _counter = _counter + 1;
    });
    // _date = _date + "/" + _userId;
    // print(_userId);
    return Firestore.instance.collection(_date + _userId).getDocuments();
  }

  callgetData() {
    this.getData().then((QuerySnapshot results) {
      setState(() {
        documentList = results;
        // isLoading = false;
        _documentLength = documentList.documents.length;
      });
      // print(_documentLength);
      if (_documentLength != 0) {
        fillItemList();
        isDocumentLength = false;
      } else {
        isLoading = false;
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
        // this.isSignedIn = true;
      });
    }
    _userId = firebaseUser.uid;
    return _userId;
  }

  fillItemList() {
    int i = documentList.documents.length;

    _documentLength = i;

    int j = 0;
    for (j = 0; j < i; j++) {
      String path = documentList.documents[j].reference.path;
      String s = documentList.documents[j].data["barcodeNumber"];
      String quantity = documentList.documents[j].data["quantity"].toString();
      _quantity = double.parse(quantity);

      Firestore.instance
          .collection("BarcodeNumber")
          .document(s)
          .snapshots()
          .listen((event) {
        // print("INSIDE IN");

        setState(() {
          _name = event.data["name"];
          _price = event.data["price"];
        });

        _firestoreReferenceForPayments = Firestore.instance
            .collection("Payments/" + _date + "/" + _userId)
            .document("barcodeNumber$_counter");

        print("LENGTH OUTSIDE:   " + length.toString());
        databaseReference
            .child("Payment")
            .child("${dateTime.month}")
            .child("${dateTime.day}")
            .child("${dateTime.year}")
            .child("user$length")
            .set({"userId": _userId});

        // Firestore.instance
        //     .collection("Payments/" + _date)
        //     .getDocuments()
        //     .then((event) {
        //   var list = event;
        //   length = list.documents.length;
        //   print("SSSSSSSSSSSSSSSSSSSSSSSS: " + list.documents.toString());
        //   length = length + 1;
        // }).then((value) {
        //   Firestore.instance
        //       .collection("Payments")
        //       .document(_date)
        //       .setData({"userId$length": _userId}, merge: true);
        // });

        _firestoreReferenceForPayments.setData(
          {
            'Payment Id': _paymentUniqueId,
            'barcodeNumber': s,
            'quantity': quantity,
            'name': _name,
            'price': _price,
            'total': _total,
            'Date Created': dateTime.toString()
          },
          merge: true,
        );

        setState(() {
          _counter++;
        });
        deleteItem(1, path);
      });
    }
  }

  deleteItem(int id, String path) {
    _firestoreReferenceFromCart = Firestore.instance.document(path);
    _firestoreReferenceFromCart.delete();
  }

//Code for Payments
  void _pay() {
    InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-EDIPXN1ISveG5eV_UYrkpg');
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
      onCardEntryCancel: _cardEntryCancel,
    );
  }

  _cardNonceRequestSuccess(CardDetails result) {
    print("Successfull:  " + result.nonce);
    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }

  void _cardEntryComplete() {
    //Success
    print("YUPPIEE");
    // setCounter();
    // setCounter();
    this.getUser().then((uuid) {
      print(uuid);
      this.callgetData().then(() => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false));
    });

    // Navigator.popUntil(context, (route) => false);
    // Navigator.pushReplacementNamed(context, "/HomePage");
  }

  void _cardEntryCancel() {
    //
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _paymentUniqueId = payId.v1();
    databaseReference
        .child("Payment")
        .child("${dateTime.month}")
        .child("${dateTime.day}")
        .child("${dateTime.year}")
        .onValue
        .listen((element) {
      Map<dynamic, dynamic> map = element.snapshot.value;
      setState(() {
        length = map.length + 1;
      });
      print("LEngth:  " + length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payments",
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
      body: Center(
        child: AlertDialog(
          title: Text(
            "Confirm Payment",
            style: TextStyle(
              color: Colors.red,
              // backgroundColor: Colors.red
            ),
          ),
          content: Text("Your Total Amount is " + _total.toString() + "."),
          actions: <Widget>[
            FlatButton(
              onPressed: _pay,
              child: Text(
                "PAY",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
