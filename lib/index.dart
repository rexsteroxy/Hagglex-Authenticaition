import 'package:flutter/material.dart';
import 'package:flutter_app/login.dart';
import 'package:page_transition/page_transition.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Card(
                      child: Text("You are Authorized",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 50.0
                      ),
                      ),
                    )),
                RaisedButton(
                  onPressed: (){
                   Navigator.pop(context);
                  },
                  child: Text("Log Out",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 50.0
                    ),
                  ),
                ),

              ],
            )),
      ),
    );
  }
}
