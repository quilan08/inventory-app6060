import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/models/sale.dart';
import 'package:flutter_application_1/providers/database.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/shop.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  String? selectedDate;
  late List<Shop>  shops = [];
  Shop? shop;

  @override
  void initState() {
    Firebase.initializeApp();
    dbService.employee.stream.listen((res) 
    {
      if(mounted){
        setState(() {
          shops = res.shops!;
          shop = res.shops![0];
        });
        _getSales(selectedDate!, shop!);
      }
     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: (
        AppBar(
          title: const Text("Sales"),
        )
        ),
        body:    Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children:<Widget>[
            Visibility(
              child: Card(
                elevation: 5.0,
                child: Padding(
                  
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                
              child:Row(
                  children:<Widget> [
                    DropdownButton<Shop>(
                      value:shop,
                      onChanged: (Shop? newValue){
                        setState(() {
                          shop = newValue;
                        });
                      },
                      items:shops.map<DropdownMenuItem<Shop>>((Shop shop) {
                        return DropdownMenuItem<Shop>(
                          value : shop,
                          child: Text(shop.shop!),
                        );
                      }
                      ).toList()
                      ),
                        GestureDetector(
                          onTap:(){ showDatePicker(context: context, initialDate:
                           DateTime.now(),firstDate: DateTime(DateTime.now().year), 
                           lastDate: DateTime(DateTime.now().year +1)
                           ).then((DateTime? dateTime){
                          if(dateTime !=null){
                            setState(() {
                              selectedDate = DateFormat("yMd").format(dateTime);
                            });
                          }
                           } );
                           },
                          child: SizedBox(width: (MediaQuery.of(context).size.width)*0.4,
                          child: Container( decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5.0)), child:  Padding(padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: Padding(padding: const EdgeInsets.all(8.0),
                          child: Text(selectedDate ?? '', style:const TextStyle(fontWeight: FontWeight.w800,
                          color: Colors.black54, fontSize: 16.0
                          ),
                          ),
                          ),
                    
                          ),
                          )
                          ),
                        ), 
                        ElevatedButton(onPressed: (){
                          _getSales(selectedDate!, shop!);
                        }, child: const Text("Apply"),
                        )
                    
                  ],)
                ),
              )
              ),
              Expanded(child: 
              ListView(scrollDirection: Axis.horizontal,
              children: <Widget>[
                SingleChildScrollView(
                  child: StreamBuilder<List<Sale>>(
                    stream: dbService.sales.stream,builder: (BuildContext context, AsyncSnapshot<List<Sale>>snapshot){
                  
                    if(snapshot.hasError){
                      return Text("Error: ${snapshot.error}");
                    } else{
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting: 
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width),
                            child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List<Widget>.filled(5,
                            Padding(padding: 
                            const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                          child:Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.black26,
                          child: Container(width: (MediaQuery.of(context).size.width),
                          height: 20.0,
                         decoration: const BoxDecoration(color: Colors.grey,
                         borderRadius: BorderRadius.all(Radius.circular(5.0))),                        )) ,
                            ), 
                            growable: false
                            ),
                            ),
                          );
                          default:return DataTable(columns: const [
                            DataColumn(label: Text("Name"),
                            numeric: false,
                            tooltip: "This is the product's name"
                            ),
                             DataColumn(label: Text("Quantity"),
                            numeric: false,
                            tooltip: "This is the product's Remaining Quantity"
                            ),
                             DataColumn(label: Text("Selling Price"),
                            numeric: false,
                            tooltip: "This is the Selling Price"
                            )
                          ], rows: snapshot.data!.map((Sale? sale) => DataRow(
                            cells
                            :[DataCell(Text(sale?.product?.name ?? "")),
                            
                            DataCell(Text(sale?.quantity.toString() ?? "")),
                            DataCell(Text(sale?.product?.sellingPrice.toString() ??""))
                            ]
                            )
                            ).toList()
                            
                            );
                          
                        }
                    }
                  },),
                )
              ],
              )) 
          ],
        ),
      );

  }
  void _getSales(String date, Shop currentShop){
    dbService.getSales(date, currentShop);
  }
}