

class Product{
  final String name;
  final String? productId;
  final String? uom;
  final double buyingPrice;
  final double sellingPrice;

  const Product({
    required this.name,
    required this.buyingPrice,
    required this.sellingPrice,
    this.productId,
    this.uom 
  });

  Map<String, dynamic> get map{
    return {
      "name": name,
        "productid": productId,
        "uom": uom,
        "buyingPrice" :buyingPrice,
        "sellingPrice":sellingPrice,
    };
  }
}