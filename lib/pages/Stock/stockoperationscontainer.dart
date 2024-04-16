import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/stock.dart';
import 'package:flutter_application_1/pages/Stock/stockPage.dart';

class StockOperationsContainer extends StatefulWidget {
  final Stock stock;
  const StockOperationsContainer({super.key, required this.stock});

  @override
  State<StockOperationsContainer> createState() => _StockOperationsContainerState();
}

class _StockOperationsContainerState extends State<StockOperationsContainer> {
  bool isMoreThanQuantity = false;
  bool islessThanZero = false;
  @override
  Widget build(BuildContext context) {
   return  Column(
    children: <Widget>[
      Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(widget.stock.product!.name,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        fontSize: 16.0
      ),
      ),
      ),

      Padding(padding: const EdgeInsets.symmetric(
        vertical:8.0,
        horizontal :16.0,
        
      ),
      child: TextField(
        controller: quantityController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Quantity to Subtract",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black54,
          )
        ),
        onChanged: (String value) {
          if(double.parse(value)> widget.stock.quantity!){
                setState(() {
                  isMoreThanQuantity = true;
                });
          }
           else{
            setState(() {
              isMoreThanQuantity = false;
            });
           }
           if(double.parse(value) <=0.0){
            setState(() {
              islessThanZero = true;
            });
           } else{
            setState(() {
              islessThanZero = false;
            });
           }
        },
      ),
      
      ),
      Visibility(
        visible: isMoreThanQuantity
        ,child: const
         Text("Value can't be lower than Zero", style:
         TextStyle(color: Colors.red),
         )
        ),
        Visibility(
        visible: islessThanZero,
        child: const Text("Value Can't be Lower Than Zero",
        style: TextStyle(color: Colors.red),
        )
        
        )
      
    ]
   );
  }
}