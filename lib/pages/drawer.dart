import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/alerts/show_pic.dart';
import 'package:shop_app/pages/Login_Page_EID.dart';
import 'package:shop_app/pages/favourite_page_EID.dart';
import 'package:shop_app/pages/orders_page_EID.dart';
class DrawerEID extends StatefulWidget
{
  String _uid;
  VoidCallback _showsnacks;
  DrawerEID(String uid,VoidCallback showsnacks)
  {
    this._uid=uid;
    this._showsnacks = showsnacks;
  }
  @override
  _DrawerEIDState createState() => _DrawerEIDState(_uid,_showsnacks);
}

class _DrawerEIDState extends State<DrawerEID>
{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String name , photourl , email;
  ShowPic _showPic = ShowPic();
  String _uid;
  VoidCallback _showsnacks;
  _DrawerEIDState(String uid,VoidCallback showsnacks)
  {
    this._uid=uid;
    this._showsnacks = showsnacks;
  }
  @override
  void initState()
  {
    super.initState();
    getUser().then((user)
    {
      if (user != null)
      {
        Firestore.instance
            .collection('users')
            .document('${user.uid}')
            .get()
            .then((DocumentSnapshot DS)
        {
          if(DS.exists)
          {
            setState(() {
              name = DS.data["username"];
              email = DS.data["email"];
              photourl = DS.data["photourl"];
            });
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: Drawer(
        child: ListView(
          children:
          [
            UserAccountsDrawerHeader(
              accountName: name != null ? Text("$name",style: TextStyle(color: Colors.black),) : Text("User name",style: TextStyle(color: Colors.black)),
              accountEmail: email == null ? Text("email isn't available",style: TextStyle(color: Colors.black)) : Text(email,style: TextStyle(color: Colors.black)),
              currentAccountPicture: InkWell(
                onTap: ()async
                {
                  await _showPic.show(context,photourl);
                },
                child: photourl == null ? CircleAvatar(
                  child: Image.asset("images/pro.png"),
                ):CircleAvatar(child: Image.network(photourl),),
              ),
              decoration: BoxDecoration(color: Colors.white),
            ),
            drawerItem(
              'My Orders',
              Icons.add_shopping_cart,
              ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrdersPage(uid:  _uid,)));
              },
              Colors.red,
            ),
            drawerItem(
              'Favourites',
              Icons.favorite,
              ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritePage(uid: _uid,)));
              },
              Colors.red,
            ),
            Divider(),
            drawerItem(
              'Settings',
               Icons.settings,
               ()
              {
                 _showsnacks();
                 Navigator.of(context).pop();
               },
               Colors.grey,
            ),
            drawerItem(
              "About",
              Icons.help,
              ()
              {
                _showsnacks();
                Navigator.of(context).pop();
              } ,
              Colors.blue,
            ),
            drawerItem(
              "Log out",
              Icons.exit_to_app,
              () async
              {
                auth.signOut();
                _showsnacks();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
              },
              Colors.grey,
            )
          ],
        ),
      ),
    );
  }
  //************************************************
  // drawer item
  Widget drawerItem(String title, IconData icon, VoidCallback func, MaterialColor color)
  {
    return InkWell(
      onTap: func,
      child: ListTile(
        title: Text(title),
        leading: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
  // end drawer item
  //************************************************
  // get user
  Future<FirebaseUser> getUser() async
  {
    return await auth.currentUser();
  }
  // end get user
  //*************************************************
}
