import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/models/shop.dart';

class Stock{
  final Product? product;
  final double? quantity;
  final String? stockId;
  final String? dateadded;
  final Shop? shop;

  Stock({
    required this.product,
    required this.dateadded,
    required this.shop,
    required this.quantity,
    this.stockId
  });

  Map<String,dynamic> get map{
    return {
       "product" : product,
       "quantity":quantity,
      "dateadded" :dateadded.toString(),
      "shop":{
        "shop":shop!.shop,
        "shopId" : shop!.shopId
      },
     
      "stockId":stockId
    };
    
  }
}