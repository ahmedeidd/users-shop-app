import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_app/data_base/category_database.dart';
import 'package:shop_app/data_base/product_database.dart';
import 'package:shop_app/pages/Products%20_EID.dart';
import 'package:shop_app/pages/cart_page_EID.dart';
import 'package:shop_app/pages/drawer.dart';
import 'package:shop_app/pages/product_details.dart';
class HomePage extends StatefulWidget
{
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  static String uid;
  String name,photourl,email;
  Map<String,dynamic> map;
  String CATID = "All";
  CATDatabse _databse = CATDatabse();
  Future<FirebaseUser> getUser() async
  {
    return await _auth.currentUser();
  }
  Icon Iconsearch = Icon(Icons.search);
  Icon Iconclose = Icon(Icons.close);
  Widget Titletext = Text("Shop", );
  bool tosearch = false;
  @override
  void initState()
  {
    super.initState();
    getUser().then((user)
    {
      if (user != null)
      {
        setState(()
        {
          uid = user.uid;
        });
        Firestore.instance.collection('users').document('${user.uid}')
            .get().then((DocumentSnapshot ds) {
          if(ds.exists)
          {
            map = ds.data;
            name = map["username"];
            email = user.email;
            photourl = map["photourl"];
          }
        });
      }
    });

  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: tosearch ? Titlesearch() : Titletext,
        actions: <Widget>
        [
          IconButton(
            icon: Icon(Icons.search,color: Colors.white,),
            onPressed: (){
              if (tosearch)
              {
                setState(()
                {
                  tosearch = false;
                });
              } else {
                setState(()
                {
                  tosearch = true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart,color: Colors.white,),
            onPressed: ()
            {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CartPage(uid)));
            },
          ),
        ],
      ),
      drawer:DrawerEID(uid,showsnacks),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: 214,
              child: Carousel(
                boxFit: BoxFit.cover,
                images:
                [
                  Image.network("https://i.dailymail.co.uk/i/pix/2017/07/05/02/4209CB9600000578-4666302-image-a-31_1499219454991.jpg"),
                  Image.asset("images/m1.jpeg"),
                  Image.asset("images/m2.jpg"),
                  Image.network("https://www.buzzwebzine.fr/wp-content/uploads/2018/12/Scarlett-Johansson-rode-de-soiree-rouge-445x700.jpg"),
                  Image.network("https://assets.myntassets.com/h_1440,q_100,w_1080/v1/assets/images/6996811/2018/7/23/2058ea63-57d1-461e-8f82-ab16617b39da1532339067981-Campus-Sutra-Full-Sleeve-Solid-Men-Jacket-6361532339067785-1.jpg"),
                ],
                autoplay: false,
                dotSize: 5,
                dotBgColor: Colors.white.withOpacity(.5),
                indicatorBgPadding: .5,
                dotColor: Colors.teal[800],
                dotIncreasedColor: Colors.tealAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Catrgories",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              height: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                [
                  Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: FlatButton.icon(
                        onPressed:()
                        {
                          setState(()
                          {
                            CATID = "All";
                          });
                        },
                        icon: Icon(
                          Icons.border_all,
                          color: Colors.red,
                          size: 55,
                        ),
                        label: Text(""),
                      ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<DocumentSnapshot>>(
                        future:_databse.getAllCAT() ,
                        builder: (context,data)
                        {
                          if(data.hasError)
                          {
                            return Center(
                              child: Text("Error at   ${data.error.toString()}"),
                            );
                          }
                          else if (data.hasData)
                          {
                            return ListView.builder(
                              itemBuilder: (context,index)
                              {
                                return Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Container(
                                    width: 100,
                                    child: ListTile(
                                      onTap:()
                                      {
                                        setState(()
                                        {
                                          CATID = data.data[index].documentID;
                                        });
                                      },
                                      title: Image.network(data.data[index]["imgurl"],height: 50,width: 50,),
                                      subtitle: Text(data.data[index]["category"],textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                );
                              },
                              itemCount: data.data.length,
                              scrollDirection: Axis.horizontal,
                            );
                          }
                          return Container(child: Center(child: CircularProgressIndicator()));
                        }
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Products",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              height: 320,
              child: Products(CATID),
            ),
          ],
        ),
      ),
    );
  }
  //********************************************************
  // start show snacks
  Future<void> showsnacks()
  {
    key.currentState.showSnackBar(
      SnackBar(
        content: Text("No action yet"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.teal[800],
      ),
    );
  }
  // end show snacks
  //*********************************************************
  // srart title search
  Widget Titlesearch()
  {
    return TypeAheadField(
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
            hintText: "Search "
        ),
        autofocus: true,
      ),
      suggestionsCallback: (pattern) async
      {
        return await ProductDatabase().getSuggestions(pattern);
      },
      itemBuilder: (context, suggestion)
      {
        return ListTile(
          title: Row(
            children:
            [
              Image.network(suggestion['images url'][0],width: 20,height: 20,),
            ],
          ),
          trailing: Text(suggestion['name']),
        );
      },
      onSuggestionSelected: (suggestion)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(suggestion)));
      },
    );
  }
  // end title search
  //**********************************************************
}

