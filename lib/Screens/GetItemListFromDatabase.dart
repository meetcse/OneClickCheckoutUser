import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GetItemListFromDatabase {

  String _name;
  String _quantity;
  String _price;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  // DataSnapshot snapshot;


    String getName(barcodeNumber) {
     _databaseReference.child(barcodeNumber).onValue.listen((event){
      
      _name= event.snapshot.value['name'];
    });
    
    return _name;
  }
    String getPrice(barcodeNumber) {
     _databaseReference.child(barcodeNumber).onValue.listen((event){
      _price =  event.snapshot.value['price'];
    });
    return _price;
  }

}