import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/models/shop.dart';

class Sale{
  final Product? product;
  final String? salesid;
  final String? dateadded;
  final int? timestamp;
  final Shop? shop;
  final double? quantity;
  final String? stockid;


  Sale({
    this.product,
    this.salesid,
    this.dateadded,
    this.timestamp,
    this.shop,
    this.quantity,
    this.stockid,
  });

  Map<String,dynamic> get map{
    return {
      "product" : product?.map,
      "salesid":salesid,
      "dateadded" : dateadded,
      "timestamp" : timestamp,
      "shop":{
        "shop":shop!.shop,
        "shopid" : shop!.shopid
      },
      "quantity":quantity,
      "stockid":stockid
    };
  }
}