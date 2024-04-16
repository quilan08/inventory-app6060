import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/providers/database.dart';
import 'package:shimmer/shimmer.dart';
class ProductScreenPage extends StatelessWidget {
  Widget build(BuildContext context){
  return  Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    verticalDirection: VerticalDirection.down,

  children: [
    SingleChildScrollView(
      child: StreamBuilder<List<Product>>(stream:dbService.products.stream,
      builder: (BuildContext context, AsyncSnapshot <List<Product>> snapshot){
        if(snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        else{
          switch(snapshot.connectionState){
            case ConnectionState.waiting : return SizedBox(
              width: (MediaQuery.of(context).size.width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List<Widget>.filled(
                  5, Padding(padding: const EdgeInsets.symmetric(
                    vertical: 2.0, horizontal: 2.0 
                  ), child: Shimmer.fromColors(
                    baseColor: Colors.black12, highlightColor: Colors.black26,
                    child: Container(height: 20.0,
                    width:(MediaQuery.of(context).size.width)
                    , decoration: const BoxDecoration(color: Colors.grey,
                     borderRadius:BorderRadius.all(Radius.circular(5.0)) ),
                    )),
                    ),growable: false
                )
                
              ),
            );
            default: 
            return  SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              
              DataTable(columns: const [
              DataColumn(label: Text("Name"),
              numeric: false,
              tooltip: "This is the product's name"
              ),
              DataColumn(
                label: Text("UOM"),
                numeric: true,
                tooltip: "This is the product Unit of Measurement"
                 ),
                 DataColumn(label: Text("BuyingPrice"),
                 numeric: true,
                 tooltip: "This is the product's Buying price"
                 ),
                 DataColumn(label: Text("SellingPrice"),
                 numeric: true,
                 tooltip: "This is the product's selling price"
                 ),
                 DataColumn(label: Text("Profit"),
                 numeric: true,
                 tooltip: "This is the profit margin"
                 )
            ], rows:snapshot.data!.map((Product product) => DataRow(cells:
             [
              DataCell(
              Text(product.name)),
              DataCell(
              Text(product.uom!)),
               DataCell(
              Text(product.buyingPrice.toString())),
              DataCell(
              Text(product.sellingPrice.toString())),
               DataCell(
              Text(product.sellingPrice.toString())),
            
            ])).toList() 
            )
            ]
            )
            );
          }
        }
      }
         ,),
    )
  ],
  );
}
}
