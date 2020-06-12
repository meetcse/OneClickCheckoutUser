import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class ItemList {
  String _id;
  String _barcodeNumber;
  String _name;
  double _price;
  double _quantity;

  ItemList.onlyBarcode(this._barcodeNumber);

  ItemList(String barcodeNumber, String name, double price, double quantity) {
    this._barcodeNumber = barcodeNumber;
    this._name = name;
    this._price = price;
    this._quantity = quantity;
  }

  ItemList.withId(this._id, this._barcodeNumber, this._name, this._price, this._quantity);


  //getters
  String get barcodeNumber => this._barcodeNumber;
  String get id => this._id;
  String get name => this._name;
  double get price => this._price;
  double get quantity => this._quantity;


  //setters

  set name(String name) {
    this._name = name;
  }

  set barcodeNumber(String barcodeNumber) {
    this._barcodeNumber = barcodeNumber;
  }

  set price (double price) {
    this._price = price;
  }
  
  set quantity (double quantity) {
    this._quantity = quantity;
  }


  ItemList.fromSnapShot(DataSnapshot snapshot) {
    this._id = snapshot.value['id'];
    // this._barcodeNumber = snapshot.value['barcodeNumber'];
    this._name = snapshot.value['name'];
    this._price = double.parse(snapshot.value['price']);
    this._quantity = double.parse(snapshot.value['quantity']);

  }

  Map<String, dynamic> toJson() {
    return {
      // "barcodeNumber" : _barcodeNumber,
      "name" : _name,
      "price" : _price,
      "quantity" : _quantity
    };
  }

  Map<String, dynamic> barcodeToJson(String barcode) {
    return {
      "barcodeNumber" : barcode,
    };
  }

}