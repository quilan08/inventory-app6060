import 'product.dart';
import 'shop.dart';

class Waste{
  final Product? product;
  final String? wasteId;
  final String? dateadded;
  final String? stockId;
  final int? timestamp;
  final Shop? shop;
  final double? quantity;

  const Waste({
    this.product,
    this.wasteId,
    this.stockId,
    this.shop,
    this.dateadded,
    this.timestamp,
    this.quantity,
  });

  Map<String,dynamic> get map{
    return{
       "product" : product,
      "salesId":wasteId,
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