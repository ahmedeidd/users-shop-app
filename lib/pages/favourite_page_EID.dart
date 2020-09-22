import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/alerts/Alert.dart';
import 'package:shop_app/data_base/favourites_database.dart';
import 'package:shop_app/pages/product_details.dart';
class FavouritePage extends StatefulWidget
{
  static String _uid;
  FavouritePage({String uid=""})
  {
    _uid = uid;
  }
  @override
  _FavouritePageState createState() => _FavouritePageState(_uid);
}

class _FavouritePageState extends State<FavouritePage>
{
  String _uid;
  _FavouritePageState(String uid)
  {
    this._uid=uid;
  }
  List<String> selectedproducts = [];
  FavouritesDatabase _favouriteDatabase = FavouritesDatabase();
  Alert _deleteAlerte = Alert();
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourits"),
        actions:
        [
          selectedproducts.isNotEmpty ? IconButton(
            icon:Icon(Icons.delete),
            onPressed: ()
            {
              _deleteAlerte.confirm(()
              {
                setState(()
                {
                  _favouriteDatabase.deleteproducts(selectedproducts, _uid);
                });
                selectedproducts.clear();
                Navigator.of(context).pop();
               }, context, "Do you want to delete selected products","Warnning","Cancel","Delete"
              );
            },
          ):Container()
        ],
      ),
      body: Container(
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _favouriteDatabase.getallsaved(_uid),
          builder: (context,snapshot)
          {
            if(snapshot.hasData)
            {
              if(snapshot.data.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index)
                  {
                    return Card(
                      child: ListTile(
                        onTap: ()
                        {
                          onfaveouriteitemtap(snapshot.data[index]);
                        },
                        selected: selectedproducts.contains(snapshot.data[index].documentID),
                        onLongPress: ()
                        {
                          setState(()
                          {
                            selectedproducts.add(snapshot.data[index].documentID);
                          });
                        },
                        leading: Image.network(snapshot.data[index]["images url"][0]),
                        title:  Text(
                          snapshot.data[index]["name"],
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(snapshot.data[index]["price"]+"  L.E"),
                        trailing: IconButton(
                          icon: Icon((Icons.delete)),
                          onPressed:()
                          {
                            _deleteAlerte.confirm(()
                            {
                              setState(()
                              {
                                _favouriteDatabase.deletesaved(snapshot.data[index].documentID, _uid);
                                Navigator.of(context).pop();
                              });
                            }, context, "Do you want to delete ${snapshot.data[index]["name"]}  from the favourites ","Warnning","Cancel","Delete");
                          },
                        ),
                      ),
                    );
                  },
                );
              }
              else
              {
                return Center(child:Text('Favourites list is empty'));
              }
            }
            if(snapshot.hasError)
            {
              return Center(child: Text(snapshot.error.toString()),);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
  //****************************************************************************
  void onfaveouriteitemtap(DocumentSnapshot _documentSnapshot)
  {
    if(selectedproducts.isEmpty)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(_documentSnapshot)));
    }
    else
    {
      if(selectedproducts.contains(_documentSnapshot.documentID))
      {
        setState(()
        {
          selectedproducts.remove(_documentSnapshot.documentID);
        });
      }
      else
      {
        setState(()
        {
          selectedproducts.add(_documentSnapshot.documentID);
        });
      }
    }
  }
  //****************************************************************************
}
