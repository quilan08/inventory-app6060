
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/models/shop.dart';
import 'package:flutter_application_1/models/stock.dart';
import 'package:flutter_application_1/pages/Stock/productdropdownstate.dart';
import 'package:flutter_application_1/providers/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';



Product? activeDropDownValue;
List<Product>? product;
TextEditingController? quantityController;

String selectedDate = DateFormat("yMd").format(DateTime.now());
class StockPage extends StatefulWidget {
  const StockPage({super.key, required this.shop});
  final Shop shop;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late List<Stock> _selectedStock;
   bool _loading = false;
  @override
  void initState() {
    Firebase.initializeApp();
    _selectedStock = [];
    product = [];
    //move this function to a global stock class
    _getProducts();
    super.initState();
  }

  void _getProducts()async{
    dbService.products.stream.listen((event) {
      
      setState(() {
        product = event;
        activeDropDownValue = event[0];
      });
    });
  }

  // selected row function
  void _onSelectedRow(bool selected, Stock stock){
    setState(() {
      if(selected){
        _selectedStock.add(stock);
      } else{
        _selectedStock.remove(stock);
      }
    });
  }
  void showToast(String message) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

void  _addStock(BuildContext context){
 
  showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    color: Color(0xFF737373),
                    child: Container(
                      decoration:   const BoxDecoration(
                        color: Colors.white,
                        borderRadius:  BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)
                        )
                      ),
                      child:  Wrap(
                        children: [
                       const ProductsDropdown(),
                       Padding(padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        left: 16.0
                       ),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Icon(Icons.add_circle,
                          color: Colors.blueAccent,
                          ),

                          OverflowBar(
                            children: <Widget>[
                              TextButton(
                                onPressed: _loading ? null :(){
                                  Navigator.pop(context);
                                  quantityController!.clear();
                                },
                                child: Text("Cancel", style:
                                 TextStyle(color: Theme.of(context).primaryColor),), 
                                ),
                               TextButton(
                                onPressed: _loading ? null :() {
                                 if(quantityController!.text.isNotEmpty){
                                 setState(() {
                                    _loading = true;
                                  
                                 });
                                 dbService.addStock(Stock(
                                  product: activeDropDownValue,
                                  dateadded: selectedDate, 
                                  shop: widget.shop, 
                                  quantity: double.parse(quantityController!.text)
                                  )
                                  ).then((res) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    print("Added Successfully");
                                    Navigator.pop(context);
                                    quantityController!.clear();
                                  }).catchError((onError){
                                    setState(() {
                                      _loading = false;
                                    });
                                    if(onError.message.contains("Permission Denied")){
                                                            const snackbar = SnackBar(
                                          content: Text("Seems you dont have permission. Please contact the adminstrator."),
                                          backgroundColor: Colors.grey,
                                          elevation: 10,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(5),
                                          duration: Durations.short3,

                                       ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                 } else if(onError.message.contains("No Internet")){
                                     const snackbar = SnackBar(
                                           content: Text("No internet Connection"),
                                           backgroundColor: Colors.grey,
                                           elevation: 10,
                                           behavior: SnackBarBehavior.floating,
                                           margin: EdgeInsets.all(5),
                                           duration: Durations.short3,
                       
                                       ); ScaffoldMessenger.of(context).showSnackBar(snackbar);

                                       }  
                                       else{
                                           const snackbar = SnackBar(
                                           content: Text("No internet Connection"),
                                           backgroundColor: Colors.grey,
                                           elevation: 10,
                                           behavior: SnackBarBehavior.floating,
                                           margin: EdgeInsets.all(5),
                                           duration: Durations.short3,
                       
                                       ); ScaffoldMessenger.of(context).showSnackBar(snackbar);

                                       }
                                  })
                                  ;
                                 }
                               }, child: Text("Save", style:
                                TextStyle(color: Theme.of(context).primaryColor),
                                )
                                ) 

                            ],
                          )
                          
                        ],
                       ),
                       )
                        ],
                      ),
                    ),
                  );
                },
              );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock"),
        actions: <Widget>[
          Visibility(
            visible: _selectedStock.length == 1,
            child: PopupMenuButton<String>(itemBuilder: (BuildContext context) =><PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: "Sales",child: Text("Add to Sales")),
            const PopupMenuItem<String>(value: "Waste",child: Text("Add to waste"),)
          ] ,))
        ]
      ),
      body:  Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children:<Widget> [
            OverflowBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible:true,
                  child:ElevatedButton(child: const Text("Add"),
                  onPressed: () {
                        _addStock(context);
                  },
                
                )
                ),

                Visibility(
                  visible: _selectedStock.length == 1 && product!.isNotEmpty,
                  child: 
                 ElevatedButton.icon(onPressed: (){
                  _editStock(context,_selectedStock[0]);
                 },
                  icon: Icon(Icons.edit, color:
                  Theme.of(context).primaryColor,), 
                  label: const Text("Edit")  
                 )
                 )
              ],
            ),

            Expanded(child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SingleChildScrollView(
                  child:
                   StreamBuilder<List<Stock>>
                   (stream: dbService.stock.stream, builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot){
                    if(snapshot.hasError){
                      return Text("Error: ${snapshot.error}");
                    }else{
                      switch(snapshot.connectionState){
                        case ConnectionState.waiting:
                          return Container(
                            width: (MediaQuery.of(context).size.width),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                            children:List<Widget>.filled(5, 
                            Padding(padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Colors.black12, highlightColor: Colors.black26,
                              child: Container(
                                  width: (MediaQuery.of(context).size.width),
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                
                            )),
                            ),
                            growable: false
                          ) ,
                            ),
                          );
                        default: 
                        return DataTable(
                          columns: const [
                            DataColumn(label: Text("Name"),
                          numeric: false,
                          tooltip: "This is product's name"
                          ),
                           DataColumn(label: Text("Quantity"),
                          numeric: false,
                          tooltip: "This is product's Remaining Quantity"
                          ),
                           DataColumn(label: Text("UOM"),
                          numeric: false,
                          tooltip: "This is the products Unit of Measurement"
                          ),
                           DataColumn(label: Text("Date Added"),
                          numeric: false,
                          tooltip: "This is product's  Buying price"
                          )
                          
                          ], rows: snapshot.data!.map((Stock stock) => 
                          DataRow(selected: _selectedStock.contains(stock),
                          onSelectChanged: (selected){
                            _onSelectedRow(selected!, stock);
                          }, cells: [
                            DataCell(
                              Text(stock.product?.name ?? "")
                            ),
                            DataCell(
                              Text(stock.quantity.toString()),
                            ),
                            DataCell(Text(
                              stock.product!.uom!
                            )
                            )
                          ,
                          DataCell(
                            Text(stock.dateadded.toString().replaceAll("00:00:00:000", ""))
                          )
                          ]
                            )
                            ).toList(),
                            );
                      }
                    }
                   })
                )
              ],
            ))
        ],),
    );
  }
    void _editStock(BuildContext context, Stock stock){
    quantityController!.text = stock.quantity.toString();
    activeDropDownValue = product!.firstWhere((product) => product.name == stock.product!.name);

    selectedDate = stock.dateadded!;

    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
        color: Color(0xFF737373),
        child: Container(decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0)
          ),
        
        ),
        child:  Wrap(children: <Widget>[
          const ProductsDropdown(),
          Padding(padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 8.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
            children:<Widget> [
              const Icon(Icons.add_circle,
              color: Colors.amberAccent,
              ),

              OverflowBar(
                children: <Widget>[

                  TextButton(onPressed: _loading  ? null : (){

                    Navigator.pop(context);
                  }, child: const Text(" Cancel")
                  ),

                  TextButton(onPressed: _loading ? null: (){
                    if(quantityController!.text.isNotEmpty){
                        setState(() {
                            _loading = true;
                        });
                        dbService.editStock(Stock(
                          product:activeDropDownValue, 
                          dateadded: selectedDate, 
                          shop: stock.shop,
                           quantity: double.parse(quantityController!.text),
                            stockId: stock.stockId
                           )
                           ).then((res) =>{
                            setState(() {
                              _loading = false;
                            })
                      , showToast("edit Successfully")
                           } ).catchError((onError){
                            setState(() {
                              _loading = false;
                            });

                            if(onError.message.contains("PERMISSION DENIED")){
                            showToast("Seems Permission was Denied, Please Contact the Adminstrator");
                            
                          } else if(onError.toString().contains("No Internet")){
                            showToast("You dont have internet connection");
                          } else{
                            print(onError);
                               const snackbar = SnackBar(
                      content: Text("Contact Adminstrator"),
                      backgroundColor: Colors.grey,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                      duration: Durations.short3,
                     
                            ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          }
                           
                           });
                    }
                  }, child:Text("Save") )
                ],
              )

            ],),
          )
        ],),
        ),
      );
    });
  }


  
}
