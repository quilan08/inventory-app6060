

class Product{
  final String name;
  final String? productid;
  final String? uom;
  final double buyingPrice;
  final double sellingPrice;

  const Product({
    required this.name,
    required this.buyingPrice,
    required this.sellingPrice,
    this.productid,
    this.uom 
  });

  Map<String, dynamic> get map{
    return {
      "name": name,
        "productid": productid,
        "uom": uom,
        "buyingPrice" :buyingPrice,
        "sellingPrice":sellingPrice,
    };
  }
}