import'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
class CartDatabase
{
  Firestore _firestore = Firestore.instance;
  // add to cart
  void addtocart({String uid,String color,int quantity,String size,DocumentSnapshot documentSnapshot})async
  {
    var id1 = Uuid().v1();
    _firestore.collection("cart").document(id1).setData(documentSnapshot.data);
    await _firestore.collection("cart").document(id1).updateData({"userid":uid,"sizes":size,"colors":color,"quantuty":quantity});
  }
  // get all cart
  Future<List<DocumentSnapshot>> getallcart(String uid)async
  {
    List<DocumentSnapshot> cartlist=[];
    QuerySnapshot querySnapshot=await _firestore.collection('cart').where("userid",isEqualTo: uid).getDocuments();
    cartlist=querySnapshot.documents;
    return cartlist;
  }
  // get cart total
  Future<double> getcarttotal(String uid)async
  {
    double total = 0;
    List<DocumentSnapshot> list=await getallcart(uid);
    for(int i=0;i<list.length;i++){
      total = total + (double.parse(list[i].data["price"])*(double.parse(list[i].data["quantuty"].toString())));
    }
    return total;
  }
  // delete from cart
  void deletefromcart(String id,String uid)async
  {
    await  _firestore.collection('cart').document(id).delete();
  }
}