import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneclickcheckout/ItemList.dart';
import 'Scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'GetItemListFromDatabase.dart';


class Cart extends StatefulWidget {
  
  // String name;
  // int quantity;
  // double price;
  // Cart(this.name, this.price, this.quantity);
  
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  String _name="HELLO";
  double _quantity=0;
  double _price;
  double _total=0;
  double _productTotalPrice=0;

  int _counter = 0;
  

  DateTime dateTime = DateTime.now();

  String _date;

  String _userId = "UserName";

  QuerySnapshot documentList;

  GetItemListFromDatabase getItems;

  DocumentReference _firestoreReference;

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  bool isLoading = true;
  // DocumentReference _firestoreReference = Firestore.instance.collection(path)

  // _CartState(this._name, this._price, this._quantity);

  // ItemList itemList;


  List<String> itemList = List<String>();
  List<String> itemBarcode = List<String>();
  List<double> itemPrice = List<double>();
  List<double> itemQuantity = List<double>();
  List<double> itemTotalPrice = List<double>();
  

  int _documentLength;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData().then((QuerySnapshot results){
      setState(() {
        documentList = results;
        // isLoading = false;
        _documentLength = documentList.documents.length;
      });

    });
    
    print("printing.......................");
    Future.delayed(Duration(seconds: 5), (){
      // print(documentList);
       fillItemList();



      //  if(_documentLength != itemPrice.length)
      //  {
      //     Future.delayed(Duration(seconds: 2), (){
      //       getItemQuantity();
      //       getProductTotalPrice();    
      //     }); 
      //  }
      //  else
      //  {
      //     getItemQuantity();
      //     getProductTotalPrice();
      //  }
        
    });
    
    // fillItemList();

     
    // test.addAll(_listItems.bnum);
  }

  fillItemList() {

    int i = documentList.documents.length;
    
    _documentLength = i;
    
    int j=0;
    for(j=0; j<i; j++)
    {
      String s = documentList.documents[j].data["barcodeNumber"];
      String quantity = documentList.documents[j].data["quantity"].toString();
      _quantity = double.parse(quantity);

      // print("In LOOP $j");

      Firestore.instance.collection("BarcodeNumber").document(s).snapshots().listen((event){
        
        // print("INSIDE IN");
        
        setState(() {
          _name = event.data["name"];
          _price = event.data["price"];

          itemQuantity.add(_quantity);
          
          // print(_name);
          itemList.add("$_name");
          itemBarcode.add(s);
          // print(itemList[0]);
          // print(_price);
          itemPrice.add(_price);
          // print(itemPrice[0]);

          if(itemList.length == i)
          {
            this.getProductTotalPrice();
            setState(() {
              // isLoading = false;
            });
          }
          
        });
      }
      );
      
   
    }
    
    // Future.delayed(Duration(seconds: 10), () {
    //   print(itemList[0]);
    //   print(itemPrice[0]);
    // });

  }


 



   


  //Get Data from Cloud Firestore
   getData() {

    _date= DateFormat.yMd().format(dateTime);
    // _date = _date + "/" + _userId;
    return Firestore.instance.collection(_date).getDocuments();

  }


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


  getItemQuantity () {
     int i = documentList.documents.length;
    
    _documentLength = i;
    
    int j=0;
    for(j=0; j<i; j++)
    {
      String s = documentList.documents[j].data["quantity"].toString();
      itemQuantity.add(double.parse(s));
    }
  }


  getProductTotalPrice() 
  {
    int length = itemPrice.length;
    int i;
    // _productTotalPrice = 1;
      for(i=0; i<length; i++)
      {
        setState(() {
          double d = itemQuantity[i] * itemPrice[i];
          itemTotalPrice.add(d);
          
        });
        
        
        print(itemTotalPrice[i]);
      }
      // setState(() {
        isLoading = false;
      // });
    // return _productTotalPrice;
  }



  //Decrease quantity
  decrementQuantity(int id) {
    String quantity = documentList.documents[id].data["quantity"].toString();
    _quantity = double.parse(quantity);
    _quantity = _quantity-1;
    if(_quantity == 0){
      deleteItem(id);
    }
    else {
      updateQuantity(id, _quantity);
    }
  }

  //increment Quantity
  incrementQuantity(int id){
    String quantity = documentList.documents[id].data["quantity"].toString();
    _quantity = double.parse(quantity);
    setState(() {
      _quantity = _quantity + 1.0;  
    });
    
    
      updateQuantity(id, _quantity);
    
  }

  
  //Update Quantity in Firebase
  updateQuantity(int id, double quantity){
    _firestoreReference = Firestore.instance.collection(_date).document("barcodeNumber$id");
    _firestoreReference.updateData({
        'quantity' : quantity,
      }
    );
    
  }

  //Delete Entry
  deleteItem(int id){
      _firestoreReference = Firestore.instance.collection(_date).document("barcodeNumber$id");
      _firestoreReference.delete();
  }






  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
         "One Click Checkout",
        ),
      ),
        // body: Container(
        //   child: ((isLoading) 
        //     // (itemPrice.isEmpty) && 
        //     // (itemList.isEmpty) &&
        //     // (_documentLength != itemList.length) && 
        //     // (itemTotalPrice.isEmpty) &&
        //     // (itemQuantity.isEmpty) 
        //     // (itemList.length != itemTotalPrice.length)

        //   )
        //   ?
        //     Center(
        //       child: CircularProgressIndicator(),
        //     )          
        //   :
        //   FirebaseAnimatedList(
        //   query: Firestore.instance.collection(_date).getDocuments(),
        //   itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index ){
        //     return GestureDetector(
        //       onTap: (){
        //         navigateToViewScreen(snapshot.key);
        //       },
        //       child: Card(
        //         color: Colors.white,
        //         elevation: 2.0,
        //         child: Container(
        //           margin: EdgeInsets.all(10.0),
        //           child: Row(
        //             children: <Widget>[
        //               Container(
        //                 width: 50.0,
        //                 height: 50.0,
        //                 decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   image: DecorationImage(
        //                   fit: BoxFit.cover,
        //                   image: snapshot.value['photoUrl'] == "empty" ? AssetImage("assets/logo.png") : NetworkImage(snapshot.value['photoUrl']),
        //                 ),
        //                 ),
        //               ),
        //               Container(
        //                 margin: EdgeInsets.all(20.0),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: <Widget>[
        //                     Text(
        //                       "${snapshot.value['firstName']} ${snapshot.value['lastName']}",
        //                       style: TextStyle(
        //                         fontSize: 20.0,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                      Text(
        //                       "${snapshot.value['phone']}",
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
          
        // ),

    );
  
  
  }
}


