import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/alerts/buy_now.dart';
import 'package:shop_app/data_base/brand_database.dart';
import 'package:shop_app/data_base/cart_database.dart';
import 'package:shop_app/data_base/category_database.dart';
import 'package:shop_app/data_base/favourites_database.dart';
import 'package:shop_app/pages/cart_page_EID.dart';
import 'package:shop_app/pages/shipment_page_EID.dart';
class ProductDetails extends StatefulWidget
{
  final DocumentSnapshot _documentSnapshot;
  ProductDetails(this._documentSnapshot);
  @override
  _ProductDetailsState createState() => _ProductDetailsState(_documentSnapshot);
}

class _ProductDetailsState extends State<ProductDetails>
{
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();

  FavouritesDatabase _favouritesDatabase = FavouritesDatabase();
  CartDatabase _cartDatabase = CartDatabase();
  CATDatabse _CATDatabase = CATDatabse();
  BrandDatabase _BrandDatabase = BrandDatabase();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  BuyNow _buyNowalert = BuyNow();

  final DocumentSnapshot _documentSnapshot;
  _ProductDetailsState(this._documentSnapshot);
  String selectedsize;
  String selectedcolor;
  int selectedquantity = 1;
  bool saved = false;
  bool valid;
  String userid = '';
  @override
  void initState()
  {
    getUser().then((user)
    {
      if (user != null)
      {
        setState(()
        {
          userid = user.uid;
          _firestore
              .collection('saved')
              .document(_documentSnapshot.documentID)
              .get()
              .then((value) {
            if (value.exists)
            {
              setState(()
              {
                saved = true;
              });
            }
          });
        });
      } else {
        print("fool");
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(_documentSnapshot["name"]),
        elevation: 0.0,
        actions: <Widget>
        [
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CartPage(userid)));
              }),
        ],
      ),
      body: ListView(
        children:
        [
          Container(
            height: 300,
            color: Colors.transparent,
            child: GridTile(
              child: Container(
                child: Carousel(
                  images:
                  [
                    Image.network(_documentSnapshot["images url"][0]),
                    Image.network(_documentSnapshot["images url"][1]),
                    Image.network(_documentSnapshot["images url"][2]),
                  ],
                  autoplay: false,
                  boxFit: BoxFit.cover,
                  dotBgColor: Colors.white.withOpacity(.5),
                  dotSize: 4,
                  indicatorBgPadding: .5,
                  showIndicator: false,
                ),
              ),
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    _documentSnapshot["name"],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _documentSnapshot["price"].toString() + "  L.E",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Description",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            subtitle: Text(_documentSnapshot["description"]),
          ),
          ListTile(
              title: Text(
                "Category",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              subtitle: FutureBuilder<DocumentSnapshot>(
                future: _CATDatabase.getCAT(_documentSnapshot["category"],),
                builder: (context, snapshot)
                {
                  if (snapshot.hasData)
                  {
                    return ListTile(
                      title: Text(snapshot.data["category"]),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error please try later");
                  }
                  return Text("loading ....");
                },
              ),
          ),
          ListTile(
              title: Text(
                "Brand",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              subtitle: FutureBuilder<DocumentSnapshot>(
                future: _BrandDatabase.getbrand(_documentSnapshot["brand"],),
                builder: (context, snapshot)
                {
                  if (snapshot.hasData)
                  {
                    return ListTile(
                      title: Text(snapshot.data["brand"]),
                      subtitle: Row(
                        children:
                        [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.network(snapshot.data["imgurl"]),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error please try later");
                  }
                  return Text("loading ....");
                },
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
            [
              FutureBuilder<List<String>>(
                future: getelementes("sizes"),
                  builder: (context, data)
                  {
                    if (data.hasData)
                    {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 20.0),
                        child: DropdownButton<String>(
                          items: data.data.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: changsize,
                          value: selectedsize,
                          hint: Text("Size"),
                        ),
                      );
                    } else if (data.hasError) {
                      return Center(child: Text(data.error.toString()));
                    }
                    return Center(child: Text("loading ...."));
                  }
              ),
              FutureBuilder<List<String>>(
                  future: getelementes("colors"),
                  builder: (context, data)
                  {
                    if (data.hasData)
                    {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 20.0),
                        child: DropdownButton<String>(
                          items: data.data.map<DropdownMenuItem<String>>((String value)
                          {
                            return DropdownMenuItem<String>(
                              child: Text(
                                "Color #${data.data.indexOf(value)}",
                                style: TextStyle(
                                  color: Color(int.parse(value)),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: value,
                            );
                          }).toList(),
                          onChanged: changcolor,
                          value: selectedcolor,
                          hint: Text("color"),
                        ),
                      );
                    } else if (data.hasError) {
                      return Center(child: Text(data.error.toString()));
                    }
                    return Center(child: Text("loading ...."));
                  }
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  child: Row(
                    children:
                    [
                      IconButton(icon: Icon(Icons.remove), onPressed: _decreaseqty,),
                      Text(selectedquantity.toString()),
                      IconButton(icon: Icon(Icons.add), onPressed: _increaseqty),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children:
            [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orange,
                    ),
                    child: MaterialButton(
                      onPressed: ()
                      {
                        _buynow();
                      },
                      child: Text("Order  Now"),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.orange,
                ),
                onPressed: _addCart,
              ),
              IconButton(
                icon: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  color: Colors.orange,
                ),
                onPressed: _save,
              ),
            ],
          ),
        ],
      ),
    );
  }
  //**********************************************************************
  // start get users
  Future<FirebaseUser> getUser() async
  {
    return await _auth.currentUser();
  }
  // end get users
  //************************************************************************
  // start get elements
  Future<List<String>> getelementes(String element) async
  {
    List<String> list = [];
    for (int i = 0; i < _documentSnapshot[element].length; i++)
    {
      list.add(_documentSnapshot[element][i]);
    }
    return list;
  }
  // end get elements
  //**************************************************************************
  // start change size
  void changsize(value)
  {
    setState(()
    {
      selectedsize = value;
    });
  }
  // end change size
  //***************************************************************************
  // staaaaart change color
  void changcolor(value)
  {
    setState(()
    {
      selectedcolor = value;
    });
  }
  // eeeeeeeend change color
  //***************************************************************************
  // start increase and decrease quantity
  void _increaseqty()
  {
    if (selectedquantity < int.parse(_documentSnapshot.data["quantuty"]))
    {
      setState(()
      {
        selectedquantity ++ ;
      });
    } else {
      Fluttertoast.showToast(msg: "Maximum available quantity is ${_documentSnapshot.data["quantuty"]}");
    }
  }
  void _decreaseqty()
  {
    if (selectedquantity > 1)
    {
      setState(()
      {
        selectedquantity -- ;
      });
    } else {
      Fluttertoast.showToast(msg: "Minimum quantity is one");
    }
  }
  // end increase and decrease quantity
  //****************************************************************************
  // start create function buy now
  void _buynow()
  {
    _validate();
    if (valid)
    {
      _buyNowalert.confirmsale(()
      {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShipmentPage(
                doc: _documentSnapshot,
                selectedcolor: selectedcolor,
                selectedquantity: selectedquantity,
                selectedsize: selectedsize,
                userid: userid)));
      }, context, _documentSnapshot["name"], selectedquantity, selectedcolor,
          selectedsize, _documentSnapshot["price"].toString());
    }
  }
  // start validate
  void _validate()
  {
    if (selectedcolor != null && selectedsize != null && selectedquantity <= int.parse(_documentSnapshot.data["quantuty"]))
    {
      valid = true;
    }
    else if (selectedcolor == null)
    {
      valid = false;
      Fluttertoast.showToast(msg: "ERROR:  please select color", toastLength: Toast.LENGTH_LONG);
    }
    else if (selectedsize == null)
    {
      valid = false;
      Fluttertoast.showToast(msg: "ERROR:  please select size", toastLength: Toast.LENGTH_LONG);
    }
    else if (selectedquantity > int.parse(_documentSnapshot.data["quantuty"]))
    {
      valid = false;
      Fluttertoast.showToast(msg: "ERROR:  the quantity is over the limits", toastLength: Toast.LENGTH_LONG);
    }
  }
  // end validate
  // end create function buy now
  //****************************************************************************
  // start add cart
  void _addCart()
  {
    _validate();
    if (valid)
    {
      _cartDatabase.addtocart(
          color: selectedcolor,
          quantity: selectedquantity,
          size: selectedsize,
          uid: userid,
          documentSnapshot: _documentSnapshot);
      Fluttertoast.showToast(msg: "the product was added to the shopping cart", toastLength: Toast.LENGTH_LONG);
    }
  }
  // end add cart
  //****************************************************************************
  // start save
  void _save()
  {
    setState(()
    {
      if (saved)
      {
        saved = false;
      }
      else
      {
        saved = true;
      }
    });
    _favouritesDatabase.saveProduct(saved, userid, _documentSnapshot);
  }
  // end save
  //****************************************************************************
}
