import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/pages/Stock/stockPage.dart';
import 'package:intl/intl.dart';

class ProductsDropdown extends StatefulWidget {
  const ProductsDropdown({super.key});

  @override
  State<ProductsDropdown> createState() => _ProductsDropdownState();
}

class _ProductsDropdownState extends State<ProductsDropdown> {
  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget> [
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          GestureDetector(
            child: Container(
            width: (MediaQuery.of(context).size.width) * 0.5,
            child: Padding(padding: const EdgeInsets.symmetric(

              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Container(decoration: BoxDecoration(border: Border.all(),
            
            borderRadius: BorderRadius.circular(5.0),
            ),child: Padding(
              padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedDate,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black54,
                fontSize: 16.0
              ),
            ),
          
            ),
            ),
            ),
            ),
            onTap: (){
              showDatePicker(context: context, initialDate: DateTime.now() ,
              firstDate: DateTime(DateTime.now().year), 
              lastDate: DateTime(DateTime.now().year + 1)
              
              ).then(
                (DateTime? value ){
                  if( value != null){
                    setState(() {
                      selectedDate = DateFormat("yMd").format(value);
                    });
                  }
                } 
              
              );
            },

        
          ),
          Container(
            width: (MediaQuery.of(context).size.width) * 0.5,
            child: Padding(padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0
            ),
            child: DropdownButton<Product>(
              value: activeDropDownValue, items:product!.map<DropdownMenuItem<Product>>((Product product){
                return  DropdownMenuItem<Product>(child: Text(product.name));
              }
              ).toList()
              , onChanged: (Product? value) {

          setState(() {
            activeDropDownValue = value;
                });
                },
            )
            ),
          )
        ],
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width)*0.5,
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0
            ),

            child: TextField(
              controller: quantityController,
             keyboardType: const TextInputType.numberWithOptions(decimal: true),
             decoration: const InputDecoration(
              hintText: "Quantity",
              hintStyle: TextStyle(fontWeight: FontWeight.w800,
              color: Colors.black54,
              )
             ),
              ),

              
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width)*0.5,
           child: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text("activeDropDownValue!.uom!",
            style: TextStyle(fontWeight: FontWeight.w800,
            color: Colors.black54,
            fontSize: 16.0
            ),
            ),
            ),
          )
        ],
        
        )
      
      ],

    );
   
  }
}