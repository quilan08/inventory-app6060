import 'product.dart';
import 'shop.dart';

class Waste{
  final Product? product;
  final String? wasteid;
  final String? dateadded;
  final String? stockid;
  final int? timestamp;
  final Shop? shop;
  final double? quantity;

  const Waste({
    this.product,
    this.wasteid,
    this.stockid,
    this.shop,
    this.dateadded,
    this.timestamp,
    this.quantity,
  });

  Map<String,dynamic> get map{
    return{
       "product" : product,
      "salesId":wasteid,
      "dateadded" : dateadded,
      "timestamp" : timestamp,
      "shop":{
        "shop":shop!.shop,
        "shopid" : shop!.shopid
      },
      "quantity":quantity,
      "stockId":stockid
    };
  }
}