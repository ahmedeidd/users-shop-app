import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/data_base/product_database.dart';
import 'package:shop_app/pages/product_details.dart';
class Products extends StatefulWidget
{
  ProductDatabase _productDatabase = ProductDatabase();
  String CATID;
  Products(String id)
  {
    this.CATID = id;
  }
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products>
{
  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: widget._productDatabase.getallproducts( widget.CATID),
      builder:(context,data)
      {
        if(data.hasData)
        {
          if(data.data.isNotEmpty)
          {
            return  GridView.builder(
              itemCount: data.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index)
              {
                return ProductItem(data.data[index]);
              });
          }
          else
          {
            return Column(
              children: <Widget>
              [
                Center(child:Text("No product for that category")),
              ],
            );
          }
        }
        else if(data.hasError)
        {
          return Center(child: Text("Error at ${data.error.toString()}"),);
        }
        return  Column(
          children: <Widget>
          [
            Container(
              width: 30,height: 30,
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }
}
//******************************************************************************
// class of product Item
class ProductItem extends StatelessWidget
{
  final DocumentSnapshot _documentSnapshot;
  ProductItem(this._documentSnapshot);
  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: Hero(
          tag: _documentSnapshot['name'],
          child: Material(
            child: InkWell(
              onTap: ()
              {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ProductDetails(_documentSnapshot)));
              },
              child: GridTile(
                child: Image.network(
                  _documentSnapshot["images url"][0],
                  fit: BoxFit.cover,
                ),
                footer: Container(
                  height: 40,
                  color: Colors.white70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                    [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Text(
                          _documentSnapshot["name"],
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,),
                        ),
                      ),
                      Text(
                        "${_documentSnapshot["price"]} " + "L.E",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
