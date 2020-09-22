import 'package:flutter/material.dart';
class ConfirmSale
{
  Future<void> confirmsale(Function function, BuildContext context,String  msg) async
  {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text('Warnning'),
            content: SingleChildScrollView(
              child: ListBody(
                children:
                [
                  Text(msg),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children:
                      [
                        Expanded(
                          child: RaisedButton(
                            color: Colors.orange,
                            child: Text(
                              'Buy',
                              style: TextStyle(color: Colors.grey[200]),
                              ),
                            onPressed: function
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.red,
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey[200]),
                            ),
                            onPressed: ()
                            {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}