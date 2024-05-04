import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/employee.dart';
import 'package:flutter_application_1/pages/Stock/stockPage.dart';
import 'package:flutter_application_1/providers/database.dart';
import 'package:shimmer/shimmer.dart';

class ShopPage extends StatefulWidget {
  
  const ShopPage({super.key});

  @override
  _ShopsPageStateState createState() => _ShopsPageStateState();
}

class _ShopsPageStateState  extends State<ShopPage> {
  final _shopController = TextEditingController();
  @override
  void dispose() {
   _shopController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: StreamBuilder<Employee>(stream:dbService.employee.stream,
      builder: (BuildContext context,AsyncSnapshot<Employee> snapshot){
        if(snapshot.hasError){
            return Text("Error ${snapshot.error}");
        } else{
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            return Container(
              width: (MediaQuery.of(context).size.width),
              child: ListView(children: List<Widget>.filled(10, ListTile(leading:
               Shimmer.fromColors(baseColor:
                Colors.black12, highlightColor: Colors.black26,
                 child:  Container(height: 50.0, width: 50.0, decoration: 
                 const BoxDecoration(color: Colors.grey,
                 borderRadius: BorderRadius.all(Radius.circular(5.0))
                 )
                 ,)
                 ),
                 title: Shimmer.fromColors(
                  baseColor: Colors.black12, highlightColor: Colors.black26,
                  child: Container(
                    height: 50.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  )
                  ),
                 ),
                 growable: false
                 
                 ),
                 ),
            );
            default:
            return ListView.builder(
              itemBuilder: 
              (BuildContext  context, index) =>Card(
                child: ListTile(
                  leading: Text((index + 1).toString()),
                  title: Text(snapshot.data!.shops![index].shop!),
                  onTap: (){
                    dbService.getStock(snapshot.data!.shops![index]);
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => StockPage(shop: snapshot.data!.shops![index]))
                    );
                  },
                ),

              ) 
            );
          }
        }
      }),
    );
  }
}