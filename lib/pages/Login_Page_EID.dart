import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/pages/home.dart';
class LoginPage extends StatefulWidget
{
  @override
  _LoginPageState createState() => _LoginPageState();
}
enum FORMTYPE { login, register }
class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin
{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  bool islogged = false;
  SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Future<void> showsnacks(String txt)
  {
    key.currentState.showSnackBar(SnackBar(content: Text(txt), duration: Duration(seconds: 3)));
  }
  final formkey = GlobalKey<FormState>();
  FORMTYPE formtype;
  String _E_MAIL = "";
  String _NAME = "";
  String PASS = "";
  AnimationController _AnimController;
  Animation<double> _animation;
  @override
  void initState()
  {
    super.initState();
    issigned();
    formtype = FORMTYPE.login;
    _AnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 6000));
    _animation = CurvedAnimation(parent: _AnimController, curve: Curves.bounceOut);
    _animation.addListener(() => this.setState(() {}));
    _AnimController.forward();
  }
  @override
  void dispose()
  {
    _AnimController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: key,
      body: Stack(
        fit: StackFit.expand,
        children:
        [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.orange,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                SizedBox(height: 30,),
                FadeTransition(
                  child: Image(
                    image: AssetImage("images/logo.png"),
                    height: 100,
                    width: 100,
                  ),
                  opacity: _animation,
                ),
                Form(
                  key: formkey,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children:
                      [
                        Visibility(
                          child: TextFormField(
                            validator: (value)
                            {
                              return value.isEmpty ? "Please enter your name" : null;
                            },
                            onSaved: (val)
                            {
                              setState(() {
                                _NAME = val;
                              });
                            },
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellowAccent),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(.5),
                              labelText: "Name",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.white),
                          ),
                          visible: formtype == FORMTYPE.register,
                        ),
                        Container(height: 20.0,),
                        TextFormField(
                          validator: (value)
                          {
                            return value.isEmpty ? "Please enter your email" : null;
                          },
                          onSaved: (val)
                          {
                            _E_MAIL = val;
                          },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellowAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.black.withOpacity(.5),
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(height: 20.0,),
                        TextFormField(
                          validator: (value)
                          {
                            return value.isEmpty ? "Please enter your password" : null;
                          },
                          onSaved: (val)
                          {
                            PASS = val;
                          },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellowAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.black.withOpacity(.5),
                            labelText: "password",
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                _custombuttons(),
              ],
            ),
          ),
          Visibility(
            child: Center(
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.red.withOpacity(.8),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                ),
            ),
            visible: loading ?? true,
          )
        ],
      ),
    );
  }
  //*******************************************************************
  // start function is signed
  void issigned() async
  {
    setState(()
    {
      loading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    islogged = await googleSignIn.isSignedIn();
    if (islogged)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
    setState(()
    {
      loading = false;
    });
  }
  // end function is signed
  //*********************************************************************
  // start custom buttons
  Widget _custombuttons()
  {
    if (formtype == FORMTYPE.login)
    {
      return Column(
        children:
        [
          Container(
            width: 240,
            child: RaisedButton(
              padding: EdgeInsets.only(left: 50, right: 50),
              onPressed: ()
              {
                login();
              },
              child: Text("Login"),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Container(
            width: 240,
            child: RaisedButton(
              padding: EdgeInsets.only(left: 50, right: 50),
              onPressed: ()
              {
                handlesigning();
              },
              child: Text("Sign in with google "),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              textColor: Colors.white,
              color: Colors.red,
            ),
          ),
          FlatButton(
            onPressed: ()
            {
              movetoregister();
            },
            child: Text(
              "Create new account",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
    else
    {
      return Column(
        children:
        [
          Container(
            width: 240,
            child: RaisedButton(
              padding: EdgeInsets.only(left: 50, right: 50),
              onPressed: ()
              {
                register();
              },
              child: Text("Create account"),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Container(
            width: 240,
            child: RaisedButton(
              padding: EdgeInsets.only(left: 50, right: 50),
              onPressed: ()
              {
                handlesigning();
              },

              child: Text("Sign in with google "),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              textColor: Colors.white,
              color: Colors.red,
            ),
          ),
          FlatButton(
            onPressed: ()
            {
              movetologin();
            },
            child: Text(
              "back to login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    }
  }
  // start login
  Future<void> login() async
  {
    final formstate = formkey.currentState;
    if (formstate.validate())
    {
      formstate.save();
      try
      {
        sharedPreferences = await SharedPreferences.getInstance();
        setState(()
        {
          loading = true;
        });
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _E_MAIL, password: PASS)).user;
        if (user != null)
        {
          Firestore.instance.collection('users')
              .document('${user.uid}')
              .get()
              .then((DocumentSnapshot ds) {
            if(!ds.exists)
            {
              Firestore.instance.collection("users").document(user.uid).setData({
                "id": user.uid,
                "photourl": user.photoUrl,
                "email":user.email,
                "username":user.displayName
              });
              sharedPreferences.setString("id", user.uid);
              sharedPreferences.setString("username", user.displayName);
              sharedPreferences.setString("photourl", user.photoUrl);
            }
            else{
              sharedPreferences.setString("id", ds["id"]);
              sharedPreferences.setString("username", ds["username"]);
              sharedPreferences.setString("photourl", ds["photourl"]);
            }
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
          setState(()
          {
            loading = false;
          });
        }
      }
      catch(PlatformException)
      {
        Fluttertoast.showToast( msg: PlatformException.toString().contains("ERROR_USER_NOT_FOUND")
            ? "ERROR_USER_NOT_FOUND"
            : PlatformException.toString());
        setState(()
        {
          loading = false;
        });
      }
    }
  }
  // end login
  //*****************************
  // start handle signing
  Future handlesigning() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(()
    {
      loading = true;
    });
    try
    {
      GoogleSignInAccount googleaccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleautha = await googleaccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleautha.accessToken,
        idToken: googleautha.idToken,
      );
      final FirebaseUser user = (await auth.signInWithCredential(credential)).user;
      if (user != null)
      {
        Firestore.instance.collection('users').document('${user.uid}')
            .get()
            .then((DocumentSnapshot ds) {
          if(!ds.exists)
          {
            Firestore.instance.collection("users").document(user.uid).setData({
              "id": user.uid,
              "photourl": user.photoUrl,
              "email":user.email,
              "username":user.displayName
            });
            sharedPreferences.setString("id", user.uid);
            sharedPreferences.setString("username", user.displayName);
            sharedPreferences.setString("photourl", user.photoUrl);
          }
          else
          {
            sharedPreferences.setString("id", ds["id"]);
            sharedPreferences.setString("username", ds["username"]);
            sharedPreferences.setString("photourl", ds["photourl"]);
          }
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        setState(()
        {
          loading = false;
        });
      }
      else
      {
        Fluttertoast.showToast(msg: "Login failed");
        setState(()
        {
          loading = false;
        });
      }
    }
    catch(e)
    {
      Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
      setState(()
      {
        loading=false;
      });
    }
  }
  // end handle signing
  //*****************************
  // start register
  register() async
  {
    final formstate = formkey.currentState;
    if (formstate.validate())
    {
      formstate.save();
      try
      {
        sharedPreferences = await SharedPreferences.getInstance();
        setState(()
        {
          loading = true;
        });
        FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _E_MAIL, password: PASS)).user;
        if (user != null)
        {
          Firestore.instance.collection('users')
              .document('${user.uid}')
              .get()
              .then((DocumentSnapshot ds) {
            if (!ds.exists)
            {
              Firestore.instance.collection("users").document(user.uid).setData({
                "id": user.uid,
                "username": _NAME,
                "photourl": user.photoUrl,
                "email": user.email,
              });
              sharedPreferences.setString("id", user.uid);
              sharedPreferences.setString("username", user.displayName);
              sharedPreferences.setString("photourl", user.photoUrl);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
              setState(()
              {
                loading = false;
              });
            }
            else
            {
              Fluttertoast.showToast(msg: "You already have account enter email and password to sign in");
            }
          });
        }
      }
      catch (PlatformException)
      {
        Fluttertoast.showToast(msg: PlatformException.toString(),toastLength: Toast.LENGTH_LONG);
        setState(()
        {
          loading=false;
        });
      }
    }
  }
  // end register
  //*****************************
  // start move to register
  movetoregister()
  {
    formkey.currentState.reset();
    setState(()
    {
      formtype = FORMTYPE.register;
    });
  }
  // end move to register
  //******************************
  // start move to login
  movetologin()
  {
    formkey.currentState.reset();
    setState(() {
      formtype = FORMTYPE.login;
    });
  }
  // end move to login
  //*****************************
  // end custom buttons
  //**********************************************************************
}
