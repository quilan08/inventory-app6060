

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/employee.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/models/sale.dart';
import 'package:flutter_application_1/models/shop.dart';
import 'package:flutter_application_1/models/stock.dart';
import 'package:flutter_application_1/models/waste.dart';
import 'package:flutter_application_1/providers/auth.dart';
import 'package:rxdart/rxdart.dart';

DatabaseProvider dbService = DatabaseProvider();
class DatabaseProvider{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseFirestore get firedb => _db;
  final employee = BehaviorSubject<Employee>();
  final stock = BehaviorSubject<List<Stock>>();
  final products = BehaviorSubject<List<Product>>();
  final sales = BehaviorSubject<List<Sale>>();
  final wastes = BehaviorSubject<List<Waste>>();

  DatabaseProvider(){
    _db.collection("products")
    .snapshots()
    .listen((QuerySnapshot productSnapshots) 
    { 
      products.add(
        productSnapshots.docs.map((e) => Product(
        name: e["name"],
        productid:e["productid"],
        buyingPrice: e["buyingPrice"], 
        sellingPrice: e["sellingPrice"],
        uom: e["uom"]
        )
        ).toList(),

      );
    });
  }

  void getCurrentEmployee() async{

    _db.collection("employees").doc((await authService.auth.currentUser)?.email).snapshots().listen(( DocumentSnapshot documentSnapshot) {
        List  shops = documentSnapshot["shops"];
        employee.add(Employee(
          name: documentSnapshot["name"], 
          email: documentSnapshot["email"],
          shops: shops.map((shop) => Shop(
            shop: shop["shop"],
            shopid: shop["shop"]
          )
          ).toList(),
           active: documentSnapshot["active"]));
    });
  }
  void getSales(String date, Shop shop){
    sales.add([]);
    _db.collection("sales")
    .where("shop", isEqualTo: {
      "shop":shop.shop,
      "shopid": shop.shopid
      }).where("dateadded", isEqualTo: date).
      //change event to querySnapshots
      snapshots().listen((event) {
        sales.add(event.docs.map((e) => Sale(
          product: Product(
            name: e["product"]["name"],
            uom: e["product"]["uom"],
            buyingPrice: e["product"]["buyingPrice"],
            sellingPrice: e["product"]["sellingPrice"],
            productid: e["product"]["productid"],
          ),
          shop: Shop(shop: e["shop"]["shop"],
          shopid: e["shop"]["shopid"]
          ),
          stockid: e["stockid"],
          salesid: e["salesid"],
          dateadded: e["dateadded"],
          timestamp: e["timestamp"],
          quantity: e["quantity"]
        )).toList(),
      );
      },
      );
  }

  void getWaste(String date, Shop shop){
    wastes.add([]);
    _db.collection("waste").where("shop", isEqualTo:{"shop":shop.shop,"shopid":shop.shopid})
    .where("dateadded",isEqualTo: date.toString()).snapshots()
    .listen((QuerySnapshot salesSnapshot) {
      wastes.add(
        salesSnapshot.docs.map((wastedocs) => Waste(
          product: Product(
          name:wastedocs["product"]["name"],
          uom: wastedocs["product"]["uom"],
          buyingPrice: wastedocs["product"]["buyingPrice"],
          sellingPrice: wastedocs["product"]["sellingPrice"],
          productid: wastedocs["product"]["productid"],
          ),
          shop: Shop(shop: wastedocs["shop"]["shop"],
          shopid: wastedocs["shop"]["shopid"]),
          stockid: wastedocs["stockid"],
          wasteid: wastedocs["wasteid"],
          dateadded: wastedocs["dateadded"],
          timestamp: wastedocs["timestamp"],
          quantity: wastedocs["quantity"]
        )).toList()
      );
    });
  }
  
  void getStock(Shop shop){
    _db.collection("stock").where("shop", isEqualTo: {
      "shop":shop.shop,
      "shopid":shop.shopid
    }).snapshots().listen((QuerySnapshot stockSnapShot) 
  {
    stock.add(
    stockSnapShot.docs.map((stockdocs) =>Stock(
      product : Product(name: stockdocs["product"]["name"],
      uom: stockdocs["product"]["uom"],
       buyingPrice: stockdocs["product"]["buyingPrice"],
       sellingPrice:stockdocs["product"]["sellingPrice"],
       productid: stockdocs["product"]["productid"]
       ),
     dateadded: stockdocs["product"]["dateadded"], 
     shop: Shop(shop: stockdocs["shop"]["shop"], 
     shopid: stockdocs["shop"]["shopid"]), 
     quantity:stockdocs["quantity"],
     stockid: stockdocs["stockId"] )
     ).toList(),
    );
   });
  }

  Future<void> addStock(Stock stock)async{
    if(connectionStatusSingleton.hasConnection){
      try{
        DocumentReference addedStockToDatabase = await _db.collection("stock").add(stock.map) ;
       //error need to be fixed here
        return await addedStockToDatabase.update({
           "stockid": addedStockToDatabase.id,
           }
       );
       }
      catch(e){
        rethrow;
      }
    }else{
      throw Exception("No Internet");
    }
  }
  Future<void> editStock(Stock stock)async{
    if(connectionStatusSingleton.hasConnection){
      try{
        return await _db.collection("stock").doc(stock.stockid).update(stock.map);
      } catch(e){
        rethrow;
      }
    } else{
      throw Exception("No Internet");
    }
  }
  Future<void> editStockOperations(Stock stock, Stock originalStock, String operations) async{
    if(connectionStatusSingleton.hasConnection){
      try{
        DocumentReference added = await _db.collection(operations).add(stock.map);
        await added.update({
          (operations =="sales" ? "salesid": "wasteid"):added.id,
          "timestamp":DateTime.now().millisecondsSinceEpoch
        });
        if(originalStock.quantity! - stock.quantity! == 0.0){
          return await _db.collection("stock").doc(originalStock.stockid).delete();
        } else{
          return await _db.collection("stock").doc(originalStock.stockid).update({
            "quantity": originalStock.quantity!-stock.quantity!,
          });
        }
      } catch(e){
        rethrow;
      }
    } else{
      throw Exception("No Exception");
    }
  }

  Future<List<Shop>?> getShops() async{
    try {
      QuerySnapshot res = await _db.collection("shops").get();
      return res.docs.map((shop) => Shop(shop: shop["shop"], shopid: shop["shopid"])
      ).toList();
    } catch (e) {
      rethrow;
    }

    
}

dispose(){
      employee.close();
      stock.close();
      products.close();
      sales.close();
      wastes.close();
    }
}