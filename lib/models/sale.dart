import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/models/shop.dart';

class Sale{
  final Product? product;
  final String? salesId;
  final String? dateadded;
  final int? timestamp;
  final Shop? shop;
  final double? quantity;
  final String? stockId;


  Sale({
    this.product,
    this.salesId,
    this.dateadded,
    this.timestamp,
    this.shop,
    this.quantity,
    this.stockId,
  });

  Map<String,dynamic> get map{
    return {
      "product" : product?.map,
      "salesId":salesId,
      "dateadded" : dateadded,
      "timestamp" : timestamp,
      "shop":{
        "shop":shop!.shop,
        "shopId" : shop!.shopId
      },
      "quantity":quantity,
      "stockId":stockId
    };
  }
}